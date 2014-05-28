
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
