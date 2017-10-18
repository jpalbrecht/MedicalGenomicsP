# ## librarys
 library(PurBayes)
# options(warn=2)
# ### functions
# extractInfo = function (vcfLine, dp4){
#     rowN = strsplit(as.character(vcfLine),split = ":")[[1]]
#     ###  DP4 field
#     tmp = rowN[posDP]
#     # extract numbers
#     tmp = sapply(strsplit(tmp,split = "\\.|,")[[1]],as.integer)
#     # make data frame for the row
#     tmp = data.frame(fRef=tmp[1], rRef=tmp[2], fAlt=tmp[3], rAlt=tmp[4], stringsAsFactors=FALSE, row.names = line)
#     # combine data frames
#     dp4 = rbind.data.frame(dp4,tmp, stringsAsFactors=FALSE)
#     return(dp4)
# }
# 
# 
 setwd("/home/phil/ownCloud/documents_master/Aktuelle_Fragestellung_MedBio/FinalReport/")
# 
# # read DP4 fields
# print("Read Data...")
# som = read.table("malignant-0.8.snp.Somatic.hc.vcf", stringsAsFactors = F)
# germ = read.table("malignant-0.8.snp.Germline.hc.vcf", stringsAsFactors = F)
# #
# colnames(som) =  c("CHROM","POS","ID","REF","ALT","QUAL","FILTER","INFO","FORMAT","NORMAL","TUMOR")
# colnames(germ) =  c("CHROM","POS","ID","REF","ALT","QUAL","FILTER","INFO","FORMAT","NORMAL","TUMOR")
# 
# ### preprocessing ###
# print("Preprocessing...")
# # assess DP4 field - assuming format is same for every row and for germline and somatic
# if (grepl("DP4",som[,"FORMAT"][1])){
#   # get position of DP4 field
#   posDP = grep("DP4" ,strsplit(as.character(som[,"FORMAT"][1]),split = ":")[[1]])
# }else{
#   stop("ERROR: Wrong format!")
# }
# 
# # assess FREQ field - assuming format is same for every row and for germline and somatic
# if (grepl("FREQ",som[,"FORMAT"][1])){
#   # get position of FREQ field
#   posFREQ = grep("FREQ" ,strsplit(as.character(som[,"FORMAT"][1]),split = ":")[[1]])
# }else{
#   stop("ERROR: Wrong format!")
# }
# 
# ### initialization ###
# #1) forward ref alleles; 2) reverse ref; 3) forward non-ref; 4) reverse non-ref alleles
# som_dp4T = data.frame("fRef"=integer(),"rRef"=integer(), "fAlt"=integer(), "rAlt"=integer(), stringsAsFactors=FALSE)
# som_dp4N = data.frame("fRef"=integer(),"rRef"=integer(), "fAlt"=integer(), "rAlt"=integer(), stringsAsFactors=FALSE)
# som_freqT = c()
# som_freqN = c()
# germ_dp4T = data.frame("fRef"=integer(),"rRef"=integer(), "fAlt"=integer(), "rAlt"=integer(), stringsAsFactors=FALSE)
# germ_dp4N = data.frame("fRef"=integer(),"rRef"=integer(), "fAlt"=integer(), "rAlt"=integer(), stringsAsFactors=FALSE)
# germ_freqN = c()
# germ_freqT = c()
# 
# ### processing ###
# print("Process somatic input...")
# # get info somatic
# for (line in 1:nrow(som)) {
#   if (grepl("DP4",som[,"FORMAT"][line])){
#     som_dp4N = extractInfo(som[,"NORMAL"][line], som_dp4N)
#     som_dp4T = extractInfo(som[,"TUMOR"][line], som_dp4T)
#     ### FREQ field tumor
#     tmp = strsplit(as.character(som[,"TUMOR"][line]),split = ":")[[1]][posFREQ]
#     # remove % and replace "," with "."
#     tmp = as.numeric(gsub(",",".",gsub("%", "",tmp)))
#     som_freqT = c(som_freqT, tmp)
#     ### FREQ field normal
#     tmp = strsplit(as.character(som[,"NORMAL"][line]),split = ":")[[1]][posFREQ]
#     # remove %
#     tmp = as.numeric(gsub(",",".",gsub("%", "",tmp)))
#     som_freqN = c(som_freqN, tmp)
#   }else {
#     stop("ERROR: Wrong Format!")
#   }
# }
# # adding sums of REF and ALT
# som_dp4T = cbind(som_dp4T,Ref = som_dp4T$fRef + som_dp4T$rRef, Alt = som_dp4T$fAlt + som_dp4T$rAlt)
# som_dp4T = cbind(som_dp4T, Sum = som_dp4T$Ref + som_dp4T$Alt)
# som_dp4N = cbind(som_dp4N,Ref = som_dp4N$fRef + som_dp4N$rRef, Alt = som_dp4N$fAlt + som_dp4N$rAlt)
# som_dp4N = cbind(som_dp4N, Sum = som_dp4N$Ref + som_dp4N$Alt)
# 
# print("Process germline input...")
# # get info germline
# for (line in 1:nrow(germ)) {
#   if (grepl("DP4",germ[,"FORMAT"][line])){
#     germ_dp4N = extractInfo(germ[,"NORMAL"][line], germ_dp4N)
#     germ_dp4T = extractInfo(germ[,"TUMOR"][line], germ_dp4T)
#     ### FREQ field normal
#     tmp = strsplit(as.character(germ[,"NORMAL"][line]),split = ":")[[1]][posFREQ]
#     # remove %
#     tmp = as.numeric(gsub(",",".",gsub("%", "",tmp)))
#     germ_freqN = c(germ_freqN, tmp)
#     ### FREQ field tumor
#     tmp = strsplit(as.character(germ[,"TUMOR"][line]),split = ":")[[1]][posFREQ]
#     # remove %
#     tmp = as.numeric(gsub(",",".",gsub("%", "",tmp)))
#     germ_freqT = c(germ_freqT, tmp)
# 
#   }else {
#     stop("ERROR: Wrong Format!")
#   }
# }
# # adding sums of REF and ALT
# germ_dp4T = cbind(germ_dp4T,Ref = germ_dp4T$fRef + germ_dp4T$rRef, Alt = germ_dp4T$fAlt + germ_dp4T$rAlt)
# germ_dp4T = cbind(germ_dp4T, Sum = germ_dp4T$Ref + germ_dp4T$Alt)
# germ_dp4N = cbind(germ_dp4N,Ref = germ_dp4N$fRef + germ_dp4N$rRef, Alt = germ_dp4N$fAlt + germ_dp4N$rAlt)
# germ_dp4N = cbind(germ_dp4N, Sum = germ_dp4N$Ref + germ_dp4N$Alt)
# 
# print("Filtering...")
# ### filtering ###
# # somatic
# include1 = som_dp4T$Ref + som_dp4T$Alt >= 10
# include2 = som_freqT < 75
# include3 = som_dp4N$Alt <= 1
# som = som[include1&include2&include3,]
# som_dp4T = som_dp4T[include1&include2&include3,]
# som_freqT = som_freqT[include1&include2&include3]
# 
# include1 = som_dp4N$Ref + som_dp4N$Alt >= 10
# include2 = som_freqN < 75
# include3 = som_dp4N$Alt <= 1
# som_dp4N = som_dp4N[include1&include2&include3,]
# som_freqN = som_freqN[include1&include2&include3]
# 
# 
# # germline
# include1 = germ_dp4T$Ref + germ_dp4T$Alt >= 10
# include2 = germ_freqT >= 25 & germ_freqT <= 75
# germ = germ[include1&include2,]
# germ_dp4T = germ_dp4T[include1&include2,]
# germ_freqT = germ_freqT[include1&include2]
# 
# include1 = germ_dp4N$Ref + germ_dp4N$Alt >= 10
# include2 = germ_freqN >= 25 & germ_freqN <= 75
# germ_dp4N = germ_dp4N[include1&include2,]
# germ_freqN = germ_freqN[include1&include2]

## PurBayes
 #result with background correction
load("malignantPurityEstWorkspaceR.RData")
 result <- PurBayes(Y = as.numeric(som_dp4T$Alt), N =  as.numeric(som_dp4T$Sum) , Z = germ_dp4N$Alt, M = germ_dp4N$Sum)
 summary(result)
 plot(result)

 # #result without background correction
 # resultN <- PurBayes(Y = as.numeric(som_dp4T$Alt), N =  as.numeric(som_dp4T$Sum))
 # summary(resultN)
 # plot(resultN)


#Heterogeneous tumor example - 1 subclonal population
#  N.var<-20
#  N<-round(runif(N.var,20,200))
#  lambda.1<-0.75
#  lambda.2<-0.25
#  lambda<-c(rep(lambda.1,10),rep(lambda.2,10))
#  Y<-rbinom(N.var,N,lambda/2)
#  PB.het<-PurBayes(N,Y)
# # summary(PB.het)
#  plot(PB.het)


######## number 2:
### with background correction
 print("PurityEst:")
 mN = sum(germ_dp4N$Alt)/sum(germ_dp4N$Sum)
 mT = sum(som_dp4T$Alt)/sum(som_dp4T$Sum)
 purityEst = mT/mN
 print(purityEst)

 # ### without background correction
 # mN = 0.5
 # mT = sum(som_dp4T$Alt)/sum(som_dp4T$Sum)
 # purityEstN = mT/mN
