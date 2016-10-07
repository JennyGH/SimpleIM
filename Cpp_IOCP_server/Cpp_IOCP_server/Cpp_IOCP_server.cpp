// Cpp_IOCP_server.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include "MYIOCPServer.h"
//#pragma comment(lib, "Kernel32.lib") 

int main()
{
	CMYIOCPServer* server = CMYIOCPServer::GetInstance();
	server->SetPortW(5150);
	server->ServerSetUp();
    return 0;
}

