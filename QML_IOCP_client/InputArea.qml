import QtQuick 2.0
import QtQuick.Controls 1.4

Rectangle{
    id:father

    //---------样式----------

    property color border_color: "#eee"
    property int border_width: 1

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
//        selectionColor: "#3399ff"
        Keys.enabled: true
//        Keys.onContext2Pressed:
        Keys.onPressed: {
            switch(event.key){
            case (Qt.Key_Return + Qt.Key_Control):
                console.log("hello1");
                break;
            case (Qt.Key_Enter + Qt.Key_Control):
                console.log("hello2");
                break;
            case Qt.Key_Escape:
                footer.getCloseBtn().click();
                break;
            default : return
            }
            event.accepted = true;
        }
    }

    function text(){
        return content;
    }

}
