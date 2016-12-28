import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "generic.js" as GEN
import "fontawesome.js" as FA

Item{
    id : father
    GradientBorder{pos : "bottom" ;color_middle: "#eee"}
    anchors.horizontalCenter: parent.horizontalCenter
    Row{
        id : row
        spacing: 5
        anchors {
            left : parent.left
            leftMargin: 5
            top : parent.top
            topMargin: 5
        }
        width : parent.width - btn_send_file.width - 20
        Image{
            id : file_ico
            source : "qrc:/src/src/File.ico"
            height: 32
            width: 32
            sourceSize: Qt.size(height,width)
            smooth : true
            anchors.verticalCenter: parent.verticalCenter

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
//                    file_name.opacity = 1;
                    tooltip.show(index*father.height - 10 ,fileurl);
                }
                onExited: {
//                    file_name.opacity = 0;
                    tooltip.hide(files);
                }
            }
        }

        MyText{
            id : file_name
            anchors.verticalCenter: parent.verticalCenter
            text : filename
            font_size : 13
            width: parent.width - file_ico.width - 10
            wrapMode: Text.WordWrap
            elide : Text.ElideRight
        }
    }

    GradientButton{
        id : btn_send_file
        height: 20
        width: contentwidth + 10
        font_size : 12
        property int complete: 0
        anchors {
            right : parent.right
            rightMargin: 5
            verticalCenter: parent.verticalCenter
        }
        onClick: {
            switch(pro_sendFile.state){
            case "ready" :
            {
                pro_sendFile.value = 100;
                //进入等待状态
                pro_sendFile.state = "wait"
                break;
            }
            case "finish" :
            {
                //发送完成
                filemodel.remove(index,1);
                pro_sendFile.value = 0;
                pro_sendFile.state = "ready";
                break;
            }
            }
        }
    }
    ProgressBar{
        id : pro_sendFile
        width: parent.width - 10
        height: 6
        value : 0
        state : "ready"
        Behavior on value{
            NumberAnimation{
                duration : 500
            }
        }
        maximumValue : 100
        minimumValue : 0
        anchors{
            top : row.bottom
            topMargin: 5
            horizontalCenter: parent.horizontalCenter
        }

        style : ProgressBarStyle{
            background: Rectangle {
                anchors.fill: parent
                radius: height
                border{
                    color : "#c5c5c5"
                    width : 1
                }
                color : "#dcdcdc"
            }
            progress: Rectangle {
                height: parent.height
                radius: height
                border{
                    color : "#0b69e5"
                    width : 1
                }
                color : "#0d75ff"
                onWidthChanged: {
                    if(pro_sendFile.value == pro_sendFile.maximumValue){
                        btn_send_file.enabled = true;
                        btn_send_file.usingFA = true;
                        btn_send_file.title = FA.icons.Ok;
                        pro_sendFile.state = "finish";
                    }
                }
            }
        }
        states: [
            State {
                name: "ready"
                PropertyChanges {
                    target: btn_send_file
                    title : "开始发送"
                    enabled : true
                    usingFA : false
                }
            },

            State {
                name: "wait"
                PropertyChanges {
                    target: btn_send_file
                    title : "传输中..."
                    enabled : false
                    usingFA : false
                }
            },

            State {
                name: "finish"
                PropertyChanges {
                    target: btn_send_file
                    title : FA.icons.Ok
                    enabled : true
                    usingFA : true
                }
            }
        ]
    }
}
