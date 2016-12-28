import QtQuick 2.0
import QtQuick.Controls 1.4

Rectangle{
    id:father

    //---------样式----------

    property color border_color: "#ccc"
    property int border_width: 1
    signal ctrl_Enter();
    signal enter();

    //-----------------------

    height: 100
    width:parent.width
    //    anchors {
    //        bottom: parent.bottom
    //        horizontalCenter: parent.horizontalCenter
    //    }
    border.color: content != null ? (content.activeFocus ? "#50c3f8" : father.border_color) : "transparent"
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
        layer.enabled: content != null ? (content.activeFocus ? true : false) : false
        layer.effect: OuterShadow{
            target:content
            color: "#50c3f8"
            radius: 10
            samples: 20
            opacity: content != null && content.activeFocus ? 1 : 0
            Behavior on opacity {
                NumberAnimation{
                    duration : 200
                }
            }
        }
        font.family: "微软雅黑"
        font.pixelSize: 12
        wrapMode : TextEdit.Wrap
        selectByMouse: true

        Keys.enabled: true
        Keys.onPressed: {
            if (((event.key == Qt.Key_Enter) || (event.key == Qt.Key_Return)) && (event.modifiers & Qt.ControlModifier))
            {
                //发送消息
                ctrl_Enter();
            }
            else if(((event.key == Qt.Key_Enter) || (event.key == Qt.Key_Return))){
                enter();
            }
            else if(event.key == Qt.Key_Escape){
                footer.getCloseBtn().click();
            }else{
                return;
            }

            event.accepted = true;
        }
    }

    Border{
        pos : "top"
        color : father.border.color
    }

    Border{
        pos : "bottom"
        color : father.border.color
    }

    Border{
        pos : "left"
        color : father.border.color
    }

    Border{
        pos : "right"
        color : father.border.color
    }

    function text(){
        return content;
    }

}
