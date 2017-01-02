import QtQuick 2.0
import "fontawesome.js" as FA

Rectangle {
    id:mask
    anchors.fill: parent
    color : "#80000000"
    z : 990
    radius:parent.radius
    signal ok();
    signal cancel();
    signal close();
    property int alertHeight: 100
    property int alertWidth: 100
    property string content: ""
    property bool isConfirm: true
    property bool success: false

    Component.onCompleted: {show();}
    Component.onDestruction: {}

    enabled: opacity == 1

    state : "hide"

    onOpacityChanged: {
        if(opacity == 0){
            close();
            if(alert.okClicked){
                alert.okClicked = false;
                ok();
            }else{
                cancel();
            }
//            mask.destroy();
        }
    }

    states: [
        State {
            name: "hide"
            PropertyChanges {
                target: mask
                opacity : 0
            }
            PropertyChanges {
                target: alert
                scale : 1.2
            }
        },

        State {
            name: "show"
            PropertyChanges {
                target: mask
                opacity : 1
            }
        }
    ]

    transitions: [
        Transition {
            from: "*"
            to: "*"
            NumberAnimation {
                target: mask
                property: "opacity"
                duration: 200
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: alert
                property: "scale"
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
    ]

    MouseArea {
        //蒙板
        enabled: mask.enabled
        anchors.fill: parent
        hoverEnabled: mask.enabled
        onClicked: {
            return false;
        }
        onEntered: {
            return false;
        }
        onExited: {
            return false;
        }
        onPressed: {
            return false;
        }
        onDoubleClicked: {
            return false;
        }
    }

    Rectangle {
        id : alert
        anchors.centerIn: parent
        color : "#f0f0f0"
//        x : (parent.width - alert.width) / 2
//        y : (parent.height - alert.height) / 2
        property bool okClicked: false
        height: alertHeight
        width: alertWidth
        border{
            color: "#fff"
            width : 1
        }
        smooth: true

        radius: 5
        z : 999

        Component.onCompleted: {
            forceActiveFocus();
        }

        MainWindowHeader{
            id: _alertheader
            movetarget: alert
            moveable: false
            btnHeight: 20
            btnWidth: btnHeight
            btnraduis: alert.radius * 100
            minable: false
            closeable: false
            title : "提示"
            font_size: 12
            height: 30
//            marginRight:-5//parent.border.width
//            marginTop: -5
            isWindow: false
            onCloseClick: {
                close();
//                mask.destroy();
            }
        }

        Item{
            id : _alertbody
            width: parent.width
//            color : "#ededef"
            anchors {
                top : _alertheader.bottom
                bottom: _alertfooter.top
            }
            MyText{
                anchors.centerIn: parent
                text: content
                font_size : 13
                MyText{
                    fa : true
                    font_size: 40
                    text : success ? FA.icons.Ok : FA.icons.ExclamationSign
                    color : success ? "green" : "#ffbb2e"
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.left
                        rightMargin: 10
                    }
                }
            }
        }
        Row{
            id:_alertfooter
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
            }
            spacing : 10
            height: _alertOK.height + 2*spacing
            GradientButton {
                id : _alertOK
                height: 23
                width: 60
                title : "确定"
                border_color: "#ccc"
                hasShadow: true
                enter_border_color: "#0b67cf"
                radius: 5
                enter_font_color: "#fff"
                font_size: 13
                anchors.verticalCenter: parent.verticalCenter
                onClick: {
                    alert.okClicked = true;
                    mask.hide();
                }
            }
            GradientButton{
                id : _alertCancel
                height: 23
                width: 60
                title : "取消"
                border_color: "#ccc"
                hasShadow: true
                enter_border_color: "#0b67cf"
                radius: 5
                enter_font_color: "#fff"
                font_size: 13
                anchors.verticalCenter: parent.verticalCenter
                visible: isConfirm
                enabled: visible
                onClick: {
                    mask.hide();
                }
            }
        }
    }

    OuterShadow {
        id:_shadow
        target :alert
        radius: 16.0
        samples: 32
    }

    function hide(){
        mask.state = "hide";
    }
    function show(){
        mask.state = "show";
    }
}
