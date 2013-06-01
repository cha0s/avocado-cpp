TEMPLATE = subdirs

CONFIG += ordered

SUBDIRS += $$system(find -maxdepth 1 -mindepth 1 -type d)

QMAKE_CLEAN += ../SPII/*.spii $$system('find -mindepth 3 -maxdepth 3 -name "*.so*" -o -name "*.spii"')
