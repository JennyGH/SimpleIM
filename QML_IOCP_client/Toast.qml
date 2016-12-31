import QtQuick 2.0

Rectangle {
    id : father
    color : Qt.rgba(0,0,0,0.6)
    width: lbl_toast.contentWidth + 30
    height: lbl_toast.contentHeight + 20
    radius: 10
    anchors {
//        verticalCenter: mainform.verticalCenter
//        horizontalCenter: parent.horizontalCenter
        centerIn:parent
    }

    opacity: 0
    smooth : true
    property string text: ""
    onOpacityChanged:{
        if(opacity == 0){
            father.destroy();
        }
    }
    layer.enabled: true
    layer.effect: OuterShadow{
        target:father
        color : "#000"
        radius: 16
        samples : 32
    }

    Behavior on opacity{
        NumberAnimation {
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }
    MyText{
        id : lbl_toast
        anchors.centerIn: parent
        text : father.text
        color : "#fff"
        font.bold: true
        font_size: 20
    }
    Component.onCompleted: {
        opacity = 1;
        start();
    }

    Timer {
        id : timer
        interval: 2 * 1000
        onTriggered: {
            father.opacity = 0;
        }
    }
    function start(){
        if(opacity == 0){
            timer.start();
        }else{
            timer.restart();
        }
    }
}
