import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../js/generic.js" as GEN

Window {
    id:details_fatherWindow
    height: 220
    width:350
    color : "transparent"
    flags: Qt.FramelessWindowHint
    visible:false
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
            btnHeight:30
            btnWidth:btnHeight
            btnraduis: _detailswindowbakg.radius * 100
            minable:false
            marginRight:5
            title : userid
        }
        Item{
            id:_detailscontent
            height: _detailswindowbakg.height - _detailswindowheader.height
            width: _detailswindowbakg.width - 50
            anchors {
                top : _detailswindowheader.bottom
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
                            style:TextFieldStyle{
                                background: Rectangle{
                                    anchors.fill: parent
                                    color : "transparent"
                                    border.color: "#e2e2e2"
                                    border.width:1
                                }
                            }
                            readOnly: true
                            enabled: !readOnly
                            property bool change: false
                            onTextChanged: {
                                if(length > 10){
                                    text = text.substring(0,10)
                                }
                                change = true;
                            }
                        }
                        ImgButton{
                            id:btneditname
                            source:"qrc:/src/src/pen.png"
                            height: 20
                            width:20
                            enter_img: source
                            exit_img: source
                            anchors {verticalCenter: parent.verticalCenter}
                            property bool editting: false
                            onClick: {
                                if(editting){
                                    btneditname.source = "qrc:/src/src/pen.png"
                                    editting = !editting
                                    txtname.readOnly = true;
                                    if(txtname.change){
                                        client.sendmessage(txtname.text,userid,6); //消息6：修改好友备注
                                    }
                                    fatherWindow.rename(friendindex,txtname.text);
                                    txtname.change = false;
                                }else{
                                    btneditname.source = "qrc:/src/src/check.png"
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
                            //                            height: 30
                            text : userid
                        }
                    }

                }

            }
        }

        GradientButton{
            id:btndelete
            width: parent.width - 20
            height: 40
            radius: 5
            enter_gradient:Gradient{
                GradientStop{position: 0.0;color : Qt.lighter("red",1.3)}
                GradientStop{position: 1.0;color : Qt.darker("red",1)}
            }
            exit_gradient : Gradient{
                GradientStop{position: 0.0;color : "red"}
                GradientStop{position: 1.0;color : Qt.darker("red",1.3)}
            }

            title : "<b>删除</b>"
            exit_font_color: "#fff"
            border_color: hasShadow ? "transparent" : "#e2e2e2"
            enter_font_color: "#fff"
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom : parent.bottom
                bottomMargin: 10
            }
            onClick: {
                if(!alertwindow){
                    alertwindow = GEN.createWindow("Alert",_detailswindowbakg);
                    alertwindow.alertHeight = 130;
                    alertwindow.alertWidth = 220;
                    alertwindow.content = "确定删除?";
                }
            }
            Connections{
                target: alertwindow
                onOk:{
//                    console.log("确认删除...")
                    client.sendmessage("",userid,7);
                    fatherWindow.remove(friendindex);
                    details_fatherWindow.close();
                    details_fatherWindow.destroy();
                }
                onCancel:{
                    alertwindow.closeAlert();
                }
                onClose:{
                    alertwindow = null;
                }
            }
        }

    }

    function setName(e){
        txtname.text = e;
    }
}
