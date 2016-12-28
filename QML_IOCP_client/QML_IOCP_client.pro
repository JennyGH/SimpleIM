TEMPLATE = app

QT += qml quick
CONFIG += c++11

SOURCES += main.cpp \
    client.cpp \
    message.cpp \
    loginmessage.cpp \
    chatmessage.cpp \
    searchmessage.cpp \
    updatemessage.cpp \
    addmessage.cpp \
    editmessage.cpp \
    deletemessage.cpp \
    signinmessage.cpp \
    leavingmessagemessage.cpp \
    deletemessagemessag.cpp

RESOURCES += qml.qrc

#LIBS += -lWS2_32

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    client.h \
    datapakage.h \
    message.h \
    loginmessage.h \
    chatmessage.h \
    searchmessage.h \
    updatemessage.h \
    addmessage.h \
    editmessage.h \
    deletemessage.h \
    signinmessage.h \
    leavingmessagemessage.h \
    headfiles.h \
    deletemessagemessage.h
