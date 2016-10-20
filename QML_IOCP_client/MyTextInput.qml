import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
//import QtGraphicalEffects 1.0


TextField{
    id:txt
    anchors.verticalCenter: parent.verticalCenter
    font.family: "微软雅黑"
    font.pixelSize: 12
//    font.bold: true
    height: 25
    selectByMouse: true
    property bool isPassword: false

    signal enterPressed();
    signal escPressed();

    onActiveFocusChanged: {
//        console.log(active)
//        if(active){

////            _txtstyle.enabled = true
//        }else{
////            _txtstyle.enabled = false
//        }
//        console.log(txt.style.background.layer.enabled)
    }

    echoMode: isPassword? TextInput.Password : TextInput.Normal

    validator: RegExpValidator {
        regExp:isPassword ? /[0-9a-zA-z\.\*]{1,16}/ : /.*/  //只允许输入0-9,a-z,A-Z,*,.
    }

    style:TextFieldStyle {
        passwordCharacter: "*"
        textColor : "#444"
        background: Rectangle{
            id:_txtstyle
            anchors.fill: parent
            border.width: 1
            radius: 4
            state : txt.activeFocus ? "active" : "negative"
            layer.enabled: txt.activeFocus
            layer.effect: OuterShadow{
                target:_txtstyle
                color: "#1f85fb"
                radius: 3
                samples: 8
            }
            states: [
                State {
                    name: "active"
                    PropertyChanges {
                        target: _txtstyle
                        border.color : "#1f85fb"
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
