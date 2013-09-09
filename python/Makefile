#
# Robert Kotcher
# September 2013
# makefile for footprints (python)
#

# compiles the stuff this app needs
# note: every line of a makefile runs in its own shell
init:
	# install pkg-config, which is a dependency for pygtk
	cd lib/pkg-config-0.28; ./configure --with-internal-glib --prefix=/usr --disable-host-tool --docdir=/usr/share/doc/pkg-config-0.28; make; sudo make install
	cd lib/pygtk-2.24.0; ./configure --prefix=/usr/bin; make; make install
	echo '** Make sure you have GTK+ installed on your machine'
