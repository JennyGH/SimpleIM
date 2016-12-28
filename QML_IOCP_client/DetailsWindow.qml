import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "generic.js" as GEN
import "fontawesome.js" as FA

Window {
    id:details_fatherWindow
    height: 220
    width:350
    color : "transparent"
    flags: Qt.FramelessWindowHint
    visible:true
    property string userid : ""
    property int friendindex: 0
    property Alert alertwindow: null
    property bool me: false

    onVisibleChanged: {
        if(!visible){
            GEN.releaseWindow(mainform.detailswindows,this);
        }
    }

//    radius:5
    Rectangle{
        id:_detailswindowbakg
        height:details_fatherWindow.height - 30
        width:details_fatherWindow.width - 30
        anchors.centerIn: parent
        color: "#f5f5f5"
        border.color: "#fff"
        radius: 5
        layer.enabled: true
        layer.effect:OuterShadow {
            target :_detailswindowbakg
        }
        MainWindowHeader{
            id:_detailswindowheader
            movetarget: details_fatherWindow
            minable:false
            marginRight:10
            title : "详细信息"
            isVerticalCenter: true
        }
        Item{
            id:_detailscontent
            height: _detailswindowbakg.height - _detailswindowheader.height
            width: _detailswindowbakg.width - 50
            anchors {
                top : _detailswindowheader.bottom
                topMargin: 10
                horizontalCenter: parent.horizontalCenter
            }

            Row{
                spacing:10
                width: parent.width
                //                anchors.horizontalCenter: parent.horizontalCenter

                Head{
                    id:_detailswindowheadicon
                    height: 80
                    width: 80
                    radius: height
                    //                anchors.left: _detailswindowheadicon.left
                    //                    anchors {verticalCenter: parent.verticalCenter}
                }

                Column{
                    spacing: 5
                    width: parent.width - _detailswindowheadicon.width
                    //                    height: _detailscontent.height
                    anchors {verticalCenter: parent.verticalCenter}
                    Row {
                        id:namerow
                        spacing : 5
                        width: parent.width
                        MyText{
                            id:lblname
                            anchors {verticalCenter: parent.verticalCenter}
                            text:"用户名："
                        }
                        MyTextInput{
                            id:txtname
                            width: 100
                            readOnly: true
                            enabled: !readOnly
                            property bool change: false
                            radius: 0
                            onTextChanged: {
                                if(length > 10){
                                    text = text.substring(0,10)
                                }
                                change = true;
                            }
                        }
                        MyButton{
                            id:btneditname
                            height: 20
                            width:20
                            usingFA : true
                            title : FA.icons.Pencil
                            font_size: 20
                            anchors {verticalCenter: parent.verticalCenter}
                            property bool editting: false
                            onClick: {
                                if(editting){
                                    btneditname.title = FA.icons.Pencil;
                                    editting = !editting
                                    txtname.readOnly = true;
                                    if(txtname.change){
                                        client.sendmessage(txtname.text,userid,editMessage); //消息6：修改好友备注
                                    }
                                    fatherWindow.rename(friendindex,txtname.text);
                                    txtname.change = false;
                                }else{
                                    btneditname.title = FA.icons.Ok;
                                    editting = !editting
                                    txtname.readOnly = false;
                                    txtname.change = false;
                                }
                            }

                        }
                    }
                    Row {
                        id:idrow
                        spacing : 5
                        width: parent.width
                        MyText{
                            id:lblid
                            anchors {verticalCenter: parent.verticalCenter}
                            text:"    帐号："
                        }
                        MyText{
                            id:txtid
                            anchors {verticalCenter: parent.verticalCenter}
                            width: 100
                            text : userid
                        }
                    }

                }

            }
        }
    }

    function setName(e){
        txtname.text = e;
    }
}
