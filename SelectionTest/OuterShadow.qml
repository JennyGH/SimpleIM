import QtQuick 2.0
import QtGraphicalEffects 1.0

DropShadow {
    property var target: null
    anchors.fill: target
    horizontalOffset: 0
    verticalOffset: 0
    radius: 10.0
    samples: 20
    color: "#80000000"
    fast: false
    source: target
    scale: target.scale
    opacity: target.opacity
    spread: 0.0
    smooth: true
    cached: false
}
