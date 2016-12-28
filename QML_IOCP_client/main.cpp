#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtPlugin>
#include <QtQml>
#include "client.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
//    qmlRegisterType<Client>("Client",1,0,"Client");
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("addMessage", new AddMessage());
    engine.rootContext()->setContextProperty("chatMessage", new ChatMessage());
    engine.rootContext()->setContextProperty("deleteMessage", new DeleteMessage());
    engine.rootContext()->setContextProperty("deletemessageMessage", new DeletemessageMessage());
    engine.rootContext()->setContextProperty("editMessage", new EditMessage());
    engine.rootContext()->setContextProperty("leavingmessageMessage", new LeavingmessageMessage());
    engine.rootContext()->setContextProperty("loginMessage", new LoginMessage());
    engine.rootContext()->setContextProperty("searchMessage", new SearchMessage());
    engine.rootContext()->setContextProperty("signinMessage", new SignInMessage());
    engine.rootContext()->setContextProperty("updateMessage", new UpdateMessage());
    engine.rootContext()->setContextProperty("client", Client::GetInstance());
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
