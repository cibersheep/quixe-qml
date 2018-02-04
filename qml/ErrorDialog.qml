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

Dialog {
    id: root
    property Page page
    property string message
    property string descriptionPrepend: i18n.tr("It has been a problem downloading the file")
    
    title: i18n.tr(message)
    text: descriptionPrepend

    function startOperation(name) {
        root.title = name
    }

    ActivityIndicator {
		id: loadingSpinner
		running: true
	}
    
    Button {
        text: i18n.tr("Close")
        onClicked: {
            console.log("Closing popup")
            //PopupUtils.close()
            mainPageStack.pop()
        }
    }

}
