import QtQuick 2.0
import QtQuick.Controls 1.4

Rectangle{
    id:father

    //---------样式----------

    property color border_color: "#eee"
    property int border_width: 1
    signal ctrl_Enter();

    //-----------------------

    height: 100
    width:parent.width
    //    anchors {
    //        bottom: parent.bottom
    //        horizontalCenter: parent.horizontalCenter
    //    }
    border.color: father.border_color
    border.width: father.border_width
    //    color: "red"

    TextArea {
        id:content
        //        height: father.height - 20
        //        width: father.width - 20
        anchors{
            centerIn: parent
            fill: parent
        }
        font.family: "微软雅黑"
        font.pixelSize: 18
        wrapMode : TextEdit.Wrap
        selectByMouse: true

        Keys.enabled: true
        Keys.onPressed: {
            if (((event.key == Qt.Key_Enter) || (event.key == Qt.Key_Return)) && (event.modifiers & Qt.ControlModifier))
            {
                //发送消息
                ctrl_Enter();
            }else if(event.key == Qt.Key_Escape){
                footer.getCloseBtn().click();
            }else{
                return;
            }

            event.accepted = true;
        }
    }

    function text(){
        return content;
    }

}
