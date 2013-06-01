TARGET = avocado-cpp
TEMPLATE = app

CONFIG -= qt
CONFIG += exceptions precompile_header

win32 {
	debug {
		CONFIG += console
	}
}
else {
	QMAKE_LFLAGS += -rdynamic
}

PRECOMPILED_HEADER = ../core/avocado-global.h

!debug {
	CONFIG += silent
}

SOURCES += \
	\
	main.cpp \
	\
	../core/FS.cpp \
	\
	../core/Script/Script.cpp ../core/Script/ScriptService.cpp \
	../core/Core/CoreService.cpp \
	../core/Graphics/GraphicsService.cpp ../core/Graphics/Canvas.cpp ../core/Graphics/Font.cpp ../core/Graphics/Image.cpp ../core/Graphics/Window.cpp \
	../core/Timing/TimingService.cpp ../core/Timing/Counter.cpp \
	../core/Sound/SoundService.cpp ../core/Sound/Sample.cpp ../core/Sound/Music.cpp

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

LIBS += -lboost_filesystem -lboost_regex -lboost_system -lboost_program_options

win32 {
	LIBS += -ldl
}

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
