import QtQuick 2.0

Rectangle{
    id:father
    property bool online: false
    height: 10
    width:10
    radius:10
    color : father.online ? "green" : "red"
}
