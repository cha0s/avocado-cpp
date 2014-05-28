
add_executable(avocado-cpp
	
	main.cpp

)

target_link_libraries(avocado-cpp

	boost_filesystem
	boost_program_options
	boost_system
	
	avocado

	dl

)

add_custom_target(avocado-cpp-spii

	COMMAND mkdir -p ${CMAKE_CURRENT_LIST_DIR}/../SPII
	COMMAND cp ${CMAKE_CURRENT_BINARY_DIR}/../lib/*.spii ${CMAKE_CURRENT_LIST_DIR}/../SPII
	
)

add_dependencies(avocado-cpp avocado-cpp-spii)
