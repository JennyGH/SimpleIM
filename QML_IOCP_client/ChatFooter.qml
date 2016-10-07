import QtQuick 2.0
import "../js/generic.js" as GEN

Rectangle{
    id:father
    height: 50
    width:parent.width
    color: "#e2e2e2"
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
        MyButton{
            id:send
            height: 30
            width : 60
            title : "发送"
            border_color : "#aaa"
            enter_color: "#bbb"
            onClick: {
                GEN.send(userid,"我",chatwindow.getContent());
                chatwindow.setContent("");
            }
            anchors {
                verticalCenter: parent.verticalCenter
            }
        }
        MyButton{
            id:close
            height: 30
            width : 60
            title : "关闭"
            border_color : "#aaa"
            enter_color: "#bbb"
            onClick: {
                chatwindow.close();
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
}
