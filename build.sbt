
name := "MotifMaker"

version in ThisBuild := "0.3.0"

organization in ThisBuild := "com.pacbio"

scalaVersion in ThisBuild := "2.11.8"

//scalacOptions in ThisBuild := Seq("-unchecked", "-deprecation", "-encoding", "utf8", "-feature")
scalacOptions in ThisBuild := Seq("-encoding", "utf8")

def PacBioProject(name: String): Project = (
  Project(name, file(name))
    settings (
      libraryDependencies ++= Seq(
        "org.scala-lang.modules" %% "scala-xml" % "1.0.2",
        "com.github.scopt" %% "scopt" % "3.4.0",
        "au.com.bytecode" % "opencsv" % "2.4",
        "com.beust" % "jcommander" % "1.27",
        "org.specs2" % "specs2_2.11" % "2.4.1-scalaz-7.0.6" % "test"
      )
    )
  )
  .disablePlugins(plugins.JUnitXmlReportPlugin)
  .settings(
    testOptions in Test += Tests.Argument(TestFrameworks.Specs2, "junitxml", "console"))

lazy val motifMaker = PacBioProject("MotifMaker")
