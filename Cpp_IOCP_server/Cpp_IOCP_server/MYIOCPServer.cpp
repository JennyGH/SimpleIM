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
	//----对方：recver
	//----自己：sender
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
类的构造函数
**************************/
CMYIOCPServer::CMYIOCPServer(void)
{
	m_iLisenPoint = DefaultPort;
}
/**************************
类的析构函数
**************************/
CMYIOCPServer::~CMYIOCPServer(void)
{
	m_CWorkQueue.Destroy(5);
}
/**************************
设置服务器IP
**************************/
void CMYIOCPServer::SetServerIp(const string & sIP)
{
	m_sServerIP = sIP;
}

/**************************
设置服务器端口
**************************/
void  CMYIOCPServer::SetPort(const int &iPort)
{
	m_iLisenPoint = iPort;
}

/**************************
设置最大的客户端连接数目
**************************/
void  CMYIOCPServer::SetMaxClientNum(const int &iMaxNum)
{
	m_iMaxClientNum = iMaxNum;
}

/**************************
服务器接收客户端消息，
工作线程
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
				m_clients.erase(mapptr);	//用户退出后删除map表中相应用户
				cerr << "用户 " << PerHandleData->username << " 退出..." << endl;
			}
			else {
				if (GetLastError() == 64)
					cerr << "有未登录用户断开连接..." << endl;
				else
					cerr << "GetQueuedCompletionStatus Error: " << GetLastError() << endl;
			}
			closesocket(PerHandleData->socket);
			showClients(m_clients);	//显示当前在线人数
			continue;
			//这里不能返回，返回子线程就结束了
			//return -1;  
		}
		PerIoData = (LPPER_IO_DATA)CONTAINING_RECORD(IpOverlapped, PER_IO_DATA, overlapped);

		// 检查在套接字上是否有错误发生   
		if (0 == BytesTransferred) {
			closesocket(PerHandleData->socket);
			GlobalFree(PerHandleData);
			GlobalFree(PerIoData);
			continue;
		}

		//得到消息码流
		memset(m_byteMsg, 0, MessMaxLen); //初始化 m_byteMsg 数组
		memcpy(m_byteMsg, PerIoData->databuff.buf, MessMaxLen);//将 buf 赋值给 m_byteMsg 数组
		//得到客户端SOCKET信息
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
		case 1:	//登陆消息
		{
			/*系统消息为1，
			*  消息0：登陆成功
			*  消息1：用户名不存在
			*  消息2：密码错误
			*/
			//客户端转发消息为2
			//查找新朋友为3
			switch (login(msg->recverID, msg->m_message, PerHandleData->socket)) {
			case 0: {
				char* sysmsg = "0";
				cout << "用户 " << msg->recverID << " 登入：" << endl;
				PerHandleData->username = msg->recverID;	//保存客户ID
				//SendMessage(PerHandleData->socket, sysmsg);	//	发送登录失败的系统消息
				send(PerHandleData->socket, sysmsg, strlen(sysmsg), 0);
				break;
			}
			case 1: {
				char* sysmsg = "{\"type\":1,\"message\":1}";
				cout << "帐号不存在" << endl;
				//SendMessage(PerHandleData->socket, sysmsg);	//	发送登录失败的系统消息
				send(PerHandleData->socket, sysmsg, strlen(sysmsg), 0);
				//closesocket(PerHandleData->socket);
				break;
			}
			case 2: {
				char* sysmsg = "{\"type\":1,\"message\":2}";
				cout << "密码错误" << endl;
				//SendMessage(PerHandleData->socket, sysmsg);	//	发送登录失败的系统消息
				send(PerHandleData->socket, sysmsg, strlen(sysmsg), 0);
				//closesocket(PerHandleData->socket);
				break;
			}
			default:break;
			}
			showClients(m_clients);	//显示当前在线人数
			break;
		}
		case 2:	//转发消息
		{
			cout << msg->recverID << " 告诉 " << msg->senderID << "：" << msg->m_message << endl;
			sClientSocket = m_clients.find(msg->senderID)->second;
			string temp = "{\"type\":2,\"friend\":\"" + msg->recverID + "\",\"message\":\"" + msg->m_message + "\"}";
			//SendMessage(sClientSocket, (char*)temp.c_str());	//	转发给指客户端
			send(sClientSocket, (char*)temp.c_str(), temp.length(), 0);
			break;
		}
		case 3: //查找新朋友
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
			send(PerHandleData->socket, (char*)returnmsg.c_str(), returnmsg.length(), 0);	//发送搜索结果JSON格式数据
			break;
		}
		case 4:	//返回好友列表
		{
			cout << "返回好友列表" << endl;
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
			send(PerHandleData->socket, (char*)returnmsg.c_str(), returnmsg.length(), 0);	//发送搜索结果JSON格式数据
			break;
		}
		default: //未知消息
		{
			cerr << "收到 " << msg->recverID << " 未知类型消息..." << endl;
			break;
		}
		}
		//HandleMessage();
		// 为下一个重叠调用建立单I/O操作数据   
		ZeroMemory(&(PerIoData->overlapped), sizeof(OVERLAPPED)); // 清空内存   
		PerIoData->databuff.len = DataBuffSize;
		memset(PerIoData->buffer, 0, strlen(PerIoData->buffer)); //	清理消息缓存
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
处理消息类
*******************/
void CMYIOCPServer::HandleMessage()
{
	printf("当前线程为 %d\n", GetCurrentThreadId());
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
	//将任务交给线程池处理
	if (NULL != pCworkItem)
	{
		m_CWorkQueue.InsertWorkItem(pCworkItem);
	}

	cout << "完成发送句柄消息..." << endl;
}

unsigned int CMYIOCPServer::login(string id, string psw, SOCKET s)
{
#if SQLenable
		//-----链接数据库验证用户信息------
		string result = m_sql->Search("JennyChat", "account", "pswd", "id=" + id, "");
		//-------------------------------
		//如果账号不存在
		if (result == "") {
			return 1;
		}

		//如果密码错误
		Json::Reader reader;
		Json::Value root;
		if (reader.parse(result, root))  // reader将Json字符串解析到root，root将包含Json里所有子元素   
		{
			if (root["Result"][0][0] != psw) {
				return 2;
			}
		}
#endif
	//	如果正确
	m_clients[id] = s;	//将新用户存入哈希表
	return 0;
}

void CMYIOCPServer::showClients(map<string, SOCKET> clts)
{
	cout << "--------当前在线列表--------" << endl;
	for (map<string, SOCKET>::iterator item = clts.begin(); item != clts.end(); item++) {
		cout << "[" << item->first << "," << item->second << "]" << endl;
	}
	cout << "----------------------------" << endl;
}

/**************************

发送消息给制定客户端
**************************/
void CMYIOCPServer::SendMessage(SOCKET &tSOCKET, char MessAge[MessMaxLen])
{
	// 开始数据处理，接收来自客户端的数据   
	WaitForSingleObject(m_hMutex, INFINITE);
	send(tSOCKET, MessAge, MessMaxLen, 0);  // 发送信息    
	ReleaseMutex(m_hMutex);
}

/**************************
初始化SOCKET对象，创建端口
和线程数组
**************************/
bool  CMYIOCPServer::LoadWindowsSocket()
{
	// 加载socket动态链接库   
	WORD wVersionRequested = MAKEWORD(2, 2); // 请求2.2版本的WinSock库   
	WSADATA wsaData;    // 接收Windows Socket的结构信息   
	DWORD err = WSAStartup(wVersionRequested, &wsaData);

	if (0 != err) {  // 检查套接字库是否申请成功   
		m_sError = "请求 Windows Socket 库 错误...\n";
		return false;
	}
	if (LOBYTE(wsaData.wVersion) != 2 || HIBYTE(wsaData.wVersion) != 2) {// 检查是否申请了所需版本的套接字库   
		WSACleanup();
		m_sError = "要求 Windows Socket 为 2.2 版本...\n";
		system("pause");
		return false;
	}

	// 创建IOCP的内核对象   
	/**
	* 需要用到的函数的原型：
	* HANDLE WINAPI CreateIoCompletionPort(
	*    __in   HANDLE FileHandle,     // 已经打开的文件句柄或者空句柄，一般是客户端的句柄
	*    __in   HANDLE ExistingCompletionPort, // 已经存在的IOCP句柄
	*    __in   ULONG_PTR CompletionKey,   // 完成键，包含了指定I/O完成包的指定文件
	*    __in   DWORD NumberOfConcurrentThreads // 真正并发同时执行最大线程数，一般推介是CPU核心数*2
	* );
	**/
	m_completionPort = CreateIoCompletionPort(INVALID_HANDLE_VALUE, NULL, 0, 0);
	if (NULL == m_completionPort) {    // 创建IO内核对象失败   
		m_sError = "创建完成端口失败...\n";
		return false;
	}

	// 创建IOCP线程--线程里面创建线程池    
	// 确定处理器的核心数量   
	SYSTEM_INFO mySysInfo;
	GetSystemInfo(&mySysInfo);

	// 基于处理器的核心数量创建线程   
	for (DWORD i = 0; i < (mySysInfo.dwNumberOfProcessors * 2); ++i) {
		// 创建服务器工作器线程，并将完成端口传递到该线程   
		HANDLE ThreadHandle = CreateThread(NULL, 0, &CMYIOCPServer::ServerWorkThread, m_completionPort, 0, NULL);
		if (NULL == ThreadHandle) {
			m_sError = "创建线程句柄失败...\n";
		}
		CloseHandle(ThreadHandle);
	}
	return true;
}
/*************************
初始化服务器SOCKET信息
*************************/
bool CMYIOCPServer::InitServerSocket()
{
	// 建立流式套接字   
	m_srvSocket = socket(AF_INET, SOCK_STREAM, 0);

	// 绑定SOCKET到本机   
	SOCKADDR_IN srvAddr;
	srvAddr.sin_addr.S_un.S_addr = htonl(INADDR_ANY);
	srvAddr.sin_family = AF_INET;
	srvAddr.sin_port = htons(m_iLisenPoint);
	int bindResult = bind(m_srvSocket, (SOCKADDR*)&srvAddr, sizeof(SOCKADDR));
	if (SOCKET_ERROR == bindResult) {
		m_sError = "绑定失败...\n";
		return false;
	}
	return true;
}
/**************************
创建服务器端的监听信息
**************************/
bool CMYIOCPServer::CreateServerSocker()
{

	// 将SOCKET设置为监听模式   
	int listenResult = listen(m_srvSocket, 10);
	if (SOCKET_ERROR == listenResult) {
		m_sError = "监听失败...\n";
		return false;
	}

	// 开始处理IO数据   
	cout << "本服务器已准备就绪，正在等待客户端的接入...\n";
	int icount = 0;
	while (true) {
		PER_HANDLE_DATA * PerHandleData = NULL;
		SOCKADDR_IN saRemote;
		int RemoteLen;
		SOCKET acceptSocket;

		// 接收连接，并分配完成端，这儿可以用AcceptEx()   
		RemoteLen = sizeof(saRemote);
		acceptSocket = accept(m_srvSocket, (SOCKADDR*)&saRemote, &RemoteLen);

		if (SOCKET_ERROR == acceptSocket) {   // 接收客户端失败   
			cerr << "接受 socket 错误 " << GetLastError() << endl;
			m_sError = "接受 socket 错误 ...\n";
			icount++;
			cout << "icount : " << icount << endl;
			if (icount > 50)
			{
				return false;
			}
			continue;
		}
		icount = 0;

		// 创建用来和套接字关联的单句柄数据信息结构   
		PerHandleData = (LPPER_HANDLE_DATA)GlobalAlloc(GPTR, sizeof(PER_HANDLE_DATA));  // 在堆中为这个PerHandleData申请指定大小的内存   
		PerHandleData->socket = acceptSocket;
		memcpy(&PerHandleData->ClientAddr, &saRemote, RemoteLen);
		m_vclientGroup.push_back(PerHandleData);       // 将单个客户端数据指针放到客户端组中   

													   // 将接受套接字和完成端口关联   
		CreateIoCompletionPort((HANDLE)(PerHandleData->socket), m_completionPort, (DWORD)PerHandleData, 0);


		// 开始在接受套接字上处理I/O使用重叠I/O机制   
		// 在新建的套接字上投递一个或多个异步   
		// WSARecv或WSASend请求，这些I/O请求完成后，工作者线程会为I/O请求提供服务       
		// 单I/O操作数据(I/O重叠)   
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
	//销毁资源 
	DWORD dwByteTrans;
	PostQueuedCompletionStatus(m_completionPort, dwByteTrans, 0, 0);
	closesocket(listenResult);
	return true;
}

/*********************
启动服务器
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