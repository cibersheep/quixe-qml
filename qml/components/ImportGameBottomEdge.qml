import QtQuick 2.4
import Ubuntu.Components 1.3

BottomEdge {
	id: bottomEdge
    anchors.fill: parent
	hint {
		text: i18n.tr("Import")
		enabled: bottomEdge.enabled
	}
	preloadContent: true

	onCommitCompleted: {
		console.log("Commit completed")
		importContent()
		bottomEdge.collapse()
	}

	contentComponent: 
	Column {
		id: addGame
		height: root.height
		anchors {
			top: bottomEdge.top
			topMargin: units.gu(12)
		}
		spacing: units.gu(1)
		
		Text {
			text: i18n.tr("Import")
			anchors.horizontalCenter: parent.horizontalCenter
			font.pointSize: units.gu(2)
			wrapMode: Text.WrapAtWordBoundaryOrAnywhere
		}
		Text {
			text: i18n.tr("a new game")
			anchors.horizontalCenter: parent.horizontalCenter
			wrapMode: Text.WrapAtWordBoundaryOrAnywhere
		}
		UbuntuShape {
		   id: iconTop
		   width: units.gu(20)
		   height: width
		   anchors.horizontalCenter: parent.horizontalCenter
		   aspect: UbuntuShape.Flat
		   source: Image {
			   sourceSize.width: parent.width
			   source: "../../assets/listIcon.svg"
		   }
	   }
	}
}
