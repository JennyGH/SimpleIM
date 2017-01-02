import QtQuick 2.5
import QtQuick.Window 2.2
import "fontawesome.js" as FA
Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    MainForm {
        anchors.fill: parent
        SelectionBox{
            id : selection
            width: 100
            anchors.centerIn: parent
            model : ["1","2","3"]
        }
    }
}
