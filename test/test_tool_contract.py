
import unittest
import os.path

import pbcommand.testkit

ROOT_DIR = os.path.dirname(os.path.dirname(__file__))
DATA_DIR = os.path.join(ROOT_DIR, "src", "test", "resources")
os.environ["PACBIO_TEST_ENV"] = "1" # XXX ugly hack to deal with java paths


class TestMotifMakerFind(pbcommand.testkit.PbTestApp):
    DRIVER_BASE = os.path.join(ROOT_DIR, "bin", "task_motifmaker_find")
    REQUIRES_PBCORE = True
    INPUT_FILES = [
        os.path.join(DATA_DIR, "mods_TGATCCAGG.gff"),
        os.path.join(DATA_DIR, "Geobacter_metallireducens_gDNA.fasta"),
    ]
    TASK_OPTIONS = {
        "motif_maker_find.task_options.min_score" : 30.0,
    }


class TestMotifMakerReprocess(pbcommand.testkit.PbTestApp):
    DRIVER_BASE = os.path.join(ROOT_DIR, "bin", "task_motifmaker_reprocess")
    REQUIRES_PBCORE = True
    INPUT_FILES = [
        os.path.join(DATA_DIR, "mods_TGATCCAGG.gff"),
        os.path.join(DATA_DIR, "motifs.csv"),
        os.path.join(DATA_DIR, "Geobacter_metallireducens_gDNA.fasta"),
    ]
    TASK_OPTIONS = {
        "motif_maker_reprocess.task_options.min_fraction": 0.0,
    }


if __name__ == "__main__":
    unittest.main()
