import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "generic.js" as GEN

Window{
    id:_signinwindow
    height: 250
    width : 300
    visible: true
    flags: Qt.FramelessWindowHint | Qt.Window
    property Rectangle bakg: _signinwindowbakg
    property Busy busy: null
    property Alert alertwindow: null
    property color bakgcolor: "#f5f5f5"

    color:Qt.rgba(0,0,0,0)

    onVisibleChanged: {
        //
    }

    Connections{
        target:client
        onRecvmessage : {
            var returnmsg = client.getMessage();
            var obj = GEN.formatMessage(returnmsg);
            var result;
            switch(parseInt(obj.type)){
            case 8: //返回注册结果
                busy.stop();
                var _alert = GEN.alert({
                                           height :130,
                                           width : 220,
                                           text : obj.message,
                                           parent : _signinwindowbakg,
                                           confirm : false,
                                           success : true,
                                           onOk : function(){
                                               _signinwindow.close();
                                               _signinwindow.destroy();
                                           },
                                           onClose : function(){
                                               _alert.destroy();
                                           }
                                       });
                break;
            default:break;
            }
        }
    }

    Rectangle{
        id:_signinwindowbakg
        height: _signinwindow.height - 30
        width : _signinwindow.width - 30
        anchors.centerIn: parent
        radius:5
        color : bakgcolor
        border.color: "#fff"
        layer.enabled: true
        layer.effect: OuterShadow {target : _signinwindow.bakg}
        Component.onCompleted: {
            //窗体背景加载完成...
        }
        MainWindowHeader{
            id:_signinwindwheader
            movetarget: _signinwindow
            marginRight:_signinwindowbakg.radius + _signinwindowbakg.border.width
            marginTop: marginRight
            title:"注册"
            onCloseClick: {
                _loginwindow.newsigninwindow = null;
            }
        }

        Rectangle {
            id:_signinwindowcontent
//            height: _signinwindowbakg.height - _signinwindwheader.height - _signinwindowfooter.height - _signinwindowbakg.border.width - 10
            width: _signinwindowbakg.width - _signinwindowbakg.border.width*2 - 10
            anchors {
                horizontalCenter: _signinwindowbakg.horizontalCenter
                top : _signinwindwheader.bottom
                topMargin: 5
                bottom: _signinwindowfooter.top
            }
            radius:3
            color : "#fff"
            border.color: "#e2e2e2"
            Column{
                spacing: 10
                anchors.centerIn: parent
                Row{
                    spacing: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    Span{
                        id:lblname
                        text:"昵称"
                        anchors.verticalCenter: parent.verticalCenter
                        height: txtname.height
                        width: 70
                    }
                    MyTextInput{
                        id:txtname
                        width: _signinwindowcontent.width - lblname.contentWidth - 50
                        radius : 0
                    }
                }
                Row{
                    spacing: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    Span{
                        id:lblpsw
                        text:"密码"
                        anchors.verticalCenter: parent.verticalCenter
                        height: txtpsw.height
                        width: 70
                    }
                    MyTextInput{
                        id:txtpsw
                        width: _signinwindowcontent.width - lblpsw.contentWidth - 50
                        isPassword:true
                        radius : 0
                    }
                }
                Row{
                    spacing: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    Span{
                        id:lblconfirmpsw
                        text:"确认密码"
                        anchors.verticalCenter: parent.verticalCenter
                        height: txtconfirmpsw.height
                        width: 70
                    }
                    MyTextInput{
                        id:txtconfirmpsw
                        width: _signinwindowcontent.width - lblconfirmpsw.contentWidth - 50
                        isPassword:true
                        radius : 0
                    }
                }
            }


        }

        Row{
            id:_signinwindowfooter
            anchors {
                bottom: parent.bottom
                right: _signinwindowbakg.right
                rightMargin: 5
            }
            height: 40
            GradientButton{
                id:btnSubmit    //提交按钮
                height: 25
                width: 60
                title:"✔"
//                hasShadow: true
                anchors {
                    verticalCenter: parent.verticalCenter
                }
                enter_font_color: "#fff"
                enter_gradient: Gradient{
                    GradientStop{position: 0.0;color : "#1bbf2e"}
                    GradientStop{position: 1.0;color : Qt.darker("#1bbf2e",1.5)}
                }

//                enter_color: "#5aa7f8"
                radius:5
                border_color: "#ccc"
                onClick: {
                    //注册
                    var _alert;
                    var canreg = false;
                    var warningStr;
                    if(txtname.text.trim() === ""){
                        warningStr = "昵称不能为空...";
                    }else if(txtpsw.text.trim() === ""){
                        warningStr = "密码不能为空...";
                    }else if(txtconfirmpsw.text.trim() === ""){
                        warningStr = "请确认密码...";
                    }else if(txtconfirmpsw.text.trim() !== txtpsw.text.trim()){
                        warningStr = "两次密码不相同...";
                    }else{
                        canreg = true;
                    }
                    if(canreg){
//                        console.log("can reg...");
                        if(!_loginwindow.isConnect){
                            if(!client.initSocket()){
                                _alert = GEN.alert({
                                                       height :130,
                                                       width : 220,
                                                       text : "连接服务器失败...",
                                                       parent : _signinwindowbakg,
                                                       success : false,
                                                       confirm : false,
                                                       onOk : function(){
        //                                                   _signinwindow.close();
        //                                                   _signinwindow.destroy();
                                                       },
                                                       onClose : function(){
                                                           _alert.destroy();
                                                       }
                                                   });
                                return false;
                            }else{
                                _loginwindow.isConnect = true;
                            }
                        }
                        client.sendmessage(txtpsw.text,txtname.text,signinMessage);
                        busy = GEN.createWindow("Busy",_signinwindowbakg);
                        busy.start();
                    }else{
                        _alert = GEN.alert({
                                               height :130,
                                               width : 220,
                                               text : warningStr,
                                               parent : _signinwindowbakg,
                                               confirm : false,
                                               onOk : function(){
//                                                   _signinwindow.close();
//                                                   _signinwindow.destroy();
                                               },
                                               onClose : function(){
                                                   _alert.destroy();
                                               }
                                           });
                    }
                }

            }
        }
    }
}
