import QtQuick 2.0
import QtQuick.Window 2.2

Item {
    id:_resize

    property Window target
    property int barwidth: 0
    property bool canhide: false
    property bool ishide: false
    signal mouseIn();
    signal timeout();

    anchors.fill: parent

    enabled: true

    Timer {
        id:timer
        interval: 300;
        onTriggered: {
            timeout();
        }
    }

    MouseArea {
        id:_top
        height: barwidth
        width: parent.width - barwidth*2
//        color:"blue"
        anchors {
            top:parent.top
            horizontalCenter: parent.horizontalCenter
        }
        hoverEnabled: true
        onEntered: {
            mouseIn();
        }
    }
    MouseArea{
        id:_bottom
        height: barwidth
        width: parent.width - barwidth*2
        enabled: parent.enabled
//        color:"red"
        anchors {
            bottom:parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
        hoverEnabled: true
        onEntered: {
            mouseIn();
        }
    }
    MouseArea{
        id:_left
        height: parent.height
        width: barwidth
        enabled: parent.enabled
//        color:"yellow"
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
        }
        hoverEnabled: true
        onEntered: {
            mouseIn();
        }
    }
    MouseArea{
        id:_right
        height: parent.height
        width: barwidth
        enabled: parent.enabled
//        color:"green"
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        hoverEnabled: true
        onEntered: {
            mouseIn();
        }
    }

    function run(){
        if(timer.running){
            timer.interval = 300;
            timer.restart();
        }else{
            timer.start();
        }
    }
    function setTime(time){
        timer.interval = time;
    }
}
