import QtQuick 2.0
import "../js/generic.js" as GEN

Image{
    id:btn
    signal click()
    signal enter()
    signal exit()

    //------样式-------
    property string enter_img :"qrc:/src/src/photo.png"
    property string exit_img : "qrc:/src/src/photo.png"
    property color enter_font_color : "#444"
    property color exit_font_color : "#444"
    property color border_color : "transparent"
    property string title : "Default"
    property int font_size: 15
    property int contentwidth: btn_title.contentWidth + 20
    state : "out"
    source:"qrc:/src/src/photo.png"
    sourceSize: Qt.size(height,width)
    //---------------------

    MyText {
        id:btn_title
        text:btn.title
        anchors.centerIn: parent
        font_size: btn.font_size
        enter_color : enter_font_color
        exit_color : exit_font_color
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
                source : btn.enter_img
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
                source : btn.exit_img
            }
            PropertyChanges {
                target: btn_title
                color : btn_title.exit_color
            }
        }
    ]
    transitions: Transition {
        ParallelAnimation {
//            ColorAnimation { property: "source"; duration: 150; easing.type: Easing.InOutSine}
        }
    }
}
