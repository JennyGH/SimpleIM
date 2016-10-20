import QtQuick 2.0
import QtQuick.Controls 1.4

Rectangle{
    id:_mask
    anchors.fill: parent
    color : Qt.rgba(255,255,255,0.8)
    z : 990
    radius:parent.radius
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
    BusyIndicator{
        id:_busy
        anchors.centerIn: parent
        z:999
        running: false
        onRunningChanged: {
            if(!running){
                _mask.destroy();
            }
        }
    }
    function start(){
        _busy.running = true;
    }
    function stop(){
        _busy.running = false;
    }
}
