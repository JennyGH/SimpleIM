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
    property Rectangle bakg: _chatwindowbakg
    height: 480
    width: 640
    visible: false
    title: "与 " + name  + " 交谈中..."
    flags: Qt.FramelessWindowHint | Qt.Window
    minimumHeight: 400
    minimumWidth: 600
    color: Qt.rgba(0,0,0,0)

    onVisibleChanged: {
        if(!visible){
            GEN.releaseWindow(this);
        }else{
            animBig.start();
            inputarea.text().forceActiveFocus();
        }
    }

    Rectangle{
        id:_chatwindowbakg
        height: parent.height - 30
        width: parent.width - 30
        scale:0
        anchors {
            centerIn: parent
        }

        color:"#f5f5f5"

        radius: 5

//        border.color: "#aaa"
        border.color: "#fff"

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
            color:"transparent"

            MainWindowHeader{
                id:_chatwindowtitle
                movetarget : chatwindow
                maxable: true
                marginRight: 5
                btnHeight: 30
                btnWidth: btnHeight
                btnraduis: _chatwindowbakg.radius * 100
                anchors {
//                    fill: parent

                    topMargin:_chatwindowtitle.marginRight
                }
                title:""
                onMove: {
                    if(movetarget.ismax){
                        _chatwindowtitle.movetarget.showNormal();
                        _chatwindowtitle.movetarget.bakg.height = _chatwindowtitle.movetarget.height - 30;
                        _chatwindowtitle.movetarget.bakg.width = _chatwindowtitle.movetarget.width - 30;
                        ismax = false;
                    }
                }
            }
        }

        Column{
            spacing : 5
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
                height: _chatwindowbakg.height - chatwindowheader.height - sendarea.height - toolbar.height - parent.spacing*2 - 2
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

            MyToolBar{
                id:toolbar
                width: parent.width
                btnradius: 5
                btnHeight: 30
                MouseArea{
                    property point clickPos: "0,0"
                    property int movecount: 0
                    property int ychangecount: 0
                    property int average:0
                    anchors.fill: parent
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

            }

            Rectangle{
                id:sendarea
                height: 100 + footer.height
//                color: footer.color
                color : "transparent"
                width: parent.width
                property int spacing: 5

                InputArea {
                    id:inputarea
                    height : undefined
                    width: parent.width - sendarea.spacing*2
                    anchors {
                        top : sendarea.top
                        //                        topMargin: sendarea.spacing
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
                          GEN.send(userid,"我",chatwindow.getContent());
                          chatwindow.setContent("");
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
//                        bottomMargin:10
                    }
                }
            }
        }


    }

    DropShadow {
        id:_shadow
        anchors.fill: _chatwindowbakg
        horizontalOffset: 0
        verticalOffset: 0
        radius: 16.0
        samples: 32
        color: "#80000000"
        source: _chatwindowbakg
//        enabled: false
//        visible: false
        scale: _chatwindowbakg.scale
    }

    PropertyAnimation {
        id: animBig
        target: _chatwindowbakg
        duration: 200
        easing.type: Easing.OutQuint
        property: 'scale'
        from: 0
        to: 1
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
