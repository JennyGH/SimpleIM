// Cpp_IOCP_server.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include "MYIOCPServer.h"
//#pragma comment(lib, "Kernel32.lib") 
#define SERVER 1

int main(int argc, char **argv)
{
#if SERVER
	if (argc <= 1) {
		CMYIOCPServer::setPswd("123456");
		//cout << sqlpswd << endl;
	}
	else {
		CMYIOCPServer::setPswd(argv[1]);
		//cout << sqlpswd << endl;
	}
	CMYIOCPServer* server = CMYIOCPServer::GetInstance();
	if (argc <= 2) {
		server->SetPort(9527);
		cout << "using port: 9527" << endl;
	}
	else {
		stringstream ss;
		ss << argv[2];
		int p;
		ss >> p;
		server->SetPort(p);
		cout << "using port: " << p << endl;
	}
	server->ServerSetUp();
#else
	CMYSQL *sql = CMYSQL::GetInstance();
	sql->InitSQL("localhost", "root", "123456", "JennyChat", 3306, "utf8");
	//cout << sql->Search("JennyChat", "account", "id,username", "userid=1", "") << endl;
	//for (int i = 0; i < 10; i++) {
	//	stringstream ss;
	//	ss << i + 1000;
	//	string temp;
	//	ss >> temp;
	//	sql->Add("JennyChat", "account", "`id`,`pswd`,`username`", "\"" + temp + "\",\"134345\",\"jenny" + temp + "\"");
	//}
	//sql->Del("JennyChat", "friendlist", "fid", "1003");
	cout << sql->Search("JennyChat", "friendlist", "fid", "(`accountid`='1' and `fid`='1007')", "")
		 << endl;
	//sql->Add("JennyChat", "friendlist", "`fid`,`fname`,`accountid`", "\"1\",\"jenny1\",\"1000\"");

	//sql->Del("JennyChat", "account", "username", "Jenny2");
#endif
    return 0;
}

