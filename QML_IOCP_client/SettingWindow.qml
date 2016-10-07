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
    flags:Qt.WindowModal | Qt.WindowMaximizeButtonHint

    property QtObject _tishi

    MainWindowHeader{
        id:_settingwindowHeader
        title : "设置"
        movetarget : _settingwindow
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
            TextField{
                id:txtIp
                height: 30
                width: _settingwindow.width -lblIP.width - 50
                font.family:"微软雅黑"
                font.pixelSize: 15
                anchors {
                    verticalCenter: parent.verticalCenter
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
            TextField{
                id:txtPort
                height: 30
                width: _settingwindow.width - lblPort.width - 50
                font.family:"微软雅黑"
                font.pixelSize: 15
                anchors {
                    verticalCenter: parent.verticalCenter
                }
            }
        }
        MyButton{
            id: ok
            height: 30
            width: 100
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
