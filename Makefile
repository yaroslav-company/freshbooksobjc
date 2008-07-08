freshobjc_test: freshobjc_test.m freshobjc_test.h FBXMLParser.m FBXMLParser.h
	gcc -ggdb -o freshobjc_test -framework Foundation freshobjc_test.m FBXMLParser.m

debug: freshobjc_test
	gdb freshobjc_test

test: freshobjc_test
	./freshobjc_test

clean:
	rm -f freshobjc_test
