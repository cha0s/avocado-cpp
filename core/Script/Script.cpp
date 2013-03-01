#include "core/avocado-global.h"

#include "Script.h"

#include "core/FS.h"

namespace avo {

FactoryManager<Script> Script::factoryManager;

Script::Script()
{
}

Script::~Script() {
}

}
