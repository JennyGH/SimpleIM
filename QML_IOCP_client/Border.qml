import QtQuick 2.0

Rectangle{
    id:father
    property string pos: ""
    width: (pos == "bottom" || pos == "top") ? parent.width : 1
    height: (pos == "left" || pos == "right") ? parent.height : 1
    color : "#aaa"
    anchors {
        left: pos == "left" ? parent.left : undefined
        right: pos == "right" ? parent.right :undefined
        top : pos == "top" ? parent.top : undefined
        bottom: pos == "bottom" ? parent.bottom : undefined
        horizontalCenter: (pos == "bottom" || pos == "top") ? parent.horizontalCenter : undefined
        verticalCenter: (pos == "left" || pos == "right") ? parent.verticalCenter : undefined
    }
}
