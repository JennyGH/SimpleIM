#include "stdafx.h"
#include "MYSQL.h"

CMYSQL* CMYSQL::m_Instance = nullptr;

CMYSQL::CMYSQL()
{
	//m_Instance = new CMYSQL();
	//&m_sql = new MYSQL;
}


CMYSQL::~CMYSQL()
{
	CloseSQL();
}

CMYSQL* CMYSQL::GetInstance()
{
	if(m_Instance == nullptr){
		m_Instance = new CMYSQL();
	}
	return m_Instance;
}

string CMYSQL::InitSQL(cstr host, cstr username, cstr pswd, cstr database,unsigned int port,cstr chara = "GBK")
{
	try {

		if (!mysql_init(&m_sql)) {

			cout << "数据库初始化失败" << endl;

			return "{\"SqlMsgType\":1,\"Result\":\"Fail to initialize MySQL...\"}";

		}
		if (!mysql_real_connect(&m_sql, host.c_str(), username.c_str(), pswd.c_str(), database.c_str(), port, NULL, 0)) {
			
			cout << "连接数据库失败..." << mysql_error(&m_sql) << endl;

			return "{\"SqlMsgType\":2,\"Result\":\"Fail to connect to MySQL...\"}";

		}
		if (mysql_set_character_set(&m_sql, chara.c_str()) != 0) {

			cout << "设置编码失败..." << endl;

			return "{\"SqlMsgType\":3,\"Result\":\"Fail to set the character of MySQL...\"}";
		}

	}
	catch (exception &err) {

		cout << "初始化数据库时发生异常：" << err.what() << endl;

		return "{\"SqlMsgType\":-1,\"Result\":\"Initialize Exception...\"}";

	}
	catch (...) {

		cout << "初始化数据库时发生未知错误..." << endl;

		return "{\"SqlMsgType\":5,\"Result\":\"Unknown Exception...\"}";
	
	}

	cout << "数据库初始化完成..." << endl;

	return "{\"SqlMsgType\":0,\"Result\":\"Initialize MySQL success...\"}";
}

string CMYSQL::Search(cstr database, cstr table, cstr col = "*", cstr whr = "", cstr like = "")
{
	try {

		if (mysql_select_db(&m_sql,database.c_str())) {

			cout << "转入数据库错误..." << mysql_error(&m_sql) << endl;

			return "{\"SqlMsgType\":1,\"Result\":\"Fail to use database\"}";

		}

		string query =
			"select " + col + " from " + table +
			(whr == "" ? "" : (" where " + whr)) +
			(like == "" ? "" : (" like " + like));

		//cout << "query:" << query << endl;

		if (mysql_real_query(&m_sql, query.c_str(),(unsigned int)query.length())) {

			cout << "查询失败..." << mysql_error(&m_sql) << endl;

			return "{\"SqlMsgType\":2,\"Result\":\"Fail to search...\"}";

		}

	}catch(exception &err){
		cout << "查询时出现异常：" << err.what() << endl;
		return "{\"SqlMsgType\":3,\"Result\":\"Search Exception...\"}";
	}
	catch (...) {
		cout << "查询时出现未知异常..." << endl;
		return "{\"SqlMsgType\":-1,\"Result\":\"Unknown Exception...\"}";
	}
	MYSQL_RES *res = mysql_store_result(&m_sql);//检索一个完整的结果集合给客户

	return getJSONResult(res);//将结果集处理成JSON格式
}

string CMYSQL::Add(cstr database, cstr table,cstr keys,cstr values)
{
	try {

		string query = "insert into `" + database + "`.`" + table + "` (" + keys + ") values (" + values + ")";

		if (mysql_real_query(&m_sql, query.c_str(), (unsigned int)query.length())) {

			cout << "插入失败..." << mysql_error(&m_sql) << endl;

			return "{\"SqlMsgType\":1,\"Result\":\"Fail to insert...\"}";

		}

	}
	catch (exception &err) {

		cout << "新增时出现异常：" << err.what() << endl;

		return "{\"SqlMsgType\":2,\"Result\":\"Insert Exception...\"}";

	}
	catch (...) {

		cout << "新增时出现未知异常..." << endl;

		return "{\"SqlMsgType\":-1,\"Result\":\"Unknown Exception...\"}";

	}
	return "{\"SqlMsgType\":0,\"Result\":\"Insert Success...\"}";
}

string CMYSQL::Del(cstr database, cstr table, cstr key, cstr value,cstr extra)
{
	//DELETE FROM `database`.`table` WHERE `key`='value';
	try {

		string query = "delete from `" + database + "`.`" + table + "` where `" + key + "`='" + value + "'" + (extra == "" ? "" : (" and " + extra));

		if (mysql_real_query(&m_sql, query.c_str(), (unsigned int)query.length())) {

			cout << "删除失败..." << mysql_error(&m_sql) << endl;

			return "{\"SqlMsgType\":1,\"Result\":\"Fail to delete...\"}";

		}

	}
	catch (exception &err) {

		cout << "删除时出现异常：" << err.what() << endl;

		return "{\"SqlMsgType\":2,\"Result\":\"Delete Exception...\"}";

	}
	catch (...) {

		cout << "删除时出现未知异常..." << endl;

		return "{\"SqlMsgType\":-1,\"Result\":\"Unknown Exception...\"}";

	}
	return "{\"SqlMsgType\":0,\"Result\":\"Delete Success...\"}";
}

string CMYSQL::Update(cstr database, cstr table, cstr set, cstr whr)
{
	//UPDATE `jennychat`.`account` SET `username`='ddd' WHERE `id`='13';
	try {

		string query = "UPDATE `" + database + "`.`" + table + "` set " + set + " where " + whr;

		if (mysql_real_query(&m_sql, query.c_str(), (unsigned int)query.length())) {

			cout << "修改失败..." << mysql_error(&m_sql) << endl;

			return "{\"SqlMsgType\":1,\"Result\":\"Fail to update...\"}";

		}

	}
	catch (exception &err) {

		cout << "修改时出现异常：" << err.what() << endl;

		return "{\"SqlMsgType\":2,\"Result\":\"Update Exception...\"}";

	}
	catch (...) {

		cout << "修改时出现未知异常..." << endl;

		return "{\"SqlMsgType\":-1,\"Result\":\"Unknown Exception...\"}";

	}
	return "{\"SqlMsgType\":0,\"Result\":\"Update Success...\"}";
}

bool CMYSQL::CheckConnect()
{
	if (mysql_ping(&m_sql)) {
		return false;
	}
	return true;
}

void CMYSQL::CloseSQL()
{
	mysql_close(&m_sql);
}

string CMYSQL::getJSONResult(MYSQL_RES *r)
{
	MYSQL_RES *res = r;
	MYSQL_ROW row;

	if (mysql_num_rows(r) == 0) {
		return "";
	}

	string json = "{\"SqlMsgType\":0,\"Result\":[";

	unsigned int colcount = mysql_num_fields(res);

	while ((row = mysql_fetch_row(res)) != NULL) {	//获取结果集数组row
		json += "[";
		for (int i = 0; i < colcount; i++) {
			json += "\"";
			json += row[i];
			json += "\"";
			if (i < colcount - 1) {
				json += ",";
			}
		}
		json += "],";
	}

	//MYSQL_FIELD *fields = mysql_fetch_fields(res);
	//for (int j = 0; j < fields->catalog_length; j++) {
	//	cout << fields->name << endl;
	//}
	json = json.substr(0, json.length() - 1);	//把最后多余的逗号去掉

	json += "]}";	//JSON格式收尾

	mysql_free_result(res);	//释放结果集使用的内存

	return json;
}

unsigned int CMYSQL::getColCount()
{
	return mysql_field_count(&m_sql);
}


