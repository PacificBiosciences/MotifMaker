#
# ----------
# MotifMaker
# ----------
#
# NOTE -- this is a PacBio internal Makefile.  If you want to build this tool from source outside of PacBio
# just run:
#    mvn package
#
# Then you can execute the tool iwth:
#    java -jar target/motif*one-jar.jar
#
# The maven 'package' goal build a 'one-jar' jar that bundles all the dependencies of the tool.
#
# Build the Scala motif tool using the 'local-repo' maven style employed by the main PacBio java codebase (assembly/java)
# The maven artifact neccesary for this are included in assembly/third-party/apache-maven-localrepos
# 
# We are using an updated maven (3.0.4) because it is required by the maven-scala-plugin
#
# PJM July 2012
#

export JAVA_HOME?=$(shell echo `bash -c "cd ../../../assembly/third-party/java;pwd"`)
export LOCAL_MVN_REPOSITORY=$(shell echo `bash -c "cd ../../../assembly/third-party/apache-maven-localrepos;pwd"`)

MVN=../../../assembly/third-party/apache-maven-3.0.4/bin/mvn
SETTINGS_XML=$(abspath settings.xml)

build:
	$(MVN) -o -s $(SETTINGS_XML) compile

clean: 
	$(MVN) -o -s $(SETTINGS_XML) clean
	
# Don't run tests for this rule - it will slow down the main secondary build
install: 
	$(MVN) -Dmaven.test.skip=true -o -s $(SETTINGS_XML) package
	install -d ${SEYMOUR_HOME}/analysis/lib/java
	install -d $(SEYMOUR_HOME)/analysis/bin
	install -m 777 target/*one-jar.jar ${SEYMOUR_HOME}/analysis/lib/java/
	install -m 777 motifMaker.sh ${SEYMOUR_HOME}/analysis/bin/

test:
	$(MVN) -o -s $(SETTINGS_XML) test

.PHONY: install clean build test
