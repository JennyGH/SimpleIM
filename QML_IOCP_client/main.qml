import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "generic.js" as GEN
import "fontawesome.js" as FA
//import Client 1.0

Window {
    id:_loginwindow
    height: 500
//    height: _loginwindowbakg.height + 30
    width: 600

    minimumHeight: 280
    minimumWidth: 380
    visible: true
//    flags: Qt.CustomizeWindowHint | Qt.CoverWindow
    flags: Qt.FramelessWindowHint | Qt.Window
    property string userID
    property string psw
    property ChatMainWindow temp_chatwindow: null
    property SettingWindow newsettingwindow: null
    property SignInWindow newsigninwindow: null
    property Busy busy: null
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
                    case 8 :
                        busy.stop();
                        var _alert = GEN.alert({
                                                   height :150,
                                                   width : 300,
                                                   text : obj.message,
                                                   parent : _loginwindowbakg,
                                                   confirm : false,
                                                   success : true,
                                                   onOk : function(){
                                                       row.state = "login";
                                                       _signinwindowcontent.clear();
                                                   },
                                                   onClose : function(){
                                                       _alert.destroy();
                                                   }
                                               });
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
//        color : "#f5f5f5"
        gradient: Gradient{
            GradientStop{position: 0.0;color : "#f6f6f6"/*Qt.lighter(father.parent.color,1.5)*/}
            GradientStop{position: 1.0;color : "#eee"}
        }

//        border.color: "#fff"
//        border.width: 1
        opacity : 0
        radius:3
        height: parent.height - 30
        width: parent.width - 30
        layer.enabled: true
        layer.effect: OuterShadow {
            target : _loginwindowbakg
//            transparentBorder: true
        }
        anchors {
            centerIn: parent
        }
        Component.onCompleted: {
    //        client.ip = "119.29.178.76"
            txtID.forceActiveFocus();
//            animBig.start();
            _loginwindowbakg.state = "show";
        }


        states: [
            State {
                name: "show"
                PropertyChanges {
                    target: _loginwindowbakg
//                    scale : 1
                    opacity : 1
                }
            }
        ]
        transitions: [
            Transition {
                from: "*"
                to: "*"

                NumberAnimation {
                    target: _loginwindowbakg
                    property: "opacity"
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
            }
        ]

        MainWindowHeader{
            id:_loginwindowheader
            movetarget : _loginwindow
            marginRight:10//parent.border.width
            marginTop: marginRight
            title : "JennyChat"
            isVerticalCenter: true
            transparent : true
            height: 35
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

        Item{

            id : _loginwindowcontent

            anchors {
                top : _logintips.bottom;
                bottom: parent.bottom
            }
            width: parent.width

            Row{
                spacing: 0
                anchors {
                    top : parent.top
                }
                width: parent.width

                MyButton{
                    id:btnShowSignin
                    title:"注册"
                    width: parent.width / 3
                    height:30 //parent.height - 10
                    font_size: 12
                    enter_font_color: "#fff"
                    exit_font_color: "#333"
                    enter_color: "#1b83fb"
                    anchors {
                        verticalCenter : parent.verticalCenter
                    }
                    property bool active: row.state == "signin"
                    Border{
                        visible: parent.active
                        pos : "bottom"
                        color : "#1b83fb"
                        height: 2
                    }

                    onClick: {
                        if(row.state != "signin"){
                            row.state = "signin";
                        }
                    }
                }

                MyButton{
                    id : btnShowLogin
                    font_size: 12
                    height: 30
                    width: parent.width / 3
                    title : "登录"
                    enter_font_color: "#fff"
                    exit_font_color: "#333"
                    enter_color: "#1b83fb"
                    anchors {
                        verticalCenter: parent.verticalCenter
                    }
                    onClick: {
                        if(row.state != "login"){
                            row.state = "login";
                        }
                    }
                    property bool active: row.state == "login"
                    Border{
                        visible: parent.active
                        pos : "bottom"
                        color : "#1b83fb"
                        height: 2
                    }
                }

                MyButton {
                    id:btnShowSetting
                    title : "设置"
                    anchors {
                        verticalCenter : parent.verticalCenter
                    }
                    height: 30//parent.height - 10
                    width: parent.width / 3
                    enter_font_color: "#fff"
                    exit_font_color: "#333"
                    enter_color: "#1b83fb"
                    font_size: 12
                    onClick: {
                        if(row.state != "setting"){
                            row.state = "setting";
                        }
                    }
                    property bool active: row.state == "setting"
                    Border{
                        visible: parent.active
                        pos : "bottom"
                        color : "#1b83fb"
                        height: 2
                    }
                }

            }

            Item{
                id:row
                width:300// _loginwindowbakg.width - 20
                clip: true
                anchors {
                    top : parent.top
                    horizontalCenter: parent.horizontalCenter
                    bottom : parent.bottom
                }
                state : "login"

                Column{
                    id : _settingcontent
                    spacing: 30
                    width: parent.width - 15
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: _logincontent.right
                        leftMargin: 10
                    }
                    Component.onCompleted: {
                        setTxtIp(client.ip);
                        setTxtPort(client.port);
                    }

                    Row{
                        spacing: 0
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width
                        Span{
                            id:lblIP
                            text : "IP地址"
                            height: txtIp.height
                            anchors {
                                verticalCenter: parent.verticalCenter
                            }
                        }
                        ComboBox {
                            id:txtIp
                            height: 30
                            property string text: txtIp.currentText
                            model: [ "119.29.178.76", "127.0.0.1" ]
                            width: parent.width -lblIP.width
                            activeFocusOnPress : true
                            onCurrentIndexChanged: {
                                text = currentText;
                            }
                        }
                    }
                    Row{
                        spacing: 0
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width
                        Span{
                            id:lblPort
                            text : "端口号"
                            height: txtPort.height
                            anchors {
                                verticalCenter: parent.verticalCenter
                            }
                        }
                        MyTextInput{
                            id:txtPort
                            width: parent.width - lblPort.width
                            radius: 0
                            height: 30
                        }
                    }
                    GradientButton{
                        id: ok
                        height: 30
                        width: parent.width
                        title : "保存"
                        anchors.horizontalCenter: parent.horizontalCenter
                        border_color : "#ccc"
        //                enter_color: "#157efb"
                        enter_font_color: "#fff"
        //                enter_border_color: "#fff"//Qt.darker("#157efb",1.5)
                        radius : 3
                        onClick: {
                            var json = JSON.stringify
                                    ({
                                         ip : txtIp.text,
                                         port : txtPort.text
                                     });
                            if(client.saveSetting(json)){
                                console.log("保存成功...");
                                GEN.showMessageBox(_logintips,"重启程序后生效...");
                            }else{
                                console.error("保存失败...");
                            }
                        }
                    }

                    function setTxtIp(ip){
                //        txtIp.text = ip;
                        var model = txtIp.model;
                        for(var item in model){
                            if(model[item] == ip){
                                txtIp.currentIndex = item;
                            }
                        }
                    }
                    function setTxtPort(p){
                        txtPort.text = p;
                    }

                }

                Column{
                    id : _logincontent
                    spacing: 30
                    width: parent.width - 10
                    anchors {
                        verticalCenter: parent.verticalCenter
                    }
                    x : 0

                    Head{
                        id:_loginwindowheadicon
                        height: 100
                        width : 100
                        radius: height
                        anchors {
                            horizontalCenter: parent.horizontalCenter
    //                        top : _logintips.top
    //                        topMargin: 10
                        }
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
                            width: parent.width - lblID.width - btnSelectID.width// - _signin.width
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
                        MyButton {
                            id : btnSelectID
                            radius: 5
                            width: 20
                            height: txtID.height
                            exit_color: "#1b83fb"
                            enter_color: "#1b83fb"
                            title : FA.icons.Selector
                            exit_font_color: "#fff"
                            enter_font_color: "#fff"
                            usingFA: true
                            anchors {
                                verticalCenter: parent.verticalCenter
                            }
                            Rectangle{
                                anchors {
                                    left: parent.left
                                    verticalCenter: parent.verticalCenter
                                }
                                width: parent.radius || 0
                                height: parent.height
                                color : "#1b83fb"
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

                Column{
                    id : _signinwindowcontent
                    spacing: 30
                    width: parent.width - 20
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right :_logincontent.left
                        rightMargin: 10
                    }

                    Row{
                        spacing: 0
                        anchors.horizontalCenter: parent.horizontalCenter
                        Span{
                            id:lblsigninname
                            text:"昵称"
                            anchors.verticalCenter: parent.verticalCenter
                            height: txtsigninname.height
                            width: 70
                        }
                        MyTextInput{
                            id:txtsigninname
                            height: 30
                            width: _signinwindowcontent.width - lblsigninname.width
                            radius :0
                        }
                    }
                    Row{
                        spacing: 0
                        anchors.horizontalCenter: parent.horizontalCenter
                        Span{
                            id:lblsigninpsw
                            text:"密码"
                            anchors.verticalCenter: parent.verticalCenter
                            height: txtsigninpsw.height
                            width: 70
                        }
                        MyTextInput{
                            id:txtsigninpsw
                            height: 30
                            width: _signinwindowcontent.width - lblsigninpsw.width
                            isPassword:true
                            radius : 0
                        }
                    }
                    Row{
                        spacing: 0
                        anchors.horizontalCenter: parent.horizontalCenter
                        Span{
                            id:lblconfirmsigninpsw
                            text:"确认密码"
                            anchors.verticalCenter: parent.verticalCenter
                            height: txtconfirmsigninpsw.height
                            width: 70
                        }
                        MyTextInput{
                            id:txtconfirmsigninpsw
                            height: 30
                            width: _signinwindowcontent.width - lblconfirmsigninpsw.width
                            isPassword:true
                            radius : 0
                        }
                    }
                    GradientButton{
                        id : btnSignin
                        radius: 3
                        title : "注册"
                        width: parent.width - 10
                        height: 30
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                        }
                        onClick: {
                            //注册
                            var _alert;
                            var canreg = false;
                            var warningStr;
                            if(txtsigninname.text.trim() === ""){
                                warningStr = "昵称不能为空...";
                            }else if(txtsigninpsw.text.trim() === ""){
                                warningStr = "密码不能为空...";
                            }else if(txtconfirmsigninpsw.text.trim() === ""){
                                warningStr = "请确认密码...";
                            }else if(txtconfirmsigninpsw.text.trim() !== txtsigninpsw.text.trim()){
                                warningStr = "两次密码不相同...";
                            }else{
                                canreg = true;
                            }
                            if(canreg){
        //                        console.log("can reg...");
                                if(!_loginwindow.isConnect){
                                    if(!client.initSocket()){
                                        _alert = GEN.alert({
                                                               height :150,
                                                               width : 300,
                                                               text : "连接服务器失败...",
                                                               parent : _loginwindowbakg,
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
                                client.sendmessage(txtsigninpsw.text,txtsigninname.text,signinMessage);
                                busy = GEN.createWindow("Busy",_loginwindowcontent);
                                busy.start();
                            }else{
                                _alert = GEN.alert({
                                                       height :150,
                                                       width : 300,
                                                       text : warningStr,
                                                       parent : _loginwindowbakg,
                                                       confirm : false,
                                                       onOk : function(){
                                                       },
                                                       onClose : function(){
                                                           _alert.destroy();
                                                       }
                                                   });
                            }
                        }

                    }
                    function clear(){
                        txtsigninname.text = "";
                        txtsigninpsw.text = "";
                        txtconfirmsigninpsw.text = "";
                    }
                }

                states: [
                    State {
                        name: "login"
                        PropertyChanges {
                            target: _logincontent
                            x : 0
                            opacity : 1
                        }
                        PropertyChanges {
                            target: txtID
                            focus:true
                        }

                    },

                    State {
                        name: "signin"
                        PropertyChanges {
                            target: _logincontent
                            x : _logincontent.width
                            opacity : 0
                        }
                        PropertyChanges {
                            target: txtsigninname
                            focus:true
                        }
                    },
                    State {
                        name: "setting"
                        PropertyChanges {
                            target: _logincontent
                            x : -_logincontent.width
                            opacity : 0
                        }
                    }
                ]
                transitions: [
                    Transition {
                        from: "*"
                        to: "*"
                        NumberAnimation {
                            target: _logincontent
                            property: "x"
                            duration: 200
                            easing.type: Easing.InOutQuad
                        }
                        NumberAnimation {
                            target: _logincontent
                            property: "opacity"
                            duration: 200
                            easing.type: Easing.InOutQuad
                        }
                    }
                ]

            }

        }
    }

//    PropertyAnimation {
//        id: animBig
//        target: _loginwindowbakg
//        duration: 150
//        easing.type: Easing.OutExpo
//        property: 'scale'
//        from: 0
//        to: 1
//    }


    function showTips(msg){
        GEN.showMessageBox(_logintips,msg);
    }
}

