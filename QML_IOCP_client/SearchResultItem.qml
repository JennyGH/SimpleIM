import QtQuick 2.0

Rectangle{
    id:father
    property color background_color: "#fff"//mainform.color
    property color background_hover_color: "#1f85fb"
    property color border_color: "#aaa"
    property color border_hover_color: "#aaa"
    property color font_color: mainform.font_color
    property color enter_font_color: "#fff"
    property int marginleft: 10

    state: "out" //默认状态

    width: parent.width
    signal dbclick()
    signal detailsClick();
    signal addClick();
    height: 40

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
            radius:height
            anchors{
                verticalCenter: parent.verticalCenter
            }
        }

        MyText{
            id:txt
            color:father.font_color
            anchors{
                verticalCenter: parent.verticalCenter
            }
            text:name + "(" + ID + ")"
        }
    }

    Row{
        spacing: 5
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: spacing
        }

        MyButton{
            id:details  //查看详情
            height: 30
            width: 60
            title : "查看"
            enter_color: "#5aa7f8"
            enter_font_color: "#fff"
            border_color: "#e2e2e2"
            visible: false
            enabled: false
            radius:_searchwindowbakg.radius
            anchors{
                verticalCenter: parent.verticalCenter
            }
            onClick: {
                //详情按钮点击...
                detailsClick();
            }
        }

        GradientButton{
            id:request  //申请好友
            height: 30
            width: 60
            title : "添加"
//            enter_color: "#09bb07"
            enter_font_color: "#fff"
            border_color: "#ddd"
            radius:_searchwindowbakg.radius
            anchors{
                verticalCenter: parent.verticalCenter
            }
            onClick: {
                //添加按钮点击...
                addClick();
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
            PropertyChanges {
                target: txt
                color : enter_font_color
            }
        },
        State {
            name: "out"
            PropertyChanges {
                target: father
                color : background_color
            }
            PropertyChanges {
                target: txt
                color : font_color
            }
        }
    ]
    transitions: Transition {
        ParallelAnimation {
            ColorAnimation { property: "color"; duration: 150 ;}
        }
    }

    function getText(){
        return txt.text
    }
}
