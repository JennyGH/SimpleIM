import QtQuick 2.0
import QtQuick.Dialogs 1.2
import "generic.js" as GEN
import "fontawesome.js" as FontAwesome

Item {
    id:father
    height: 40
    width: parent.width
    property int btnradius: 0
    property int btnHeight: 25
    property int btnWidth: 25

    signal selectFile(var filename,var url,var state);

    GradientBorder{pos : "top";color_middle : "#ccc"}
    GradientBorder{pos : "bottom";color_middle : "#ccc"}

    MouseArea{
        property point clickPos: "0,0"
        anchors.fill: parent
        onPressed: {
            clickPos = Qt.point(mouse.x,mouse.y);
        }
        onPositionChanged: {
            //鼠标偏移量
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y);
            father.y = father.y + delta.y;
            if(father.y < 160){
                father.y = 160;
            }else if(father.y > 500){
                father.y = 500;
            }
        }
    }

    Row{
        spacing: 5
        width: parent.width
        anchors.left: parent.left
        anchors.leftMargin: spacing
        anchors.verticalCenter: parent.verticalCenter
        GradientButton{
            id:btnemoji
            anchors.verticalCenter: parent.verticalCenter
            height: btnHeight
            width: contentwidth
            usingFA: true
            title :FontAwesome.icons.Smile
//            enter_color: "#157efb"
            enter_font_color: "#fff"
            radius:btnradius
            border_color: "#ccc"
            onClick: {
//                console.log("emoji");
            }
        }
        GradientButton{
            id:btnsendfile
            property QtObject fd: null
            anchors.verticalCenter: parent.verticalCenter
            height: btnHeight
            width: contentwidth
            usingFA: true
            title :FontAwesome.icons.File
//            enter_color: "#157efb"
            enter_font_color: "#fff"
            radius:btnradius
            border_color: "#ccc"
            onClick: {
                if (comp_file.status == Component.Ready)
                      fd = comp_file.createObject(chatwindow);
            }

            Component{
                id : comp_file
                FileDialog{
                    id : fileDialog
                    title: "Please choose a file"
                    folder: shortcuts.home
                    visible: true
                    objectName: "filedialog"
                    onAccepted: {
                        var str = fileUrl.toString().split("file:///")[1];
                        str = str.replace(new RegExp("/","gm"),"\\");
//                        console.log(str);
//                        file_name.text = str;
                        var filename = getFileName(str),
                            url = str,
                            state = "ready";
                        selectFile(filename,url,state);
                    }
                    onRejected: {
                    }
                    function getFileName(name){
                        var dotindex = name.lastIndexOf('\\');
                        return name.substring(dotindex + 1,name.length);
                    }
                }
            }
        }
        GradientButton{
            id:btnfont
            anchors.verticalCenter: parent.verticalCenter
            height: btnHeight
            width: contentwidth
            usingFA: true
            title :FontAwesome.icons.Font
//            enter_color: "#157efb"
            enter_font_color: "#fff"
            radius:btnradius
            border_color: "#ccc"
            onClick : {
            }
        }
        Sliper{
            id:sliper
            anchors.verticalCenter: parent.verticalCenter
            step : 1
            onChange: {
                inputarea.text().font.pixelSize = 12 + getProgress("int");
                GEN.toast("字体大小: " + inputarea.text().font.pixelSize,inputarea);
            }
        }
    }
}
