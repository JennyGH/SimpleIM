import QtQuick 2.0
import "fontawesome.js" as FA

Rectangle {
    id:father
    height: 40
    width: parent.width
    color: Qt.lighter("#eee789",1);
    property string tips: ""
    property var topObject : header
    state: "hide"

    anchors {
        top : topObject.bottom
    }
    Row{
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 10
        }
        spacing : 5
        MyText{
            text : FA.icons.WarningSign
            fa : true
            font_size: 20
        }
        MyText{
            text : father.tips
        }
    }

    MyButton{
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: 10
        }
        height: 20
        width: 20
        usingFA : true
        title :FA.icons.Times.Circle
        exit_font_color:"#fff"
        font_size: 20
        exit_color: "transparent"
        enter_color : "transparent"
        onClick: {
            father.state = "hide"
        }
    }

    states: [
        State {
            name: "hide"
            PropertyChanges {
                target: father
                height: 0
                opacity : 0
            }
        },
        State {
            name: "show"
            PropertyChanges {
                target: father
                height : 40
                opacity : 0.8
            }
        }
    ]
    transitions: [
        Transition {
            from: "*"
            to: "*"
            ParallelAnimation{
                NumberAnimation {
                    target: father
                    property: "height"
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: father
                    property: "opacity"
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
            }
        }
    ]

    Component.onCompleted: {
    }
}
