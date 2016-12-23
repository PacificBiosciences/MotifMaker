Test command-line execution of MotifMaker.

  $ EXE="$TESTDIR/../../target/pack/bin/motifMaker"
  $ DATA="$TESTDIR/../../src/test/resources"
  $ GFF="$DATA/basemods_simple.gff"
  $ FASTA="$DATA/genome_simple.fasta"

Try running with the data used for unit tests (trimmed down to a subset of motifs):

  $ $EXE find --gff $GFF --fasta $FASTA --output motifs_test.csv
  Motif Searching...
  Motif Refinement...
  Found motif: GTAC
  Motif Searching...
  Motif Refinement...
  Found motif: CTAG
  Not enough modifications left to cluster
  Got results:
  MotifSummary(*,52,106,*,100.0,4.0,100.0,GTAC,2,modified_base,Some(GTAC),Some(GTAC)) (glob)
  MotifSummary(*,49,100,0.49,100.0,4.0,100.0,CTAG,2,modified_base,Some(CTAG),Some(CTAG)) (glob)
  $ wc -l motifs_test.csv
  3 motifs_test.csv
