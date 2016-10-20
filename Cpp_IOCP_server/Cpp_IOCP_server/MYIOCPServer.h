#pragma once
#pragma comment(lib, "json_vc71_libmt.lib")
#include <string>
#include <winsock2.h>   
#include <Windows.h>  
#include <vector>
#include <map>
#include <iostream>
#include <sstream>
#include <ctime>
#include <iomanip>
//#include "CThreadPool.h" 
#include <atlutil.h>
#include <queue>
#include "WorkQueue.h"
#include "mysql\include\json\json.h"

#define SQLenable 1

#if SQLenable
#include "MYSQL.h"
#endif

//#include "WorkA.h"
//#include "WorkB.h"
using namespace std;
#pragma comment(lib, "Ws2_32.lib")      // Socket编程需用的动态链接库   

#define DefaultIP  "127.0.0.1"
#define DefaultPort 9999
#define DefaultClientNum 6000
#define MessMaxLen   1024 * 2
#define DataBuffSize   2 * 1024 

static map<string, SOCKET> m_clients;
static string sqlpswd;

//消息包结构体
struct MessagePakag {    //消息包
	string recverID;  //好友ID
	bool m_online;      //是否在线
	string senderID;        //自己的ID号
	string m_message;   //消息，当m_type=1时存放密码，=2时存放聊天消息
	string m_type;   //1:登陆消息，2:聊天消息
};

/**
* 结构体名称：PER_IO_DATA
* 结构体功能：重叠I/O需要用到的结构体，临时记录IO数据
**/
typedef struct
{
	OVERLAPPED overlapped;
	WSABUF databuff;
	char buffer[DataBuffSize];
	int BufferLen;
	int operationType;
	SOCKET socket;
}PER_IO_OPERATEION_DATA, *LPPER_IO_OPERATION_DATA, *LPPER_IO_DATA, PER_IO_DATA;

/**
* 结构体名称：PER_HANDLE_DATA
* 结构体存储：记录单个套接字的数据，包括了套接字的变量及套接字的对应的客户端的地址。
* 结构体作用：当服务器连接上客户端时，信息存储到该结构体中，知道客户端的地址以便于回访。
**/
typedef struct
{
	SOCKET socket;
	SOCKADDR_STORAGE ClientAddr;
	string userid;
	string username;
}PER_HANDLE_DATA, *LPPER_HANDLE_DATA;

class CMYIOCPServer
{
public:
	~CMYIOCPServer(void);
	bool ServerSetUp();
	void SetServerIp(const string & sIP = DefaultIP);
	void SetPort(const int &iPort = DefaultPort);
	void SetMaxClientNum(const int &iMaxNum = DefaultClientNum);
	static DWORD WINAPI  ServerWorkThread(LPVOID CompletionPortID);
	static void SendMessage(SOCKET &tSOCKET, char MessAge[MessMaxLen]);
	static CMYIOCPServer* GetInstance();
	static void formatMessage(char* str, MessagePakag &mp);
	static void setPswd(string pswd);
	static string now();
private:
	//私有方法
	CMYIOCPServer(void);
	bool  LoadWindowsSocket();
	bool InitServerSocket();
	bool CreateServerSocker();
	static char* getIpAddr(SOCKADDR_STORAGE saddr);
	static void HandleMessage();
	static unsigned int login(string id,string psw, LPPER_HANDLE_DATA lhd);
	static void showClients(map<string,SOCKET> clts);
	//私有数据
	string m_sServerIP;
	int m_iLisenPoint;
	string m_sError;
	int m_iMaxClientNum;
	vector< PER_HANDLE_DATA* > m_vclientGroup;//保持客户端的连接信息  
	static HANDLE m_hMutex;//多线程访问互斥变量 
	static HANDLE m_completionPort;
	SOCKET m_srvSocket;
	static CMYIOCPServer *m_pInstance;
	static char m_byteMsg[MessMaxLen];
	static CWorkQueue m_CWorkQueue;//线程池
#if SQLenable
	static CMYSQL *m_sql;
#endif
};

