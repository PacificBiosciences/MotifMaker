package com.pacbio.basemods

import org.junit._
import Assert._

class QuickTest {
  
  
  def getTestFile(filename : String) =
  {
    var url = this.getClass().getResource("/" + filename)
    var f = new java.io.File(url.getFile())
    f.getPath()
  }
  
  
  @Test
  def makeXml() =
  {
    var s = MotifUtils.loadMotifCsv(getTestFile("hpylori-motifs2.csv"), 0.0)
    //MotifSummary.makeXmlTable(s, "test-table.xml")
  }
    
  
  @Test def hetMerge()
  {
    var l1 = List(10,11,12,20,30)
    var l2 = List(1,2,3,25,35)
    
    var m = (new HetMerge[Int,Int,Int](l1, e=>e, l2, e=>e)).toList
    
    var all = m map { case Left(i) => i; case Right(i) => i; case Both(i,_) => i }
    
   assertEquals(all, List(1,2,3,10,11,12,20,25,30,35))
   
   
   l1 = List(0,1,2,3,7)
   l2 = List(1,2,3,3,4)
   
   m = (new HetMerge[Int,Int,Int](l1, e=>e, l2, e=>e)).toList
   
   var expected = List(Left(0), Both(1, List(1)), Both(2, List(2)), Both(3, List(3,3)), Right(4), Left(7))
   
   assertEquals(expected, m)
   
   
   
   
  }
  
  
  @Test def gffLoad()
  {
    var f = getTestFile("modifications.gff.gz");
    val gffData = Gff.loadGff(f)
    
    val row0 = gffData.rows(0)
    
    assertEquals(row0.startPos, 42)
    assertEquals(row0.score, 36, 1e-5)
    
    assertEquals(gffData.headers.length, 4)
    assertEquals(gffData.rows.length, 149175)
  }
  /*
  @Test def fastaLoad()
  {
    var f = getTestFile("Geobacter_metallireducens_gDNA.fasta")
    var fastaData = Reader.readFastaContigs(f)
    
    assertEquals(fastaData(0).length, 3997420)
  }
  */
  
  @Test def genomePointerCompare()
  {
    var p1 = GenomePointer(0, 279, 0)
    
    var p2 = GenomePointer(0,279,0)
    
    assertTrue(PointerCompare.compare(p1, p2) == 0)   
    
  }
  
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
  
  /*
  @Test def searchFirstMotif()
  {
    // Look for the first motif in Geobacter
    var fasta = getTestFile("Geobacter_metallireducens_gDNA.fasta")    
    var genome = Reader.makeGenomeInfo(Reader.readFasta(fasta))    
    
    var mods = Program.loadModificationsGff(getTestFile("modifications.gff.gz"), 90)    
    
    // Find the first motif
    val r = MotifMixture.search(genome, mods)
    
    // Check it is what we expect
    val motifString = Motif.cutString(r.cuts)    
    assertEquals("GATCC", motifString)    
    assertTrue(r.fractionHit > 0.90)
  }
  */
  
  
  
}