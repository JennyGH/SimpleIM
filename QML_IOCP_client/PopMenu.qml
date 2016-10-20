import QtQuick 2.0

Rectangle {
    color : "blue"
    width: 135
    height:200
    visible : false
    enabled: false

    MouseArea{
        anchors.fill: parent
        onClicked: {
            console.log("pop menu clicked...")
        }
    }

}
