import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "generic.js" as GEN

Window {
    id:_settingwindow
    height: 250
    width: 330
    maximumHeight: height
    maximumWidth: width
    minimumHeight: height
    minimumWidth: width
    visible: true
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
        border.color: "#fff"
        color : "#f5f5f5"
        radius:5

        MainWindowHeader{
            id:_settingwindowHeader
            title : "设置"
            movetarget : _settingwindow
            marginRight: 10
            minable: false
            isVerticalCenter: true
        }

        Item{
            anchors {
                top : _settingwindowHeader.bottom
                bottom: _settingwindowFooter.top
            }
            width: parent.width
            Column{
                id : col
                spacing: 10
                width: parent.width - 20 - (parent.height - col.height)/2
                anchors {
                    centerIn: parent
                }

                Row{
                    spacing: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    Span{
                        id:lblIP
                        text : "IP地址"
                        height: txtIp.height
                        anchors {
                            verticalCenter: parent.verticalCenter
                        }
                    }
    //                MyTextInput{
    //                    id:txtIp
    //                    width: _settingwindowbakg.width -lblIP.width - 50
    //                    validator: RegExpValidator {
    //                        regExp:/((?:(?:25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d)))\.){3}(?:25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d))))/
    //                    }
    //                }
                    //119.29.178.76
                    ComboBox {
                        id:txtIp
                        height: 30
                        property string text: txtIp.currentText
                        model: [ "119.29.178.76", "127.0.0.1" ]
                        width: parent.width -lblIP.width
                        activeFocusOnPress : true
                        onCurrentIndexChanged: {
                            text = currentText;
                        }
                    }
                }
                Row{
                    spacing: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    Span{
                        id:lblPort
                        text : "端口号"
                        height: txtPort.height
                        anchors {
                            verticalCenter: parent.verticalCenter
                        }
                    }
                    MyTextInput{
                        id:txtPort
                        width: parent.width - lblPort.width
                        radius: 0
                        height: 30
                    }
                }
                GradientButton{
                    id: ok
                    height: 30
                    width: col.width
                    title : "保存"
                    anchors.horizontalCenter: parent.horizontalCenter
                    border_color : "#ccc"
    //                enter_color: "#157efb"
                    enter_font_color: "#fff"
    //                enter_border_color: "#fff"//Qt.darker("#157efb",1.5)
                    radius : _settingwindowHeader.radius
                    onClick: {
                        var json = JSON.stringify
                                ({
                                     ip : txtIp.text,
                                     port : txtPort.text
                                 });
                        if(client.saveSetting(json)){
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

        MainWindowFooter{
            id : _settingwindowFooter
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
//        txtIp.text = ip;
        var model = txtIp.model;
        for(var item in model){
            if(model[item] == ip){
                txtIp.currentIndex = item;
            }
        }
    }
    function setTxtPort(p){
        txtPort.text = p;
    }
}
