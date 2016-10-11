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

struct MessagePakag{    //��Ϣ��
    string friend_id;  //����ID
    unsigned char m_online;      //�Ƿ�����
    string myID;        //�Լ���ID��
    string m_message;   //��Ϣ����m_type=1ʱ������룬=2ʱ���������Ϣ
    string m_type;   //1:��½��Ϣ��2:������Ϣ
};


#endif // DATAPAKAGE_H
