import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import "../js/generic.js" as GEN
//import Client 1.0

Window{
    id:_loginwindow
    height: 280
    width: 380

    minimumHeight: 280
    minimumWidth: 380
    visible: true
    flags: Qt.FramelessWindowHint | Qt.Window
    property string userID
    property string psw
    color: Qt.rgba(0,0,0,0)

    onVisibleChanged: {
    }

    Component.onCompleted: {
//        client.ip = "119.29.178.76"
        txtID.forceActiveFocus();
//        animBig.start();
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


    ResizeBar {
        id:reize
//        target: _loginwindow
        barwidth: 30    //鼠标有效区域的宽度
        enabled: false  //设为true后可调整窗口大小
    }

    Rectangle{
        id:_loginwindowbakg
        color : "#f5f5f5"
        border.color: "#88888888"
        border.width: 1
//        anchors.fill: parent
        height: parent.height - 30
        width: parent.width - 30
//        scale:0
        anchors {
            centerIn: parent
        }

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
            width: _loginwindowbakg.width - _loginwindowbakg.border.width*2
            anchors{
                horizontalCenter: _loginwindowbakg.horizontalCenter
            }
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
                    width: _loginwindowbakg.width * 0.9
                    title:"<b>登录</b>"
                    font_size: 16
                    exit_color: "#3399ff"
                    enter_color: Qt.lighter("#3399ff",1.2)
                    enter_font_color: "#fff"
                    exit_font_color: "#fff"
                    border_color: "#fff"
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                    }
                    onClick: {
                        _loginwindowbakg.state = "hide"
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


        Component.onCompleted: {
        }
    }
    PropertyAnimation {
        id: animBig
        target: _loginwindowbakg
        duration: 500
        easing.type: Easing.InOutBounce
        property: 'scale'
        from: 0
        to: 1
//            loops:Animation.Infinite
//        running: true
    }

    DropShadow {
        anchors.fill: _loginwindowbakg
        horizontalOffset: 0
        verticalOffset: 0
        radius: 16.0
        samples: 32
        color: "#80000000"
        source: _loginwindowbakg
    }
}

