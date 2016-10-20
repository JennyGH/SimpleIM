import QtQuick 2.0

Rectangle{
    id:father
    height: 40
    width: parent.width
    property var movetarget: fatherWindow
    property var closebtn: _row//(min.enabled ? min : (max.enabled ? max : close))
    property string title: "无标题"
    property int font_size: 18
    property int marginRight: 0
    property int marginTop: marginRight
    property bool minable: true
    property bool maxable: false
    property bool moveable: true
    property bool closeable: true
    property bool isWindow: true
    property int btnraduis: 0
    property int btnHeight: 30
    property int btnWidth: 40
    signal closeClick();
    signal move();
    signal dbclick();
    z: 10
//    color: Qt.rgba(0,0,0,0)
    radius:parent.radius
    anchors {
        top:parent.top
        horizontalCenter: parent.horizontalCenter
    }

    gradient: Gradient{
        GradientStop{position: 0.0;color : Qt.lighter(father.parent.color,1.5)}
        GradientStop{position: 1.0;color : "transparent"}
    }

    MouseArea{
        property point clickPos: "0,0"
        anchors.fill: parent;
        enabled: moveable
        onPressed: {
            clickPos = Qt.point(mouse.x,mouse.y)
        }
        onPositionChanged: {
            //鼠标偏移量
            move();
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)
            //如果mainwindow继承自QWidget,用setPos
            movetarget.x = (movetarget.x+delta.x)
            movetarget.y = (movetarget.y+delta.y)
//            console.log(mouseX,mouseY);
        }
        onDoubleClicked: {
            dbclick();
            maxclick();
        }
    }
    MyText{
        text : father.title
        anchors {
            verticalCenter: parent.verticalCenter
//            top : parent.top
//            topMargin: 5
            left: parent.left
            leftMargin: 10
        }
        font_size: font_size
    }

    Row{
        id:_row
        spacing: 1

        anchors{
            right:parent.right
            rightMargin: marginRight
            top:parent.top
            topMargin: marginTop
        }

        MyButton{
            id:min
            height: btnHeight
            width: btnWidth
            title : "—"
            font_size: 11
            enabled: minable
            visible: minable
            radius:btnraduis
            anchors {
                verticalCenter: parent.verticalCenter
            }
            enter_color: "#bbb"
            onClick: {
                movetarget.showMinimized();
            }
        }

        MyButton{
            id:max
            height: btnHeight
            width: btnWidth
            anchors {
                verticalCenter: parent.verticalCenter
            }
            enabled: maxable
            visible: maxable
            radius:btnraduis
            title : "□"
            font_size: 15
            enter_color: "#bbb"
            onClick: {
                if(!movetarget.ismax){
                    movetarget.showMaximized();
                    movetarget.bakg.height = movetarget.height;
                    movetarget.bakg.width = movetarget.width;
                    movetarget.ismax = true;
                }else{
                    movetarget.showNormal();
                    movetarget.bakg.height = movetarget.height - 30;
                    movetarget.bakg.width = movetarget.width - 30;
                    movetarget.ismax = false;
                }
            }
        }

        MyButton {
            id:close
            height: btnHeight
            width: btnWidth
            enter_color: "#e81123"
            title : "×"
            font_size : 20
            enabled: visible
            visible: closeable
            enter_font_color : "#fff"
            radius:btnraduis
//            enter_gradient:Gradient{
//                GradientStop{position: 0.0;color : Qt.lighter("red",1.3)}
//                GradientStop{position: 1.0;color : "red"}
//            }
//            exit_gradient : Gradient{
//                GradientStop{position: 0.0;color : "red"}
//                GradientStop{position: 1.0;color : Qt.darker("red",1.5)}
//            }
//            exit_font_color: "#fff"

            onClick: {
                closeClick();
                if(isWindow){
                    movetarget.close();
                    movetarget.destroy();
                }
            }
        }
    }

    function maxclick(){
        max.click();
    }

}
