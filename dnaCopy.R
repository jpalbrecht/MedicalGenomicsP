library(DNAcopy)
setwd("/home/phil/ownCloud/documents_master/Aktuelle_Fragestellung_MedBio/FinalReport/")
cn <- read.table("n_m.copynumber",header=T)
CNA.object <-CNA( genomdat = cn[,7], chrom = cn[,1], maploc = cn[,2], data.type = 'logratio')
CNA.smoothed <- smooth.CNA(CNA.object)
segs <- segment(CNA.smoothed, verbose=0, min.width=2)
segs2 = segs$output
#write.table(segs2[,2:6], file="n_m-segmented.copynumber", row.names=F, col.names=F, quote=F, sep="\t")

seg.pvalue <- segments.p(segs, ngrid=100, tol=1e-6, alpha=0.05, search.range=100, nperm=1000)
#write.table (seg.pvalue, file="perl.input", row.names=F, col.names=F, quote=F, sep="\t")

