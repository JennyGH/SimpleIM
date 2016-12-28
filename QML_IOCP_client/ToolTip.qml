import QtQuick 2.0

Item{
    id : father
    height: tooltip.height + narrow.height
    width : tooltip.width
    opacity : 0
    property string text: ""

    property double colorOpacity: 0.5
    property double leftWidth: width - narrow.anchors.rightMargin
    z: 999
    Behavior on opacity{
        NumberAnimation {
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }
    Rectangle{
        id : tooltip
        color : Qt.rgba(0,0,0,colorOpacity)
        radius: 5
        width: lbl_tooltip.contentWidth + 30
        height: lbl_tooltip.contentHeight + 10
        layer.enabled: true
        layer.effect: OuterShadow{
            target:tooltip
            color : "#000"
            radius: 16
            samples : 32
        }
        smooth : true
        MyText{
            id : lbl_tooltip
            color : "#fff"
            anchors.centerIn: parent
            text : father.text
        }
    }
    Image{
        id : narrow
        source : "qrc:/src/src/naroow.png"
        height: 5
        width: 10
        anchors {
            top : tooltip.bottom
            right: tooltip.right
            rightMargin: marginRight()
        }
        smooth: true
        opacity: colorOpacity
    }

    function marginRight(){
        if(father.width > files.width){
            return files.width - 20;
        }
        if(father.width < files.width){
            return father.width / 2;
        }
    }

    function show(y,text){
//        father.parent = pare;
        father.y = y;
        father.text = text;
        father.opacity = 1;
    }
    function hide(pare){
//        parent = pare;
//        text = "";
        opacity = 0;
    }
}
