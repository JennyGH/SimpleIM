import QtQuick 2.0

ListModel{
    id:father
//    ListElement{
//        name:"Jenny"
//        message : "Hello!"
//    }
    onCountChanged: {
        chatmessahelist.currentIndex = father.count - 1
    }
}
