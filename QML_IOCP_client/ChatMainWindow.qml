import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../js/generic.js" as GEN
//import Client 1.0

Window {
    id:fatherWindow
    visible: true
    height: mainform.height + 30//630
    width:mainform.width + 30//330
    property bool conn: false
    property string myName : "null"
    property var friendListArray: new Array
    property bool canhide: false
    property bool ishide: false
    property SearchFriend searchwindow: null
    property SettingWindow newsettingwindow: null
    property Window loginwindow: null
    flags: Qt.FramelessWindowHint | Qt.Window
    color: Qt.rgba(0,0,0,0)

    //    flags:Qt.WindowModal | Qt.WindowMaximizeButtonHint

    minimumWidth: width
    minimumHeight: height

    maximumHeight: height + 120
    maximumWidth: width + 300

    onVisibleChanged: {
        if(!fatherWindow.visible){
            GEN.clearWindow(mainform.chatwindows);
            GEN.clearWindow(mainform.detailswindows);
        }else{
            fadeout.start();
            client.sendmessage("","",4);    //消息4：更新好友列表
        }
    }

    Component.onCompleted: {}

    onActiveChanged: {
        if(!fatherWindow.active){
            if(!ishide && canhide){
                senseArea.run();
//                hideWindow.start();
            }

//            ishide = true;
//            canhide = true;
        }
    }

    onCanhideChanged: {
        senseArea.canhide = fatherWindow.canhide
    }
    onIshideChanged: {
        senseArea.ishide = fatherWindow.ishide
    }

    Connections{
        target: client
        onRecvmessage: {
            var returnmsg = client.getMessage();
            var obj = GEN.formatMessage(returnmsg);
//            console.log(returnmsg);
            var result;
            switch(parseInt(obj.type)){
            case 2:
                var currentwindow = GEN.isExistWindow(mainform.chatwindows,obj.friend);
                if(currentwindow){
                    console.log("新消息...",currentwindow);
                    currentwindow.recv(currentwindow.name,obj.message);
                }else{
                    //好友列表显示消息气泡
                    console.log("你有未读留言...");
                    for(var i = 0;i<friendmodel.count;i++){
                        if(friendmodel.get(i).ID === obj.friend){
                            friendList.itemAt(0,50*(i+1)).shine();
                            break;
                        }
                    }
                    //内存中暂存留言
                    client.keepMessage(obj.friend,obj.message);
                }
                break;
            case 4:
                //返回好友列表信息
                refresh(obj);
                myName = obj.myName;
                break;
            case 5:
                if(obj.message !== 0){
                    if(obj.message.SqlMsgType === 0){
                        client.sendmessage("","",4);
                    }else{
                        console.log("添加好友发生错误：",obj.message.Result);
                    }
                }else{
                    console.log("好友已存在...");
                }
                break;
            case 6:
                //修改好友备注
//                console.log(obj.message.ID);
                break;
            case 7 :
//                console.log(obj.message.Result);
                if(obj.message.SqlMsgType == 0){
//                    client.sendmessage("","",4);    //消息4：更新好友列表
//                    refresh(obj);
//                    friendList.remove();
                }
                break;
            default:
                break;
            }
        }
        onLoseConnect:{
//            var newloginwindow = GEN.createWindow("main",null);
            fatherWindow.visible = false;
            loginwindow.isConnect = false;
            loginwindow.visible = true;
            loginwindow.showTips("与服务器断开连接，请重新登陆...");
//            fatherWindow.destroy();
//            newloginwindow.showTips("与服务器断开连接，请重新登陆...");
        }
    }

    ResizeBar {
        id:senseArea
//        target: _loginwindow
        barwidth: 15    //鼠标有效区域的宽度
        enabled: false  //设为true后可调整窗口大小
        ishide : fatherWindow.ishide
        canhide : fatherWindow.canhide
        z:999
        onMouseIn: {
            console.log("mouse in")
            run();
        }
        onTimeout: {
            if(ishide){
                //显示
                hideWindow.stop();
                showWindow.start();
            }else{
                //隐藏
                showWindow.stop();
                hideWindow.start();
            }
        }
    }

    MainForm {
        id:mainform
        property color font_color: "#444"
        property var chatwindows : new Array
        property var detailswindows: new Array
        height: 600
        width: 280
        anchors {
            centerIn: parent
        }
        border.color: "#fff"//"#88888888"
        color : "#f5f5f5"
        radius: 5
        opacity: 0

        MainWindowHeader {
            id:header
            title : "JennyChat"
            marginRight:5//mainform.border.width
            marginTop: marginRight
//            anchors {
//                topMargin:header.marginRight
//            }
            onCloseClick:{
                console.log(searchwindow);
                if(searchwindow){
                    searchwindow.close();
                }
            }
            onMove:{
//                console.log(fatherWindow.y)
                if(fatherWindow.y <= -15){
                    //到达屏幕边缘
                    canhide = true;
                    fatherWindow.y = -15
                    senseArea.enabled = true;
                }else{
                    //未到屏幕边缘
                    canhide = false;
                    senseArea.enabled = false;
                }
            }
        }

        MessageBox{
            id:tishi
            state : "hide"
            width: mainform.width - mainform.border.width*2
            anchors{
                horizontalCenter: mainform.horizontalCenter
            }
        }

        Me{
            id:me
            conn : fatherWindow.conn
            myName : fatherWindow.myName
            width: parent.width - mainform.border.width * 2
            anchors{
                top:tishi.bottom
                horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle{
            id:mainformbody
            height: mainform.height - me.height - header.height - tishi.height - mainformfooter.height - mainform.border.width*2 - 10
            width: mainform.width - mainform.border.width * 2 - 10
            anchors{
                top:me.bottom
                topMargin: 5
                horizontalCenter: parent.horizontalCenter
            }
            color : "transparent"
            border.color: "#fff"
            radius:3
            ScrollView {
                id:mainformbodyscroll
                height: parent.height - parent.radius*2
                width: parent.width - parent.radius*2
                horizontalScrollBarPolicy:Qt.ScrollBarAlwaysOff
                verticalScrollBarPolicy:Qt.ScrollBarAsNeeded
                style: ScrollViewStyle{transientScrollBars:true}
                anchors.centerIn: parent
//                visible: false
                ListView{
                    id:friendList
                    anchors {
                        fill : parent
                    }
                    highlightFollowsCurrentItem : true

                    model: FriendModel{
                        id:friendmodel
                        onCountChanged: {
    //                        if(oldcount < count){
    //                            friendListArray.push(ID);
    //                        }else if(oldcount < count){
    //                            console.log("删除某人");
    ////                            friendListArray.splice(,1);
    //                        }
    //                        oldcount = count;
                        }
                    }
                    delegate: Friend{
                        id:friend
                        height: 60
//                        color : mainformbody.color
//                        background_color : mainformbody.color
                        onDbclick: {
                            var existwindow;
                            if((existwindow = GEN.isExistWindow(mainform.chatwindows,ID))){

                                existwindow.requestActivate();

                                return existwindow;
                            }else{

                                var newchatwindow = GEN.createSingleWindow(mainform.chatwindows,"ChatWindow",null);
                                newchatwindow.userid = ID;
                                newchatwindow.name = name;
                                newchatwindow.address= address;
                                newchatwindow.online = onLine;
                                newchatwindow.getHeader().clientname = name;
                                newchatwindow.getHeader().online = onLine;
                            }

                            if(friend.msgcount){
                                var jsonstr = client.alreadyRead(ID);
                                if(jsonstr.trim() !== ""){
                                    console.log(jsonstr);
                                    var json = JSON.parse(jsonstr);
                                    for(var i = 0;i<json.message.length;i++){
                                        newchatwindow.recv(newchatwindow.name,json.message[i]);
                                    }
                                    friend.msgcount = 0;
                                }
                            }
                        }
                    }
                }
            }
        }
//        InnerShadow {
//            anchors.fill: mainformbody
//            horizontalOffset: 1
//            verticalOffset: 1
//            radius: 4.0
//            samples: 8
//            color: "#dddddddd"
//            source: mainformbody
//        }

        Rectangle{
            id:mainformfooter
            height: 40
            width: parent.width - parent.border.width*2
            color : Qt.rgba(0,0,0,0)
//            gradient: Gradient {
//                GradientStop { position: 0.0; color: "#fff" }
//                GradientStop { position: 1.0; color: "#eee" }
//            }
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom:parent.bottom
                bottomMargin: parent.border.width
            }

            Row{

                spacing: 5

                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                    leftMargin: spacing
                }

                MyButton{
                    id:setting
                    title : ""
                    height: 30
                    width: 30
                    enter_color: "#bbb"
                    radius:40
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

                    onClick: {
                        if(!newsettingwindow){
                            newsettingwindow = GEN.createWindow("SettingWindow",mainform);
                            if(newsettingwindow){
                                newsettingwindow.setTxtIp(client.ip);
                                newsettingwindow.setTxtPort(client.port);
                                newsettingwindow._tishi = tishi;
                                GEN.showWindow(newsettingwindow);
                            }else{
                                console.error("SettingWindow 未创建...");
                            }
                        }
                    }
                }

                MyButton{
                    id:add
                    title:"<b>+</b>"
                    font_size: 20
                    height: 30
                    width: 30
                    radius:30
                    anchors {
                        verticalCenter: parent.verticalCenter
                    }
                    enter_color: "#bbb"
                    onClick: {

                        if(!searchwindow){
                            searchwindow = GEN.createWindow("SearchFriend",null);
                            if(searchwindow){
                                GEN.showWindow(searchwindow);
                            }
                        }else{
                            searchwindow.raise()
                        }
                    }
                }
            }
        }
    }
    OuterShadow {
        id:_shadow
        target :mainform
    }

    PropertyAnimation {
        id: fadeout
        target: mainform
        duration: 400
        easing.type: Easing.OutSine
        property: 'opacity'
        from: 0
        to: 1
    }

    PropertyAnimation {
        id: hideWindow
        target: fatherWindow
        duration: 200
        easing.type: Easing.OutSine
        property: 'y'
        from: y//-16
        to: -10-(height - 28)
        onStopped: {
//            canhide = true;
            senseArea.z = 999
            ishide = true;
            senseArea.setTime(0);
        }
    }

    PropertyAnimation {
        id: showWindow
        target: fatherWindow
        duration: 200
        easing.type: Easing.OutSine
        property: 'y'
        to: -16
        from: y//-10-(height - 28)
        onStopped:{
//            canhide = false;
            senseArea.z = 0
            ishide = false;
            senseArea.setTime(300);
        }
    }

//    states: [
//        State {
//            name: "hide"
//            PropertyChanges {
//                target: fatherWindow
//                y: -fatherWindow.height - 15
//            }
//        },
//        State {
//            name: "show"
//            PropertyChanges {
//                target: fatherWindow
//                y: -15
//            }
//        }
//    ]

//    transitions: [
//        Transition {
//            from: "*"
//            to: "*"

//            NumberAnimation {
//                target: fatherWindow
//                property: "y"
//                duration: 200
//                easing.type: Easing.InOutQuad
//            }
//        }
//    ]

    function addFriend(id,name,ol,addr){
        friendmodel.append({"ID":id,"name":name,"onLine":ol,"address":addr});
        friendListArray.push(id);
    }
    function refresh(obj){
        var result;
        friendmodel.clear();
        if(parseInt(obj.message.SqlMsgType) == 0){
            result = obj.message.Result;
            for(var i=0;i<result.length;i++){
                addFriend(result[i][0],result[i][1],true,"");
            }
        }
    }
    function remove(index){
        friendmodel.remove(index,1);
    }
    function rename(index,name){
        friendmodel.set(index, {"name":name});
    }
}

