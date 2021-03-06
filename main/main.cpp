
#include <iostream>

#include "avocado-global.h"

#include <boost/filesystem/operations.hpp>

#include <boost/program_options/options_description.hpp>
#include <boost/program_options/parsers.hpp>
#include <boost/program_options/variables_map.hpp>

#include "FS.h"
#include "Script/ScriptService.h"
#include "SpiiLoader.h"

namespace po = boost::program_options;

/** Application entry point. */
int main(int argc, char **argv) {
	AVOCADO_UNUSED(argc);

	try {

		// Declare the supported options.
		po::options_description desc("Allowed options");
		desc.add_options()
		    ("help", "produce help message")
		    (
		    	"exe-path",
		    	po::value<std::string>()->default_value(
		    		boost::filesystem::path(argv[0]).parent_path().string()
		    	),
		    	"set the execution path"
		    )
		    (
		    	"engine-root",
		    	po::value<std::string>()->default_value("."),
		    	"set the engine root"
		    )
		    (
		    	"resource-root",
		    	po::value<std::string>()->default_value(
	    			(boost::filesystem::path(".") / "resource").string()
		    	),
		    	"set the resource root"
		    )
		    (
		    	"script-spii",
		    	po::value<std::string>()->default_value("v8"),
		    	"set the script SPII"
		    )
		;

		po::variables_map vm;
		po::store(po::parse_command_line(argc, argv, desc), vm);
		po::notify(vm);

		if (vm.count("help")) {
		    std::cout << desc << "\n";
		    return 1;
		}

		boost::filesystem::path exePath = vm["exe-path"].as<std::string>();

		// Set <EXEPATH>.
		avo::FS::setExePath(boost::filesystem::canonical(boost::filesystem::absolute(
			exePath,
			boost::filesystem::current_path()
		)));

		boost::filesystem::path engineRoot = vm["engine-root"].as<std::string>();

		// The native main code's filepath.
		boost::filesystem::path scriptPath = avo::FS::exePath();

		boost::filesystem::path resourceRoot = vm["resource-root"].as<std::string>();

		// Set resource root to <EXEPATH>/resource.
		avo::FS::setResourceRoot(resourceRoot);

		// Load the Script SPII.
		std::string scriptSpii = vm["script-spii"].as<std::string>();
		avo::SpiiLoader spiiLoader;
		spiiLoader.implementSpi<avo::ScriptService>(scriptSpii);

		// Instantiate the Script system.
		avo::ScriptService *ScriptService = avo::ScriptService::factoryManager.instance()->create();

		// Bootstrap.
		ScriptService->loadScripts(scriptPath / "bootstrap", false);

		// Load avocado.
		ScriptService->loadScripts(engineRoot / "avocado" / "scripts");

		// Load C++ scripts.
		ScriptService->loadScripts(scriptPath / "scripts");

		// Load scripts.
		ScriptService->loadScripts(engineRoot / "scripts");

		avo::Script *main = ScriptService->scriptFromFile(
			scriptPath / "main.coffee"
		);

		// Execute the main loop.
		main->execute();

		delete main;

		delete ScriptService;
	}
	catch (std::exception &e) {

		// Report any errors.
		std::cerr << "Uncaught exception: " << e.what() << std::endl;
	}

	return 0;
}
