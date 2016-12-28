import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "fontawesome.js" as FA


TextField{
    id:txt
    anchors.verticalCenter: parent.verticalCenter
    font.family: "微软雅黑"
    font.pixelSize: 12
    height: 25
    selectByMouse: true
    property bool isPassword: false
    property int radius: 5

    signal enterPressed();
    signal escPressed();

    onActiveFocusChanged: {
    }

    echoMode: isPassword? TextInput.Password : TextInput.Normal

    validator: RegExpValidator {
        regExp:isPassword ? /[0-9a-zA-z\.\*]{1,16}/ : /.*/  //只允许输入0-9,a-z,A-Z,*,.
    }

    MyText{
        id : _cleartxt
        width: contentWidth
        fa : true
        text : FA.icons.Times.Circle
        enabled : ((txt.text.length > 0) && txt.activeFocus)
        opacity : enabled ? 1 : 0
        font_size: 15
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: 5
        }
        color : "#bbb"
        Behavior on color {
            ColorAnimation {
                duration: 200
            }
        }
        Behavior on opacity {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }

        MouseArea{
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                txt.text = "";
            }
            hoverEnabled: true
            onEntered: {
                _cleartxt.color = "#444"
            }
            onExited: {
                _cleartxt.color = "#bbb"
            }
        }
    }

    style:TextFieldStyle {
        passwordCharacter: "●"
        textColor : "#444"
        background: Rectangle{
            id:_txtstyle
            anchors.fill: parent
            width : txt.bakgwidth
            border.width: 1
            radius: txt.radius
            state : txt.activeFocus ? "active" : "negative"
            layer.enabled: txt.activeFocus
            layer.effect: OuterShadow{
                target:_txtstyle
                color: "#50c3f8"
                radius: 7
                samples: 14
                spread: 0.18
            }
            states: [
                State {
                    name: "active"
                    PropertyChanges {
                        target: _txtstyle
                        border.color : "#168de9"
                    }
                },
                State {
                    name: "negative"
                    PropertyChanges {
                        target: _txtstyle
                        border.color : "#bbb"
                    }
                }
            ]
            transitions: Transition {
                ParallelAnimation {
                    ColorAnimation { property: "color"; duration: 200; easing.type: Easing.InOutSine}
                }
            }
        }
    }

    Keys.enabled: true
    Keys.onPressed: {
        switch(event.key){
        case Qt.Key_Return:
            enterPressed();
            break;
        case Qt.Key_Enter:
            enterPressed();
            break;
        case Qt.Key_Escape:
            escPressed();
            break;
        default : return
        }
        event.accepted = true;
    }
}
