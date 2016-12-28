import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
CheckBox{
    id:checkbox
    height:16
    width:16
//    anchors.verticalCenter: parent.verticalCenter
    style:CheckBoxStyle {
        indicator: Image {
            height:checkbox.height
            width:checkbox.width
            source:"qrc:/checkBox_normal.png"
            Image {
                visible: checkbox.checked
                source:"qrc:/checkBox_selected.png"
                anchors.fill: parent
            }
        }
    }
}

