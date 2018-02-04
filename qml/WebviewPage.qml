import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Web 0.2
import com.canonical.Oxide 1.0 as Oxide

import "components"

Page {
	id: web
	anchors {
		fill: parent
		bottom: parent.bottom
	}
	width: parent.width
	height: parent.height

	header: AppHeader {
		title: "Quixe"
		id: header
	}

	property string game
	
	WebContext {
		id: webcontext
		//userAgent: 'Mozilla/5.0 (Linux; Android 5.0; Nexus 5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.102 Mobile Safari/537.36 Ubuntu Touch Webapp'
		userScripts: [
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

		context: webcontext
		url: 'www/play.html?story=' + game
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
		

	}

	ProgressBar {
		//style: { color: darkColor }
		height: units.dp(3)
		anchors {
			left: parent.left
			right: parent.right
			top: header.visible ? header.bottom : parent.top
		}

		showProgressPercentage: false
		value: (webview.loadProgress / 100)
		visible: (webview.loading && !webview.lastLoadStopped)
	}
	
	HideHeader { }
	


} // </page>
