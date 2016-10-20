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
#pragma comment(lib, "Ws2_32.lib")      // Socket������õĶ�̬���ӿ�   

#define DefaultIP  "127.0.0.1"
#define DefaultPort 9999
#define DefaultClientNum 6000
#define MessMaxLen   1024 * 2
#define DataBuffSize   2 * 1024 

static map<string, SOCKET> m_clients;
static string sqlpswd;

//��Ϣ���ṹ��
struct MessagePakag {    //��Ϣ��
	string recverID;  //����ID
	bool m_online;      //�Ƿ�����
	string senderID;        //�Լ���ID��
	string m_message;   //��Ϣ����m_type=1ʱ������룬=2ʱ���������Ϣ
	string m_type;   //1:��½��Ϣ��2:������Ϣ
};

/**
* �ṹ�����ƣ�PER_IO_DATA
* �ṹ�幦�ܣ��ص�I/O��Ҫ�õ��Ľṹ�壬��ʱ��¼IO����
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
* �ṹ�����ƣ�PER_HANDLE_DATA
* �ṹ��洢����¼�����׽��ֵ����ݣ��������׽��ֵı������׽��ֵĶ�Ӧ�Ŀͻ��˵ĵ�ַ��
* �ṹ�����ã��������������Ͽͻ���ʱ����Ϣ�洢���ýṹ���У�֪���ͻ��˵ĵ�ַ�Ա��ڻطá�
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
	//˽�з���
	CMYIOCPServer(void);
	bool  LoadWindowsSocket();
	bool InitServerSocket();
	bool CreateServerSocker();
	static char* getIpAddr(SOCKADDR_STORAGE saddr);
	static void HandleMessage();
	static unsigned int login(string id,string psw, LPPER_HANDLE_DATA lhd);
	static void showClients(map<string,SOCKET> clts);
	//˽������
	string m_sServerIP;
	int m_iLisenPoint;
	string m_sError;
	int m_iMaxClientNum;
	vector< PER_HANDLE_DATA* > m_vclientGroup;//���ֿͻ��˵�������Ϣ  
	static HANDLE m_hMutex;//���̷߳��ʻ������ 
	static HANDLE m_completionPort;
	SOCKET m_srvSocket;
	static CMYIOCPServer *m_pInstance;
	static char m_byteMsg[MessMaxLen];
	static CWorkQueue m_CWorkQueue;//�̳߳�
#if SQLenable
	static CMYSQL *m_sql;
#endif
};

