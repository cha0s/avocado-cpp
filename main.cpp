#include "avocado-global.h"

#include <boost/filesystem/operations.hpp>

#include <boost/program_options/options_description.hpp>
#include <boost/program_options/parsers.hpp>
#include <boost/program_options/variables_map.hpp>

#include "deploy.h"
#include "FS.h"
#include "SPI/Script/ScriptService.h"
#include "SPI/SpiiLoader.h"

namespace po = boost::program_options;

/** Application entry point. */
int main(int argc, char **argv) {
	AVOCADO_UNUSED(argc);

	try {

		// Declare the supported options.
		po::options_description desc("Allowed options");
		desc.add_options()
		    ("help", "produce help message")
		    ("deploy", po::value<std::string>(), "deployment target (native, web)")
		    ("exe-path", po::value<std::string>(), "set the execution path")
		    ("engine-root", po::value<std::string>(), "set the engine root")
		    ("resource-root", po::value<std::string>(), "set the resource root")
		;

		po::variables_map vm;
		po::store(po::parse_command_line(argc, argv, desc), vm);
		po::notify(vm);

		if (vm.count("help")) {
		    std::cout << desc << "\n";
		    return 1;
		}

		boost::filesystem::path exePath;
		if (vm.count("exe-path")) {
			exePath = vm["exe-path"].as<std::string>();
		}
		else {
			exePath = boost::filesystem::path(argv[0]).parent_path();
		}

		// Set <EXEPATH>.
		avo::FS::setExePath(boost::filesystem::canonical(boost::filesystem::absolute(
			exePath,
			boost::filesystem::current_path()
		)));

		boost::filesystem::path engineRoot;
		if (vm.count("engine-root")) {
			engineRoot = vm["engine-root"].as<std::string>();
		}
		else {
			engineRoot = ".";
		}

		// Set engine root.
		avo::FS::setEngineRoot(engineRoot);

		// The native main code's filepath.
		boost::filesystem::path scriptPath = avo::FS::exePath();

		boost::filesystem::path resourceRoot;
		if (vm.count("resource-root")) {
			resourceRoot = vm["resource-root"].as<std::string>();
		}
		else {
			resourceRoot = boost::filesystem::path(".") / "resource";
		}

		// Set resource root to <EXEPATH>/resource.
		avo::FS::setResourceRoot(resourceRoot);

		// We're only using v8 as a Script SPII (for now).
		avo::SpiiLoader<avo::ScriptService> scriptServiceSpiiLoader;
		scriptServiceSpiiLoader.implementSpi("v8");

		// Instantiate the Script system.
		avo::ScriptService *ScriptService = avo::ScriptService::factoryManager.instance()->create();

		// Initialize the engine.
		avo::Script *initialize = ScriptService->scriptFromFile(
			scriptPath / "Initialize.coffee"
		);
		initialize->execute();

		// Load avocado.
		ScriptService->loadScripts(avo::FS::engineRoot() / "avocado");

		// Load scripts.
		ScriptService->loadScripts(avo::FS::exePath() / "scripts");
		ScriptService->loadScripts(avo::FS::engineRoot() / "scripts");

		avo::Script *main = ScriptService->scriptFromFile(
			scriptPath / "Main.coffee"
		);

		if (vm.count("deploy")) {

//			// Do the deployment.
//			avo::deploy(
//				argv[0],
//				vm["deploy"].as<std::string>(),
//				scripts,
//				ScriptService
//			);
		}
		else {

			// Execute the main loop.
			main->execute();
		}

		delete main;
		delete initialize;

		delete ScriptService;
	}
	catch (std::exception &e) {

		// Report any errors.
		std::cerr << "Uncaught exception: " << e.what() << std::endl;
	}

	return 0;
}
