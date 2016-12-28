import QtQuick 2.0

Rectangle{
    id : father
    height: 30
    width: parent.width
    radius: parent.radius
    clip : true
    smooth : true
    gradient: Gradient{
        GradientStop{position: 0.0;color : "#eee"}
        GradientStop{position: 1.0;color : "#dcdcdd"}
    }

    Rectangle{
        anchors.top: parent.top
        width : parent.width
        height: parent.height - parent.radius
        z : 0
        gradient: Gradient{
            GradientStop{position: 0.0;color : "#eee"}
            GradientStop{position: 1.0;color : "transparent"}
        }
        clip : true
        smooth : true
        Border{pos : "top"}
    }
    anchors {
        horizontalCenter: parent.horizontalCenter
        bottom : parent.bottom
    }
}
