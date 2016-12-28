#ifndef CLIENT_H
#define CLIENT_H

#include <QObject>
#include "datapakage.h"
#pragma comment(lib,"ws2_32.lib")
#include <WinSock2.h>
#include <Windows.h>
#include <iostream>
#include <fstream>
#include <sstream>
#include <map>
#include <list>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>
#include "headfiles.h"
using namespace std;

#define defaultIP "127.0.0.1"
#define defaultPort 5150
const unsigned int BUFFSIZE = 2048;

class Client : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString ip READ ip WRITE setIp)
    Q_PROPERTY(int port READ port WRITE setPort)
    Q_PROPERTY(int Ret READ Ret)
public:
    Q_INVOKABLE bool initSocket();
    Q_INVOKABLE bool reconnect();
    Q_INVOKABLE bool sendmessage(QString msg,QString fid,Message *type);
    Q_INVOKABLE bool saveSetting(QString values);
    Q_INVOKABLE bool login(QString id,QString psw);
    Q_INVOKABLE bool searchNewFriend(QString idOrName);
    int port() const;
    void setPort(int p);
    QString ip() const;
    void setIp(QString vip);
    int Ret() const;
    static DWORD WINAPI recvThread(Client *clt);
    static DWORD WINAPI updateThread(Client *clt);
    static Client* GetInstance();
    ~Client();
signals:
    void recvmessage();
    void loseConnect();
public slots:
    QString getMessage();
    unsigned int keepMessage(QString userid,QString msg);
    QString alreadyRead(QString userid);
    void destroyWindow(QObject *w);
private ://私有方法

    explicit Client(QObject *parent = 0);

    template<typename T>
    static void debug(T e);

    static int stringToInt(string str);
    static string getSettingValue(string val);
    bool _connect();
    bool _recv();
private : //私有属性
    string m_ip;
    string m_id;
    int m_port;
    SOCKET sk;
    WSADATA wsadata;
    SOCKADDR_IN m_addr;
    MessagePakag *msgpakage;
    char buff[BUFFSIZE];
    int p_ret;
//    HANDLE recvthread;
//    HANDLE updatethread;
    map<string,HANDLE> thread_map;
    map<string,list<string>> m_keep;
    unsigned int m_msgcount;
    static Client* m_client;
};

#endif // CLIENT_H
