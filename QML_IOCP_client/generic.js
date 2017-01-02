//var windowArray;
var existwindow;

function createWindow(src,parent){
//    console.log("create window");
    try{
        var newwidnow;
        var component = Qt.createComponent(src + ".qml");
        if (component.status === Component.Ready) {
            newwidnow = component.createObject(parent);
        }
    }catch(ex){
        console.log("createWindow异常：",ex);
    }
    return newwidnow;
}

function createSingleWindow(array,src,pare) {

    try{
        var component = Qt.createComponent("../" + src + ".qml");

        if (component.status === Component.Ready) {
            var _chatwindow = component.createObject(pare);
            array.push(_chatwindow);
            console.log(array);
            showWindow(_chatwindow);
        }
    }catch(ex){
        console.log("createSingleWindow异常：",ex);
    }
    return _chatwindow;
}
function createSingleComponent(src) {

    try{
        var component = Qt.createComponent(src + ".qml");
    }catch(ex){
        console.log("createSingleComponent异常：",ex);
    }
    return component;
}

function toast(str,pare){
    var _toast;
    if(fatherWindow.m_toast == null){
        var component = Qt.createComponent("Toast.qml");
        if(component.status === Component.Ready){
            _toast = component.createObject(pare ? pare : fatherWindow);
            fatherWindow.m_toast = _toast;
        }
    }else{
        _toast = fatherWindow.m_toast;
    }
    _toast.text = str;
    _toast.start();
    return _toast;
}

function showWindow(window){

    window.visible = true;

}

function setWindowSize(window,height,width){
    window.height = height;
    window.width = width;
}

function releaseWindow(array,window){
    try{
//        console.log("释放窗口：",array);
        removeWindowFromArray(array,window,null);
        window.destroy();
    }catch(ex){
        console.log(ex);
    }
}

function isExistWindow(array,userid,tabbar){
    for(var i in array){
        if(array[i].userid === userid){
            if(tabbar == null){
                return array[i];
            }else{
                return i;
            }
        }
    }
}

function removeWindowFromArray(array,window,tabindex){

//    windowArray = mainform.chatwindows;
    if(tabindex == null){
        for(var i in array){

            if(window === array[i]){

                array.splice(i,1);

            }
        }
    }else{
        array.splice(tabindex,1);
    }
}

function clearWindow(array){
//    windowArray = mainform.chatwindows;
    var count = array ? array.length : 0;
    for(var i=0;i<count;i++){
        array[0].close();
    }
}


//function closeChatWindow(window){
//    window.close();
//}

function send(userid,name,msg){
    var orginmsg = msg;
    if(msg.trim() === "" || msg === "\n") return;
    msg = msg.replace(/\\/gi, "&s;");
    msg = msg.replace(/(\n)+|(\r\n)+/g, "&r;");
    msg = msg.replace(/\"/gi,"&q;");
    if(client.sendmessage(msg,userid,chatMessage)){
        chatmessagelistmodel.append({"name": name , "message": orginmsg , "me" : true});
    }
}

function showMessageBox(t,msg){
    t.tips = msg;
    t.state = "show";
}

function root(e){
    if(e.parent === null){
        return e;
    }else{
        root(e.parent);
    }
}
function limitNumber(txt){
    var ss = txt.text;
    var last = txt.getText(ss.length - 1,ss.length);
    if(isNaN(last)){
        txt.text = txt.text.substring(0,ss.length - 1);
        return false;
    }else{
        return true;
    }
}

function formatMessage(msg){
    console.log(msg);
    if(msg.trim() !== ""){
        return JSON.parse(msg);
    }
}

function alert(obj){
    var _alert = createWindow("Alert",obj.parent);
    _alert.alertHeight = obj.height;
    _alert.alertWidth = obj.width;
    _alert.content = obj.text;
    _alert.ok.connect(obj.onOk || function(){});
    _alert.cancel.connect(obj.onCancel || function(){});
    _alert.close.connect(obj.onClose || function(){});
    _alert.isConfirm = obj.confirm || false;
    _alert.success = obj.success || false;
    _alert.show();
    return _alert;
}
