// Cpp_IOCP_server.cpp : �������̨Ӧ�ó������ڵ㡣
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

