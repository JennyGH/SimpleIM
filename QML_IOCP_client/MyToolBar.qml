import QtQuick 2.0

Item {
    id:father
    height: 30
    width: parent.width
    property int btnradius: 0
    property int btnHeight: 25
    property int btnWidth: 25
    Row{
        spacing: 5
        width: parent.width
        anchors.left: parent.left
        anchors.leftMargin: spacing
        anchors.verticalCenter: parent.verticalCenter
        MyButton{
            id:btnsendfile
            anchors.verticalCenter: parent.verticalCenter
            height: btnHeight
            width: contentwidth
            title: "😄"
            enter_color: "#157efb"
            enter_font_color: "#fff"
            radius:btnradius
            border_color: "#ddd"
        }
        MyButton{
            id:btnemoji
            anchors.verticalCenter: parent.verticalCenter
            height: btnHeight
            width: contentwidth
            title: "🍱"
            enter_color: "#157efb"
            enter_font_color: "#fff"
            radius:btnradius
            border_color: "#ddd"
        }
        MyButton{
            id:btnfont
            anchors.verticalCenter: parent.verticalCenter
            height: btnHeight
            width: contentwidth
            title: "🔍"
            enter_color: "#157efb"
            enter_font_color: "#fff"
            radius:btnradius
            border_color: "#ddd"
        }
    }
}
