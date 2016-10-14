import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import "../js/generic.js" as GEN

Window{
    id:father
    height: 480
    width : 470
    visible: true
    flags: Qt.FramelessWindowHint | Qt.Window
    property Rectangle bakg: _signinwindowbakg
    property color bakgcolor: "#f5f5f5"

    color:Qt.rgba(0,0,0,0)

    onVisibleChanged: {
        //
    }

    Rectangle{
        id:_signinwindowbakg
        height: father.height - 30
        width : father.width - 30
        anchors.centerIn: parent
        radius:5
        color : bakgcolor
        border.color: "#fff"
        Component.onCompleted: {
            //窗体背景加载完成...
        }
        MainWindowHeader{
            id:_signinwindwheader
            movetarget: father
            marginRight:_signinwindowbakg.radius + _signinwindowbakg.border.width
            title:"注册"
            btnHeight: 30
            btnWidth: btnHeight
            btnraduis: _signinwindowbakg.radius * 100
            anchors {
                topMargin: marginRight
            }
            onCloseClick: {
                _loginwindow.newsigninwindow = null;
            }
        }

        Rectangle{
            id:_signinwindowcontent
            height: _signinwindowbakg.height - _signinwindwheader.height - _signinwindowfooter.height - _signinwindowbakg.border.width - 10
            width: _signinwindowbakg.width - _signinwindowbakg.border.width*2 - 10
            anchors {
                horizontalCenter: _signinwindowbakg.horizontalCenter
                top : _signinwindwheader.bottom
            }
            radius:3
            color : "#fff"
            border.color: "#e2e2e2"
//            TextArea{
//                id:txt
//                text:"<img src='qrc:/src/src/userIcon.png' width='100' height='100'>"
//                anchors.centerIn: parent
//                textFormat: TextEdit.RichText
//            }
        }
        Row{
            id:_signinwindowfooter
            anchors {
                top :_signinwindowcontent.bottom
//                horizontalCenter: _signinwindowbakg.horizontalCenter
                right: _signinwindowbakg.right
                rightMargin: 5
            }
            height: 40
            MyButton{
                id:btnSubmit    //提交按钮
                height: 30
                width: 60
                title:"提交"
                anchors {
                    verticalCenter: parent.verticalCenter
                }
                enter_font_color: "#fff"
                enter_color: "#5aa7f8"
                radius:5
                border_color: "#ddd"
            }
        }
    }

    DropShadow {
        anchors.fill: father.bakg
        horizontalOffset: 0
        verticalOffset: 0
        radius: 16.0
        samples: 32
        color: "#80000000"
        source: father.bakg
        scale: father.bakg.scale
        opacity: father.bakg.opacity
    }
}
