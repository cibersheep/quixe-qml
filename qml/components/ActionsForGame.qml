import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Content 1.3

ListItemActions {
	actions: [
		Action {
			visible: fileSuffix === "zip"
			iconName: "add"
			text: i18n.tr("Extract")
			onTriggered: {
				console.log("fileSuffix is zip")
				//extract			
			}
		},
		Action {
			iconName: "share"
			text: i18n.tr("Share")
			onTriggered: {
				//Open the click with Telegram, OpenStore, etc.
				var sharePage = mainPageStack.push(Qt.resolvedUrl("../SharePage.qml"), {"url": filePath, "contentType": ContentType.All, "handler": ContentHandler.Share});
				sharePage.imported.connect(function(filePath) {
					mainPageStack.pop()
				})
			}

		},
		Action {
			iconName: "save"
			text: i18n.tr("Save")
			onTriggered: {
				//Save with File Manger, etc.
				var InstallPage = mainPageStack.push(Qt.resolvedUrl("../InstallPage.qml"), {"url": filePath, "contentType": ContentType.All, "handler": ContentHandler.Destination});
				InstallPage.imported.connect(function(filePath) {
					mainPageStack.pop()
				})
			}
		}
	]
}
