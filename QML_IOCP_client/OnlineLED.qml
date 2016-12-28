import QtQuick 2.0

Rectangle{
    id:father
    property bool online: false
    height: 11
    width:height
    radius:height
//    color : father.online ? "green" : "red"
    gradient: Gradient{
        GradientStop{position : 0.0;color : father.online ? "#c8fca7" : "red"}
        GradientStop{position : 1.0;color : father.online ? "#8cbd6d" : "red"}
    }

    border{
        color : "#97cd75"
        width : 1
    }
    smooth : true
    layer.enabled: father.online
    layer.effect: OuterShadow{
        target: father
        color: "#97cd75"
        spread: 0.18
        radius: 4
        samples: 8
    }
}
