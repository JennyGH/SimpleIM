import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import "../js/generic.js" as GEN
//import Client 1.0

Window {
    id:fatherWindow
    visible: true
    height: mainform.height + 30//630
    width:mainform.width + 30//330
    property bool conn: false
    property string myName : "Me"
    property var friendListArray: new Array
    property SearchFriend searchwindow: null
    flags: Qt.FramelessWindowHint | Qt.Window
    color: Qt.rgba(0,0,0,0)

    //    flags:Qt.WindowModal | Qt.WindowMaximizeButtonHint

    minimumWidth: width
    minimumHeight: height

    maximumHeight: height + 120
    maximumWidth: width + 300

    onVisibleChanged: {
        if(!fatherWindow.visible){
            GEN.clearWindow();
        }
    }

    Component.onCompleted: {

        GEN.windowArray = [];

        client.sendmessage("","",4);    //消息4：更新好友列表

//        console.log("show mainform")
    }

    Connections{
        target: client
        onRecvmessage: {
            var returnmsg = client.getMessage();
            var obj = GEN.formatMessage(returnmsg);
//            console.log(returnmsg);
            switch(parseInt(obj.type)){
            case 2:
                var currentwindow = GEN.isExistWindow(obj.friend);
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
//                friendmodel.clear();
                if(parseInt(obj.message.SqlMsgType) == 0){
                    var result = obj.message.Result;
                    for(var i=0;i<result.length;i++){
                        addFriend(result[i][0],result[i][1],true,"");
                    }
                }break;
            default:
                break;
            }
        }
        onLoseConnect:{
            var newloginwindow = GEN.createWindow("main",null);
            fatherWindow.close();
//            fatherWindow.destroy();
            newloginwindow.showTips("与服务器断开连接，请重新登陆...");
        }
    }

    MainForm {
        id:mainform
        property color font_color: "#444"
        property var chatwindows
        height: 600
        width: 300
        anchors {
            centerIn: parent
        }
        border.color: "#88888888"

        MainWindowHeader {
            id:header
            title : "JennyChat"
            marginRight:mainform.border.width
            anchors {
                topMargin:header.marginRight
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

        ScrollView {
            height: mainform.height - me.height - header.height - tishi.height - mainformfooter.height - mainform.border.width*2
            width: mainform.width - mainform.border.width * 2
            horizontalScrollBarPolicy:Qt.ScrollBarAlwaysOff
            verticalScrollBarPolicy:Qt.ScrollBarAsNeeded
            style: ScrollViewStyle{transientScrollBars:true}
            anchors{
                top:me.bottom
                horizontalCenter: parent.horizontalCenter
            }

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
                    onDbclick: {
                        var newchatwindow = GEN.createChatWindow(ID,name,address,onLine);
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
                highlight: Rectangle{
                    color: "#3399ff"
                    height: 50
                    width: parent.width
                }
            }
        }

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
                        var newsettingwindow = GEN.createWindow("SettingWindow",mainform);
                        if(newsettingwindow){
                            newsettingwindow.setTxtIp(client.ip);
                            newsettingwindow.setTxtPort(client.port);
                            newsettingwindow._tishi = tishi;
                            GEN.showWindow(newsettingwindow);
                        }else{
                            console.error(newsettingwindow + " 未创建...");
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

    DropShadow {
        anchors.fill: mainform
        horizontalOffset: 0
        verticalOffset: 0
        radius: 16.0
        samples: 32
        color: "#80000000"
        source: mainform
    }

    function addFriend(id,name,ol,addr){
        friendmodel.append({"ID":id,"name":name,"onLine":ol,"address":addr});
        friendListArray.push(id);
    }
}

