import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import "generic.js" as GEN
import "fontawesome.js" as FontAwesome

Item{
    id:father
    property color normal_color: mainform.color
    property color enter_color: "#eee"
    property color border_color: "#aaa"
    property color enter_border_color: "#aaa"
    property color font_color: mainform.font_color
    property color enter_font_color: mainform.font_color
    property color shine_color: Qt.lighter("#3399ff",1.5)
    property int marginleft: 10
    property int msgcount: 0

    state: "out" //默认状态

    width: parent.width
    signal click()
    signal dbclick()
    height: mainform.itemHeight + bottombar.height
    smooth: true
    GradientBorder{
        z: 2
        pos : "bottom"
        color_middle : "#eee"
    }

    Rectangle{
        id : itembakg
        z : 1
        color:father.normal_color
        height: father.height - bottombar.height
        width: parent.width
        anchors {
            horizontalCenter: parent.horizontalCenter
            top : parent.top
        }

        MouseArea{
            id:mousearea
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked:{
                if(mouse.button === Qt.RightButton){
                    showAnimation.start();
                }else{
                    forceActiveFocus();
                    hideAnimation.start();
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
            onDoubleClicked: {
                if(mousearea.pressedButtons & Qt.LeftButton)
                    dbclick();
            }
        }
    }

    Row {
        id:row
        z: 1
        spacing: father.marginleft
        width: father.width

        anchors{
            verticalCenter: bottombar.visible ? undefined : parent.verticalCenter
            bottom: bottombar.visible ? bottombar.top : undefined
            bottomMargin: bottombar.visible ? 5 : undefined
            leftMargin: father.marginleft
            left: parent.left
        }

        Head{
            id:head
            height: 30
            width:30
            radius:30
            anchors{
                verticalCenter: parent.verticalCenter
            }
            Rectangle{
                id:circlemsgcount
                visible: (msgcount > 0)
                height: lblmsgcount.contentHeight
//                color: "red"
                gradient : Gradient{
                    GradientStop{position: 0;color : "#e00f00"}
                    GradientStop{position: 1;color : "#960200"}
                }

                width: lblmsgcount.contentWidth + 10
                radius: height
                MyText{
                    id:lblmsgcount
                    anchors.centerIn: parent
                    font_size: 12
                    color: "#fff"
                    text: "<b>" + (msgcount > 99 ? "99+" : msgcount) + "</b>"
                }
                anchors {
                    top:parent.top
                    right: parent.right
                    rightMargin: -width/3
                    topMargin: -height/3
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

        MyText{
            id:txt
            color:father.font_color
            font_size: 13
            anchors{
                verticalCenter: parent.verticalCenter
            }
            text:name
        }
    }

    Item{
        id : bottombar
        width: parent.width
        height: 0
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom : parent.bottom
        }
        enabled: visible && opacity
        visible: height > 0
        Behavior on height {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutExpo
            }
        }
        onActiveFocusChanged: {
            if(!activeFocus){
                hideAnimation.start();
            }
        }
        layer.enabled: true
        layer.effect: InnerShadow{
            anchors.fill: bottombar
            radius: 6.0
            samples: 6
            horizontalOffset: 0
            verticalOffset: 2
            color: Qt.rgba(0,0,0,0.1)
            source: bottombar
        }

        Row{
            spacing: 0
            property int btnHeight: height
            property int btnFontsize: Math.max(12,btnHeight - 15)
            property int buttonCount: 2
            anchors.fill: parent
            MyButton{
                id : edit
                width: parent.width/parent.buttonCount
                height: parent.btnHeight
                usingFA: true
                title : FontAwesome.icons.ListAlt
                font_size: parent.btnFontsize
                enter_color: father.enter_color
                enter_font_color: father.enter_font_color
                onClick: {
                    var newdetailswindow;
                    if((newdetailswindow = GEN.isExistWindow(mainform.detailswindows,ID))){

                        newdetailswindow.requestActivate();

                        return newdetailswindow;
                    }else{
                        newdetailswindow = GEN.createSingleWindow(mainform.detailswindows,"DetailsWindow",mainform);
                        newdetailswindow.userid = ID;
//                        newdetailswindow.friendindex = index;
                        newdetailswindow.setName(name);
                    }
                    //            newdetailswindow.visible = true;
                }
            }
            MyButton{
                id : btnDelete
                width: parent.width/parent.buttonCount
                height: parent.btnHeight
                usingFA: true
                title : FontAwesome.icons.Trash
                font_size: parent.btnFontsize
                enter_color: "red"
                enter_font_color: father.enter_font_color
                onClick: {
                    var _alert = GEN.alert({
                                               height :130,
                                               width : 220,
                                               text : "确定删除吗？",
                                               parent : mainform,
                                               confirm : true,
                                               onOk : function(){
                                                   client.sendmessage("",ID,deleteMessage);
                                                   fatherWindow.remove(index);
                                               },
                                               onClose : function(){
                                                   _alert.destroy();
                                               }
                                           });
                }
            }

        }

    }

    states: [
        State {
            name: "in"
            PropertyChanges {
                target: itembakg
                color : enter_color
            }
            PropertyChanges {
                target: txt
                color : enter_font_color
            }
        },
        State {
            name: "out"
            PropertyChanges {
                target: itembakg
                color : normal_color
            }
            PropertyChanges {
                target: txt
                color : font_color
            }
        }
    ]
    transitions: Transition {
        ParallelAnimation {
            ColorAnimation { property: "color"; duration: 200 ;}
        }
    }

    ParallelAnimation{
        id : showAnimation
        NumberAnimation {
            target: bottombar
            property: "opacity"
            to : 1
            duration: 200
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: bottombar
            property: "height"
            to : 30
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }

    ParallelAnimation{
        id : hideAnimation
        NumberAnimation {
            target: bottombar
            property: "opacity"
            to : 0
            duration: 200
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: bottombar
            property: "height"
            to : 0
            duration: 200
            easing.type: Easing.InOutQuad
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
