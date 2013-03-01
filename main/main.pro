TARGET = avocado-cpp
TEMPLATE = app

CONFIG -= qt
CONFIG += exceptions precompile_header

QMAKE_LFLAGS += -rdynamic

PRECOMPILED_HEADER = avocado-global.h

!debug {
	CONFIG += silent
}

SOURCES += \
	\
	main.cpp \
	\
	FS.cpp \
	\
	Script/Script.cpp Script/ScriptService.cpp \
	Core/CoreService.cpp \
	Graphics/GraphicsService.cpp Graphics/Font.cpp Graphics/Image.cpp Graphics/Window.cpp \
	Timing/TimingService.cpp Timing/Counter.cpp \
	Sound/SoundService.cpp Sound/Sample.cpp Sound/Music.cpp

HEADERS += \
	\
	avocado-global.h deploy.h \
	\
	Factory.h \
	\
	FS.h \
	\
	SpiiLoader.h \
	Script/Script.h Script/ScriptService.h \
	Core/CoreService.h \
	Graphics/GraphicsService.h Graphics/Font.h Graphics/Image.h Ui/Window.h \
	Timing/TimingService.h Timing/Counter.h \ 
	Sound/SoundService.h Sound/Sample.h Sound/Music.h

INCLUDEPATH += deps ..

LIBS += -lboost_filesystem -lboost_regex -lboost_system -lboost_program_options

unix:OUT_DIR = obj/unix

OBJECTS_DIR = $$OUT_DIR

unix:QMAKE_CXXFLAGS += -ansi -Werror

main.path = ..
main.files += avocado-cpp
INSTALLS += main
