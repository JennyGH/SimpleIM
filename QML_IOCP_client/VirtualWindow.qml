import QtQuick 2.0
import QtQuick.Window 2.2
import "../js/generic.js" as GEN

Window {
    height: 1
    width:1
    visible: true;
    opacity: 0
    flags : Qt.FramelessWindowHint | Qt.Window
    onVisibleChanged: {
        if(!visible){
            GEN.releaseWindow(this);
        }
    }
}
