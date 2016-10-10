// Cpp_IOCP_server.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include "MYIOCPServer.h"
//#pragma comment(lib, "Kernel32.lib") 
#define SERVER 1

int main()
{
#if SERVER
	CMYIOCPServer* server = CMYIOCPServer::GetInstance();
	server->SetPortW(5150);
	server->ServerSetUp();
#else
	CMYSQL *sql = CMYSQL::GetInstance();
	sql->InitSQL("localhost", "root", "", "JennyChat", 3306, "utf8");
	//cout << sql->Search("JennyChat", "account", "id,username", "userid=1", "") << endl;
	//for (int i = 0; i < 10; i++) {
	//	stringstream ss;
	//	ss << i + 1000;
	//	string temp;
	//	ss >> temp;
	//	sql->Add("JennyChat", "account", "`id`,`pswd`,`username`", "\"" + temp + "\",\"134345\",\"jenny" + temp + "\"");
	//}
	sql->Add("JennyChat", "friendlist", "`fid`,`fname`,`accountid`", "\"1\",\"jenny1\",\"1000\"");

	//sql->Del("JennyChat", "account", "username", "Jenny2");
#endif
    return 0;
}

