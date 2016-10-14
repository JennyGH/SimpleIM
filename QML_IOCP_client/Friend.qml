import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Rectangle{
    id:father
    property color background_color: mainform.color
    property color background_hover_color: "#eee"
    property color border_color: "#aaa"
    property color border_hover_color: "#aaa"
    property color font_color: mainform.font_color
    property color shine_color: Qt.lighter("#3399ff",1.5)
    property int marginleft: 10
    property int msgcount: 0

    state: "out" //默认状态

    width: parent.width
    signal click()
    signal dbclick()
    height: 50

//    border.color: father.border_color

    //-----样式-------------

//    source: "qrc:/"       //Image时用source属性加载背景图片
//    gradient: Gradient {  //Mac渐变
//              GradientStop { position: 0.0; color: "#fff" }
//              GradientStop { position: 1.0; color: "#e2e2e2" }
//          }

    color:father.background_color

    //----------------------

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onClicked:{
            father.click();
        }
        onEntered: {
            head.state = "ACTIVE";
            father.state = "in";
        }
        onExited: {
            head.state = "NEGTIVE";
            father.state = "out";
        }
        onPressed: {
//            row.scale = 0.9
        }
        onReleased: {
//            row.scale = 1
        }
        onDoubleClicked: {
            dbclick();
        }
    }


    Row{
        id:row
        spacing: father.marginleft
        width: father.width

        anchors{
            verticalCenter: parent.verticalCenter
            leftMargin: father.marginleft
            left: parent.left
        }

        Head{
            id:head
            height: 40
            width:40
            radius:40
            anchors{
                verticalCenter: parent.verticalCenter
            }
            Rectangle{
                id:circlemsgcount
                visible: (msgcount > 0)
                height: lblmsgcount.contentHeight
                color: "red"
                width: lblmsgcount.contentWidth + 10
                radius: height
                MyText{
                    id:lblmsgcount
                    anchors.centerIn: parent
                    font_size: 15
                    color: "#fff"
                    text: "<b>" + (msgcount > 99 ? "99+" : msgcount) + "</b>"
                }
                anchors {
                    top:parent.top
                    right: parent.right
                    rightMargin: -width/2
                    topMargin: -height/2
                }
            }
        }

        OnlineLED{
            id:onlineled
            online : true
            anchors{
                verticalCenter: parent.verticalCenter
            }
        }

        Row{
            spacing : 1
            anchors{
                verticalCenter: parent.verticalCenter
            }
            TextField{
                id:txtname
                text : name
    //            color:father.font_color
                width: 100
                height: 30
                font.family: txt.font.family
                font.pixelSize: txt.font.pixelSize
                anchors{
                    verticalCenter: parent.verticalCenter
                }
                property int borderwidth: 0
                property bool change: false
                style:TextFieldStyle{
                    background: Rectangle{
                        anchors.fill: parent
                        color : "transparent"
                        border.color: "#e2e2e2"
                        border.width:txtname.borderwidth
                    }
                }

                selectByMouse: true
                readOnly: true
                enabled: !readOnly
                onTextChanged: {
                    if(length > 10){
                        text = text.substring(0,10)
                    }
                    change = true;
                }
            }

            MyText{
                id:txt
                color:father.font_color
                anchors{
                    verticalCenter: parent.verticalCenter
                }

                text:"(" + ID + ")"
            }
        }
    }


    MyButton{
        id:edit
        height: 25
        width:40
        title:"编辑"
        enter_color: "#5aa7f8"
        enter_font_color: "#fff"
        radius:5
        font_size: 12
        border_color: "#e2e2e2"
        property bool editting: false
        anchors{
            verticalCenter: parent.verticalCenter
            right:parent.right
            rightMargin: 10
        }
        onClick: {
            if(editting){
                title = "编辑"
                editting = !editting
                enter_color = "#5aa7f8"
//                console.log("保存修改")
                txtname.readOnly = true;
                txtname.borderwidth = 0;
                if(txtname.change){
                    client.sendmessage(txtname.text,ID,6); //消息6：修改好友备注
                }
                txtname.change = false;
            }else{
                title = "保存"
                editting = !editting
                enter_color = "#09bb07"
//                console.log("编辑模式")
                txtname.readOnly = false;
                txtname.borderwidth = 1;
                txtname.change = false;
            }
        }
    }

    states: [
        State {
            name: "in"
            PropertyChanges {
                target: father
                color : background_hover_color
            }
        },
        State {
            name: "out"
            PropertyChanges {
                target: father
                color : background_color
            }
        }
//        State {
//            name: "active"
//            PropertyChanges {
//                target: txt
//                scale : 0.9
//            }
//        },
//        State {
//            name: "nagative"
//            PropertyChanges {
//                target: txt
//                scale : 1
//            }
//        }
    ]
    transitions: Transition {
        ParallelAnimation {
            ColorAnimation { property: "color"; duration: 200 ;}
        }
    }
    function shine(){
        msgcount++;
    }
    function clear(){
        msgcount = 0;
    }

    function getText(){
        return txt.text
    }
}
