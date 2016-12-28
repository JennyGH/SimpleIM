import QtQuick 2.0

Rectangle{
    id:myself
    property int marginleft: 10
    property int margintop: 10
    property color font_color: mainform.font_color
    property bool conn: false
    property string myName: "Me"
    width:parent.width
    height: 60
    color: mainform.color
    state:"exit"

    signal click()
    signal dbClick();

    Row{
        id:row
        anchors{
            left:parent.left
            leftMargin: marginleft
            top:parent.top
            topMargin: margintop
        }
        width: parent.width
        spacing: 10

        Head{
            id:my_head
            height: 40
            width: 40
            radius:40
            anchors{
                verticalCenter: parent.verticalCenter
            }
        }
        MyText{
            id:txt
            color:myself.font_color
            font_size:18
            anchors{
                verticalCenter: parent.verticalCenter
            }
            text:"<b>  " + myName + "(" + (conn ? "在线" : "离线") + ")</b> "
        }
        OnlineLED {
            id:ol
            online: myself.conn;
            anchors{
                verticalCenter: parent.verticalCenter
            }
        }
    }

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            click();
        }
        onEntered:{
            myself.state = "enter";
        }
        onExited: {
            myself.state = "exit";
        }
        onDoubleClicked: {
            dbClick();
        }
    }
    states: [
        State {
            name: "enter"
            PropertyChanges {
                target: myself
                color: "#e2e2e2"
            }
        },
        State {
            name: "exit"
            PropertyChanges {
                target: myself
                color: mainform.color
            }
        }
    ]

    transitions: Transition {
        ParallelAnimation {
            ColorAnimation { property: "color"; duration: 200 ;}
        }
    }
}
