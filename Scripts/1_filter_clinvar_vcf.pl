use strict;
use warnings;

my $vcf="../clinvar_20170905.vcf";
open(OUT, ">clinvar_20170905_cardiacPhenotypes.vcf");
print OUT "chr\tpos\tref\talt\tclinvarID\tphenotype\tclinSig\ttier\n";

### FILTER TO ONLY DISEASES OF INTEREST
my %unique_bits;
open(VCF, $vcf)||die "Cannot open $vcf";
while(<VCF>)
{
	chomp;
	if ($_ =~ /^#/){}
	else
	{
		my $phenotype="";
		my $clinsig="";
		my $tier="";
		my @line = split /\t/, $_;
		my $info = $line[7];
		my @split_info = split /;/, $info;
		foreach my $bit (@split_info)
		{
			if ($bit =~ /CLNDN/) # if disease name
			{
				if ((($bit =~ /hypertrophic/i)&&($bit =~ /cardiomyopathy/i))||($bit =~ /hcm/i))
				{
					$phenotype="HCM";
				}
				elsif ((($bit =~ /dilated/i)&&($bit =~ /cardiomyopathy/i))||($bit =~ /dcm/i))
				{
					$phenotype="DCM";
				}
				elsif ((($bit =~ /arrhythmogenic/i)&&($bit =~ /cardiomyopathy/i))||($bit =~ /arvc/i))
				{
					$phenotype="ARVC";
				}
				elsif ((($bit =~ /long/i)&&($bit =~ /qt/i))||($bit =~ /lqt/i)||($bit =~ /lqts/i))
				{
					$phenotype="LQTS";
				}
				elsif (($bit =~ /brugada/i)||($bit =~ /brs/i))
				{
					$phenotype="Brugada";
				}
			}
			elsif ($bit =~ /CLNSIG=/) # get only Pathogenic or Likely Pathogenic
			{
				if (($bit =~ /Pathogenic/)||($bit =~ /Likely_pathogenic/))
				{
					$clinsig="Path_LikelyPath";
				}
			}
			elsif ($bit =~ /CLNREVSTAT/) # implement tiering
			{
				if (($bit =~ /criteria_provided,_multiple_submitters,_no_conflicts/)||($bit =~ /reviewed_by_expert_panel/)||($bit =~ /practice_ guideline/))
				{
					$tier="1";
				}
				elsif ($bit =~ /criteria_provided,_single_submitter/)
				{
					$tier="2";
				}
				elsif ($bit =~ /no_assertion_criteria_provided/)
				{
					$tier="3";
				}
			}
		}
		if (($tier)&&($clinsig)&&($phenotype))
		{
			print OUT "$line[0]\t$line[1]\t$line[3]\t$line[4]\t$line[2]\t$phenotype\t$clinsig\t$tier\n";
		}
	}
}

