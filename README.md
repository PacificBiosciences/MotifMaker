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


Output file descriptions:
-------------------------

Using the ``find`` command:

- Output csv file: This file follows the same format as the standard
  "Fields included in motif_summary.csv" described in the Methylome
  Analysis White Paper
  (https://github.com/PacificBiosciences/Bioinformatics-Training/wiki/Methylome-Analysis-Technical-Note).

- Output xml file: This is an output used by SMRT Portal and is not
  necessary using the command line. Simply do not include the -x
  command option. The information contained in this file is used to
  fill in the standard motif report table in SMRT Portal and is
  redundant with the CSV output file.

Using the ``reprocess`` command:
(Reprocessing will update a modifications.gff file with information based on new Modification QV thresholds)

- Output gff file: The format of the output file is the same as the
  input file, and is described in the Methylome Analysis White Paper
  (https://github.com/PacificBiosciences/Bioinformatics-Training/wiki/Methylome-Analysis-White-Paper)
  under "Fields included in the modifications.gff file".

DISCLAIMER
----------
THIS WEBSITE AND CONTENT AND ALL SITE-RELATED SERVICES, INCLUDING ANY DATA, ARE PROVIDED "AS IS," WITH ALL FAULTS, WITH NO REPRESENTATIONS OR WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, ANY WARRANTIES OF MERCHANTABILITY, SATISFACTORY QUALITY, NON-INFRINGEMENT OR FITNESS FOR A PARTICULAR PURPOSE. YOU ASSUME TOTAL RESPONSIBILITY AND RISK FOR YOUR USE OF THIS SITE, ALL SITE-RELATED SERVICES, AND ANY THIRD PARTY WEBSITES OR APPLICATIONS. NO ORAL OR WRITTEN INFORMATION OR ADVICE SHALL CREATE A WARRANTY OF ANY KIND. ANY REFERENCES TO SPECIFIC PRODUCTS OR SERVICES ON THE WEBSITES DO NOT CONSTITUTE OR IMPLY A RECOMMENDATION OR ENDORSEMENT BY PACIFIC BIOSCIENCES.
