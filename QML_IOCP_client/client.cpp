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
        debug("读取setting.ini失败，将使用默认设置..");
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
            debug( "初始化失败，错误代码 " + p_ret);
            closesocket(sk);
            sk = NULL;
            return false;
        }

        if ((sk = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)) == INVALID_SOCKET) {
            debug("创建socket失败，错误代码 " + WSAGetLastError());
            closesocket(sk);
            sk = NULL;
            WSACleanup();
            return false;
        }

        m_addr.sin_family = AF_INET;
        m_addr.sin_port = htons(m_port);
        m_addr.sin_addr.S_un.S_addr = inet_addr(m_ip.c_str());
        debug ("正在尝试连接服务端...");
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
            debug("接收方id不能为空...");
            return false;
        }
        debug ("发送给 " + fid.toLocal8Bit().toStdString());
        msgpakage->m_type = CHAT_MSG;
        break;
    case 3:
        if(fid.isEmpty() || fid.isNull()){
            debug("关键字不能为空...");
            return false;
        }
        debug ("查找 " + fid.toLocal8Bit().toStdString());
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
        debug("发送失败");
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
        debug ("打开setting.ini失败...");
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
        debug ("用户名与密码不能为空...");
        return false;
    }
    //如果已经连接上服务器...
    m_id = id.toStdString();
    return sendmessage(psw,NULL,1);
    //否则
    //debug("连接服务器失败，请检查网络设置...");
    //return false
}

bool Client::searchNewFriend(QString idOrName)
{
    // type:3 查找新好友
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

        cout << "keepMessage捕获异常：" << err.what() << endl;
    }
    catch(...){

        debug ("keepMessage未知异常...");

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

            cout << "alreadyRead出现异常：" << err.what() << endl;
            return "";

        }
        catch(...){

            debug("alreadyRead未知异常...");
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
            debug("接收失败...");
            closesocket(m_client->sk);
            WSACleanup();
            m_client->sk = NULL;
            m_client->threadhld = NULL;
            emit m_client->loseConnect();
            break;
        }
        //成功接收数据后
        m_client->buff[ret] = '\0';//由于接收的数据末尾不带结束符\0，要手动加上。
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
        debug("连接失败，错误代码 " + WSAGetLastError());
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
            debug ("创建线程失败...");
            return false;
        }
        debug("线程创建成功...");
        CloseHandle(threadhld);
    }else{
        cout << "已存在线程 " << threadhld << endl;
    }
    return true;
}

