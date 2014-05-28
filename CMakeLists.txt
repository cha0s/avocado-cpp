cmake_minimum_required(VERSION 2.8)

if(NOT DEFINED AVOCADO_CPP_CORE_DIRECTORY)
	message(STATUS "Avocado CPP core will use the ./core directory by default...")
	set(AVOCADO_CPP_CORE_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/core)
endif()

if(NOT EXISTS ${AVOCADO_CPP_CORE_DIRECTORY})
	message(FATAL_ERROR "Avocado CPP core is not available!")
endif()

include(${AVOCADO_CPP_CORE_DIRECTORY}/CMakeLists-core.txt)

project(avocado-cpp)

set(LIBRARY_OUTPUT_PATH "${PROJECT_BINARY_DIR}/lib")

add_subdirectory(core)
add_subdirectory(SPI)
add_subdirectory(main)
