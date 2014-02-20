MotifMaker
=========

Overview
--------
MotifMaker is a tool for identify motifs associated with DNA
modifications in prokaryotic genomes. Modified DNA in prokaryotes
commonly arises from restriction-modification systems that methylate a
specific base in a specific sequence motif.  The canonical example the
m6A methylation of adenine in GATC contexts in E.coli. Prokaryotes may
have a very large number of active restriction-modification systems
present, leading to a complicated mixture of sequence motifs.

PacBio SMRT sequencing is sensitive to the presence of methylated DNA
at single base resolution, via shifts in the polymerase kinetics
observed in the real-time sequencing traces.  See our publication for
more background on modification detection:
http://nar.oxfordjournals.org/content/early/2011/12/07/nar.gkr1146.full

Algorithm
---------
Existing motif finding algorithms such as MEME-chip and YMF are
sub-optimal for this case for the following reasons:

1. They search for a single motif, rather than attempting to identify a
   complicated mixture of motifs

2. They generally don't accept the notion of aligned motifs - the
   input to the tools is a window into the reference sequence which
   can contain the motif at any offset, rather a single center
   position that is available with kinetic modification detection.

3. Implementations generally either use a Markov model of the
   reference (MEME-chip), or do exact counting on the reference, but
   place restrictions on the size and complexity of the motifs that
   can be discovered.


Here we give a rough overview of the algorthim used by
MotifMaker. Define a motif as a set of (position relative to
methylation, required base) tuples. Positions not listed in the motif
are implicitly degenerate.  Given a list of modification detections
and a genome sequence, we define the following objective function on
motifs:

Motif score(motif) = (# of detections matching motif) / (# of genome sites matching motif)  *  (Sum of log-pvalue of detections matching motif)
                   = (fraction methylated) * (sum of log-pvalues of matches)

We search (close to exhaustively) through the space of all possible
motifs, progressively testing longer motifs using a branch-and-bound
search. The 'fraction methylated' term must be less than 1, so the
maximum achievable score of a child node is the sum of scores of
modification hits in the current node, permitting us to prune all
search paths whose maximum achievable score is less than the best
score discovered so far.



Usage
----

The jar supplied in target/motif-maker-0.2.one-jar.jar bundles all
dependencies and should be runnable on most systems. mvn package will
rebuild the one-jar jar if you make any code change.

For command-line motif finding, run the 'find' sub-command, and pass
the reference fasta and the modifications.gff(.gz) file emitted by the
PacBio modification detection workflow.  The reprocess command
annotates the the gff with motif information for better genome
browsing.

```
$ java -jar target/motif-maker-0.2.one-jar.jar

Usage: MotifMaker [options] [command] [command options]
  Options:
    -h, --help
                 Default: false
  Commands:
    find      Run motif finding
      Usage: find [options]
        Options:
        * -f, --fasta      Reference fasta file
        * -g, --gff        modifications.gff or .gff.gz file
          -m, --minScore   Minimum Qmod score to use in motif finding
                           Default: 40.0
        * -o, --output     Output motifs csv file
          -x, --xml        Output motifs xml file

    reprocess      Reprocess gff file with motif information
      Usage: reprocess [options]
        Options:
          -c, --csv           Raw modifications.csv file
        * -f, --fasta         Reference fasta file
        * -g, --gff           original modifications.gff or .gff.gz file
              --minFraction   Only use motifs above this methylated fraction
                              Default: 0.75
        * -m, --motifs        motifs csv
        * -o, --output        Reprocessed modifications.gff file
```
