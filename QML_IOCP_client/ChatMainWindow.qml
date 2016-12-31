import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import "generic.js" as GEN
import "fontawesome.js" as FA
//import Client 1.0

Window {
    id:fatherWindow
    visible: true
    height: 730//mainform.height + 30//630
    width:_side.width + _chatarea.width + 30//mainform.width + 30//330
    property bool conn: false
    property string myName : "null"
    property var friendListArray: new Array
    property bool canhide: false
    property bool ishide: false
    property SearchFriend searchwindow: null
    property SettingWindow newsettingwindow: null
    property Window loginwindow: null
    property Toast m_toast: null
    property bool ismax: false
    flags: Qt.FramelessWindowHint | Qt.Window
    color: Qt.rgba(0,0,0,0)


    NumberAnimation {
        id : showAnimation
        target: fatherWindow
        property: "opacity"
        to : 1
        duration: 200
        easing.type: Easing.InOutQuad
    }


    NumberAnimation {
        id : changeSizeAnimation
        target: fatherWindow
        property: "opacity"
        to : 0
        duration: 200
        easing.type: Easing.InOutQuad
        onStopped: {
            if(!ismax){
                ismax = true;
                showMaximized();
                mainform.height = mainform.parent.height;
                mainform.width = mainform.parent.width;
            }else{
                showNormal();
                mainform.height = mainform.parent.height - 30;
                mainform.width = mainform.parent.width - 30;
                ismax = false;
            }
            showAnimation.start();
        }
    }

    onVisibleChanged: {
        if(!fatherWindow.visible){
            GEN.clearWindow(mainform.detailswindows);
        }else{
            fadeout.start();
            client.sendmessage("","",updateMessage);    //消息4：更新好友列表
        }
    }

    Component.onCompleted: {}

    onCanhideChanged: {
        senseArea.canhide = fatherWindow.canhide
    }
    onIshideChanged: {
        senseArea.ishide = fatherWindow.ishide
    }

    Connections{
        target: client
        onRecvmessage: {
            var returnmsg = client.getMessage();
            var obj = GEN.formatMessage(returnmsg);
//            console.log(returnmsg);
            var result;
            switch(parseInt(obj.type)){
            case 2:
                var currentwindow = GEN.isExistWindow(mainform.chatwindows,obj.friend);
                var currendtWindowIndex = GEN.isExistWindow(mainform.chatwindows,obj.friend,_tabbar);
                if(currentwindow){
                    //已经打开对话窗口
                    if(currendtWindowIndex != _tabbar.currentIndex){
                        //焦点不在此窗口
//                        console.log(_tabbar.getTab(currendtWindowIndex).style);
//                        _tabbar.requestFocus(currendtWindowIndex);
                        _tabbar.tabs[currendtWindowIndex].shining = true;
                    }
                    currentwindow.recv(currentwindow.name,obj.message);
                }else{
                    //未打开对话窗口
                    //好友列表显示消息气泡
                    console.log("你有未读留言...");
                    for(var i = 0;i<friendmodel.count;i++){
                        if(friendmodel.get(i).ID === obj.friend){
                            friendList.itemAt(0,mainform.itemHeight*(i)).shine();
                            break;
                        }
                    }
                    //内存中暂存留言
                    client.keepMessage(obj.friend,obj.message);
                }
                break;
            case 4:
                //返回好友列表信息
                refresh(obj);
                client.sendmessage("","",leavingmessageMessage);    //更新完好友列表后开始获取留言信息
                myName = obj.myName;
                break;
            case 5:
                if(obj.message !== 0){
                    if(obj.message.SqlMsgType === 0){
                        client.sendmessage("","",updateMessage);
                    }else{
                        console.log("添加好友发生错误：",obj.message.Result);
                    }
                }else{
                    console.log("好友已存在...");
                }
                break;
            case 9:

                //接收留言信息
                 console.log("接收到的留言：");
                var res = obj.message.Result;
                for(var item in res){
                    if(parseInt(res[item][2])){
                        //是好友
                        for(var i = 0;i<friendmodel.count;i++){
                            if(friendmodel.get(i).ID === res[item][1]){
                                friendList.itemAt(0,mainform.itemHeight*(i)).shine();
                                break;
                            }
                        }
                        //内存中暂存留言
                        client.keepMessage(res[item][1],res[item][0]);
                    }else{
                        console.log(res[item][1] + " 请求添加你为好友");
                    }
                }

                break;

            default:
                break;
            }
        }
        onLoseConnect:{
//            var newloginwindow = GEN.createWindow("main",null);
            fatherWindow.visible = false;
            loginwindow.isConnect = false;
            loginwindow.visible = true;
            loginwindow.showTips("与服务器断开连接，请重新登陆...");
//            fatherWindow.destroy();
//            newloginwindow.showTips("与服务器断开连接，请重新登陆...");
        }
    }

    MainForm {
        id:mainform
        property color font_color: "#444"
        property var chatwindows : new Array
        property var detailswindows: new Array
        property int itemHeight: 40
        property Alert alert: null
        height: parent.height - 30
        width:parent.width - 30
        anchors {
            centerIn: parent
        }
//        border.color: "#fff"
        color : "#f0f0f0"
        radius: 5
        opacity: 0
        smooth: true

//        Alert{
//            id : alert;
//        }

        MainWindowHeader {
            id:header
            title : "JennyChat"
            marginRight:10//mainform.border.width
            marginTop: marginRight
            maxable : false
            onCloseClick:{
                if(searchwindow){
                    searchwindow.close();
                }
            }
            height: 40
            isVerticalCenter: true
            onMove:{}
        }

        MessageBox{
            id:tishi
            state : "hide"
            width: mainform.width - mainform.border.width*2
            anchors{
                horizontalCenter: mainform.horizontalCenter
            }
        }

        Column{
            id:_side
            spacing : 0
            width: 250
            anchors{
                top:tishi.bottom
                left: parent.left
                bottom: footer.top
            }
            Me{
                id:me
                conn : fatherWindow.conn
                myName : fatherWindow.myName
                width: parent.width
                color : mainform.color
//                anchors{
//                    top:tishi.bottom
//                    horizontalCenter: parent.horizontalCenter
//                }
            }

            Rectangle{
                id:mainformbody
                height: mainform.height - me.height - header.height - tishi.height - mainformfooter.height - mainform.border.width*2 - footer.height
                width : parent.width //- mainform.border.width * 2 - 10
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }

                color : "#fff"

//                border.color: "#ccc"

                smooth: true

//                radius:3
                ScrollView {
                    id:mainformbodyscroll
                    height: parent.height - parent.radius*2
                    width: parent.width - parent.radius*2
                    horizontalScrollBarPolicy:Qt.ScrollBarAlwaysOff
                    verticalScrollBarPolicy:Qt.ScrollBarAsNeeded
                    style: ScrollViewStyle{transientScrollBars:true}
                    anchors.centerIn: parent
    //                visible: false
                    ListView{
                        id:friendList
                        anchors {
                            fill : parent
                        }
                        highlightFollowsCurrentItem : true

                        model: FriendModel{
                            id:friendmodel
                            onCountChanged: {
                            }
                        }
                        delegate: Friend{
                            id:friend
                            normal_color : mainformbody.color
                            enter_font_color : "#fff"
                            enter_color: "#1b83fb"
//                            radius : mainform.radius
                            onDbclick: {
                                var existwindow;
                                if((existwindow = GEN.isExistWindow(mainform.chatwindows,ID,_tabbar))){

                                    _tabbar.currentIndex = existwindow;  //如果存在窗口，该窗口获得焦点

                                    return existwindow;
                                }else{
                                    var newchatwindow = GEN.createSingleComponent("ChatWindow");
                                    _tabbar.addTab(name,newchatwindow);
                                    _tabbar.currentIndex = _tabbar.count - 1;
                                    var object = _tabbar.getTab(_tabbar.currentIndex).item;
//                                    object.handle = newchatwindow;
                                    object.userid = ID;
                                    object.name = name;
                                    object.address= address;
                                    object.online = onLine;
                                    object.tabIndex = index;
                                    object.getHeader().clientname = name;
                                    object.getHeader().online = onLine;
                                    mainform.chatwindows.push(object);
                                    if(_tabbar.count > 0 && _chatarea.width == 0){
                                        _chatarea.width = 1000;
//                                        header.maxable = true;
                                    }
                                }

                                if(friend.msgcount){
                                    var jsonstr = client.alreadyRead(ID);
                                    if(jsonstr.trim() !== ""){
                                        var json = JSON.parse(jsonstr);
                                        newchatwindow = _tabbar.getTab(_tabbar.currentIndex).item;
                                        for(var i = 0;i<json.message.length;i++){
                                            newchatwindow.recv(newchatwindow.name,json.message[i]);
                                        }
                                        client.sendmessage(1,ID,deletemessageMessage); //清除已读好友留言消息
                                        friend.msgcount = 0;
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Rectangle{
                id:mainformfooter
                height: 20
                width: parent.width
                color : Qt.rgba(0,0,0,0)
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }

                Row{

                    spacing: 0

                    anchors {
                        fill: parent
                    }
                    property int radius: 0
                    property int btnHeight: 25
                    property int btnWidth: width/btnCount
                    property int btnFontsize: Math.min(btnWidth,btnHeight) - 10
                    property int btnCount: 3

                    MyButton{
                        id:setting
                        usingFA: true
                        title : FA.icons.Gear
                        height: parent.btnHeight
                        width: parent.btnWidth
                        enter_color: "#bbb"
                        radius:parent.radius
                        font_size: parent.btnFontsize
                        anchors {
                            verticalCenter: parent.verticalCenter
                        }
                        onClick: {
                            if(!newsettingwindow){
                                newsettingwindow = GEN.createWindow("SettingWindow",mainform);
                                if(newsettingwindow){
                                    newsettingwindow.setTxtIp(client.ip);
                                    newsettingwindow.setTxtPort(client.port);
                                    newsettingwindow._tishi = tishi;
                                    GEN.showWindow(newsettingwindow);
                                }else{
                                    console.error("SettingWindow 未创建...");
                                }
                            }
                        }
                    }

                    MyButton{
                        id:add
                        title:FA.icons.Search
                        usingFA: true
                        height: parent.btnHeight
                        width: parent.btnWidth
                        enter_color: "#bbb"
                        radius:parent.radius
                        font_size: parent.btnFontsize
                        anchors {
                            verticalCenter: parent.verticalCenter
                        }
                        Border{
                            pos : "left"
                            color: "#ccc"
                        }
                        Border{
                            pos : "right"
                            color: "#ccc"
                        }

                        onClick: {

                            if(!searchwindow){
                                searchwindow = GEN.createWindow("SearchFriend",null);
                                if(searchwindow){
                                    GEN.showWindow(searchwindow);
                                }
                            }else{
                                searchwindow.raise()
                            }
                        }
                    }

                    MyButton{
                        id:btn_addreq
                        title:FA.icons.OkCircle
                        height: parent.btnHeight
                        width: parent.btnWidth
                        enter_color: "#bbb"
                        radius:parent.radius
                        font_size: parent.btnFontsize
                        usingFA: true
                        anchors {
                            verticalCenter: parent.verticalCenter
                        }
                        onClick: {

                            if(!searchwindow){
                                searchwindow = GEN.createWindow("SearchFriend",null);
                                if(searchwindow){
                                    GEN.showWindow(searchwindow);
                                }
                            }else{
                                searchwindow.raise()
                            }
                        }
                    }
                }
            }

        }

        Rectangle{
            id:_chatarea
            width:0
//            height:parent.height - header.height - tishi.height
            opacity: width > 0 ? 1 : 0
            anchors{
                left:_side.right
                top : _side.top
                bottom : footer.top
            }

            Border{pos : "left"; color : "#ccc"}

            radius: mainform.radius
            color : mainform.color
            TabView{
                id:_tabbar
                property color tab_border_color: "#ADADAD"
                property var tabs: new Array
                signal requestFocus(var currentWindowIndex);
                anchors{
                    centerIn: parent
                }
                height : parent.height
                width : parent.width
                style: TabViewStyle {
                          frameOverlap: 1
                          tab: Rectangle {
                              id : tabstyle
                              property bool shining: false
                              color: shining ? (styleData.selected ? "#dcdcdd" : "#70caf4"):(styleData.selected ? "#dcdcdd" : "#c0bfc0")
                              smooth: true
                              border.color:  _tabbar.tab_border_color
                              implicitWidth: width
                              implicitHeight: height
                              height: 25
                              width : ((_chatarea.width) / _tabbar.count) + 1//text.width + close.width + 30
                              clip : true
                              layer.enabled: !styleData.selected
                              layer.effect: InnerShadow{
                                  anchors.fill: tabstyle
                                  radius: 6.0
                                  samples: 6
                                  horizontalOffset: 0
                                  verticalOffset: 2
                                  color: Qt.rgba(0,0,0,0.1)
                                  source: tabstyle
                              }

                              onColorChanged: {
                                  if(color == "#dcdcdd"){
                                      shining = false;
                                  }
                              }

                              Component.onCompleted: {
                                  _tabbar.tabs.push(this);
                              }
                              Component.onDestruction: {
                              }
                              Behavior on color{
                                  ColorAnimation{
                                      duration: 200
                                  }
                              }

                              Border{
                                  pos : "top"
                                  color : parent.color
                                  width: parent.width - parent.border.width*2
                              }

                              MyText {
                                  id: text
                                  text: styleData.title
                                  color: styleData.selected ? "#2A2A2A" : "#6B6B6B"
                                  anchors {
                                      verticalCenter: parent.verticalCenter
                                      left: parent.left
                                      leftMargin: 5
                                      right: close.left
                                      rightMargin: 5
                                  }
                                  font_size: 13
//                                  width: contentWidth + 20
                                  wrapMode: Text.WordWrap
                                  elide : Text.ElideRight
                                  verticalAlignment:Text.AlignVCenter
                                  horizontalAlignment: Text.AlignHCenter
                              }
                              MyText{
                                  id : close
                                  color: "#ADADAD"
                                  width : contentWidth + 2
                                  fa : true
                                  font_size: 15
                                  text : FA.icons.Times.Circle
                                  Behavior on color{ ColorAnimation{duration: 200}}
                                  anchors{
                                      verticalCenter: parent.verticalCenter
                                      right: parent.right
                                      rightMargin: 10
                                  }
                                  MouseArea{
                                      anchors.fill: parent
                                      hoverEnabled: true
                                      onClicked: {
                                          GEN.removeWindowFromArray(mainform.chatwindows,null,index);//删除某个窗口的指针
                                          GEN.removeWindowFromArray(_tabbar.tabs,null,index);//删除某个tab的指针
                                          _tabbar.removeTab(index);
                                          if(_tabbar.count == 0){
                                              _chatarea.width = 0;
//                                              header.maxable = false
                                          }
                                      }
                                      onEntered: {
                                          close.color = "black";
                                      }
                                      onExited: {
                                          close.color = "#ADADAD";
                                      }
                                  }
                              }
                          }
                          frame: Item { }
                }
            }
        }

        MainWindowFooter{
            id :footer
            height: 30
        }

    }
    OuterShadow {
        id:_shadow
        target :mainform
    }

    PropertyAnimation {
        id: fadeout
        target: mainform
        duration: 400
        easing.type: Easing.OutSine
        property: 'opacity'
        from: 0
        to: 1
    }

    PropertyAnimation {
        id: hideWindow
        target: fatherWindow
        duration: 200
        easing.type: Easing.OutSine
        property: 'y'
        from: y//-16
        to: -10-(height - 28)
        onStopped: {
//            canhide = true;
            senseArea.z = 999
            ishide = true;
            senseArea.setTime(0);
        }
    }

    PropertyAnimation {
        id: showWindow
        target: fatherWindow
        duration: 200
        easing.type: Easing.OutSine
        property: 'y'
        to: -16
        from: y//-10-(height - 28)
        onStopped:{
//            canhide = false;
            senseArea.z = 0
            ishide = false;
            senseArea.setTime(300);
        }
    }

    function addFriend(id,name,ol,addr){
        friendmodel.append({"ID":id,"name":name,"onLine":ol,"address":addr});
        friendListArray.push(id);
    }
    function refresh(obj){
        var result;
        friendmodel.clear();
        if(parseInt(obj.message.SqlMsgType) == 0){
            result = obj.message.Result;
            for(var i=0;i<result.length;i++){
                addFriend(result[i][0],result[i][1],true,"");
            }
        }
    }
    function remove(index){
        friendmodel.remove(index,1);
    }
    function rename(index,name){
        friendmodel.set(index, {"name":name});
    }
}

