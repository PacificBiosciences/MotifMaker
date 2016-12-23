
import unittest
import re
import os.path

import pbcommand.testkit

ROOT_DIR = os.path.dirname(os.path.dirname(__file__))
DATA_DIR = os.path.join(ROOT_DIR, "src", "test", "resources")
os.environ["PACBIO_TEST_ENV"] = "1" # XXX ugly hack to deal with java paths
os.environ["PATH"] = os.environ["PATH"] + ":" + os.path.join(ROOT_DIR, "target", "pack", "bin")


class TestMotifMakerFind(pbcommand.testkit.PbTestApp):
    DRIVER_BASE = os.path.join(ROOT_DIR, "bin", "task_motifmaker_find")
    REQUIRES_PBCORE = True
    INPUT_FILES = [
        os.path.join(DATA_DIR, "basemods_simple.gff"),
        os.path.join(DATA_DIR, "genome_simple.fasta"),
    ]
    TASK_OPTIONS = {
        "motif_maker_find.task_options.min_score" : 30.0,
    }

    def run_after(self, rtc, output_dir):
        motifs = set()
        with open(rtc.task.output_files[0]) as csv:
            for line in csv.readlines()[1:]:
                motifs.add(re.sub('"', "", line.split(",")[0]))
        self.assertEqual(motifs, set(["GTAC","CTAG"]))


class TestMotifMakerReprocess(pbcommand.testkit.PbTestApp):
    DRIVER_BASE = os.path.join(ROOT_DIR, "bin", "task_motifmaker_reprocess")
    REQUIRES_PBCORE = True
    INPUT_FILES = [
        os.path.join(DATA_DIR, "basemods_simple.gff"),
        os.path.join(DATA_DIR, "motifs_simple.csv"),
        os.path.join(DATA_DIR, "genome_simple.fasta"),
    ]
    TASK_OPTIONS = {
        "motif_maker_reprocess.task_options.min_fraction": 0.0,
    }


if __name__ == "__main__":
    unittest.main()
