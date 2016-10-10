import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import "../js/generic.js" as GEN

Window{
    id:chatwindow
    property string userid: ""
    property string name: ""
    property string address: ""
    property bool online: false
    property bool ismax: false
    height: 480
    width:640
    visible: false
    title: "与 " + name  + " 交谈中..."
    flags: Qt.FramelessWindowHint | Qt.Window
    minimumHeight: 400
    minimumWidth: 600
    color: Qt.rgba(0,0,0,0)

    onVisibleChanged: {
        if(!visible){
            GEN.releaseWindow(this);
        }
    }

    Rectangle{
        id:_chatwindowbakg
//        anchors.fill: parent
        height: parent.height - 30
        width: parent.width - 30
        anchors {
            centerIn: parent
        }

        border.color: "#aaa"

        ChatHeader {
            id:chatwindowheader
            height : 50
            width: parent.width - parent.border.width*2
            clientname:chatwindow.name
            anchors {
                top:_chatwindowbakg.top
                topMargin: _chatwindowbakg.border.width
                horizontalCenter: _chatwindowbakg.horizontalCenter
            }

            MainWindowHeader{
                id:_chatwindowtitle
                movetarget : chatwindow
                maxable: true
                anchors {
                    fill: parent
                }
                title:""
                onMove: {
                    if(movetarget.ismax){
                        _chatwindowtitle.movetarget.showNormal();
                        ismax = false;
                    }
                }
            }
        }

        Column{
            //            anchors.fill: parent
            height: _chatwindowbakg.height - chatwindowheader.height - _chatwindowbakg.border.width*2
            width: _chatwindowbakg.width - _chatwindowbakg.border.width*2
            anchors {
                top : chatwindowheader.bottom
                horizontalCenter: chatwindowheader.horizontalCenter
            }
            MessageArea {
                id:msgArea
                border.color: _chatwindowbakg.border.color
                height: _chatwindowbakg.height - chatwindowheader.height - sendarea.height - 2
                width: _chatwindowbakg.width
                anchors {
                    horizontalCenter: parent.horizontalCenter
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
            Rectangle{
                id:sendarea
                height: 100 + footer.height
                color: footer.color
                width: parent.width
                property int spacing: 5
                MouseArea{
                    id:toolbar
                    width: parent.width
                    height: sendarea.spacing
                    anchors {
                        top : parent.top
                        horizontalCenter: parent.horizontalCenter
                    }
                    property point clickPos: "0,0"
                    property int movecount: 0
                    property int ychangecount: 0
                    property int average:0
                    onPressed: {
                        clickPos = Qt.point(mouse.x,mouse.y);
                        movecount = 0;
                        ychangecount = 0;
                    }
                    onPositionChanged: {
                        //鼠标偏移量
                        var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y);
                        ychangecount += Math.abs(delta.y);
                        movecount++;
                        average = ychangecount / movecount;
                        if(Math.abs(delta.y) > average){
                            delta.y = (delta.y < 0 ? -average : average);
                        }
                        //如果mainwindow继承自QWidget,用setPos
                        if((sendarea.height - delta.y) > _chatwindowbakg.height * 0.4)
                            sendarea.height = _chatwindowbakg.height * 0.4;
                        else if((sendarea.height - delta.y) < 100)
                            sendarea.height = 100;
                        else
                            sendarea.height = sendarea.height - delta.y;
                    }
                }

                InputArea {
                    id:inputarea
                    height : undefined
                    border_color: "#e2e2e2"
                    border_width : 2
                    width: parent.width - sendarea.spacing*2
                    anchors {
                        top : toolbar.bottom
                        //                        topMargin: sendarea.spacing
                        horizontalCenter: parent.horizontalCenter
                        bottom: footer.top
                        bottomMargin: inputarea.border_width
                    }
                    onCtrl_Enter: {
                        GEN.send(userid,"我",chatwindow.getContent());
                        chatwindow.setContent("");
                    }
                }
                ChatFooter{
                    id:footer
                    height:40
                    anchors {
                        bottom : parent.bottom
                    }
                }
            }
        }


    }

    DropShadow {
        anchors.fill: _chatwindowbakg
        horizontalOffset: 0
        verticalOffset: 0
        radius: 16.0
        samples: 32
        color: "#80000000"
        source: _chatwindowbakg
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
        chatmessagelistmodel.append({"name": friend , "message": msg , "me" : false});
    }
}
