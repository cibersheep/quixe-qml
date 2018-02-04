import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Content 1.3

import Backend 1.0

ListItem {
	clip: true
	divider.visible: false
	highlightColor: "transparent"
	leadingActions: ListItemActions { actions: [
						Action {
							iconName: "delete"
							text: i18n.tr("Delete")
							onTriggered: {
								console.log("Will delete: " + fileName)
								Backend.remove(filePath)
							}
						}
					]
	}
	trailingActions: ActionsForGame {}
	
	MouseArea {
		anchors.left: parent.left
		anchors.right: parent.right
		height: layout.height
		
		onClicked: {
			console.log("game" + filePath)

			//Edit
			var actionQml
			switch (fileSuffix) {
			case "zip":
				console.log("fileSuffix is zip")
				//extract
				extractArchive(filePath, fileName, fileSuffix)
				break
			case "ulx":
			case "gblorb":
			case "blb":
				console.log("Game with fileSuffix " + fileSuffix)
				mainPageStack.push(Qt.resolvedUrl("../WebviewPage.qml"),{"game": filePath})
				break
			default:
				console.log("We don't know what type of file it is: " + fileSuffix)
				
				//TO DO: Give an error
			}

			
		}
		ListItemLayout {
			id:layout
			title.text: fileName
			title.color: darkColor
			
			//subtitle.text: i18n.tr("")
			summary.text: i18n.tr("Modified: %1. Accessed: %2").arg(fileModified.toLocaleDateString(Locale.ShortFormat)).arg(fileAccessed.toLocaleDateString(Locale.ShortFormat))
			
			width: parent.width //- marginColumn * 2	
			anchors.horizontalCenter: parent.horizontalCenter
			
			Icon {
				source: "../../assets/listIcon.svg"
				SlotsLayout.position: SlotsLayout.Leading
				width: units.gu(3)
			}
			
			Icon {
				name: "next"
				SlotsLayout.position: SlotsLayout.Trailing
				width: units.gu(2)
			}
			
		}
	}
}
