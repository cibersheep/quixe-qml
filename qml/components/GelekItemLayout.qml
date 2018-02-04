import QtQuick 2.4
import Ubuntu.Components 1.3

ListItemLayout {
    title.text: root.title.text
    title.color: lightColor
    
    //subtitle.text: i18n.tr("")
	//summary.text: i18n.tr("")

    width: parent.width //- marginColumn * 2
    anchors.horizontalCenter: parent.horizontalCenter
    
    //CheckBox { SlotsLayout.position: SlotsLayout.Leading }
    Icon {
        name: "next"
        SlotsLayout.position: SlotsLayout.Trailing;
        width: units.gu(2)
    }
}
