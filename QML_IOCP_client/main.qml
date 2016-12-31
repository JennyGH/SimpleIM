import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "generic.js" as GEN
import "fontawesome.js" as FA
//import Client 1.0

Window {
    id:_loginwindow
    height: 300
//    height: _loginwindowbakg.height + 30
    width: 380

    minimumHeight: 280
    minimumWidth: 380
    visible: true
//    flags: Qt.CustomizeWindowHint | Qt.CoverWindow
    flags: Qt.FramelessWindowHint | Qt.WindowSystemMenuHint | Qt.WindowMinimizeButtonHint | Qt.WindowActive
    property string userID
    property string psw
    property ChatMainWindow temp_chatwindow: null
    property SettingWindow newsettingwindow: null
    property SignInWindow newsigninwindow: null
    property bool isConnect: false
    color: Qt.rgba(0,0,0,0)

    Connections {
        target: client
        onRecvmessage: {
            var returnmsg = client.getMessage();
            var obj = GEN.formatMessage(returnmsg);
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
                if(obj !== undefined){
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

    }
    Rectangle{
        id:_loginwindowbakg
        color : "#f5f5f5"
        border.color: "#fff"
        scale:0
        border.width: 1
        radius:5
        height: parent.height - 30
//        height: _loginwindowheader.height + _bakg.height + row.height + _loginwindowfooter.height + 10
        width: parent.width - 30
        layer.enabled: true
        layer.effect: OuterShadow {
            target : _loginwindowbakg
            transparentBorder: true
        }
        anchors {
            centerIn: parent
        }
        Component.onCompleted: {
    //        client.ip = "119.29.178.76"
            txtID.forceActiveFocus();
            animBig.start();
        }

        Image{
            id:_bakg
            source : "qrc:src/src/bakg.png"
            width: parent.width
            height: _loginwindowheadicon.height + 20
            sourceSize: Qt.size(height,width)
//            anchors.centerIn: parent
            anchors.top : _loginwindowheader.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            z: 0
        }

        MainWindowHeader{
            id:_loginwindowheader
            movetarget : _loginwindow
            marginRight:10//parent.border.width
            marginTop: marginRight
            title : "JennyChat"
            isVerticalCenter: true
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
            height: 100
            width : 100
            radius: height
            border.width: 1
            anchors {
                horizontalCenter: parent.horizontalCenter
                top : _logintips.top
                topMargin: 10
//                topMargin: 10
            }
        }

        Item{
            id:row
            width: _loginwindowbakg.width - 20
            anchors {
                top : _bakg.bottom
                horizontalCenter: _loginwindowbakg.horizontalCenter
                bottom : _loginwindowfooter.top
            }

            Column{
                spacing: 10
                width: parent.width
                anchors {
                    centerIn : parent
                }

                Row{
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                    }
                    spacing: 0
                    width : parent.width

                    Span{
                        id:lblID
                        height: txtID.height
                        usingFA : true
                        text : FA.icons.User
                        anchors {
                            verticalCenter: parent.verticalCenter
                        }
                    }

                    MyTextInput{
                        id:txtID
                        width: parent.width - lblID.width// - _signin.width
                        validator: RegExpValidator {
                            regExp:/[1-9][0-9]{1,10}/
                        }
                        radius : 0

                        height: 30

                        onTextChanged: {
//                            GEN.limitNumber(txtID);
//                            console.log(parseInt(txtID.text));
                        }
                        onEnterPressed: {
                            txtpsw.forceActiveFocus();
                        }
                    }
                }

                Row{
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                    }
                    spacing: 0
                    width: parent.width
                    Span{
                        id:lblpsw
                        height: txtpsw.height
                        usingFA : true
                        text : FA.icons.Key
                        anchors {
                            verticalCenter: parent.verticalCenter
                        }
                    }

                    MyTextInput{
                        id:txtpsw
                        width: parent.width - lblpsw.width - btnlogin.width// - _forget.width
                        validator:  RegExpValidator {
                            regExp:/[0-9a-zA-z\.\*]{1,16}/  //只允许输入0-9,a-z,A-Z,*,.
                        }
                        height: 30
                        isPassword: true
                        radius : 0
                        z : 10
                        onEnterPressed: {
                            btnlogin.click();
                        }
                    }


                    GradientButton{
                        id:btnlogin
                        height: txtpsw.height
                        width: height + 10
                        title:FA.icons.CircleArrowRight
                        font_size: 20
                        usingFA: true
                        enter_font_color: "#fff"
                        exit_font_color: "#333"
                        radius:_loginwindowbakg.radius
                        anchors {
                            verticalCenter: parent.verticalCenter
                        }
                        onEnter : {
                            zhezhao.gradient = btnlogin.gradient;
                            zhezhaoborder_top.color = btnlogin.enter_border_color;
                            zhezhaoborder_bottom.color = btnlogin.enter_border_color;
                        }
                        onExit : {
                            zhezhao.gradient = btnlogin.gradient;
                            zhezhaoborder_top.color = btnlogin.exit_border_color;
                            zhezhaoborder_bottom.color = btnlogin.exit_border_color;
                        }

                        Rectangle{
                            id : zhezhao
                            height: parent.height
                            smooth : true
                            width: parent.radius
                            color : parent.color
                            gradient: parent.gradient
                            anchors {
                                left: parent.left
                                verticalCenter: parent.verticalCenter
                            }
                            Border{id:zhezhaoborder_top;pos : "top"}
                            Border{id:zhezhaoborder_bottom;pos : "bottom"}
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
//                    MyButton{
//                        id:_forget
//                        title:"忘记密码"
//                        width: 40
//                        height: 30
//                        enter_font_color: "#000"
//                        border_color: "#ddd"
//                        font_size: 12
//                        radius: _loginwindowbakg.radius
//                        exit_border_color:"transparent"
//                        enter_border_color: "transparent"
//                        anchors.verticalCenter: parent.verticalCenter
//                    }
                }
            }

        }

        MainWindowFooter{
            id : _loginwindowfooter

            Row{
                spacing: 5

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 5
                }

                MyButton{
                    id:_signin
                    title:"注册"
                    width: 40
                    height: parent.height - 10
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
            GradientButton {
                id:setting
                title : FA.icons.Gear
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: 5
                }
                height: parent.height - 10
                usingFA: true
                width: height + 10
                radius: _loginwindowbakg.radius
                visible: true
                enabled: visible
                enter_font_color: "#fff"
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

