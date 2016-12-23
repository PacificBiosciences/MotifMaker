
import java.nio.file.{Paths, Files}

import org.specs2.mutable._

import com.pacbio.basemods._


class MotifMakerSpec extends Specification {

  def getTestFile(filename : String) = {
    val url = getClass.getResource(filename)
    val f = new java.io.File(url.getFile())
    f.getPath()
  }

  "Test utility functions" should {
    "Import CSV and convert to XML" in {
      val s = MotifUtils.loadMotifCsv(getTestFile("hpylori-motifs2.csv"), 0.0)
      s must not beNull
      //MotifSummary.makeXmlTable(s, "test-table.xml")
    }
    "Test HetMerge API" in {
      var l1 = List(10,11,12,20,30)
      var l2 = List(1,2,3,25,35)
      var m = (new HetMerge[Int,Int,Int](l1, e=>e, l2, e=>e)).toList
      val all = m map { case Left(i) => i; case Right(i) => i; case Both(i,_) => i }
      all must beEqualTo(List(1,2,3,10,11,12,20,25,30,35))
      l1 = List(0,1,2,3,7)
      l2 = List(1,2,3,3,4)
      m = (new HetMerge[Int,Int,Int](l1, e=>e, l2, e=>e)).toList
      val expected = List(Left(0), Both(1, List(1)), Both(2, List(2)), Both(3, List(3,3)), Right(4), Left(7))
      m must beEqualTo(expected)
    }
    "Load basemods GFF file" in {
      val f = getTestFile("modifications.gff.gz");
      val gffData = Gff.loadGff(f)
      val row0 = gffData.rows(0)
      row0.startPos must beEqualTo(42)
      row0.score.toDouble must beCloseTo(36.0, 1e-5)
      gffData.headers.length must beEqualTo(4)
      gffData.rows.length must beEqualTo(149175)
    }
    "Load FASTA file" in {
      val f = getTestFile("Geobacter_metallireducens_gDNA.fasta")
      val fastaData = Reader.readFastaContigs(f)
      fastaData(0)._2.length must beEqualTo(3997420)
    }
    "Test GenomePointer comparison" in {
      var p1 = GenomePointer(0, 279, 0)
      var p2 = GenomePointer(0,279,0)
      PointerCompare.compare(p1, p2) must beEqualTo(0)
    }
  }

  // FIXME these need to be brought up to date
  //"Test motif finding" should {
/*
  @Test def searchCountSubCuts()
  {
    // Look for the first motif in Geobacter
    var fasta = getTestFile("Geobacter_metallireducens_gDNA.fasta")
    var genome = Reader.makeGenomeInfo(fasta)

    var mods = Program.loadModificationsGff(getTestFile("modifications.gff.gz"), 90)


    var allInstances = MotifMixture.allGenomeInstances(genome)


    var c1 = MotifMixture.countSubCuts(genome, allInstances)
    var c2 = MotifMixture.countSubCutsPar(genome, allInstances)

    for(i <- 0 until c1.length)
      for(j <- 0 until c1(i).length)
        assertEquals(c1(i)(j), c2(i)(j))
  }
*/

    /*"Search for first motif" in {
      // Look for the first motif in Geobacter
      val fasta = getTestFile("Geobacter_metallireducens_gDNA.fasta")
      val genomeInfo = Reader.makeGenomeInfo(fasta)
      val mods = Program.loadModificationsGff(getTestFile("modifications.gff.gz"), 30.0, genomeInfo)
      val r = MotifMixture.loopSearch(genomeInfo, mods)
      val motifString = Motif.cutString(r(0).cuts)
      motifString must beEqualTo("GATCC")
      r(0).fractionHit.toDouble must beGreaterThan(0.90)
    }
  }*/
}
