TEMPLATE = app
TARGET = myApp
QT += quick
CONFIG += c++17
HEADERS += src/SystemInfo.h src/Multitouch.h
SOURCES += main.cpp
RESOURCES += resources.qrc
LIBS += -lQt5Quick -lQt5Qml -lQt5Core -lQt5Gui
include(lib/lqtutils/lqtutils.pri)