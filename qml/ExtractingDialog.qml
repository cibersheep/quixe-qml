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

import Backend 1.0

Dialog {
    id: extractingDialog
    //property FolderListModel model
    property Page page
    property string descriptionPrepend: i18n.tr("The file is being uncompressed")
    
    title: i18n.tr("Uncompressing")
    text: descriptionPrepend

    function startOperation(name) {
        root.title = name
    }

    ProgressBar {
		id: downloadBar
		height: units.dp(3)
		anchors {
			left: parent.left
			right: parent.right
		}
		indeterminate: true
		showProgressPercentage: false
		minimumValue: 0
		maximumValue: 100
	}
    
    //TO DO: Implement a cancel to the uncompress
    /*
    Button {
        text: i18n.tr("Close")
        onClicked: {
            console.log("Closing popup")
            //DownloadInterceptor.cancelAction()
            PopupUtils.close(root)
            mainPageStack.pop()
        }
    }
    */
    

Connections {
	target: Backend
	onFileExtracted: {
		PopupUtils.close(extractingDialog)
	}
}
}

