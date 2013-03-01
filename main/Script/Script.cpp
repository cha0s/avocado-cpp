#include "main/avocado-global.h"

#include "Script.h"

#include "main/FS.h"

namespace avo {

FactoryManager<Script> Script::factoryManager;

Script::Script()
{
}

Script::~Script() {
}

}
