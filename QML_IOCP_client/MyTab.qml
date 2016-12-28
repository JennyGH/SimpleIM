import QtQuick 2.0
Rectangle{
    id:tab
    height: 50
    color : mainform.color
    radius : 5
    border.color: "#bbb"
    border.width: 1
    property string friendname: "Jenny"
    property int btnHeight: 15
    property int btnraduis: btnHeight
    property int btnWidth: btnHeight
    signal closeClick();
    states: [
        State {
            name: "active"
            PropertyChanges {
                target: tab
                color : "#fff"
            }
        }
    ]
    MyText{
        id:_friendname
        text: friendname
        width : parent.width - close.width
        anchors{
            verticalCenter: parent.verticalCenter
            left: parent.left
        }
    }
    MyButton {
        id:close
        height: btnHeight
        width: btnWidth
        enter_color: "red"
        exit_color: "#f5544d"
        border_color: "#bc1b14"
        title : ""
        font_size : 20
        enter_font_color : "#fff"
        radius:btnraduis
        onClick: {
            closeClick();
        }
    }
}
