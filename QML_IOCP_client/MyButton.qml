import QtQuick 2.0
import "../js/generic.js" as GEN

Rectangle{
    id:btn
    signal click()
    signal enter()
    signal exit()

    //------样式-------
    property color enter_color :"#f5f5f5"// Qt.rgba(0,0,0,0)
    property color exit_color : "#f5f5f5"// Qt.rgba(0,0,0,0)
    property color enter_font_color : "#444"
    property color exit_font_color : "#444"
    property int enter_border_width: 1
    property int exit_border_width: 0
    property color enter_border_color : border_color
    property color exit_border_color : border_color
    property color border_color : "transparent"
    property int border_width: 1
    property string title : "Button"
    property int font_size: 15
    property int contentwidth: btn_title.contentWidth + 20
    state : "out"
    border.color: border_color
    border.width: border_width
    //---------------------

    MyText {
        id:btn_title
        text:btn.title
        anchors.centerIn: parent
        font_size: btn.font_size
        enter_color : enter_font_color
        exit_color : exit_font_color
        textFormat: Text.RichText
    }

    MouseArea{
        anchors.fill: btn
        hoverEnabled: true
        onClicked: {click();}
        onEntered:{
            btn.state = "in";
            enter();
        }
        onExited:{
            btn.state = "out";
            exit();
        }
    }

    states: [
        State {
            name: "in"
            PropertyChanges {
                target: btn
                color : btn.enter_color
            }
            PropertyChanges {
                target: btn
                border.color: enter_border_color
            }
            PropertyChanges {
                target: btn_title
                color : btn_title.enter_color
            }
        },
        State {
            name: "out"
            PropertyChanges {
                target: btn
                color : btn.exit_color
            }
            PropertyChanges {
                target: btn
                border.color: exit_border_color
            }
            PropertyChanges {
                target: btn_title
                color : btn_title.exit_color
            }
        }
    ]
    transitions: Transition {
        ParallelAnimation {
            ColorAnimation { property: "color"; duration: 150; easing.type: Easing.InOutSine}
        }
    }
}
