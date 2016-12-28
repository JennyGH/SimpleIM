import QtQuick 2.4
import QtQuick.Window 2.2

Window {
    visible: true

    height: 400
    width: 400

    GradientButton{
        id : btn
        title : "按钮"
        height: 30
        width: 80
        anchors {
            top : parent.top
            topMargin: 20
            horizontalCenter: parent.horizontalCenter
        }
        signal shadowRadiusChanged(var radius);
        signal shadowSamplesChanged(var samples);
        signal shadowSpreadChanged(var spread);
        layer.enabled: true
        layer.effect: OuterShadow{
            id : shadow
            target : btn
            verticalOffset: 1
            radius: 1.0
            samples: 2
            spread: 0

            Connections{
                target: btn
                onShadowRadiusChanged:{
                    shadow.radius = radius;
                }
                onShadowSamplesChanged : {
                    shadow.samples = samples;
                }
                onShadowSpreadChanged : {
                    shadow.spread = spread;
                }
            }

        }
    }

//    MacCheckBox{
//        id : checkbox
//        height: 16
//        width: 16
//        anchors {
//            top : btn.bottom
//            topMargin: 5
//            horizontalCenter: parent.horizontalCenter
//        }
//    }

    Column {
        spacing: 10
        width: parent.width - 80
        anchors.centerIn: parent
        Row{
            spacing: 10
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
            width: parent.width
            MyText {
                id : lbl_radius
                text : "radius "
            }
            Sliper {
                id:sliper_radius
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - lbl_radius.width - lbl_showRaduis.width
                step : 1.6
                onChange: {
                    var n = getProgress();
                    btn.shadowRadiusChanged(n);
                    lbl_showRaduis.text = n;
                }
            }

            MyText {
                id : lbl_showRaduis
                text : "0.0"
            }
        }

        Row{
            spacing: 10
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
            width: parent.width
            MyText{
                id : lbl_sample
                text : "sample"
            }

            Sliper{
                id:sliper_sample
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - lbl_sample.width - lbl_showSamples.width
                step : 3.2
                onChange: {
                    var n = getProgress();
                    btn.shadowSamplesChanged(n);
                    lbl_showSamples.text = n;
                }
            }
            MyText{
                id : lbl_showSamples
                text : "0.0"
            }
        }

        Row{
            spacing: 10
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
            width: parent.width
            MyText{
                id : lbl_spread
                text : "spread "
            }

            Sliper{
                id:sliper_spread
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - lbl_spread.width - lbl_showSpread.width
                step : 0.1
                onChange: {
                    var n = getProgress();
                    btn.shadowSpreadChanged(n);
                    lbl_showSpread.text = n;
                }
            }
            MyText{
                id : lbl_showSpread
                text : "0.0"
            }
        }
    }


}
