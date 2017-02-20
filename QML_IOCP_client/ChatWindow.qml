import QtQuick 2.4
//import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "generic.js" as GEN
import "fontawesome.js" as FA

Rectangle{
    id:chatwindow
    property string userid: ""
    property string name: ""
    property string address: ""
    property bool online: false
    property bool ismax: false
    property int tabIndex
    property Rectangle bakg: _chatwindowbakg
    anchors.fill: parent

    visible: true
    color: "transparent"

    onVisibleChanged: {
        if(visible){
            inputarea.text().forceActiveFocus();
        }
    }

    Component.onDestruction: {
//        chatwindow.destroy();
//        client.destroyWindow(chatwindow);
    }

    Rectangle{
        id:_chatwindowbakg
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 5
            right: files.left
            rightMargin: 10
        }
        height: parent.height

        color: mainform.color

        ChatHeader {
            id:chatwindowheader
            height : 50
            width: parent.width
            clientname:chatwindow.name
            clip : true
            anchors {
                top:_chatwindowbakg.top
                topMargin: _chatwindowbakg.border.width
                horizontalCenter: _chatwindowbakg.horizontalCenter
            }
            color:"transparent"
            GradientBorder{
                pos : "bottom"
                color_middle : "#ccc"
            }
        }

        MessageArea {
            id:msgArea
            border.color: "#f0f0f0"
            //                height: _chatwindowbakg.height - chatwindowheader.height - sendarea.height - toolbar.height - parent.spacing*2 - 2
            width: _chatwindowbakg.width
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom : toolbar.top
                bottomMargin: 5
                top : chatwindowheader.bottom
            }
            ScrollView {
                width: parent.width - msgArea.border.width*2
                height: parent.height - parent.border.width*2
                horizontalScrollBarPolicy:Qt.ScrollBarAlwaysOff
                verticalScrollBarPolicy:Qt.ScrollBarAsNeeded
                style: ScrollViewStyle{transientScrollBars:true}
                anchors {
                    centerIn: parent
                }

                ListView {
                    id:chatmessahelist
                    anchors.fill: parent
                    model: ChatMessageListModel{id:chatmessagelistmodel}
                    delegate : ChatMessageListItem{id:chatmessagelistitem}
                }
            }
        }

        MyToolBar{
            id:toolbar
            width: parent.width
            btnradius: 5
            btnHeight: 25
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
            y : 400
            onSelectFile: {
//                file_progress.visible = true;
                filemodel.append({"filename": filename , "fileurl": url , "filestate" : "ready"});
            }
        }

        Rectangle{
                id:sendarea
                height: 100 + footer.height
                color : "transparent"
                width: parent.width
                property int spacing: 5

                anchors {
                    top : toolbar.bottom
                    topMargin: 5
                    bottom : parent.bottom
                    horizontalCenter: parent.horizontalCenter
                }

                InputArea {
                    id:inputarea
                    height : undefined
                    width: parent.width - sendarea.spacing*2
                    anchors {
                        top : sendarea.top
                        horizontalCenter: parent.horizontalCenter
                        bottom: footer.top
                        bottomMargin: inputarea.border_width
                    }

                    onCtrl_Enter: {
                        text().append("");
//                        GEN.send(userid,"我",chatwindow.getContent());
//                        chatwindow.setContent("");
                    }
                    onEnter:{
                        footer.sendbtnclick();
//                          GEN.send(userid,"我",chatwindow.getContent());
//                          chatwindow.setContent("");
                    }
                }

                ChatFooter{
                    id:footer
                    height:40
                    color:"transparent"
                    btnradius:5
                    font_size: 13
                    anchors {
                        bottom : parent.bottom
                    }
                }
            }

    }

    Rectangle {
        id : files
        height: parent.height - 20
        width: 300
        visible: width > 0
        anchors {
            right : parent.right
            rightMargin: 5
            verticalCenter: parent.verticalCenter
        }

        color : "#fff"
        border{
            color : "#ccc"
            width: 1
        }
        radius: 3
        smooth : true
        clip : false

        ScrollView{
            anchors.fill: parent
            smooth : true
            clip : false
            ListView{
                id : fileList
                anchors.fill: parent
                smooth : true
                clip : false
                model : ListModel {
                    id : filemodel
                    ListElement{filename : ".png";fileurl : "A:/dqwd/qd/wqrhrthrtd/qwd/.png";}
                    ListElement{filename : "dddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee.png";fileurl : "B:/dqwd/qd/wqrhrthrtd/qwd/dddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee.png";}
                    ListElement{filename : "dddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee.png";fileurl : "C:/dqwd/qd/wqrhrthrtd/qwd/dddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee.png";}
                    ListElement{filename : "dddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee.png";fileurl : "D:/dqwd/qd/wqrhrthrtd/qwd/dddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee.png";}
                    onCountChanged: {
                        if(count == 0){
                            files.width = 0;
                            _chatwindowbakg.anchors.rightMargin = 0;
//                            _chatarea.width = 800;
                        }else{
                            files.width = 300;
                            _chatwindowbakg.anchors.rightMargin = 10;
//                            _chatarea.width = 1000;
                        }
                    }
                }
                delegate:FileElement{
                    id : filedelegate
                    height: 55
                    width: parent.width - 10
                }
            }
        }
    }
    ToolTip{
        id : tooltip
        opacity: 0
        colorOpacity : 0.7
//            anchors.bottom : parent.top
        x : files.x + 20 - leftWidth
        y : files.y
        text : ""
    }

    function getContent(){
        return inputarea.text().text;
    }
    function setContent(e){
        inputarea.text().text = e;
    }
    function getHeader(){
        return chatwindowheader;
    }
    function recv(friend,msg){
        //{"type":2,"friend":"1","message":"\"trimmsg\"\"trimmsg\"  \"trimmsg\""}
        msg = msg.replace(/(&s;)/gi,"\\");
        msg = msg.replace(/(&r;)/gi,"\n");
        msg = msg.replace(/(&q;)/gi,"\"");
        chatmessagelistmodel.append({"name": friend , "message": msg , "me" : false});
    }
}
