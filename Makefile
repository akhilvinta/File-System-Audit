#Aryaman Ladha, Akhil Vinta

TAR = tar
TARFLAGS = -czvf
TAREXT = gz
all-files = README Makefile FileSystemExploration.py executable.sh

default: FileSystem
clean:
	rm -f *.o FileSystemExploration.$(TAR).$(TAREXT) FileSystem
dist: FileSystemExploration.tar.gz
FileSystemExploration.tar.gz: default
	$(TAR) $(TARFLAGS) $@ $(all-files)
FileSystem: FileSystemExploration.py executable.sh
	rm -f FileSystem
	chmod +x executable.sh
	ln executable.sh FileSystem
	chmod +x FileSystem