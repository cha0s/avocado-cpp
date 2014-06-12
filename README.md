# Avocado CPP execution context

# Building

In order to build this project, you will need:

* git (obviously, gotta get the sources somehow!)
* cmake
* g++ (on Ubuntu, do *sudo apt-get install build-essential*)
* Boost (specifically, the filesystem, program_options, regex, and system components)

and SFML dependencies:

* pthread
* opengl
* xlib
* xrandr
* freetype
* glew
* jpeg
* sndfile
* openal

and v8 dependencies:

* svn

First, check out the project:

```
git clone --recursive https://github.com/cha0s/avocado-cpp.git
```

(Note the --recursive flag)

Navigate to the avocado-cpp directory and run these commands:

```
mkdir build
cd build
cmake ..
make
```
