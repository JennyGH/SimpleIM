import QtQuick 2.0

Rectangle{
    id:father
    property color background_color: mainform.color
    property color background_hover_color: "#eee"
    property color border_color: "#aaa"
    property color border_hover_color: "#aaa"
    property color font_color: mainform.font_color
    property int marginleft: 10

    state: "out" //默认状态

    width: parent.width
    signal dbclick()
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
            radius:0
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
            radius:_searchwindowbakg.radius
            anchors{
                verticalCenter: parent.verticalCenter
            }
        }

        MyButton{
            id:request  //申请好友
            height: 30
            width: 60
            title : "添加"
            enter_color: "#09bb07"
            enter_font_color: "#fff"
            border_color: "#e2e2e2"
            radius:_searchwindowbakg.radius
            anchors{
                verticalCenter: parent.verticalCenter
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
    ]
    transitions: Transition {
        ParallelAnimation {
            ColorAnimation { property: "color"; duration: 200 ;}
        }
    }

    function getText(){
        return txt.text
    }
}
