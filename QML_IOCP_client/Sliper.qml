import QtQuick 2.0

Rectangle{
    id:father
    height: 5
    radius: height
    width: 100
    color: "#a7a7a8"
    smooth: true
    signal change();
    property double step: 0.0
    property double maxValue: 100.0
    property double minValue: 0.0
    property double currentValue: 0.0
    property bool colorful: true
    onWidthChanged: {
        dot.x = (father.width - dot.width - dot.minx) * currentValue;
    }
    MouseArea{
        anchors {
            centerIn: parent
        }
        height: dot.height
        width: parent.width
        onPressed: {
            dot.move(mouseX);
        }
        onEntered: {
            wheel.accepted=true;
        }
        onExited: {
            wheel.accepted=false;
        }
        onWheel: {
            if (wheel.angleDelta.y > 0)
            {
                dot.move(getDotX() + father.width*0.01);
            }
            else
            {
                dot.move(getDotX() - father.width*0.01);
            }

//             按住Ctrl
//            if (wheel.modifiers & Qt.ControlModifier){

//            }
//            else{
//                wheel.accepted=false
//            }
        }
    }

    Rectangle{
        id : gone
        radius: parent.radius
        height: parent.height
        color : "#1b83fb"
        visible: father.colorful
        anchors {
            left: parent.left
            right: dot.left
            rightMargin: -dot.width/2
        }
    }

    Rectangle{
        id:dot
        height: parent.height + 10
        width: height
        radius: width
        property double minx: 0
        x : minx
        border{
            color : "#aaa"
            width: 1
        }
        anchors{
            verticalCenter: parent.verticalCenter
        }

        MouseArea{
            id : dotSense
            anchors.fill: parent
            property point clickPos: "0,0"
            onPressed: {
                clickPos = Qt.point(mouse.x,mouse.y);
            }
            onPositionChanged: {
                //鼠标偏移量
                var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y);
                dot.move(dot.x+delta.x);
            }
        }
        function move(e){
            dot.x = e;
            if(dot.x < dot.minx){
                dot.x = dot.minx;
            }
            if(dot.x > father.width - dot.width - dot.minx){
                dot.x = father.width - dot.width - dot.minx;
            }
            change();
        }
    }
    function getDotX(){
        return dot.x;
    }
    function getProgress(type){
        var percent = (dot.x / (father.width - dot.width - dot.minx));
        var temp;
        if(type == "int"){
            temp = Math.ceil(percent * step * 10);
        }else{
            temp = parseFloat(percent * step * 10).toFixed(1);
        }
        currentValue = percent;
        return temp;
    }
}
