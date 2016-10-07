import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import "../js/generic.js" as GEN
//import Client 1.0

Window{
    id:_loginwindow
    height: 250
    width: 350
    visible: true
    flags: Qt.FramelessWindowHint | Qt.Window
    property string userID
    property string psw

    Component.onCompleted: {
//        client.ip = "119.29.178.76"
        txtID.forceActiveFocus();
    }

    Connections {
        target: client
        onRecvmessage: {
            var returnmsg = client.getMessage();
            var obj = GEN.formatMessage(returnmsg);
            if(parseInt(returnmsg) === 0){
                try{
                    var chatmainwindow = GEN.createWindow("ChatMainWindow",null);
                    if(chatmainwindow){
//                        chatmainwindow.setClient(client);
//                        console.log("client:" + chatmainwindow.client);
                        chatmainwindow.conn = true;
                        chatmainwindow.myName = _loginwindow.userID;
                        _loginwindow.close();
                    }
                }catch(ex){
                    console.log(ex);
                }
            }else{
                switch(parseInt(obj.type)){
                case 1:
                    //系统消息
                    switch(parseInt(obj.message)){
                    case 1:
                        GEN.showMessageBox(_logintips,"用户名不存在...");
                        break;
                    case 2:
                        GEN.showMessageBox(_logintips,"密码错误...");
                        break;
                    default:
                        break;
                    }
                    break;
                default:
                    break;
                }
            }
        }

    }


    Rectangle{
        id:_loginwindowbakg
        color : "#f5f5f5"
        border.color: "#e2e2e2"
        border.width: 1
        anchors.fill: parent

        MainWindowHeader{
            id:_loginwindowheader
            movetarget : _loginwindow
            marginRight:parent.border.width
            title : ""
            anchors {
                topMargin: marginRight
            }
            Row{
                spacing : 1
                anchors {
                    top : _loginwindowheader.top
                    right:_loginwindowheader.closebtn.left
                    rightMargin: 1
                }

                MyButton{
                    id:setting
                    title : ""
                    anchors {
                        verticalCenter: parent.verticalCenter
                    }
                    Image{
//                        anchors.fill: parent
                        source : "qrc:/src/src/setting.png"
                        height: parent.height * 0.5
                        width: height
                        sourceSize.height: height
                        sourceSize.width: width
                        anchors.centerIn: parent
                    }

                    height: 30
                    width: 40
                    enter_color: "#bbb"
                    onClick: {
                        var newsettingwindow = GEN.createWindow("SettingWindow",_loginwindow);
                        if(newsettingwindow){
                            newsettingwindow.setTxtIp(client.ip);
                            newsettingwindow.setTxtPort(client.port);
                            newsettingwindow._tishi = _logintips;
                            GEN.showWindow(newsettingwindow);
                        }else{
                            console.error(newsettingwindow + " 未创建...");
                        }
                    }
                }

                MyButton{
                    id:min
                    height: 30
                    width: 40
                    title : "—"
                    font_size: 11
                    anchors {
                        verticalCenter: parent.verticalCenter
                    }
                    enter_color: "#bbb"
                    onClick: {
                        _loginwindow.showMinimized();
                    }
                }
            }
        }

        MessageBox{
            id:_logintips
            state : "hide"
            topObject : _loginwindowheader
        }

        Item{
            height: _loginwindowbakg.height - _loginwindowheader.height - _logintips.height
            width: _loginwindowbakg.width
            anchors {
//                fill : parent
                top : _logintips.bottom
                horizontalCenter: _loginwindowbakg.horizontalCenter
            }

            Column{
                spacing: 20
                width: _loginwindowbakg.width
                anchors.centerIn: parent
                Row{
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                    }
                    spacing: 10

                    MyText{
                        id:lblID
                        text : "用户ID:"
                        anchors {
                            verticalCenter: parent.verticalCenter
                        }
                    }
                    TextField{
                        id:txtID
                        width: _loginwindowbakg.width - lblID.contentWidth - 50
                        font.family: "微软雅黑"
                        font.pixelSize: 15
                        height: 30
                        anchors {
                            verticalCenter: parent.verticalCenter
                        }
                        onTextChanged: {
                            GEN.limitNumber(txtID);
//                            console.log(parseInt(txtID.text));
                        }

                        Keys.enabled: true
                        Keys.onPressed: {
                            switch(event.key){
                            case Qt.Key_Return:
                                txtpsw.forceActiveFocus();
                                break;
                            case Qt.Key_Enter:
                                txtpsw.forceActiveFocus();
                                break;
                            case Qt.Key_Escape:
                                break;
                            default : return
                            }
                            event.accepted = true;
                        }
                    }
                }
                Row{
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                    }
                    spacing: 10

                    MyText{
                        id:lblpsw
                        text : "密码:    "
                        anchors {
                            verticalCenter: parent.verticalCenter
                        }
                    }
                    TextField{
                        id:txtpsw
                        width: _loginwindowbakg.width - lblpsw.contentWidth - 50
                        font.family: "微软雅黑"
                        font.pixelSize: 15
                        height: 30
                        anchors {
                            verticalCenter: parent.verticalCenter
                        }

                        Keys.enabled: true
                        Keys.onPressed: {
                            switch(event.key){
                            case Qt.Key_Return:
                                btnlogin.click();
                                break;
                            case Qt.Key_Enter:
                                btnlogin.click();
                                break;
                            case Qt.Key_Escape:
                                break;
                            default : return
                            }
                            event.accepted = true;
                        }
                    }
                }
                MyButton{
                    id:btnlogin
                    height: 40
                    width: _loginwindow.width * 0.9
                    title:"登录"
                    enter_color: "#3399ff"
                    enter_font_color: "#fff"
                    border_color: "#e2e2e2"
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                    }
                    onClick: {
                        _loginwindow.userID = txtID.text;
                        _loginwindow.psw = txtpsw.text;
                        if(userID.trim() == ""){
                            GEN.showMessageBox(_logintips,"用户名不能为空...");
                            return false;
                        }
                        if(psw.trim() == ""){
                            GEN.showMessageBox(_logintips,"密码不能为空...");
                            return false;
                        }
                        if(!client.initSocket()){
                            GEN.showMessageBox(_logintips,"连接服务器失败...");
                            return false;
                        }
                        client.login(userID,psw);
                    }
                }
            }

        }
    }
}

