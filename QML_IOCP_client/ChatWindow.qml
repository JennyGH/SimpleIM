import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
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

    onVisibleChanged: {
        if(!visible){
            GEN.releaseWindow(this);
        }
    }

    Rectangle{
        id:_chatwindowbakg
        anchors.fill: parent
        border.color: "#aaa"
        MainWindowHeader{
            id:_chatwindowtitle
            movetarget : chatwindow
            marginRight: 1
            anchors {
                topMargin: _chatwindowbakg.border.width
            }
            onMove: {
                if(movetarget.ismax){
                    _chatwindowtitle.movetarget.showNormal();
                    ismax = false;
                }
            }

            Row{
                spacing : 1
                anchors {
                    top : _chatwindowtitle.top
                    right:_chatwindowtitle.closebtn.left
                    rightMargin: 1
                }
                MyButton{
                    id:min
                    height: 30
                    width:40
                    anchors {
                        verticalCenter: parent.verticalCenter
                    }
                    title : "—"
                    font_size: 11
                    enter_color: "#bbb"
                    onClick: {
                        _chatwindowtitle.movetarget.showMinimized();
                    }
                }
                MyButton{
                    id:max
                    height: 30
                    width:40
                    anchors {
                        verticalCenter: parent.verticalCenter
                    }
                    title : "□"
                    font_size: 20
                    enter_color: "#bbb"
                    onClick: {
                        if(!_chatwindowtitle.movetarget.ismax){
                            _chatwindowtitle.movetarget.showMaximized();
                            _chatwindowtitle.movetarget.ismax = true;
                        }else{
                            _chatwindowtitle.movetarget.showNormal();
                            _chatwindowtitle.movetarget.ismax = false;
                        }
                    }
                }
            }
        }

        Column{
//            anchors.fill: parent
            height: chatwindow.height - _chatwindowtitle.height - _chatwindowbakg.border.width*2
            width: chatwindow.width - _chatwindowbakg.border.width*2
            anchors {
                top : _chatwindowtitle.bottom
                horizontalCenter: _chatwindowtitle.horizontalCenter
            }

            ChatHeader {
                id:chatwindowheader
                height : 50
                clientname:chatwindow.name
            }
            MessageArea {
                id:msgArea
                border.color: _chatwindowbakg.border.color
                height: chatwindow.height - _chatwindowtitle.height - sendarea.height - chatwindowheader.height - 12
                ScrollView {
                    anchors.fill: parent
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
                height: inputarea.height + footer.height
                color: footer.color
                width: parent.width
                property int spacing: 5
                InputArea{
                    id:inputarea
                    height : 100
                    border_color: "#e2e2e2"
                    border_width : 2
                    width: parent.width - sendarea.spacing*2
                    anchors {
                        top : sendarea.top
                        topMargin: sendarea.spacing
                        horizontalCenter: parent.horizontalCenter
                    }
                }
                ChatFooter{
                    id:footer
                    anchors {
                        top : inputarea.bottom
                        topMargin: sendarea.spacing
                    }
                }
            }
        }
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
