TEMPLATE = lib

CONFIG -= qt
CONFIG += dll
CONFIG += debug

QMAKE_LFLAGS += -g

QMAKE_POST_LINK = cp $(TARGET) $${TARGET}.spii

PRECOMPILED_HEADER = ../../../core/avocado-global.h

!debug {
	CONFIG += silent
}

SOURCES += implementSpi.cpp

HEADERS += ../../../core/avocado-global.h

INCLUDEPATH += ../../.. ../../../core/deps

unix:OUT_DIR = obj/unix

OBJECTS_DIR = $$OUT_DIR

unix:QMAKE_CXXFLAGS += -ansi -Werror
