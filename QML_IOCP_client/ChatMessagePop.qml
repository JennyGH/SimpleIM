import QtQuick 2.0

Rectangle{
    id:father

    //-----------气泡大小------------
    property int row: 50
    property int length: 100
    property bool me: true
    property string content: ""
    //------------------------------

    height: msg_content.contentHeight
    width: msg_content.contentWidth
    radius : 5

    color:me ? "#3399ff" : "#fff"

    MyText{
        id:msg_content
        font_size: 15
        color:  me ? "#fff" : "#444"
        text: content
        anchors.centerIn: parent
        wrapMode: Text.Wrap
    }

    anchors {
        right: me ? parent.right : undefined
        left: me ? undefined : parent.left
        leftMargin:  me ? 0 : 20
        rightMargin:  me ? 20 : 0
    }
}
