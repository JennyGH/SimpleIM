import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import "../js/generic.js" as GEN
//import Client 1.0

Window {
    id:_loginwindow
    height: 280
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
    color: Qt.rgba(0,0,0,0)

    onVisibleChanged: {
        if(!visible){
            //
        }else{
//            animBig.start();
        }
    }

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
            title : "JennyChat"
            anchors {
                topMargin: marginRight
            }
            btnHeight: 30
            btnWidth: btnHeight
            btnraduis: _loginwindowbakg.radius * 100
            MyButton{
                id:setting
                title : ""
                anchors {
                    right: _loginwindowheader.closebtn.left
                    rightMargin: 1
                }
                height: 30
                width: 30
                radius: _loginwindowbakg.radius * 100
                Image{
//                        anchors.fill: parent
                    source : "qrc:/src/src/setting.png"
                    height: parent.height * 0.5
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
                        width: _loginwindowbakg.width - lblID.contentWidth - 50 - _signin.width
                        font.family: "微软雅黑"
                        font.pixelSize: 15
                        height: 30
                        anchors {
                            verticalCenter: parent.verticalCenter
                        }
                        validator: RegExpValidator {
                            regExp:/[1-9][0-9]{1,10}/
                        }

                        onTextChanged: {
//                            GEN.limitNumber(txtID);
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

                    MyButton{
                        id:_signin
                        title:"注册"
                        width: 70
                        height: 30
                        enter_font_color: "#000"
                        border_color: "#ddd"
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

                    MyText{
                        id:lblpsw
                        text : "密码:    "
                        anchors {
                            verticalCenter: parent.verticalCenter
                        }
                    }
                    TextField{
                        id:txtpsw
                        width: _loginwindowbakg.width - lblpsw.contentWidth - 50 - _forget.width
                        font.family: "微软雅黑"
                        font.pixelSize: 15
                        height: 30
                        anchors {
                            verticalCenter: parent.verticalCenter
                        }
                        validator:  RegExpValidator {
                            regExp:/[0-9a-zA-z\.\*]{1,16}/  //只允许输入0-9,a-z,A-Z,*,.
                        }

                        echoMode : TextInput.Password

                        style:TextFieldStyle{
                            passwordCharacter: "*"
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

                    MyButton{
                        id:_forget
                        title:"忘记密码"
                        width: 70
                        height: 30
                        enter_font_color: "#000"
                        border_color: "#ddd"
                        radius: _loginwindowbakg.radius
                        exit_border_color:"transparent"
                        enter_border_color: "transparent"
                        anchors.verticalCenter: parent.verticalCenter
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
                    border_color: Qt.darker("#3399ff",1.2)
                    radius:_loginwindowbakg.radius
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

//    PropertyAnimation {
//        id: fadeout
//        target: _loginwindowbakg
//        duration: 500
//        easing.type: Easing.OutExpo
//        property: 'opacity'
//        from: 1
//        to: 0
//        onStopped: {

//        }
//    }

    DropShadow {
        anchors.fill: _loginwindowbakg
        horizontalOffset: 0
        verticalOffset: 0
        radius: 16.0
        samples: 32
        color: "#80000000"
        source: _loginwindowbakg
        scale: _loginwindowbakg.scale
        opacity: _loginwindowbakg.opacity
    }
    function showTips(msg){
        GEN.showMessageBox(_logintips,msg);
    }
}

