import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import "../js/generic.js" as GEN

Window {
    id:_searchwindow
    height: _searchwindowbakg.height + 30
    width:_searchwindowbakg.width + 30
    flags: Qt.FramelessWindowHint | Qt.Window
    color: Qt.rgba(0,0,0,0)
//    visible: true
    onVisibleChanged: {
        if(!visible){
            GEN.releaseWindow(this);
        }else{
            txtsearchuser.forceActiveFocus();
        }
    }

    Connections{
        target: client
        onRecvmessage: {
            var returnmsg = client.getMessage();
            var obj = GEN.formatMessage(returnmsg);

            switch(parseInt(obj.type)){
            case 3:
                friendmodel.clear();
                if(parseInt(obj.message.SqlMsgType) == 0){
                    var result = obj.message.Result;
                    for(var i=0;i<result.length;i++){
                        friendmodel.append({"ID":result[i][0],"name":result[i][1]});
                    }
                }break;

            default:
                break;
            }
        }
    }

    Rectangle {
        id:_searchwindowbakg
        height: 450
        width: 440
        color : "#f8f8f8"
        radius:5
        border.color: "#fff"
        anchors.centerIn: parent

        MainWindowHeader{
            id:_searchwindowheader
            movetarget : _searchwindow
            marginRight:5
            marginTop:marginRight
            title : "查找好友"
            onCloseClick: {
                fatherWindow.searchwindow = null;
            }
        }

        Row{

            id:searcharea

            spacing : 5

            height: btnsearchuser.height + 10

            anchors {
                top : _searchwindowheader.bottom
                horizontalCenter: parent.horizontalCenter
            }

            MyTextInput{
                id:txtsearchuser
                width: _searchwindowbakg.width - btnsearchuser.width - 30
                height: 28

                onEnterPressed: {
                    btnsearchuser.click();
                }
                onEscPressed: {
                    text = "";
                }
            }

            GradientButton{
                id:btnsearchuser
                height: 30
                width: 60
                anchors {
                    verticalCenter : parent.verticalCenter
                }
                title : "查找"

//                enter_color: "#e2e2e2"

                border_color: "#ddd"

                enter_font_color: "#fff"

                radius: _searchwindowbakg.radius

                onClick: {
                    console.log(client.searchNewFriend(txtsearchuser.text))
                }
            }
        }

        Rectangle{
            height: _searchwindowbakg.height - _searchwindowheader.height - parent.border.width - searcharea.height - 5
            width: parent.width - parent.border.width * 2 - 10
            color: "#fff"
            radius: parent.radius
            border.color: "#eee"
            anchors{
                top:searcharea.bottom
                horizontalCenter: parent.horizontalCenter
            }
            ScrollView {
                height: parent.height - parent.radius*2
                width: parent.width - parent.radius*2
                horizontalScrollBarPolicy:Qt.ScrollBarAlwaysOff
                verticalScrollBarPolicy:Qt.ScrollBarAsNeeded
                style: ScrollViewStyle{transientScrollBars:true}
                anchors.centerIn: parent

                ListView{
                    id:friendList
                    anchors {
                        fill : parent
                    }
                    highlightFollowsCurrentItem : true

                    model: SearchResultModel{
                        id:friendmodel
                    }
                    delegate: SearchResultItem{
                        id:friend
                        height: 50
                        onDbclick: {}
                        onDetailsClick: {}
                        onAddClick: {
                            client.sendmessage(name,ID,5);    //消息5：添加好友
                        }
                    }
                }
            }

        }
    }


    DropShadow {
        anchors.fill: _searchwindowbakg
        horizontalOffset: 0
        verticalOffset: 0
        radius: 16.0
        samples: 32
        color: "#80000000"
        source: _searchwindowbakg
    }
}
