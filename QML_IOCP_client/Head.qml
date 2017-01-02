import QtQuick 2.0
import QtGraphicalEffects 1.0
Rectangle{
    id:user_head
    height:120
    width:120
    radius: 100
    smooth: true
    property string headIconSource : "qrc:/src/src/userIcon.png"
    Image{
        id:icon
        smooth: true
//        anchors.fill: parent
        anchors.centerIn: parent
        height: parent.height - parent.border.width*2
        width: parent.width - parent.border.width*2
        fillMode: Image.PreserveAspectCrop
        source:parent.headIconSource
        sourceSize: Qt.size(parent.width, parent.height)
//        visible: false
    }
//    Image {
//        id: mask
//        source: "qrc:/src/src/OpacityMask.png"
//        sourceSize: Qt.size(parent.width, parent.height)
//        smooth: true
//        visible: false
//    }
//    OpacityMask{
//        cached: true
//        anchors.fill: icon
//        source: icon
//        maskSource: mask
//    }

    states: [
        State {
            name: "ACTIVE"
            PropertyChanges {
                target: user_head
                border.color : "#50c3f8"
            }
        },
        State {
            name: "NEGTIVE"
            PropertyChanges {
                target: user_head
                border.color : "#f5f5f5"
            }
        }
    ]
    transitions: Transition {
        ParallelAnimation {
            ColorAnimation { property: "border.color"; duration: 300 }
        }
    }
}

