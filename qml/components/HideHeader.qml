/*
	Project: Qml Templates for Ubuntu Touch
	https://github.com/cibersheep/qml-templates-for-ubuntutouch
	
	CC-By Joan CiberSheep
	USe: Place this qml in a folder i.e. Components
		- in main qml add at the top: import "rute-to/Components"
		- add in the MainView: property darColor: "#000000" and change coloe hex accordantly
			or comment line 31
		- at the bottom of a page use: HideHeader {}
*/

import QtQuick 2.4
import Ubuntu.Components 1.3

AbstractButton {
	anchors{ 
		top: parent.top
		right: parent.right
		rightMargin: units.gu(2)
		topMargin: header.visible ? header.height + units.gu(1.2) : units.gu(1.2)
		}
	onClicked: { 
		header.visible = !header.visible
	}
	width: units.gu(2)
	height: units.gu(2)
	Icon {
		width: units.gu(2)
		height: units.gu(2)
		color: darkColor
	name: header.visible ? "up" : "down"
	}	
}
