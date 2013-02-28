TARGET = avocado-test
TEMPLATE = app

CONFIG -= qt
CONFIG += exceptions precompile_header

QMAKE_LFLAGS += -rdynamic

PRECOMPILED_HEADER = ../main/avocado-global.h

!debug {
	CONFIG += silent
}

SOURCES += \
	main.cpp \
	\
	../main/FS.cpp ../main/FS.test.cpp

HEADERS += \
	\
	../main/avocado-global.h \
	\
	../main/FS.h

INCLUDEPATH += ../deps gtest/include

gtestlib.target = g
gtestlib.commands += \
	#
	# Google Test
	#
	echo "Building Google Test..."; \
	cd gtest; \
	#
	# Build it if it hasn't been.
	#
	test ! -d avocado \
		&& mkdir avocado \
		&& cd avocado \
		&& cmake .. \
		&& make \
		&& cd ..; \
	cd ..; \
	echo "Done building Google Test."; \
	echo "Building tests..."; \
	#
	# Build tests
	#
#	qmake; \
#	make -j4 && \
#	cd .. && \
#	echo "Done building tests..." && \
#	echo "Running tests..." && \
#	#
#	# Run tests
#	#
#	./avocado-test;

QMAKE_EXTRA_TARGETS += gtestlib

PRE_TARGETDEPS += g

LIBS += -Lgtest/avocado
LIBS += -lgtest -lpthread

LIBS += -lboost_filesystem -lboost_regex -lboost_system

unix:OUT_DIR = obj/unix

OBJECTS_DIR = $$OUT_DIR

unix:QMAKE_CXXFLAGS += -ansi -Werror
