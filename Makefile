SHELL=/bin/bash

clean:
	sbt clean

build:
	sbt clean pack

unit-test:
	sbt test

cram-test:
	cram test/cram/*.t

tc-test:
	nosetests --with-xunit test/test_tool_contract.py

misc-tests: cram-test tc-test
