TARGET = TimingService-sfml

include(../../Abstract/Timing/Timing.pri)

SOURCES += \
	\
	SfmlTimingService.cpp \
	\
	SfmlCounter.cpp

HEADERS += \
	\
	SfmlTimingService.h \
	\
	SfmlCounter.h

INCLUDEPATH += ../deps/SFML/include
LIBS += -L../deps/SFML/build/lib
LIBS += -lsfml-system-s -lrt
	