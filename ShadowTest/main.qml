import QtQuick 2.4
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0

Window {
    id : mainwindow
    visible: true

    height: 400
    width: 400

    color: "#f5f5f5"

    signal shadowRadiusChanged(var radius);
    signal shadowSamplesChanged(var samples);
    signal shadowSpreadChanged(var spread);
    signal shadowAlphaChanged(var alpha);
    signal shadowVerticaloffsetChanged(var v);
    signal shadowHorizontaloffsetChanged(var h);

    Column{
        id : sample
        spacing: 10

        anchors {
            top : parent.top
            topMargin: 20
        }
        width: parent.width

        GradientButton{
            id : btn
            title : "按钮"
            height: 30
            width: 80
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
            layer.enabled: true
            layer.effect: OuterShadow{
                id : shadow
                target : btn
                verticalOffset: 1
                radius: 1.0
                samples: 2
                spread: 0
                color: Qt.rgba(0,0,0,0)
                Connections{
                    target: mainwindow
                    onShadowRadiusChanged:{
                        shadow.radius = radius;
                    }
                    onShadowSamplesChanged : {
                        shadow.samples = samples;
                    }
                    onShadowSpreadChanged : {
                        shadow.spread = spread;
                    }
                    onShadowAlphaChanged : {
                        shadow.color = Qt.rgba(0,0,0,alpha);
                    }
                    onShadowVerticaloffsetChanged : {
                        shadow.verticalOffset = v;
                    }
                    onShadowHorizontaloffsetChanged : {
                        shadow.horizontalOffset = h;
                    }
                }
                Connections{
                    target: vertical_negative
                    onCheckedChanged : {
                        shadow.verticalOffset *= -1;
                    }
                }
                Connections{
                    target: horizontal_negative
                    onCheckedChanged : {
                        shadow.horizontalOffset *= -1;
                    }
                }
            }
        }

        Rectangle{
            id : rec_sample
            height: 100
            width: parent.width - 20
            radius: 5
            border {
                color : "#ccc"
                width: 1
            }
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
            smooth: true
            color: "#fff"
            layer.enabled: true
            layer.effect:InnerShadow {
                id : innershadow
                anchors.fill: rec_sample
                horizontalOffset: 0
                verticalOffset: 0
                radius: 0.0
                samples: 0
                color: Qt.rgba(0,0,0,0)
                fast: false
                source: rec_sample
                spread: 0.0
                smooth: true
                cached: false
                Connections{
                    target: mainwindow
                    onShadowRadiusChanged:{
                        innershadow.radius = radius;
                    }
                    onShadowSamplesChanged : {
                        innershadow.samples = samples;
                    }
                    onShadowSpreadChanged : {
                        innershadow.spread = spread;
                    }
                    onShadowAlphaChanged : {
                        innershadow.color = Qt.rgba(0,0,0,alpha);
                    }
                    onShadowVerticaloffsetChanged : {
                        innershadow.verticalOffset = v;
                    }
                    onShadowHorizontaloffsetChanged : {
                        innershadow.horizontalOffset = h;
                    }
                }
                Connections{
                    target: vertical_negative
                    onCheckedChanged : {
                        innershadow.verticalOffset *= -1;
                    }
                }
                Connections{
                    target: horizontal_negative
                    onCheckedChanged : {
                        innershadow.horizontalOffset *= -1;
                    }
                }
            }
        }
    }


    Column {
        id :effect
        spacing: 10
        width: parent.width - 80
        anchors {
            horizontalCenter: parent.horizontalCenter
            top : sample.bottom
            topMargin: 10
        }

        Row{
            spacing: 10
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
            width: parent.width
            MyText{
                id : lbl_verticaloffset
                text : "垂直偏移"
            }

            Sliper{
                id:sliper_verticaloffset
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - lbl_verticaloffset.width - lbl_showVerticaloffset.width - vertical_negative.width
                step : 1
                onChange: {
                    var n = getProgress();
                    shadowVerticaloffsetChanged(vertical_negative.checked ? -n : n);
                    lbl_showVerticaloffset.text = n;
                }
            }
            MyText{
                id : lbl_showVerticaloffset
                text : "0.0"
            }
            MacCheckBox{
                id : vertical_negative
                height: 16
                width: 16
            }
        }

        Row{
            spacing: 10
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
            width: parent.width
            MyText{
                id : lbl_horizontaloffset
                text : "水平偏移"
            }

            Sliper{
                id:sliper_horizontaloffset
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - lbl_horizontaloffset.width - lbl_showHorizontaloffset.width - horizontal_negative.width
                step : 1
                onChange: {
                    var n = getProgress();
                    shadowHorizontaloffsetChanged(horizontal_negative.checked ? -n : n);
                    lbl_showHorizontaloffset.text = n;
                }
            }
            MyText{
                id : lbl_showHorizontaloffset
                text : "0.0"
            }
            MacCheckBox{
                id : horizontal_negative
                height: 16
                width: 16
            }
        }

        Row{
            spacing: 10
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
            width: parent.width
            MyText{
                id : lbl_alpha
                text : "透明度"
            }

            Sliper{
                id:sliper_alpha
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - lbl_alpha.width - lbl_showAlpha.width
                step : 0.1
                onChange: {
                    var n = getProgress();
                    shadowAlphaChanged(n);
                    lbl_showAlpha.text = n;
                }
            }
            MyText{
                id : lbl_showAlpha
                text : "0.0"
            }
        }

        Row{
            spacing: 10
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
            width: parent.width
            MyText {
                id : lbl_radius
                text : "半径"
            }
            Sliper {
                id:sliper_radius
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - lbl_radius.width - lbl_showRaduis.width
                step : 1.6
                onChange: {
                    var n = getProgress();
                    shadowRadiusChanged(n);
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
                text : "采样值"
            }

            Sliper{
                id:sliper_sample
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - lbl_sample.width - lbl_showSamples.width
                step : 3.2
                onChange: {
                    var n = getProgress();
                    shadowSamplesChanged(n);
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
                text : "扩散"
            }

            Sliper{
                id:sliper_spread
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - lbl_spread.width - lbl_showSpread.width
                step : 0.1
                onChange: {
                    var n = getProgress();
                    shadowSpreadChanged(n);
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
