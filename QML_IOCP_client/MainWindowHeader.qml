import QtQuick 2.0

Rectangle{
    id:father
    height: 40
    width: parent.width
    property var movetarget: fatherWindow
    property var closebtn: close
    property string title: "无标题"
    property int marginRight: 8
    signal closeClick();
    signal move();
    z: 10
    color: Qt.rgba(0,0,0,0)
    anchors {
        top:parent.top
        horizontalCenter: parent.horizontalCenter
    }

    MouseArea{
        property point clickPos: "0,0"
        anchors.fill: parent;
        onPressed: {
            clickPos = Qt.point(mouse.x,mouse.y)
        }
        onPositionChanged: {
            //鼠标偏移量
            move();
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)
            //如果mainwindow继承自QWidget,用setPos
            movetarget.setX(movetarget.x+delta.x)
            movetarget.setY(movetarget.y+delta.y)
        }
    }
    MyText{
        text : father.title
        anchors {
            //            verticalCenter: parent.verticalCenter
            top : parent.top
            topMargin: 5
            left: parent.left
            leftMargin: 10
        }
        font_size: 18
    }

    MyButton {
        id:close
        height: 30
        width: 40
        enter_color: "#e81123"
        title : "×"
        font_size : 20
        enter_font_color : "#fff"
        anchors {
            top : parent.top
            right:parent.right
            rightMargin: marginRight
        }
        onClick: {
            closeClick();
            movetarget.close();
        }
    }

}
