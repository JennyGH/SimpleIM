import QtQuick 2.0

Rectangle{
    property string pos: ""
    property color color_begin: "transparent"
    property color color_middle: "#aaa"
    property color color_end: "transparent"
    gradient: Gradient{
        GradientStop{position: 0.0;color:color_begin}
        GradientStop{position: 0.1;color:color_middle}
        GradientStop{position: 0.9;color:color_middle}
        GradientStop{position: 1.0;color:color_end}
    }
    rotation: (pos == "top" || pos == "bottom") ? 90 : 0
    width : 1
    height: (pos == "top" || pos == "bottom") ? parent.width : parent.height
    anchors{
        left: pos == "left" ? parent.left : undefined
        right: pos == "right" ? parent.right :undefined
        top : (pos == "top") ? parent.top : undefined
        topMargin: (pos == "top") ? -height/2 : undefined
        bottom : (pos == "bottom") ? parent.bottom : undefined
        bottomMargin: (pos == "bottom") ? -height / 2 : undefined
        horizontalCenter: (pos == "top" || pos == "bottom") ? parent.horizontalCenter : undefined
        verticalCenter: (pos == "left" || pos == "right") ? parent.verticalCenter : undefined
    }
}
