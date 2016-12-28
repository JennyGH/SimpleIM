import QtQuick 2.0

Row{
    id:father
    spacing: 1
    property var tabs: new Array
    property Rectangle currentTab: null
    width : parent.width
    height: 50
    function getCurrentTab(){
        return currentTab;
    }
    function setCurrentTab(e){
        currentTab.state = "";
        e.state = "active";
        father.currentTab = e;
    }
}
