import QtQuick 2.0

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
    property bool isComfirm: true

    MouseArea {
        //蒙板
        anchors.fill: parent
        hoverEnabled: true
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
        color : "#ededef"
//        x : (parent.width - alert.width) / 2
//        y : (parent.height - alert.height) / 2
        height: alertHeight
        width: alertWidth
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
                mask.destroy();
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
                font_size : 15
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
            GradientButton{
                id : _alertOK
                height: 25
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
                    ok();
                    mask.destroy();
                }
            }
            GradientButton{
                id : _alertCancel
                height: 25
                width: 60
                title : "取消"
                border_color: "#ccc"
                hasShadow: true
                enter_border_color: "#0b67cf"
                radius: 5
                enter_font_color: "#fff"
                font_size: 13
                anchors.verticalCenter: parent.verticalCenter
                visible: isComfirm
                enabled: visible
                onClick: {
                    cancel();
                    mask.destroy();
                }
            }
        }
    }
    function closeAlert(){
        mask.destroy();
    }
}
