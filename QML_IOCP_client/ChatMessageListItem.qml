import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Rectangle {
    id: father

    height: messagepop.height + client_name.height
    width: parent.width

    anchors {
        horizontalCenter: parent.horizontalCenter
    }

    Item{
//        spacing: 10
        anchors {
//            fill: parent
            left: (me ? undefined : parent.left);
            right:(me ? parent.right : undefined);
            leftMargin: (me ? undefined : 10);
            rightMargin: (me ? 10 : undefined);
//            top : parent.top
//            topMargin: 10
            verticalCenter: parent.verticalCenter
        }

        MyText {
            id:client_name
            font_size: 18
            text : "<b>" + (me ? (" :" + name) : (name + ": ")) + "</b>"
            anchors {
                verticalCenter: parent.verticalCenter
                right: (me ? parent.right : undefined)
                left: (me ? undefined : parent.left)
            }
        }

        Rectangle{
            id : messagepop
            height: client_message.contentHeight + 10
            width : (client_message.contentWidth > chatwindow.width ? chatwindow.width : client_message.contentWidth) + 10
            radius: 5
            color : me ? "#3399ff" : "#f0f0f0"
            anchors {
                verticalCenter: parent.verticalCenter
                right: (me ? client_name.left : undefined)
                rightMargin: (me ? 20 : undefined)
                left: (me ? undefined : client_name.right)
                leftMargin: (me ? undefined : 10)
            }
            Image{
                source : me ? "qrc:/src/src/naill.png" : "qrc:/src/src/gray-naill.png"
                height: 10
                width: 10
                sourceSize.height: 10
                sourceSize.width: 10
                mirror: me
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: (me ? undefined : parent.left)
                    left: (me ? parent.right : undefined)
                }
            }

            MyText{
                id:client_message
                font_size: 15
                text : message
//                width: contentWidth > (chatwindow.width - 100) ? (chatwindow.width - 100) : undefined
                anchors {
//                    centerIn: parent
                    left: parent.left
                    leftMargin: 5
                    top : parent.top
                    topMargin: 5
                }
                wrapMode: Text.Wrap
                color : me ? "#fff" : "#444"
            }
        }
    }

//    Row {
//        spacing : 10

//        anchors {
//            verticalCenter: parent.verticalCenter
//            right: parent.right
//            rightMargin: 10
//        }
//    }
}
