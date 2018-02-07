import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Web 0.2
import com.canonical.Oxide 1.19 as Oxide

import DownloadInterceptor 1.0
import Backend 1.0

import "components"

Page {
	id: webArchive
	anchors {
		fill: parent
		bottom: parent.bottom
	}
	width: parent.width
	height: parent.height

	header: AppHeader {
		title: "If Archive"
		id: headerIf
	}

	property string game
	
	WebContext {
		id: webcontextIF
		//userAgent: 'Mozilla/5.0 (Linux; Android 5.0; Nexus 5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.102 Mobile Safari/537.36 Ubuntu Touch Webapp'
		userScripts: [
			Oxide.UserScript {
				context: "oxide://"
				url: Qt.resolvedUrl("js/cssinjection.js")
				matchAllFrames: true
			}
		]
	}

	WebView {
		id: webview
		anchors {
			fill: parent
			topMargin: header.visible ? header.height : 0//test
			bottom: parent.bottom
		}
		width: parent.width
		height: parent.height

		context: webcontextIF
		url: 'http://www.ifarchive.org/indexes/if-archiveXgamesXglulx.html'
		preferences.localStorageEnabled: true
		preferences.appCacheEnabled: true
		preferences.javascriptCanAccessClipboard: true
		preferences.allowFileAccessFromFileUrls: true
		
		messageHandlers: [
		]

		//filePicker: pickerComponent

		Component.onCompleted: {
			preferences.localStorageEnabled = true;
		}
		
		onDownloadRequested: {
			console.log('download requested', request.url.toString(), request.suggestedFilename);
			DownloadInterceptor.download(request.url, request.cookies, request.suggestedFilename, webcontextIF.userAgent);

			request.action = Oxide.NavigationRequest.ActionReject;
			PopupUtils.open(downloadingDialog, root.mainView, { "fileName" : request.suggestedFilename })
		}
		

	}

	ProgressBar {
		height: units.dp(3)
		anchors {
			left: parent.left
			right: parent.right
			top: headerIf.visible ? headerIf.bottom : parent.top
		}

		showProgressPercentage: false
		value: (webview.loadProgress / 100)
		visible: (webview.loading && !webview.lastLoadStopped)
	}
	
	Connections {
		target: DownloadInterceptor
		onSuccess: {
			console.log("Path is: " + path)
			var gameName = path.split("/")
			console.log("Copy: " + gameName[gameName.length-1])
			Backend.copyLocally(path.replace("file://",""), gameName[gameName.length-1])
			//PopupUtils.close(downloadingDialog)
			mainPageStack.pop()

			/*
			path is the full path to the file, you can use it to open in
			another app or manipulate it as needed.

			When you are done with the file you can optionally use
			DownloadInterceptor.remove(path) to remove the file.
			*/
		}

		
		
	}

	HideHeader { }
	
	Component {
        id: downloadingDialog

        DownloadingDialog {
            anchors.fill: parent
        }
    }
	Component {
        id: errorDialog

        ErrorDialog {
            anchors.fill: parent
        }
    }

} // </page>
