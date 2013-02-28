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
	../SPI/Abstract/Script/Script.cpp ../SPI/Abstract/Script/ScriptService.cpp \
	../SPI/Abstract/Core/CoreService.cpp \
	../SPI/Abstract/Graphics/GraphicsService.cpp ../SPI/Abstract/Graphics/Font.cpp ../SPI/Abstract/Graphics/Image.cpp ../SPI/Abstract/Graphics/Window.cpp \
	../SPI/Abstract/Timing/TimingService.cpp ../SPI/Abstract/Timing/Counter.cpp \
	../SPI/Abstract/Sound/SoundService.cpp ../SPI/Abstract/Sound/Sample.cpp ../SPI/Abstract/Sound/Music.cpp

HEADERS += \
	\
	avocado-global.h deploy.h \
	\
	Factory.h \
	\
	FS.h \
	\
	../SPI/Abstract/SpiiLoader.h \
	../SPI/Abstract/Script/Script.h ../SPI/Abstract/Script/ScriptService.h \
	../SPI/Abstract/Core/CoreService.h \
	../SPI/Abstract/Graphics/GraphicsService.h ../SPI/Abstract/Graphics/Font.h ../SPI/Abstract/Graphics/Image.h ../SPI/Abstract/Ui/Window.h \
	../SPI/Abstract/Timing/TimingService.h ../SPI/Abstract/Timing/Counter.h \ 
	../SPI/Abstract/Sound/SoundService.h ../SPI/Abstract/Sound/Sample.h ../SPI/Abstract/Sound/Music.h

INCLUDEPATH += deps ..

LIBS += -lboost_filesystem -lboost_regex -lboost_system -lboost_program_options

unix:OUT_DIR = obj/unix

OBJECTS_DIR = $$OUT_DIR

unix:QMAKE_CXXFLAGS += -ansi -Werror

main.path = ..
main.files += avocado-cpp
INSTALLS += main
