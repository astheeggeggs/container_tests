#!/bin/bash

if [ -d "output" ] 
then
    mv output output_tmp
    mkdir output
fi

Rscript createSparseGRM.R \
    --plinkFile=./input/nfam_100_nindep_0_step1_includeMoreRareVariants_poly \
    --nThreads=4  \
    --outputPrefix=./output/sparseGRM \
    --numRandomMarkerforSparseKin=2000 \
    --relatednessCutoff=0.125

Rscript step1_fitNULLGLMM.R \
    --plinkFile=./input/nfam_100_nindep_0_step1_includeMoreRareVariants_poly_22chr \
    --phenoFile=./input/pheno_1000samples.txt_withdosages_withBothTraitTypes.txt \
    --phenoCol=y_binary \
    --covarColList=x1,x2,a9,a10 \
    --qCovarColList=a9,a10 \
    --sampleIDColinphenoFile=IID \
    --traitType=binary \
    --outputPrefix=./output/example_binary \
    --nThreads=24 \
    --IsOverwriteVarianceRatioFile=TRUE

Rscript step1_fitNULLGLMM.R \
    --plinkFile=./input/nfam_100_nindep_0_step1_includeMoreRareVariants_poly_22chr \
    --useSparseGRMtoFitNULL=FALSE \
    --phenoFile=./input/pheno_1000samples.txt_withdosages_withBothTraitTypes.txt \
    --phenoCol=y_quantitative \
    --covarColList=x1,x2,a9,a10 \
    --qCovarColList=a9,a10 \
    --sampleIDColinphenoFile=IID \
    --invNormalize=TRUE \
    --traitType=quantitative \
    --outputPrefix=./output/example_quantitative \
    --nThreads=24 \
    --IsOverwriteVarianceRatioFile=TRUE

Rscript step1_fitNULLGLMM.R     \
    --sparseGRMFile=output/sparseGRM_relatednessCutoff_0.125_1000_randomMarkersUsed.sparseGRM.mtx   \
    --sparseGRMSampleIDFile=output/sparseGRM_relatednessCutoff_0.125_1000_randomMarkersUsed.sparseGRM.mtx.sampleIDs.txt     \
    --useSparseGRMtoFitNULL=TRUE    \
    --phenoFile=./input/pheno_1000samples.txt_withdosages_withBothTraitTypes.txt \
    --phenoCol=y_binary \
    --covarColList=x1,x2,a9,a10 \
    --qCovarColList=a9,a10  \
    --sampleIDColinphenoFile=IID \
    --traitType=binary        \
    --outputPrefix=./output/example_binary_sparseGRM

Rscript step2_SPAtests.R \
    --bgenFile=./input/genotype_100markers.bgen \
    --bgenFileIndex=./input/genotype_100markers.bgen.bgi \
    --sampleFile=./input/samplelist.txt \
    --AlleleOrder=ref-first \
    --SAIGEOutputFile=./output/genotype_100markers_marker_bgen_Firth.txt \
    --chrom=1 \
    --minMAF=0 \
    --minMAC=20 \
    --GMMATmodelFile=./output/example_binary.rda \
    --varianceRatioFile=./output/example_binary.varianceRatio.txt \
    --is_Firth_beta=TRUE \
    --pCutoffforFirth=0.1

Rscript step2_SPAtests.R \
    --bedFile=./input/genotype_100markers.bed \
    --bimFile=./input/genotype_100markers.bim \
    --famFile=./input/genotype_100markers.fam \
    --AlleleOrder=alt-first \
    --SAIGEOutputFile=./output/genotype_100markers_marker_plink.txt \
    --chrom=1 \
    --minMAF=0 \
    --minMAC=20 \
    --GMMATmodelFile=./output/example_binary.rda \
    --varianceRatioFile=./output/example_binary.varianceRatio.txt \
    --is_output_moreDetails=TRUE

Rscript step2_SPAtests.R \
    --vcfFile=./input/genotype_100markers.vcf.gz \
    --vcfFileIndex=./input/genotype_100markers.vcf.gz.csi \
    --vcfField=GT \
    --SAIGEOutputFile=./output/genotype_100markers_marker_vcf.txt \
    --chrom=1 \
    --minMAF=0 \
    --minMAC=20 \
    --GMMATmodelFile=./output/example_binary.rda \
    --varianceRatioFile=./output/example_binary.varianceRatio.txt \
    --is_output_moreDetails=TRUE

Rscript step2_SPAtests.R \
    --vcfFile=./input/genotype_100markers.vcf.gz \
    --vcfFileIndex=./input/genotype_100markers.vcf.gz.csi \
    --vcfField=GT \
    --SAIGEOutputFile=./output/genotype_100markers_marker_vcf_step1withSparseGRM.txt \
    --chrom=1 \
    --minMAF=0 \
    --minMAC=20 \
    --GMMATmodelFile=./output/example_binary_sparseGRM.rda \
    --is_output_moreDetails=TRUE \
    --sparseGRMFile=output/sparseGRM_relatednessCutoff_0.125_1000_randomMarkersUsed.sparseGRM.mtx \
    --sparseGRMSampleIDFile=output/sparseGRM_relatednessCutoff_0.125_1000_randomMarkersUsed.sparseGRM.mtx.sampleIDs.txt

Rscript step2_SPAtests.R \
    --vcfFile=./input/genotype_100markers.vcf.gz \
    --vcfFileIndex=./input/genotype_100markers.vcf.gz.csi \
    --vcfField=GT \
    --SAIGEOutputFile=./output/genotype_100markers_marker_vcf_step1withSparseGRM.txt \
    --chrom=1 \
    --minMAF=0 \
    --minMAC=20 \
    --GMMATmodelFile=./output/example_binary_sparseGRM.rda \
    --is_output_moreDetails=TRUE \
    --sparseGRMFile=output/sparseGRM_relatednessCutoff_0.125_1000_randomMarkersUsed.sparseGRM.mtx \
    --sparseGRMSampleIDFile=output/sparseGRM_relatednessCutoff_0.125_1000_randomMarkersUsed.sparseGRM.mtx.sampleIDs.txt \
    --is_Firth_beta=TRUE \
    --pCutoffforFirth=0.01

Rscript step2_SPAtests.R \
    --vcfFile=./input/genotype_100markers.vcf.gz \
    --vcfFileIndex=./input/genotype_100markers.vcf.gz.csi \
    --vcfField=GT \
    --SAIGEOutputFile=./output/genotype_100markers_marker_vcf_cond.txt \
    --chrom=1 \
    --minMAF=0 \
    --minMAC=20 \
    --GMMATmodelFile=./output/example_binary.rda \
    --varianceRatioFile=./output/example_binary.varianceRatio.txt \
    --is_output_moreDetails=TRUE \
    --condition=1:13:A:C,1:79:A:C

cd output
md5sum * > ../checklist.chk # generates a list of checksums for any file that matches *
md5sum -c ../checklist.chk

cd ../output_tmp
md5sum -c ../checklist.chk

cd ..
rm output
mv output_tmp output
