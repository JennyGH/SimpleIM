import QtQuick 2.0
import QtQuick.Window 2.2

Item {
    id:_resize

    property Window target
    property int barwidth: 0

    anchors.fill: parent

    enabled: true

    MouseArea {
        id:_top
        height: barwidth
        width: parent.width - barwidth*2
        cursorShape :Qt.SizeVerCursor
        enabled: parent.enabled
        anchors {
            top:parent.top
            horizontalCenter: parent.horizontalCenter
        }
        property point clickPos: "0,0"
        onPressed: {
            clickPos = Qt.point(mouse.x,mouse.y);
        }
        onPositionChanged: {
            //鼠标偏移量
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y);
            if(_resize.parent.height + delta.y >= minimumHeight){
                _resize.parent.height += delta.y;
            }
        }
    }
    MouseArea{
        id:_bottom
        height: barwidth
        width: parent.width - barwidth*2
        cursorShape :Qt.SizeVerCursor
        enabled: parent.enabled
        anchors {
            bottom:parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
        property point clickPos: "0,0"
        onPressed: {
            clickPos = Qt.point(mouse.x,mouse.y);
        }
        onPositionChanged: {
            //鼠标偏移量
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y);
            if(_resize.parent.height + delta.y >= minimumHeight){
                _resize.parent.height += delta.y;
            }
        }
    }
    MouseArea{
        id:_left
        height: parent.height - barwidth*2
        width: barwidth
        cursorShape :Qt.SizeHorCursor
        enabled: parent.enabled
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
        }
        property point clickPos: "0,0"
        onPressed: {
            clickPos = Qt.point(mouse.x,mouse.y);
        }
        onPositionChanged: {
            //鼠标偏移量
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y);
            if(_resize.parent.width + delta.x >= _resize.parent.minimumWidth){
                _resize.parent.width += delta.x
            }
        }
    }
    MouseArea{
        id:_right
        height: parent.height - barwidth*2
        width: barwidth
        cursorShape :Qt.SizeHorCursor
        enabled: parent.enabled
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        property point clickPos: "0,0"
        onPressed: {
            clickPos = Qt.point(mouse.x,mouse.y);
        }
        onPositionChanged: {
            //鼠标偏移量
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y);
            if(_resize.parent.width + delta.x >= _resize.parent.minimumWidth){
                _resize.parent.width += delta.x
            }
        }
    }
}
