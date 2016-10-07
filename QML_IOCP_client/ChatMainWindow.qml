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

    Connections{
        target: client
        onRecvmessage: {
            var returnmsg = client.getMessage();
            var obj = GEN.formatMessage(returnmsg);
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
            default:
                break;
            }
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
            Row{
                spacing : 1
                anchors {
                    top : header.top
                    right:header.closebtn.left
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
                        fatherWindow.showMinimized();
                    }
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
        ScrollView {
            height: mainform.height - me.height - header.height - tishi.height - mainform.border.width*2
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
                        if(oldcount < count){
                            friendListArray.push(ID);
                        }else if(oldcount < count){
                            console.log("删除某人");
//                            friendListArray.splice(,1);
                        }
                        oldcount = count;
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

    Component.onCompleted: {

        GEN.windowArray = [];
    }
}

