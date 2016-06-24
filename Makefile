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
# The maven artifact neccesary for this are included in ../../../smrtanalysis/prebuilt.out/maven/apache-maven-localrepos
# 
# We are using an updated maven (3.0.4) because it is required by the maven-scala-plugin
#
# PJM July 2012
#

G_TOPDIR              = ../../../..
JAVA_HOME            ?= $(shell echo `bash -c "cd $(G_TOPDIR)/smrtanalysis/prebuilt.out/java/java;pwd"`)
LOCAL_MVN_REPOSITORY := $(shell echo `bash -c "cd $(G_TOPDIR)/smrtanalysis/prebuilt.out/maven/apache-maven-localrepos;pwd"`)
MVN                  := $(G_TOPDIR)/smrtanalysis/prebuilt.out/maven/apache-maven-3.0.4/bin/mvn
SETTINGS_XML         := $(abspath settings.xml)
export JAVA_HOME
export LOCAL_MVN_REPOSITORY

build:
	$(MVN) -o -s $(SETTINGS_XML) compile

clean: 
	$(MVN) -o -s $(SETTINGS_XML) clean

package:
	$(MVN) -Dmaven.test.skip=true -o -s $(SETTINGS_XML) package
	
# Don't run tests for this rule - it will slow down the main secondary build
install: 
	$(MVN) -Dmaven.test.skip=true -o -s $(SETTINGS_XML) package
	install -d ${SEYMOUR_HOME}/analysis/lib/java
	install -d $(SEYMOUR_HOME)/analysis/bin
	install -m 777 target/*one-jar.jar ${SEYMOUR_HOME}/analysis/lib/java/
	install -m 777 bin/motifMaker ${SEYMOUR_HOME}/analysis/bin/
	install -m 777 bin/task_motifmaker_find ${SEYMOUR_HOME}/analysis/bin/
	install -m 777 bin/task_motifmaker_reprocess ${SEYMOUR_HOME}/analysis/bin/

test:
	$(MVN) -o -s $(SETTINGS_XML) test

.PHONY: install clean build test
