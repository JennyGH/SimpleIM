import QtQuick 2.0
import "generic.js" as GEN

Rectangle{
    id:father
    height: 50
    width:parent.width
    color: "#e2e2e2"
    property int font_size: 14
    property int btnradius: 0
    anchors {
        horizontalCenter: parent.horizontalCenter
    }

    Row{
        id :  row
        spacing : 10
        anchors {
            verticalCenter: parent.verticalCenter
            right: father.right
            rightMargin: 10
//            top : father.top
//            topMargin: 5
        }
        GradientButton{
            id:send
            height: 26
            width : contentwidth + 15
            title : "发送"
            border_color : "#bbb"
//            enter_color: "#157efb"
            enter_font_color: "#fff"
//            enter_border_color: "#fff"//Qt.darker("#157efb",1.5)
            font_size:father.font_size
            radius:btnradius
            onClick: {
                if(inputarea.text().text.length >= 800){
                    var alert = GEN.createWindow("Alert",_chatwindowbakg);
                    alert.isComfirm = false;
                    alert.alertHeight = 130;
                    alert.alertWidth = 220;
                    alert.content = "字数过多，请分段发送\n当前字数:" + inputarea.text().text.length;
                    return false;
                }else{
                    GEN.send(userid,"我",chatwindow.getContent());
                    chatwindow.setContent("");
                }
            }
            anchors {
                verticalCenter: parent.verticalCenter
            }
        }
        GradientButton{
            id:close
            height: 26
            width : contentwidth + 15
            title : "关闭"
            border_color : "#bbb"
//            enter_color: "#157efb"
            enter_font_color: "#fff"
//            enter_border_color: "#fff"//Qt.darker("#157efb",1.5)
            font_size:father.font_size
            radius:btnradius
            onClick: {
                GEN.removeWindowFromArray(mainform.chatwindows,null,_tabbar.currentIndex);
                _tabbar.removeTab(_tabbar.currentIndex);
                if(_tabbar.count == 0){
                    _chatarea.width = 0;
//                    header.maxable = false;
                }
            }
            anchors {
                verticalCenter: parent.verticalCenter
            }
        }
    }


    function getCloseBtn(){
        return close;
    }
    function getSendBtn(){
        return send;
    }
    function sendbtnclick(){
        send.click();
    }
}
