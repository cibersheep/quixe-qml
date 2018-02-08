/*
 * Copyright (C) 2013 Canonical Ltd
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authored by: Arto Jalkanen <ajalkane@gmail.com>
 */
import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
//import org.nemomobile.folderlistmodel 1.0

import DownloadInterceptor 1.0

Dialog {
    id: downloadDialog
    //property FolderListModel model
    signal abortDownload()
    property Page page
    property string dialogTitle: i18n.tr("Download in progress")
    property string descriptionPrepend: i18n.tr("The game will be added to the list of games")
    
    title: dialogTitle
    text: descriptionPrepend

    ProgressBar {
		id: downloadBar
		height: units.dp(3)
		anchors {
			left: parent.left
			right: parent.right
		}

		showProgressPercentage: false
		minimumValue: 0
		maximumValue: 100
	}
    
    //TO DO: Implement a cancel to the download
    
    Button {
		id: cancelButton
		visible: true
        text: i18n.tr("Cancel")
        onClicked: {
            console.log("Aborting")
            DownloadInterceptor.abort()
            //DownloadInterceptor.cancelAction()
            console.log("Closing popup")
            //PopupUtils.close()
            mainPageStack.pop()
        }
    }
    
    
    Connections {
		target: DownloadInterceptor
		
		onDownloading: {
			downloadBar.value = (received * 100) / total
			//console.log("- " + received + " % " +downloadBar.value)
		}
		
		onFail: {
			//Something went wrong and the `message` argument will tell you what it was.
			console.log("Error: " + message)
			cancelButton.visible = true
			cancelButton.texxt = i18n.tr("Close")
			downloadDialog.text = message
		}
	}


}
