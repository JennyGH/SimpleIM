//var windowArray;
var existwindow;

function createWindow(src,parent){
//    console.log("create window");
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

function createSingleWindow(array,src,pare) {

    try{
        var component = Qt.createComponent("../" + src + ".qml");

        if (component.status === Component.Ready) {
            var _chatwindow = component.createObject(pare);

//            windowArray.push(_chatwindow);
//            mainform.chatwindows = windowArray; //传出到mainform以不被初始化
//            console.log(mainform.chatwindows);
            array.push(_chatwindow);
            console.log(array);

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

function releaseWindow(array,window){
    try{
        console.log("释放窗口：",array);
        removeWindowFromArray(array,window);
        window.destroy();
    }catch(ex){
        console.log(ex);
    }
}

function isExistWindow(array,userid){
    for(var i in array){
        if(array[i].userid === userid) return array[i];
    }
}

function removeWindowFromArray(array,window){

//    windowArray = mainform.chatwindows;

    for(var i in array){

        if(window === array[i]){

            array.splice(i,1);

        }
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
    if(client.sendmessage(msg,userid,2)){
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
    if(msg.trim() !== ""){
        return JSON.parse(msg);
    }
}
