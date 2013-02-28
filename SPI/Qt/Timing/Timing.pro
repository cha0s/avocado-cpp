TARGET = TimingService-qt

include(../../Abstract/Timing/Timing.pri)

CONFIG += qt

SOURCES += \
	\
	QtTimingService.cpp \
	\
	QtCounter.cpp

HEADERS += \
	\
	QtTimingService.h \
	\
	QtCounter.h
