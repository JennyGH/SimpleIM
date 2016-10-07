#pragma once
#include <queue>
#include <windows.h>
//#include<vcl.h>
class CWorkQueue;
class WorkItemBase
{
	virtual void   DoWork(void* pThreadContext) = 0;
	virtual void   Abort() = 0;
	friend CWorkQueue;
};
typedef std::queue<WorkItemBase*>           WorkItemQueue, *PWorkItemQueue;

class CWorkQueue
{
public:
	virtual ~CWorkQueue() {};
	bool Create(
		const unsigned int       nNumberOfThreads,
		void*                    *pThreadDataArray = NULL
	);
	bool InsertWorkItem(WorkItemBase* pWorkItem);
	void Destroy(int iWairSecond);
	int GetThreadTotalNum();
private:
	static unsigned long __stdcall ThreadFunc(void* pParam);
	WorkItemBase* RemoveWorkItem();
	int GetWorekQueueSize();
	enum {
		ABORT_EVENT_INDEX = 0,
		SEMAPHORE_INDEX,
		NUMBER_OF_SYNC_OBJ,
	};
	//申请到的线程
	PHANDLE                  m_phThreads;
	unsigned int             m_nNumberOfThreads;
	void*                    m_pThreadDataArray;
	HANDLE                   m_phSincObjectsArray[NUMBER_OF_SYNC_OBJ];
	CRITICAL_SECTION         m_CriticalSection;
	PWorkItemQueue           m_pWorkItemQueue;
};


