import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Rectangle {
    id: father

    height: messagepop.height + client_name.height + 30
    width: parent.width
//    color : "#e2e2e2"
//    border.color: "#000"

//    property Gradient meballooncolor: Gradient {
//        GradientStop{position: 0.0;color : "#69b2f8"}
//        GradientStop{position: 1.0;color : "#1f85fb"}
//    }
//    property Gradient friendballooncolor: Gradient {
//        GradientStop{position: 0.0;color : "#fff"}
//        GradientStop{position: 1.0;color : "#f9f9f9"}
//    }

    anchors {
        horizontalCenter: parent.horizontalCenter
    }

    Column{
        spacing: 10
        width: parent.width
        anchors {
//            left: (me ? undefined : parent.left);
//            right:(me ? parent.right : undefined);
//            leftMargin: (me ? undefined : 10);
//            rightMargin: (me ? 10 : undefined);
            verticalCenter: parent.verticalCenter
//            fill : parent
        }


        Rectangle{
            height: client_name.contentHeight + 10
            width: client_name.width + 20
            radius: height
            color : "transparent"
            border.color: "#ddd"
            gradient: Gradient{
                GradientStop{position: 0.0;color : "#fff"}
                GradientStop{position: 1.0;color : "#f5f5f5"}
            }

            MyText {
                id:client_name
                font_size: 14
                anchors.centerIn: parent
                text : "<b>" + name + "</b>"
            }
            anchors {
//                verticalCenter: parent.verticalCenter
//                top: parent.top
//                topMargin: 7
                right: (me ? parent.right : undefined)
                left: (me ? undefined : parent.left)
                leftMargin: (me ? undefined : 10);
                rightMargin: (me ? 10 : undefined);
            }
        }

        Rectangle{
            id : messagepop
            height: client_message.contentHeight + 10
            width : ((client_message.contentWidth + 10) > 500 ? 500 : (client_message.contentWidth + 10))
            radius: 10
            color : me ? "#3399ff" : "#f0f0f0"
//            gradient: me ? meballooncolor : friendballooncolor
            anchors {
//                verticalCenter: parent.verticalCenter
                right: (me ? parent.right : undefined)
                rightMargin: (me ? 10 : undefined)
                left: (me ? undefined : parent.left)
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
//                    verticalCenter: parent.verticalCenter
                    top: parent.top
                    topMargin: 7
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
                    right: parent.right
                    rightMargin: 5
                    verticalCenter: parent.verticalCenter
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
