import QtQuick 2.0
import "fontawesome.js" as FA

Rectangle{
    id:father
    property string text: ""
    property bool usingFA: false
    radius: 5
    border {
        color : "#aaa"
        width: 1
    }
    gradient: Gradient{
        GradientStop{position: 0.0;color : "#eee"}
        GradientStop{position: 1.0;color : "#dcdcdd"}
    }
    smooth: true
    clip : true
    width: usingFA ? 35 : lbl.contentWidth + 10
    MyText{
        id : lbl
        text : father.text
        fa : usingFA
        anchors.centerIn: parent
        style: Text.Raised
        styleColor: "#fff"
    }
    Rectangle{
        height: parent.height
        smooth : true
        width: parent.radius
        color : parent.color
        gradient: parent.gradient
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        Border{pos : "top"}
        Border{pos : "bottom"}
    }
}
