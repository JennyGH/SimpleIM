import QtQuick 2.0

Text{
    property int font_size: 13
    property color enter_color: "#444"
    property color exit_color: "#444"
    property bool fa: false
    font.family: fa ? fontawesome.name : "微软雅黑"
    font.pixelSize: font_size
    color: "#444"
    FontLoader{
        id:fontawesome
        source :"qrc:/fa/fontawesome-webfont.ttf"
    }
}
