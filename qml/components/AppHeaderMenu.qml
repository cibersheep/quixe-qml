import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.0
import Ubuntu.Content 1.3
import Backend 1.0

AppHeader {
	title: "Quixe"
	id: header
	
	leadingActionBar.actions: [
		Action {
			iconName: "info"
			text: i18n.tr("Back")
			//onTriggered: PopupUtils.open(openDialogComponent, root) //, {'path': path});
			onTriggered: Backend.extractZip("here","there")
		},
		Action {
			iconName: "import"
			text: i18n.tr("Import Game")
			onTriggered: {
				importContent()
			}
		},
		Action {
			iconName: "import"
			text: i18n.tr("Back")
			onTriggered: {
				root.extractArchive("/home/cibersheep/Ubuntu_Touch_Projects/Quixe-qml/qml/www/media/eliza.zip","./zip", "zip")
				//Backend.extractZip("/home/cibersheep/Ubuntu_Touch_Projects/Quixe-qml/qml/www/media/eliza.zip","./zip")
			}
		}
	]
}
