import QtQuick 2.0

Rectangle{
    id:father
    height: 50
    width: parent.width
    color:"#f9f9f9"

    //----------私有属性-------------

    property string headsrc : "qrc:/src/src/userIcon.png"
    property string clientname : ""
    property bool online: false

    //------------------------------

    Row {
        spacing : 10

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 10
        }

        Head{
            id:client_head
            headIconSource: headsrc
            height: 40
            width: 40
            radius: 0
            anchors {
                verticalCenter: parent.verticalCenter
            }
        }

        MyText{
            id:client_name
            text : father.clientname
            anchors {
                verticalCenter: parent.verticalCenter
            }
        }

        OnlineLED{
            id:ol
            online: father.online
            anchors {
                verticalCenter: parent.verticalCenter
            }
        }
    }

    //    anchors {
    //        top : parent.top
    //        horizontalCenter: parent.horizontalCenter
    //    }
    //    color: "yellow"
}
