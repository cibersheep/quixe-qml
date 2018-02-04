import QtQuick 2.4
import Ubuntu.Components 1.3

PageHeader {
	title: root.title
	
	StyleHints {
		foregroundColor: lighterColor
		backgroundColor: darkColor
		divider.visible: false
	}
	
	trailingActionBar {
		numberOfSlots: 1
		actions: [
			Action {
				id: actionNew
				iconName: "info"
				shortcut: "Ctrl+i"
				text: i18n.tr("Information")
				onTriggered: {
					mainPageStack.push(Qt.resolvedUrl("../about.qml"));
				}
			}
		]
	}
	
}
