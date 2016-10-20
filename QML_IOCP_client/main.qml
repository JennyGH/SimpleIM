import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../js/generic.js" as GEN
//import Client 1.0

Window {
    id:_loginwindow
    height: 330
    width: 380

    minimumHeight: 280
    minimumWidth: 380
    visible: true
    flags: Qt.FramelessWindowHint | Qt.Window
    property string userID
    property string psw
    property ChatMainWindow temp_chatwindow: null
    property SettingWindow newsettingwindow: null
    property SignInWindow newsigninwindow: null
    property bool isConnect: false
    color: Qt.rgba(0,0,0,0)

    onVisibleChanged: {
        if(!visible){
            //
        }else{
//            animBig.start();
        }
    }
//    onClosing:{
//        console.log("closing")
//    }

    Connections {
        target: client
        onRecvmessage: {
            var returnmsg = client.getMessage();
            var obj = GEN.formatMessage(returnmsg);
            console.log(returnmsg)
            if(parseInt(returnmsg) === 0){
                try{
                    if(!temp_chatwindow){
                        temp_chatwindow = GEN.createWindow("ChatMainWindow",null);
                    }
                    if(temp_chatwindow){
    //                        chatmainwindow.setClient(client);
    //                        console.log("client:" + chatmainwindow.client);
                        temp_chatwindow.conn = true;
                        temp_chatwindow.myName = _loginwindow.userID;
                        temp_chatwindow.loginwindow = _loginwindow;
                        temp_chatwindow.visible = true;
                        _loginwindow.visible = false;
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
                        txtID.forceActiveFocus();
                        break;
                    case 2:
                        GEN.showMessageBox(_logintips,"密码错误...");
                        txtpsw.forceActiveFocus();
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
//        border.color: "#88888888"
        border.color: "#fff"
        scale:0
        border.width: 1
        radius:5
//        anchors.fill: parent
        height: parent.height - 30
        width: parent.width - 30
        layer.enabled: true
        layer.effect: OuterShadow {
            target : _loginwindowbakg
            transparentBorder: true
        }
//        scale:0
        anchors {
            centerIn: parent
        }
        Component.onCompleted: {
    //        client.ip = "119.29.178.76"
            txtID.forceActiveFocus();
            animBig.start();
        }

        MainWindowHeader{
            id:_loginwindowheader
            movetarget : _loginwindow
            marginRight:5//parent.border.width
            marginTop: marginRight
            title : "JennyChat"
//            anchors {
//                topMargin: marginRight
//            }
            btnHeight: 25
            btnWidth: btnHeight
            btnraduis: _loginwindowbakg.radius * 100
            MyButton{
                id:setting
                title : ""
                anchors {
                    right: _loginwindowheader.closebtn.left
                    rightMargin: 1
                    topMargin: parent.marginRight
                    top :parent.top
                }
                height: 25
                width: height
                radius: _loginwindowbakg.radius * 100
                Image{
//                        anchors.fill: parent
                    source : "qrc:/src/src/settings.png"
                    height: parent.height * 0.6
                    width: height
                    sourceSize.height: height
                    sourceSize.width: width
                    anchors.centerIn: parent
                }
                enter_color: "#bbb"
                onClick: {
                    if(!newsettingwindow){
                        newsettingwindow = GEN.createWindow("SettingWindow",_loginwindow);
                        if(newsettingwindow){
                            newsettingwindow.setTxtIp(client.ip);
                            newsettingwindow.setTxtPort(client.port);
                            newsettingwindow._tishi = _logintips;
                            GEN.showWindow(newsettingwindow);
                        }else{
                            console.error("SettingWindow 未创建...");
                        }
                    }
                }
            }
        }

        MessageBox{
            id:_logintips
            state : "hide"
            z: 999
            opacity : 0.8
            topObject : _loginwindowheader
            width: _loginwindowbakg.width - _loginwindowbakg.border.width*2
            anchors{
                horizontalCenter: _loginwindowbakg.horizontalCenter
            }
        }

        Head{
            id:_loginwindowheadicon
            height: 120
            width : 120
            radius: height
            anchors {
                horizontalCenter: parent.horizontalCenter
                top : _logintips.top
//                topMargin: 10
            }
        }

        Item{
            id:row
//            spacing : 10
//            color : "blue"
//            height: _loginwindowbakg.height - _loginwindowheader.height - _logintips.height - btnlogin.height - _loginwindowheadicon.height
            width: _loginwindowbakg.width - 50
            anchors {
//                fill : parent
                top : _loginwindowheadicon.bottom
//                topMargin: 10
                horizontalCenter: _loginwindowbakg.horizontalCenter
                bottom:btnlogin.top
//                bottomMargin: 10
            }

            Column{
                spacing: 10
                width: _loginwindowbakg.width - 20
//                anchors.centerIn: parent
                anchors.verticalCenter: parent.verticalCenter

                Row{
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                    }
                    spacing: 10
                    width : parent.width

                    MyText{
                        id:lblID
                        text : "用户ID:"
                        anchors {
                            verticalCenter: parent.verticalCenter
                        }
                    }
                    MyTextInput{
                        id:txtID
                        width: parent.width - lblID.contentWidth - 50 - _signin.width
                        validator: RegExpValidator {
                            regExp:/[1-9][0-9]{1,10}/
                        }

                        onTextChanged: {
//                            GEN.limitNumber(txtID);
//                            console.log(parseInt(txtID.text));
                        }
                        onEnterPressed: {
                            txtpsw.forceActiveFocus();
                        }
                    }

                    MyButton{
                        id:_signin
                        title:"注册"
                        width: 40
                        height: 30
                        enter_font_color: "#000"
                        border_color: "#ddd"
                        font_size: 12
                        radius: _loginwindowbakg.radius
                        exit_border_color:"transparent"
                        enter_border_color: "transparent"
                        anchors.verticalCenter: parent.verticalCenter
                        onClick: {
                            if(!newsigninwindow){
                                //如果 newsigninwindow 为空则创建新的注册窗口
                                newsigninwindow = GEN.createWindow("SignInWindow",_loginwindow);
                            }
                        }
                    }
                }

                Row{
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                    }
                    spacing: 10
                    width: parent.width

                    MyText{
                        id:lblpsw
                        text : "密码:    "
                        anchors {
                            verticalCenter: parent.verticalCenter
                        }
                    }
                    MyTextInput{
                        id:txtpsw
                        width: parent.width - lblpsw.contentWidth - 50 - _forget.width
                        validator:  RegExpValidator {
                            regExp:/[0-9a-zA-z\.\*]{1,16}/  //只允许输入0-9,a-z,A-Z,*,.
                        }
                        onEnterPressed: {
                            btnlogin.click();
                        }
                    }

                    MyButton{
                        id:_forget
                        title:"忘记密码"
                        width: 40
                        height: 30
                        enter_font_color: "#000"
                        border_color: "#ddd"
                        font_size: 12
                        radius: _loginwindowbakg.radius
                        exit_border_color:"transparent"
                        enter_border_color: "transparent"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

        }
        GradientButton{
            id:btnlogin
            height: 40
            width: _loginwindowbakg.width * 0.9
            title:"<b>登录</b>"
            font_size: 16
//            exit_color: Qt.lighter("green",1.2)//"#3399ff"
//            enter_color: Qt.lighter("green",1.5)//Qt.lighter("#3399ff",1.2)
            enter_gradient:Gradient{
                GradientStop{position: 0.0;color : Qt.lighter("#1bbf2e",1.3)}
                GradientStop{position: 1.0;color : "#1bbf2e"}
            }
            exit_gradient : Gradient{
                GradientStop{position: 0.0;color : "#1bbf2e"}
                GradientStop{position: 1.0;color : Qt.darker("#1bbf2e",1.5)}
            }

            enter_font_color: "#fff"
            exit_font_color: "#fff"
            border_color: hasShadow ? "transparent" : "#fff" //Qt.darker("#3399ff",1.2)
            radius:_loginwindowbakg.radius
            anchors {
                horizontalCenter: parent.horizontalCenter
//                top :row.bottom
                bottom:parent.bottom
                bottomMargin: 10
            }
            onClick: {
                _loginwindowbakg.state = "hide"
                _loginwindow.userID = txtID.text;
                _loginwindow.psw = txtpsw.text;
                if(userID.trim() == ""){
                    GEN.showMessageBox(_logintips,"用户名不能为空...");
                    txtID.forceActiveFocus();
                    return false;
                }
                if(psw.trim() == ""){
                    GEN.showMessageBox(_logintips,"密码不能为空...");
                    txtpsw.forceActiveFocus();
                    return false;
                }
                if(!isConnect){
                    if(!client.initSocket()){
                        GEN.showMessageBox(_logintips,"连接服务器失败...");
                        return false;
                    }else{
                        isConnect = true;
                    }
                }
                client.login(userID,psw);
            }
        }
    }
    PropertyAnimation {
        id: animBig
        target: _loginwindowbakg
        duration: 150
        easing.type: Easing.OutExpo
        property: 'scale'
        from: 0
        to: 1
    }
    function showTips(msg){
        GEN.showMessageBox(_logintips,msg);
    }
}

