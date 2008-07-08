freshobjc_test: freshobjc_test.m freshobjc_test.h \
		FBXMLParser.m FBXMLParser.h \
		FBClient.m FBClient.h \
		FBObject.m FBObject.h \
		FBResponse.m FBResponse.h \
		test_account.h
	gcc -DDEBUG=1 -ggdb -o freshobjc_test -framework Foundation freshobjc_test.m FBXMLParser.m FBClient.m FBObject.m FBResponse.m

debug: freshobjc_test
	gdb freshobjc_test

test: freshobjc_test
	./freshobjc_test

clean:
	rm -f freshobjc_test
