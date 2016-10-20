import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../js/generic.js" as GEN

Window {
    id:_settingwindow
    height: 200
    width: 300
    maximumHeight: height
    maximumWidth: width
    minimumHeight: height
    minimumWidth: width
    visible: false
    title : "设置"
//    flags:Qt.WindowModal | Qt.WindowMaximizeButtonHint
    flags: Qt.FramelessWindowHint
    color: Qt.rgba(0,0,0,0)

    property QtObject _tishi

    Rectangle{
        id:_settingwindowbakg

        height: parent.height - 30
        width : parent.width - 30
        anchors.centerIn: parent
        border.color: "#88888888"

        MainWindowHeader{
            id:_settingwindowHeader
            title : "设置"
            movetarget : _settingwindow
            marginRight: 1
            minable: false
            anchors {
                top : _settingwindowbakg.top
                topMargin: _settingwindowbakg.border.width
            }
        }

        Column{
            spacing: 10
            width: parent.width
            height: parent.height - _settingwindowHeader.height - 5
            anchors {
                top : _settingwindowHeader.bottom
                topMargin: 5
            }

            Row{
                spacing: 10
                anchors.horizontalCenter: parent.horizontalCenter
                MyText{
                    id:lblIP
                    text : "IP地址："
                    anchors {
                        verticalCenter: parent.verticalCenter
                    }
                }
                MyTextInput{
                    id:txtIp
                    width: _settingwindowbakg.width -lblIP.width - 50
                    validator: RegExpValidator {
                        regExp:/((?:(?:25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d)))\.){3}(?:25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d))))/
                    }
                }
            }
            Row{
                spacing: 10
                anchors.horizontalCenter: parent.horizontalCenter
                MyText{
                    id:lblPort
                    text : "端口号："
                    anchors {
                        verticalCenter: parent.verticalCenter
                    }
                }
                MyTextInput{
                    id:txtPort
                    width: _settingwindowbakg.width - lblPort.width - 50
                }
            }
            MyButton{
                id: ok
                height: 30
                width: _settingwindowbakg.width * 0.9
                title : "保存"
                anchors.horizontalCenter: parent.horizontalCenter
                border_color: "#ddd"
                enter_color: "#ddd"
                onClick: {
                    if(client.saveSetting(txtIp.text,txtPort.text)){
                        console.log("保存成功...");
                        _settingwindow.close();
                        GEN.showMessageBox(_tishi,"重启程序后生效...");
                    }else{
                        console.error("保存失败...");
                    }
                }
            }
        }

    }

    OuterShadow {
        target : _settingwindowbakg
    }

    onVisibleChanged: {
        if(!visible){
            try{_settingwindow.destroy();}
            catch(ex){console.exception(ex);}
        }
    }
    function setTxtIp(ip){
        txtIp.text = ip;
    }
    function setTxtPort(p){
        txtPort.text = p;
    }
}
