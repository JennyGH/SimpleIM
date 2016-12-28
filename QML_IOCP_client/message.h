#ifndef MESSAGE_H
#define MESSAGE_H
#include <QObject>
#include <string>
using namespace std;

class Message : public QObject
{
    Q_OBJECT
public:
//    static Message* GetInstance();
    virtual string getType() const;
public:
    Message();
    virtual ~Message();
//    Message *instance;
protected:
    string type;
};

#endif // MESSAGE_H
