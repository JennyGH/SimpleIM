var windowArray;
var existwindow;

function init(){
    var component = Qt.createComponent("../VirtualWindow.qml");
    if (component.status === Component.Ready) {
        fatherWindow.virtualwindow = component.createObject(null);
    }
}

function createWindow(src,parent){
    try{
        var newwidnow;
        var component = Qt.createComponent("../" + src + ".qml");
        if (component.status === Component.Ready) {
            newwidnow = component.createObject(parent);
        }
    }catch(ex){
        console.log(ex);
    }
    return newwidnow;
}

function createChatWindow(id,name,address,online) {

    if((existwindow = isExistWindow(id))){

        existwindow.requestActivate();

        return existwindow;
    }

    try{
        var component = Qt.createComponent("../ChatWindow.qml");

        if (component.status === Component.Ready) {
            var _chatwindow = component.createObject(null);

            _chatwindow.userid = id;
            _chatwindow.name = name;
            _chatwindow.address= address;
            _chatwindow.online = online;

    //        _chatwindow.header.headsrc = id;
            _chatwindow.getHeader().clientname = name;
            _chatwindow.getHeader().online = online;

            windowArray.push(_chatwindow);

            mainform.chatwindows = windowArray; //传出到mainform以不被初始化

//            setWindowSize(_chatwindow,300,300);
            showWindow(_chatwindow);
        }
    }catch(ex){
        console.log("异常：",ex);
    }
    return _chatwindow;
}

function showWindow(window){

    window.visible = (window.visible === false);

}

function setWindowSize(window,height,width){
    window.height = height;
    window.width = width;
}

function releaseWindow(window){
    console.log("释放窗口：",window.title);
    removeWindowFromArray(window);
    window.destroy();
}

function isExistWindow(userid){
    for(var i in windowArray){
        if(windowArray[i].userid === userid) return windowArray[i];
    }
}

function removeWindowFromArray(window){

    windowArray = mainform.chatwindows;

    for(var i in windowArray){

        if(window === windowArray[i]){

            windowArray.splice(i,1);

        }
    }
}

function clearWindow(){
    windowArray = mainform.chatwindows;
    var count = windowArray.length;
    for(var i=0;i<count;i++){
        windowArray[0].close();
    }
}


//function closeChatWindow(window){
//    window.close();
//}

function send(userid,name,msg){
    if(msg.trim() === "" || msg === "\n") return;
    if(client.sendmessage(msg,userid,2)){
        chatmessagelistmodel.append({"name": name , "message": msg , "me" : true});
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
    if(msg.trim() !== ""){
        return JSON.parse(msg);
    }
}
