import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "fontawesome.js" as FA


Item{
    id : father
    width: 200
    height: list.height + inputbox.height
    property var model: new Array
    clip: false
    MyTextInput{
        id : inputbox
        height: 30
        width: parent.width - btnSelectID.width
        MyButton {
            id : btnSelectID
            radius: 5
            width: 20
            height: parent.height
            exit_color: "#1b83fb"
            enter_color: "#1b83fb"
            title : FA.icons.Selector
            exit_font_color: "#fff"
            enter_font_color: "#fff"
            usingFA: true
            anchors {
                left: parent.right
                verticalCenter: parent.verticalCenter
            }
            Rectangle{
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }
                width: parent.radius || 0
                height: parent.height
                color : "#1b83fb"
            }
            onClick: {
                list.visible = !list.visible;
            }
        }
    }
    Rectangle{
        id : list
        height: Math.min(listmodel.count * 25,250)
        width: inputbox.width
        visible: false
        enabled: visible
        border {
            color : "#eee"
            width: 1
        }
        color : Qt.rgba(255,255,255,0.5)
        anchors {
            top : inputbox.bottom
            left: inputbox.left
        }
        layer.enabled: true
        layer.effect: OuterShadow{
            target : list
        }

        ScrollView{
            anchors.fill: parent
            ListView{
                anchors.fill: parent
                model: ListModel{
                    id : listmodel
                    Component.onCompleted: {
                        for(var item in father.model){
                            append({"ltext": model[item], "value":parseInt(model[item])})
                        }
                    }
                }
                delegate: Rectangle{
                    width: parent.width
                    height: 25
                    color: Qt.rgba(255,255,255,0.1)
                    MyText{
                        text : ltext
                        anchors.centerIn: parent
                    }

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            parent.color = "#1b83fb";
                        }
                        onExited: {
                            parent.color = Qt.rgba(255,255,255,0.5);
                        }
                    }
                }
            }
        }

    }
}


