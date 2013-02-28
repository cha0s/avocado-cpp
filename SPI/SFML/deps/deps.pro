TEMPLATE = lib

sfmllib.commands += \
	echo "Building dependencies..."; \
	#
	# Test for binaries.
	#
	`type git >/dev/null 2>&1` || exit 1; \
	#
	# SFML
	#
	echo "Building SFML..."; \
	#
	# Checkout the SFML git repository if it hasn't been yet.
	#
	test ! -d SFML \
		&& git clone git://github.com/LaurentGomila/SFML.git; \
	cd SFML; \
	#
	# Build SFML if necessary.
	#
	test ! -d build \
		&& mkdir build \
		&& cd build \
		&& cmake -DBUILD_SHARED_LIBS=off .. \
		&& make \
		&& cd .. \
	cd ../..; \
	echo "Done building SFML.";
	
sfmllib.target = s

QMAKE_EXTRA_TARGETS += sfmllib

PRE_TARGETDEPS += s

QMAKE_POST_LINK = rm libdeps*
