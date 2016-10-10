#include "StdAfx.h"
#include "MYIOCPServer.h"

HANDLE  CMYIOCPServer::m_completionPort = NULL;
HANDLE CMYIOCPServer::m_hMutex = NULL;
CMYIOCPServer* CMYIOCPServer::m_pInstance = NULL;

#if SQLenable
CMYSQL* CMYIOCPServer::m_sql = NULL;
#endif

char CMYIOCPServer::m_byteMsg[MessMaxLen] = { 0 };
CWorkQueue CMYIOCPServer::m_CWorkQueue;


CMYIOCPServer* CMYIOCPServer::GetInstance()
{

	if (NULL == m_pInstance)
	{
		m_pInstance = new CMYIOCPServer();
	}

#if SQLenable

		m_sql = CMYSQL::GetInstance();

		m_sql->InitSQL("localhost","root","","JennyChat",3306,"utf8");

#endif

	m_CWorkQueue.Create(10);
	return m_pInstance;
}
void CMYIOCPServer::formatMessage(char * str, MessagePakag & mp)
{
	//----�Է���recver
	//----�Լ���sender
	string temp = str;
	Json::Reader reader;
	Json::Value value;
	if (reader.parse(temp, value)) {
		mp.m_type = value["type"].asString();
		mp.m_message = value["message"].asString();
		mp.recverID = value["myid"].asString();
		mp.senderID = value["fid"].asString();
	}
}
/**************************
��Ĺ��캯��
**************************/
CMYIOCPServer::CMYIOCPServer(void)
{
	m_iLisenPoint = DefaultPort;
}
/**************************
�����������
**************************/
CMYIOCPServer::~CMYIOCPServer(void)
{
	m_CWorkQueue.Destroy(5);
}
/**************************
���÷�����IP
**************************/
void CMYIOCPServer::SetServerIp(const string & sIP)
{
	m_sServerIP = sIP;
}

/**************************
���÷������˿�
**************************/
void  CMYIOCPServer::SetPort(const int &iPort)
{
	m_iLisenPoint = iPort;
}

/**************************
�������Ŀͻ���������Ŀ
**************************/
void  CMYIOCPServer::SetMaxClientNum(const int &iMaxNum)
{
	m_iMaxClientNum = iMaxNum;
}

/**************************
���������տͻ�����Ϣ��
�����߳�
**************************/
DWORD WINAPI   CMYIOCPServer::ServerWorkThread(LPVOID CompletionPortID)
{
	HANDLE CompletionPort = (HANDLE)CompletionPortID;
	DWORD BytesTransferred;
	LPOVERLAPPED IpOverlapped;
	LPPER_HANDLE_DATA PerHandleData = NULL;
	LPPER_IO_DATA PerIoData = NULL;
	DWORD RecvBytes;
	DWORD Flags = 0;
	BOOL bRet = false;

	while (true) {
		bRet = GetQueuedCompletionStatus(m_completionPort, &BytesTransferred, (PULONG_PTR)&PerHandleData, (LPOVERLAPPED*)&IpOverlapped, INFINITE);
		if (bRet == 0) {
			map<string, SOCKET>::iterator mapptr;
			mapptr = m_clients.find(PerHandleData->username);
			if (mapptr != m_clients.end()) {
				m_clients.erase(mapptr);	//�û��˳���ɾ��map������Ӧ�û�
				cerr << "�û� " << PerHandleData->username << " �˳�..." << endl;
			}
			else {
				if (GetLastError() == 64)
					cerr << "��δ��¼�û��Ͽ�����..." << endl;
				else
					cerr << "GetQueuedCompletionStatus Error: " << GetLastError() << endl;
			}
			closesocket(PerHandleData->socket);
			showClients(m_clients);	//��ʾ��ǰ��������
			continue;
			//���ﲻ�ܷ��أ��������߳̾ͽ�����
			//return -1;  
		}
		PerIoData = (LPPER_IO_DATA)CONTAINING_RECORD(IpOverlapped, PER_IO_DATA, overlapped);

		// ������׽������Ƿ��д�����   
		if (0 == BytesTransferred) {
			closesocket(PerHandleData->socket);
			GlobalFree(PerHandleData);
			GlobalFree(PerIoData);
			continue;
		}

		//�õ���Ϣ����
		memset(m_byteMsg, 0, MessMaxLen); //��ʼ�� m_byteMsg ����
		memcpy(m_byteMsg, PerIoData->databuff.buf, MessMaxLen);//�� buf ��ֵ�� m_byteMsg ����
		//�õ��ͻ���SOCKET��Ϣ
		SOCKET sClientSocket;
		MessagePakag *msg = new MessagePakag;
		cout << "m_byteMsg:" << m_byteMsg << endl;
		formatMessage(m_byteMsg, *msg);
		stringstream ss;
		ss << msg->m_type;
		int value;
		ss >> value;
		switch (value)
		{
		case 1:	//��½��Ϣ
		{
			/*ϵͳ��ϢΪ1��
			*  ��Ϣ0����½�ɹ�
			*  ��Ϣ1���û���������
			*  ��Ϣ2���������
			*/
			//�ͻ���ת����ϢΪ2
			//����������Ϊ3
			switch (login(msg->recverID, msg->m_message, PerHandleData->socket)) {
			case 0: {
				char* sysmsg = "0";
				cout << "�û� " << msg->recverID << " ���룺" << endl;
				PerHandleData->username = msg->recverID;	//����ͻ�ID
				//SendMessage(PerHandleData->socket, sysmsg);	//	���͵�¼ʧ�ܵ�ϵͳ��Ϣ
				send(PerHandleData->socket, sysmsg, strlen(sysmsg), 0);
				break;
			}
			case 1: {
				char* sysmsg = "{\"type\":1,\"message\":1}";
				cout << "�ʺŲ�����" << endl;
				//SendMessage(PerHandleData->socket, sysmsg);	//	���͵�¼ʧ�ܵ�ϵͳ��Ϣ
				send(PerHandleData->socket, sysmsg, strlen(sysmsg), 0);
				//closesocket(PerHandleData->socket);
				break;
			}
			case 2: {
				char* sysmsg = "{\"type\":1,\"message\":2}";
				cout << "�������" << endl;
				//SendMessage(PerHandleData->socket, sysmsg);	//	���͵�¼ʧ�ܵ�ϵͳ��Ϣ
				send(PerHandleData->socket, sysmsg, strlen(sysmsg), 0);
				//closesocket(PerHandleData->socket);
				break;
			}
			default:break;
			}
			showClients(m_clients);	//��ʾ��ǰ��������
			break;
		}
		case 2:	//ת����Ϣ
		{
			cout << msg->recverID << " ���� " << msg->senderID << "��" << msg->m_message << endl;
			sClientSocket = m_clients.find(msg->senderID)->second;
			string temp = "{\"type\":2,\"friend\":\"" + msg->recverID + "\",\"message\":\"" + msg->m_message + "\"}";
			//SendMessage(sClientSocket, (char*)temp.c_str());	//	ת����ָ�ͻ���
			send(sClientSocket, (char*)temp.c_str(), temp.length(), 0);
			break;
		}
		case 3: //����������
		{
			string result = m_sql->Search("JennyChat", "account", "id,username", "id='" + msg->senderID + "'", "");
			if (result == "") {
				result = m_sql->Search("JennyChat", "account", "id,username", "username='" + msg->senderID + "'", "");
			}else{
				Json::Reader reader;
				Json::Value value;
				if (reader.parse(result, value)) {
					if (value["SqlMsgType"] != 0) {
						result = m_sql->Search("JennyChat", "account", "id,username", "username='" + msg->senderID + "'", "");
						if (result != "") {
							if (reader.parse(result, value)) {
								if (value["SqlMsgType"] != 0) {
									result = "";
								}
							}
						}
					}
				}
			}
			string returnmsg = "{\"type\":3,\"message\":" + (result == "" ? "\"\"" : result) + "}";
			cout << "returnmsg:" << returnmsg << endl;
			send(PerHandleData->socket, (char*)returnmsg.c_str(), returnmsg.length(), 0);	//�����������JSON��ʽ����
			break;
		}
		case 4:	//���غ����б�
		{
			cout << "���غ����б�" << endl;
			string result = m_sql->Search("JennyChat", "friendlist", "fid,fname", "accountid=(select id from account where id='" + msg->recverID + "')", "");
			if (result != "") {
				Json::Reader reader;
				Json::Value value;
				if (reader.parse(result, value)) {
					if (value["SqlMsgType"] != 0) {
						result = "";
					}
				}
			}
			string returnmsg = "{\"type\":4,\"message\":" + (result == "" ? "\"\"" : result) + "}";
			cout << "returnmsg:" << returnmsg << endl;
			send(PerHandleData->socket, (char*)returnmsg.c_str(), returnmsg.length(), 0);	//�����������JSON��ʽ����
			break;
		}
		default: //δ֪��Ϣ
		{
			cerr << "�յ� " << msg->recverID << " δ֪������Ϣ..." << endl;
			break;
		}
		}
		//HandleMessage();
		// Ϊ��һ���ص����ý�����I/O��������   
		ZeroMemory(&(PerIoData->overlapped), sizeof(OVERLAPPED)); // ����ڴ�   
		PerIoData->databuff.len = DataBuffSize;
		memset(PerIoData->buffer, 0, strlen(PerIoData->buffer)); //	������Ϣ����
		PerIoData->databuff.buf = PerIoData->buffer;
		PerIoData->operationType = 0;    // read   
		WSARecv(PerHandleData->socket, &(PerIoData->databuff), 1, &RecvBytes, &Flags, &(PerIoData->overlapped), NULL);
		//WSASend(PerHandleData->socket, &(PerIoData->databuff), 1, &RecvBytes, Flags, &(PerIoData->overlapped), NULL);
		delete msg;
		msg = nullptr;
	}
	return  0;
}

/*******************
������Ϣ��
*******************/
void CMYIOCPServer::HandleMessage()
{
	printf("��ǰ�߳�Ϊ %d\n", GetCurrentThreadId());
	WorkItemBase *pCworkItem = NULL;
	byte iCommand = m_byteMsg[0];
	switch (iCommand)
	{
	case  '0':
		//pCworkItem = new CWorkA();
		break;
	case '1':
		//pCworkItem = new CWorkB();
		break;

	case '2':
		break;
	default:
		break;
	}
	//�����񽻸��̳߳ش���
	if (NULL != pCworkItem)
	{
		m_CWorkQueue.InsertWorkItem(pCworkItem);
	}

	cout << "��ɷ��;����Ϣ..." << endl;
}

unsigned int CMYIOCPServer::login(string id, string psw, SOCKET s)
{
#if SQLenable
		//-----�������ݿ���֤�û���Ϣ------
		string result = m_sql->Search("JennyChat", "account", "pswd", "id=" + id, "");
		//-------------------------------
		//����˺Ų�����
		if (result == "") {
			return 1;
		}

		//����������
		Json::Reader reader;
		Json::Value root;
		if (reader.parse(result, root))  // reader��Json�ַ���������root��root������Json��������Ԫ��   
		{
			if (root["Result"][0][0] != psw) {
				return 2;
			}
		}
#endif
	//	�����ȷ
	m_clients[id] = s;	//�����û������ϣ��
	return 0;
}

void CMYIOCPServer::showClients(map<string, SOCKET> clts)
{
	cout << "--------��ǰ�����б�--------" << endl;
	for (map<string, SOCKET>::iterator item = clts.begin(); item != clts.end(); item++) {
		cout << "[" << item->first << "," << item->second << "]" << endl;
	}
	cout << "----------------------------" << endl;
}

/**************************

������Ϣ���ƶ��ͻ���
**************************/
void CMYIOCPServer::SendMessage(SOCKET &tSOCKET, char MessAge[MessMaxLen])
{
	// ��ʼ���ݴ����������Կͻ��˵�����   
	WaitForSingleObject(m_hMutex, INFINITE);
	send(tSOCKET, MessAge, MessMaxLen, 0);  // ������Ϣ    
	ReleaseMutex(m_hMutex);
}

/**************************
��ʼ��SOCKET���󣬴����˿�
���߳�����
**************************/
bool  CMYIOCPServer::LoadWindowsSocket()
{
	// ����socket��̬���ӿ�   
	WORD wVersionRequested = MAKEWORD(2, 2); // ����2.2�汾��WinSock��   
	WSADATA wsaData;    // ����Windows Socket�Ľṹ��Ϣ   
	DWORD err = WSAStartup(wVersionRequested, &wsaData);

	if (0 != err) {  // ����׽��ֿ��Ƿ�����ɹ�   
		m_sError = "���� Windows Socket �� ����...\n";
		return false;
	}
	if (LOBYTE(wsaData.wVersion) != 2 || HIBYTE(wsaData.wVersion) != 2) {// ����Ƿ�����������汾���׽��ֿ�   
		WSACleanup();
		m_sError = "Ҫ�� Windows Socket Ϊ 2.2 �汾...\n";
		system("pause");
		return false;
	}

	// ����IOCP���ں˶���   
	/**
	* ��Ҫ�õ��ĺ�����ԭ�ͣ�
	* HANDLE WINAPI CreateIoCompletionPort(
	*    __in   HANDLE FileHandle,     // �Ѿ��򿪵��ļ�������߿վ����һ���ǿͻ��˵ľ��
	*    __in   HANDLE ExistingCompletionPort, // �Ѿ����ڵ�IOCP���
	*    __in   ULONG_PTR CompletionKey,   // ��ɼ���������ָ��I/O��ɰ���ָ���ļ�
	*    __in   DWORD NumberOfConcurrentThreads // ��������ͬʱִ������߳�����һ���ƽ���CPU������*2
	* );
	**/
	m_completionPort = CreateIoCompletionPort(INVALID_HANDLE_VALUE, NULL, 0, 0);
	if (NULL == m_completionPort) {    // ����IO�ں˶���ʧ��   
		m_sError = "������ɶ˿�ʧ��...\n";
		return false;
	}

	// ����IOCP�߳�--�߳����洴���̳߳�    
	// ȷ���������ĺ�������   
	SYSTEM_INFO mySysInfo;
	GetSystemInfo(&mySysInfo);

	// ���ڴ������ĺ������������߳�   
	for (DWORD i = 0; i < (mySysInfo.dwNumberOfProcessors * 2); ++i) {
		// �����������������̣߳�������ɶ˿ڴ��ݵ����߳�   
		HANDLE ThreadHandle = CreateThread(NULL, 0, &CMYIOCPServer::ServerWorkThread, m_completionPort, 0, NULL);
		if (NULL == ThreadHandle) {
			m_sError = "�����߳̾��ʧ��...\n";
		}
		CloseHandle(ThreadHandle);
	}
	return true;
}
/*************************
��ʼ��������SOCKET��Ϣ
*************************/
bool CMYIOCPServer::InitServerSocket()
{
	// ������ʽ�׽���   
	m_srvSocket = socket(AF_INET, SOCK_STREAM, 0);

	// ��SOCKET������   
	SOCKADDR_IN srvAddr;
	srvAddr.sin_addr.S_un.S_addr = htonl(INADDR_ANY);
	srvAddr.sin_family = AF_INET;
	srvAddr.sin_port = htons(m_iLisenPoint);
	int bindResult = bind(m_srvSocket, (SOCKADDR*)&srvAddr, sizeof(SOCKADDR));
	if (SOCKET_ERROR == bindResult) {
		m_sError = "��ʧ��...\n";
		return false;
	}
	return true;
}
/**************************
�����������˵ļ�����Ϣ
**************************/
bool CMYIOCPServer::CreateServerSocker()
{

	// ��SOCKET����Ϊ����ģʽ   
	int listenResult = listen(m_srvSocket, 10);
	if (SOCKET_ERROR == listenResult) {
		m_sError = "����ʧ��...\n";
		return false;
	}

	// ��ʼ����IO����   
	cout << "����������׼�����������ڵȴ��ͻ��˵Ľ���...\n";
	int icount = 0;
	while (true) {
		PER_HANDLE_DATA * PerHandleData = NULL;
		SOCKADDR_IN saRemote;
		int RemoteLen;
		SOCKET acceptSocket;

		// �������ӣ���������ɶˣ����������AcceptEx()   
		RemoteLen = sizeof(saRemote);
		acceptSocket = accept(m_srvSocket, (SOCKADDR*)&saRemote, &RemoteLen);

		if (SOCKET_ERROR == acceptSocket) {   // ���տͻ���ʧ��   
			cerr << "���� socket ���� " << GetLastError() << endl;
			m_sError = "���� socket ���� ...\n";
			icount++;
			cout << "icount : " << icount << endl;
			if (icount > 50)
			{
				return false;
			}
			continue;
		}
		icount = 0;

		// �����������׽��ֹ����ĵ����������Ϣ�ṹ   
		PerHandleData = (LPPER_HANDLE_DATA)GlobalAlloc(GPTR, sizeof(PER_HANDLE_DATA));  // �ڶ���Ϊ���PerHandleData����ָ����С���ڴ�   
		PerHandleData->socket = acceptSocket;
		memcpy(&PerHandleData->ClientAddr, &saRemote, RemoteLen);
		m_vclientGroup.push_back(PerHandleData);       // �������ͻ�������ָ��ŵ��ͻ�������   

													   // �������׽��ֺ���ɶ˿ڹ���   
		CreateIoCompletionPort((HANDLE)(PerHandleData->socket), m_completionPort, (DWORD)PerHandleData, 0);


		// ��ʼ�ڽ����׽����ϴ���I/Oʹ���ص�I/O����   
		// ���½����׽�����Ͷ��һ�������첽   
		// WSARecv��WSASend������ЩI/O������ɺ󣬹������̻߳�ΪI/O�����ṩ����       
		// ��I/O��������(I/O�ص�)   
		LPPER_IO_OPERATION_DATA PerIoData = NULL;
		PerIoData = (LPPER_IO_OPERATION_DATA)GlobalAlloc(GPTR, sizeof(PER_IO_OPERATEION_DATA));
		ZeroMemory(&(PerIoData->overlapped), sizeof(OVERLAPPED));
		PerIoData->databuff.len = 1024;
		PerIoData->databuff.buf = PerIoData->buffer;
		PerIoData->operationType = 0;    // read   

		DWORD RecvBytes;
		DWORD Flags = 0;
		WSARecv(PerHandleData->socket, &(PerIoData->databuff), 1, &RecvBytes, &Flags, &(PerIoData->overlapped), NULL);
	}
	//������Դ 
	DWORD dwByteTrans;
	PostQueuedCompletionStatus(m_completionPort, dwByteTrans, 0, 0);
	closesocket(listenResult);
	return true;
}

/*********************
����������
*********************/
bool CMYIOCPServer::ServerSetUp()
{
	if (false == LoadWindowsSocket())
	{
		return false;
	}
	if (false == InitServerSocket())
	{
		return false;
	}
	if (false == CreateServerSocker())
	{
		return false;
	}
	return true;
}