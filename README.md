# Response To Shah _et al_.

Code and resources relating to Whiffin _et al_. bioRxiv 2018 "Response to Shah et al: Using high-resolution variant frequencies empowers clinical genome interpretation and enables investigation of genetic architecture" writen in response to Shah _et al_. AJHG 2018.

### the method

Full details of our frequency filtering approach can be found in https://www.nature.com/articles/gim201726

In brief, we calculate the maximum credible frequency of any disease-causing variant in the general population using the following equation:

_max credible pop AF = disease prevalence * max allele contribution * 1/penetrance_

where _max allele contribution_ is defined as the maximum proportion of disease caused by any one variant.

For each variant, we then compare this _max credible pop AF_ to a pre-calculated _filtering allele frequency_, to determine whether that variant is a credible candidate to cause disease. This value takes into account the major continental populations in gnomAD and accounts for sampling variance.

### scripts

This directory contains Perl code to identify ClinVar Pathogenic/Likely Pathogenic varaints for five phenotypes of interest (dilated cardiomyopathy, hypertrophic cardiomyopathy, arrhythmogenic right ventricular cardiomyopathy, long QT syndrome (LQT), and Brugada syndrome) that are above our stipulated disease-specific allele frequency thresholds in gnomAD.

1_filter_clinvar_vcf.pl
  Filters a ClinVar VCF to retain only variants associated with the diseases of interest and annotates the    variants according to the 'sets' described in Shah _et al_.
  
2_annotate_with_FAFs.pl
  Annotates each variants with _filtering allele freqeuncies_ calculated from gnomAD exomes and genomes.
  
3_find_FAF_violations.pl
  Assess for each variant whether the _filtering allele freqeuncy_ is above the disease-specific _max credible pop AF_

### gnomAD filtering allele frequency files

This directory contains the pre-calculated _filtering allele frequency_ values for all variants in the gnomAD 2.0 dataset. These values were caulcated seperately for exomes and genomes. We previously shared the code for these calculations here: https://github.com/ImperialCardioGenetics/frequencyFilter/tree/master/src.

Included in each file are all variants that are observed with AC>1 in at least one of the five continental populations (i.e. not using the ASJ and FIN populations with known founder effects). The popmax _filtering allele_frequency_ can be calculated by taking the maximum across all five populations for a variant.

For variants on the X and Y chromsome we have provided _filtering allele freqeuncy_ values for males and females seperately as well as the combined values. These values can be useful for sex-chromosome linked disorders. We have also calculted the values at both 95% and 99% confidence.
