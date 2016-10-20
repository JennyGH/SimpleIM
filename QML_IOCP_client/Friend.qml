import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import "../js/generic.js" as GEN

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

    color:father.background_color

    //----------------------

//    PopMenu{
//        id:rightmenu
////        visible:(mousearea.pressedButtons & Qt.RightButton)
//        enabled:visible
//        z:999
//        parent: father.parent

//        onVisibleChanged: {
//            if(visible){
//                forceActiveFocus();
//            }
//        }

//        onActiveFocusChanged: {
//            if(!activeFocus){
//                console.log("un active");
//                visible = false;
//            }
//        }
//    }

    MouseArea{
        id:mousearea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked:{
            if(mouse.button === Qt.RightButton){
//                edit.width = 60
                if(edit.x >= edit.hidex){
                    showdetailsbtn.start();
                }
            }else{
                forceActiveFocus();
//                edit.width = 0;
                if(edit.x <= edit.showx){
                    hidedetailsbtn.start();
                }
            }
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
            if(mousearea.pressedButtons & Qt.LeftButton)
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

            MyText{
                id:txt
                color:father.font_color
                anchors{
                    verticalCenter: parent.verticalCenter
                }
                text:name
            }
        }
    }
    MyButton{
        id:edit
        height: parent.height
        width:60
        title:"查看"
        state:"hide"
        enter_color: "#5aa7f8"
        enter_font_color: "#fff"
//        radius:5
        font_size: 12
//        border_color: "#e2e2e2"
        property int showx: 202
        property int hidex: 262
        x : 262
        color : Qt.lighter("#5aa7f8",1.2)
        exit_color: Qt.lighter("#5aa7f8",1.2)
        anchors{
            verticalCenter: parent.verticalCenter
//            right:parent.right
//            left : father.right
//            rightMargin: 10
        }
        onClick: {
            var newdetailswindow;
            if((newdetailswindow = GEN.isExistWindow(mainform.detailswindows,ID))){

                newdetailswindow.requestActivate();

                return newdetailswindow;
            }else{
                newdetailswindow = GEN.createSingleWindow(mainform.detailswindows,"DetailsWindow",mainform);
                newdetailswindow.userid = ID;
                newdetailswindow.friendindex = index;
                newdetailswindow.setName(name);
            }
//            newdetailswindow.visible = true;
        }
        Component.onCompleted: {
//            console.log(x)
        }
        onActiveFocusChanged: {
            if(!activeFocus){
                if(edit.x <= edit.showx){
                    hidedetailsbtn.start();
                }
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
    PropertyAnimation {
        id: showdetailsbtn
        target: edit
        duration: 150
        easing.type: Easing.OutExpo
        property: 'x'
        from: edit.hidex
        to: edit.showx
        onStarted: {
            edit.enabled = true;
            edit.forceActiveFocus();
        }
    }
    PropertyAnimation {
        id: hidedetailsbtn
        target: edit
        duration: 150
        easing.type: Easing.OutExpo
        property: 'x'
        from: edit.showx
        to: edit.hidex
        onStarted: {
            edit.enabled = false;
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
