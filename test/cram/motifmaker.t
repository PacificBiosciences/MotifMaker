Test command-line execution of MotifMaker.

  $ JAVA="$TESTDIR/../../../../../../prebuilt.out/java/java/bin/java"
  $ DATA="$TESTDIR/../../src/test/resources"
  $ JAR_FILE="$TESTDIR/../../target/motif-maker-0.2.one-jar.jar"
  $ GFF="$DATA/mods_TGATCCAGG.gff"
  $ FASTA="$DATA/Geobacter_metallireducens_gDNA.fasta"

For some reason the help output includes unnecessary whitespace at the end of
certain lines...

  $ $JAVA -jar $JAR_FILE
  Usage: MotifMaker [options] [command] [command options]
    Options:
      -h, --help   
                   Default: false
    Commands:
      find      Run motif finding
        Usage: find [options]      
          Options:
          * -f, --fasta         Reference fasta file
          * -g, --gff           modifications.gff or .gff.gz file
            -m, --minScore      Minimum Qmod score to use in motif finding
                                Default: 30.0
          * -o, --output        Output motifs csv file
            -p, --parallelize   Parallelize motif finder
                                Default: true
            -x, --xml           Output motifs xml file
  
      reprocess      Reprocess gff file with motif information
        Usage: reprocess [options]      
          Options:
            -c, --csv           Raw modifications.csv file
          * -f, --fasta         Reference fasta file
          * -g, --gff           original modifications.gff or .gff.gz file
                --minFraction   Only use motifs above this methylated fraction
                                Default: 0.0
          * -m, --motifs        motifs csv
          * -o, --output        Reprocessed modifications.gff file
  
  

Now try running with the data used for unit tests (trimmed down to a subset of motifs):

  $ $JAVA -jar $JAR_FILE find --gff $GFF --fasta $FASTA --output motifs_test.csv
  Motif Searching...
  Motif Refinement...
  Found motif: TGATCCAGG
  Motif Searching...
  Motif Refinement...
  Found motif: TGATCCAGG
  Motif Searching...
  Motif Refinement...
  Found motif: TGATBCAGG
  Motif Searching...
  Motif Refinement...
  Got results:
  MotifSummary(*,TGATCCAGG,2,modified_base,Some(TGATCCAGG),None) (glob)
  MotifSummary(*,TGATCCAGG,6,modified_base,Some(TGATCCAGG),None) (glob)
  $ wc -l motifs_test.csv
  3 motifs_test.csv
