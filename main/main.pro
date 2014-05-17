TARGET = avocado-cpp
TEMPLATE = app

CONFIG -= qt
CONFIG += exceptions precompile_header

win32 {
	debug {
		CONFIG += console
	}
}

!debug {
	CONFIG += silent
}

SOURCES += \
	\
	main.cpp

HEADERS += \
	\
	../core/avocado-global.h \
	\
	../core/Factory.h \
	\
	../core/FS.h \
	\
	../core/SpiiLoader.h \
	../core/Script/Script.h ../core/Script/ScriptService.h \
	../core/Core/CoreService.h \
	../core/Graphics/GraphicsService.h ../core/Graphics/Canvas.h ../core/Graphics/Font.h ../core/Graphics/Image.h ../core/Graphics/Window.h \
	../core/Timing/TimingService.h ../core/Timing/Counter.h \ 
	../core/Sound/SoundService.h ../core/Sound/Sample.h ../core/Sound/Music.h

INCLUDEPATH += ../core/deps ..

win32 {
	debug {
		LIBS += -L../core/debug
	}
	else {
		LIBS += -L../core/release
	}
}
else {
	LIBS += -L../core
	LIBS += -lboost_filesystem -lboost_system
}
LIBS += -lavocado -lboost_program_options -ldl

win32:OUT_DIR = obj/win32
unix:OUT_DIR = obj/unix

OBJECTS_DIR = $$OUT_DIR

unix:QMAKE_CXXFLAGS += -ansi -Werror

main.path = ..
win32 {
	debug {
		main.files += debug/avocado-cpp.exe
	}
	else {
		main.files += release/avocado-cpp.exe
	}
}
else {
	main.files += avocado-cpp
}
INSTALLS += main
