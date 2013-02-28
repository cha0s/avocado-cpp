TEMPLATE = lib

CONFIG -= qt
CONFIG += dll
CONFIG += debug

QMAKE_LFLAGS += -g

QMAKE_POST_LINK = cp $(TARGET) $${TARGET}.spii

PRECOMPILED_HEADER = ../../../main/avocado-global.h

!debug {
	CONFIG += silent
}

SOURCES += implementSpi.cpp

HEADERS += ../../../main/avocado-global.h

INCLUDEPATH += ../../.. ../../../main/deps

unix:OUT_DIR = obj/unix

OBJECTS_DIR = $$OUT_DIR

unix:QMAKE_CXXFLAGS += -ansi -Werror
