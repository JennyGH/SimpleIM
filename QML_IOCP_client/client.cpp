#include "client.h"

Client* Client::m_client = NULL;

Client::Client(QObject *parent) : QObject(parent)
{
    sk = NULL;
    threadhld = NULL;
    m_msgcount = 0;
    //    memset(buff,0,sizeof(buff));
    ifstream fin("setting.ini");
    if(!fin){
        debug("��ȡsetting.iniʧ�ܣ���ʹ��Ĭ������..");
        m_ip = defaultIP;
        m_port = defaultPort;
    }else{
        string tempip,tempport;
        while(getline(fin,tempip)){
            getline(fin,tempport);
            m_ip = getSettingValue(tempip);
            m_port = stringToInt(getSettingValue(tempport));
        }
    }
}

bool Client::initSocket()
{
    if(sk == NULL){
        if ((p_ret = WSAStartup(MAKEWORD(2, 2), &wsadata)) != 0) {
            debug( "��ʼ��ʧ�ܣ�������� " + p_ret);
            closesocket(sk);
            sk = NULL;
            return false;
        }

        if ((sk = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)) == INVALID_SOCKET) {
            debug("����socketʧ�ܣ�������� " + WSAGetLastError());
            closesocket(sk);
            sk = NULL;
            WSACleanup();
            return false;
        }

        m_addr.sin_family = AF_INET;
        m_addr.sin_port = htons(m_port);
        m_addr.sin_addr.S_un.S_addr = inet_addr(m_ip.c_str());
        debug ("���ڳ������ӷ����...");
        connect(this,recvmessage,this,getMessage);
        return _connect();
    }
    return true;
}

bool Client::reconnect()
{
    closesocket(sk);
    WSACleanup();
    initSocket();
}

template<typename T>
void Client::debug(T e)
{
    cout << "Debug info: " << e << endl;
}

int Client::stringToInt(string str)
{
    stringstream ss;
    ss << str;
    int value;
    ss >> value;
    return value;
}

string Client::getSettingValue(string val)
{
    return val.substr(val.find('=') + 1);
}

bool Client::sendmessage(QString msg,QString fid,unsigned int type = 2)
{
    msgpakage = new MessagePakag;
    string temp;
    switch (type) {
    case 1:
        msgpakage->m_type = LOGIN_MSG;
        break;
    case 2:
        if(fid.isEmpty() || fid.isNull()){
            debug("���շ�id����Ϊ��...");
            return false;
        }
        debug ("���͸� " + fid.toLocal8Bit().toStdString());
        msgpakage->m_type = CHAT_MSG;
        break;
    case 3:
        if(fid.isEmpty() || fid.isNull()){
            debug("�ؼ��ֲ���Ϊ��...");
            return false;
        }
        debug ("���� " + fid.toLocal8Bit().toStdString());
        msgpakage->m_type = SEARCH_MSG;
        break;
    case 4:
        msgpakage->m_type = UPDATE_LIST;
        break;
    default:
        msgpakage->m_type = "0";
        break;
    }
    msgpakage->friend_id = fid.toLocal8Bit().toStdString();
    msgpakage->myID = m_id;
    msgpakage->m_message = msg.toLocal8Bit().toStdString();

    temp = "{\"type\":" + msgpakage->m_type + "," +
            "\"myid\":" + "\"" + msgpakage->myID + "\"," +
            "\"fid\":" + "\"" + msgpakage->friend_id + "\"," +
            "\"message\":" + "\"" + msgpakage->m_message + "\"" +
            "}";
    if ((p_ret = send(sk, temp.c_str(), temp.length(), 0)) == SOCKET_ERROR) {
        debug("����ʧ��");
        closesocket(sk);
        WSACleanup();
        delete msgpakage;
        msgpakage = NULL;
        return false;
    }
    //    buff = msg.toLatin1().data();
    delete msgpakage;
    msgpakage = NULL;
    return true;
}

bool Client::saveSetting(QString vip, QString vport)
{
    ofstream fout("setting.ini");
    if(!fout){
        debug ("��setting.iniʧ��...");
        return false;
    }
    fout << "ip=" << vip.toLocal8Bit().toStdString() << endl
         << "port=" << vport.toLocal8Bit().toStdString() << endl;
    fout.close();
    return true;
}

bool Client::login(QString id, QString psw)
{
    cout << "login" << endl;
    if(id.isEmpty() || id.isNull() || psw.isEmpty() || psw.isNull()){
        debug ("�û��������벻��Ϊ��...");
        return false;
    }
    //����Ѿ������Ϸ�����...
    m_id = id.toStdString();
    return sendmessage(psw,NULL,1);
    //����
    //debug("���ӷ�����ʧ�ܣ�������������...");
    //return false
}

bool Client::searchNewFriend(QString idOrName)
{
    // type:3 �����º���
    return sendmessage("",idOrName,3);
}

unsigned int Client::keepMessage(QString userid, QString msg)
{
    list<string> *second = &m_keep[userid.toStdString()];

    try {

        second->push_back(msg.toLocal8Bit().toStdString());
        m_msgcount++;

    }
    catch(exception &err){

        cout << "keepMessage�����쳣��" << err.what() << endl;
    }
    catch(...){

        debug ("keepMessageδ֪�쳣...");

    }
    return m_msgcount;
}

QString Client::alreadyRead(QString userid)
{
    list<string> *second = &m_keep[userid.toStdString()];
    int count = second->size();
    if(count){
        string json = "{\"message\":[";  // + "]}";
        try{
            for(int i = 0;i<count;i++){
//                debug(*(second->begin()));
                json += "\"" + *(second->begin()) + "\"";
                second->pop_front();

                if(i < count - 1) json += ",";

                m_msgcount--;
            }
        }
        catch(exception &err){

            cout << "alreadyRead�����쳣��" << err.what() << endl;
            return "";

        }
        catch(...){

            debug("alreadyReadδ֪�쳣...");
            return "";
        }

        json += "]}";
        return QString::fromLocal8Bit(json.c_str());
    }
    return "";
}

QString Client::getMessage()
{
    return QString::fromLocal8Bit(buff);
}

DWORD WINAPI Client::recvThread(Client *clt)
{
    int ret;
    memset(m_client->buff,0,BUFFSIZE);
    while(1){
        ret = recv(m_client->sk,m_client->buff,sizeof(m_client->buff),0);
        if (ret == SOCKET_ERROR) {
            debug("����ʧ��...");
            closesocket(m_client->sk);
            WSACleanup();
            m_client->sk = NULL;
            m_client->threadhld = NULL;
            emit m_client->loseConnect();
            break;
        }
        //�ɹ��������ݺ�
        m_client->buff[ret] = '\0';//���ڽ��յ�����ĩβ����������\0��Ҫ�ֶ����ϡ�
        cout << "emit:" << m_client->buff << ",current thread:" << GetCurrentThreadId() << ",client:" << m_client << endl;
        emit m_client->recvmessage();
    }
    return 0;
}

Client *Client::GetInstance()
{
    debug("GetInstance");
    if(m_client == NULL){
        m_client = new Client();
    }
    return m_client;
}

Client::~Client()
{
    debug("~Client");
    delete m_client;
    m_client = NULL;
}

int Client::port() const
{
    return m_port;
}

void Client::setPort(int p)
{
    m_port = p;
}

QString Client::ip() const
{
    return QString::fromStdString(m_ip);
}

void Client::setIp(QString vip)
{
    m_ip = vip.toStdString();
}

int Client::Ret() const
{
    return p_ret;
}

bool Client::_connect()
{
    if (::connect(sk, (SOCKADDR*)&m_addr, sizeof(m_addr)) == SOCKET_ERROR) {
        debug("����ʧ�ܣ�������� " + WSAGetLastError());
        closesocket(sk);
        sk = NULL;
        WSACleanup();
        return false;
    }
    return _recv();
}

bool Client::_recv()
{
    if(threadhld == NULL)
    {
        threadhld = ::CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)Client::recvThread, (LPVOID)this, 0, NULL);
        if(threadhld == NULL){
            debug ("�����߳�ʧ��...");
            return false;
        }
        debug("�̴߳����ɹ�...");
        CloseHandle(threadhld);
    }else{
        cout << "�Ѵ����߳� " << threadhld << endl;
    }
    return true;
}

