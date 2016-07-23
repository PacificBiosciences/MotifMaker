SHELL=/bin/bash

clean:
	sbt clean

build:
	sbt clean pack
