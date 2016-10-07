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
    engine.rootContext()->setContextProperty("client", new Client);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
