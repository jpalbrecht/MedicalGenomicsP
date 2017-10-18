library(ABSOLUTE)

setwd("/home/phil/ownCloud/documents_master/Aktuelle_Fragestellung_MedBio/FinalReport/")
#absSeq = read.table("absolute_try3.segment", header = TRUE)
plate.name <- "DRAWS"
genome <- "hg19"
platform <- "Illumina_WES"
primary.disease <- "Glioma"
sample.name <- "SRP055730"
sigma.p <- 0
max.sigma.h <- 0.02
min.ploidy <- 0.95
max.ploidy <- 3
max.as.seg.count <- 1500
max.non.clonal <- 0.8
max.neg.genome <- 0.5
maf.fn = "absolute.nothc.snp"
min.mut.af = 0.25
copy_num_type <- "total"
seg.dat.fn <- "ngCGH.absolute.chrOnly.negLog.segment"
results.dir <- file.path(".", "outputAbs", "absolute")
print(paste("Starting scan", "at", results.dir))
if (!file.exists(results.dir)) {
  dir.create(results.dir, recursive=TRUE)
}
RunAbsolute(seg.dat.fn, sigma.p, max.sigma.h, min.ploidy, max.ploidy, primary.disease,
            platform, sample.name, results.dir, max.as.seg.count, max.non.clonal,
            max.neg.genome, copy_num_type,maf.fn, min.mut.af, verbose=TRUE)

obj.name <- "SRP055730"
results.dir <- file.path(".", "outputAbs", "abs_summary")
absolute.files <- file.path(".", "outputAbs", "absolute", paste("SRP055730.ABSOLUTE.RData", sep=""))


CreateReviewObject(obj.name, absolute.files, results.dir, "total", plot.modes = TRUE, verbose=TRUE)
## At this point you'd perform your manual review and mark up the file 
## output/abs_summary/SRP055730.PP-calls_tab.txt by prepending a column with
## your desired solution calls. After that (or w/o doing that if you choose to accept
## the defaults, which is what running this code will do) run the following command:
calls.path = file.path("outputAbs", "abs_summary", "SRP055730.PP-calls_tab.txt")
modes.path = file.path("outputAbs", "abs_summary", "SRP055730.PP-modes.data.RData")
output.path = file.path("outputAbs", "abs_extract")
ExtractReviewedResults(calls.path, "SRP055730", modes.path, output.path, "absoluteAbs", "total")
