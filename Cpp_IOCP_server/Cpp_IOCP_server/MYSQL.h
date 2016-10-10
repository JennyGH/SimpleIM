#pragma once
#pragma comment(lib,"libmysql.lib") 
#pragma comment(lib, "Ws2_32.lib")
#include <WinSock2.h> 
//#include <Windows.h>
//#include <stdlib.h>
#include "mysql\include\my_global.h"
#include "mysql\include\mysql.h"
#include <string>
#include <iostream>
using namespace std;

typedef string cstr;
#define UNKNOWN_ERR -1

class CMYSQL
{
public:

	//��ȡʵ��
	static CMYSQL* GetInstance();
	
	//��ʼ��
	string InitSQL(cstr host, cstr username, cstr pswd, cstr database, unsigned int port,cstr chara);
	
	//��
	string Search(cstr database,cstr table,cstr col,cstr whr,cstr like);

	//��
	string Add(cstr database, cstr table, cstr keys, cstr values);

	//ɾ:DELETE FROM `jennychat`.`account` WHERE `id`='14';
	string Del(cstr database,cstr table,cstr key,cstr value);

	//��:UPDATE `jennychat`.`account` SET `username`='ddd' WHERE `id`='13';
	string Update(cstr database, cstr table, cstr set, cstr whr);

	//�ر����ݿ�
	void CloseSQL();

	~CMYSQL();

private://˽�к���

	//��ȡJSON��ʽ�����
	string getJSONResult(MYSQL_RES *res);

	//��ȡ����ֶ���
	unsigned int getColCount();

	CMYSQL();

private://˽������
	MYSQL m_sql;
	static CMYSQL* m_Instance;
};

