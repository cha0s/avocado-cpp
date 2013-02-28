TEMPLATE = subdirs

CONFIG += ordered

SUBDIRS += SPI main

#QMAKE_CLEAN += ../SPII/*.spii $$system('find -mindepth 3 -maxdepth 3 -name "*.so*" -o -name "*.spii"')
#
#spiis.path = ../SPII
#spiis.files += $$system('find -name "*.spii"')
#INSTALLS += spiis
