TEMPLATE = app
TARGET = scmd3
QT += core gui widgets

CONFIG += c++11

SOURCES += main.cpp

INCLUDEPATH += /usr/include/qt6 /usr/include/qt6/QtCore /usr/include/qt6/QtGui /usr/include/qt6/QtWidgets
LIBS += -L/usr/lib64/qt6 -lQt6Core -lQt6Gui -lQt6Widgets
