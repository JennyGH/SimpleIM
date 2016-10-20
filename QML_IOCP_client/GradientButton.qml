import QtQuick 2.0
import "../js/generic.js" as GEN

Rectangle{
    id:btn
    signal click()
    signal enter()
    signal exit()

    //------样式-------
    property Gradient enter_gradient :Gradient{
        GradientStop{position: 0.0;color : "#6bb2f7"}
        GradientStop{position: 1.0;color : "#1f85fb"}
    }// Qt.rgba(0,0,0,0)
    property Gradient exit_gradient : Gradient{
        GradientStop{position: 0.0;color : "#fff"}
        GradientStop{position: 1.0;color : "#f9f9f9"}
    }
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
    property bool hasShadow: false
    state : "out"
    border.color: border_color
    border.width: border_width
    gradient:exit_gradient
    layer.enabled: hasShadow
    layer.effect:OuterShadow {
        target : btn
        radius: 1.0
        samples: 2
        verticalOffset: 1
        color : "#ddd"
    }
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
            gradient  = enter_gradient;
            enter();
        }
        onExited:{
            btn.state = "out";
            gradient  = exit_gradient;
            exit();
        }
    }

    states: [
        State {
            name: "in"
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
                border.color: exit_border_color
            }
            PropertyChanges {
                target: btn_title
                color : btn_title.exit_color
            }
        }
    ]
//    transitions: Transition {
//        ParallelAnimation {
//            ColorAnimation { property: "color"; duration: 150; easing.type: Easing.InOutSine}
//        }
//    }
}
