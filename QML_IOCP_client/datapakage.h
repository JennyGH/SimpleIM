#ifndef DATAPAKAGE_H
#define DATAPAKAGE_H

#include <string>
using namespace std;

#define MESG_LENGTH 1024
#define LOGIN_MSG "1"
#define CHAT_MSG "2"
#define SEARCH_MSG "3"
#define UPDATE_LIST "4"
#define ADD "5"
#define EDIT "6"

struct MessagePakag{    //消息包
    string friend_id;  //好友ID
    unsigned char m_online;      //是否在线
    string myID;        //自己的ID号
    string m_message;   //消息，当m_type=1时存放密码，=2时存放聊天消息
    string m_type;   //1:登陆消息，2:聊天消息
};


#endif // DATAPAKAGE_H
