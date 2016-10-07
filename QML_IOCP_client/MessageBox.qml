import QtQuick 2.0

Rectangle {
    id:father
    height: 50
    width: parent.width
    color: Qt.lighter("#eee789",1);
    property string tips: ""
    property var topObject : header
    state: "hide"

    anchors {
        top : topObject.bottom
    }

    MyText{
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 10
        }
        text : father.tips
    }

    MyButton{
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: 10
        }
        height: 20
        width: 20
        title :"×"
        border_color: "#ddd"
        enter_color: "#bbb"
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
                height : 50
                opacity : 1
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
