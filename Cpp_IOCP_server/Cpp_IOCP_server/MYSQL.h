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

	//获取实例
	static CMYSQL* GetInstance();
	
	//初始化
	string InitSQL(cstr host, cstr username, cstr pswd, cstr database, unsigned int port,cstr chara);
	
	//查
	string Search(cstr database,cstr table,cstr col,cstr whr,cstr like);

	//增
	string Add(cstr database, cstr table, cstr keys, cstr values);

	//删:DELETE FROM `jennychat`.`account` WHERE `id`='14';
	string Del(cstr database,cstr table,cstr key,cstr value);

	//改:UPDATE `jennychat`.`account` SET `username`='ddd' WHERE `id`='13';
	string Update(cstr database, cstr table, cstr set, cstr whr);

	//关闭数据库
	void CloseSQL();

	~CMYSQL();

private://私有函数

	//获取JSON格式结果集
	string getJSONResult(MYSQL_RES *res);

	//获取表格字段数
	unsigned int getColCount();

	CMYSQL();

private://私有属性
	MYSQL m_sql;
	static CMYSQL* m_Instance;
};

