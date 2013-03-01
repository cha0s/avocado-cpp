#include <gtest/gtest.h>

#include "../core/FS.h"

int main(int argc, char **argv) {
	::testing::InitGoogleTest(&argc, argv);

	// Set <EXEPATH>.
	avo::FS::setExePath(
		boost::filesystem::canonical(boost::filesystem::absolute(
			boost::filesystem::path(argv[0]).parent_path(),
			boost::filesystem::current_path()
		))
	);

	// Set resource root to <EXEPATH>/test/resource.
	avo::FS::setResourceRoot(avo::FS::exePath() / "resource");

	// Set resource root to <EXEPATH>/test/resource.
	avo::FS::setEngineRoot("..");

	return RUN_ALL_TESTS();
}
