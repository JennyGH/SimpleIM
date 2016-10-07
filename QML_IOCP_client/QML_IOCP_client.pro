TEMPLATE = app

QT += qml quick
CONFIG += c++11

SOURCES += main.cpp \
    client.cpp

RESOURCES += qml.qrc

LIBS += -lWS2_32

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    client.h \
    datapakage.h
