use strict;
use warnings;

my %faf_thresholds;
$faf_thresholds{"HCM"}=4.0e-5;
$faf_thresholds{"DCM"}=8.4e-5;
$faf_thresholds{"ARVC"}=9.2e-5;
$faf_thresholds{"LQTS"}=8.2e-6;
$faf_thresholds{"Brugada"}=1.0e-5;

my $file="clinvar_20170905_cardiacPhenotypes_withFAF.txt";
open(OUT, ">violating_clinvar_variants.txt");
print OUT "chr\tpos\tref\talt\tclinvarID\tphenotype\tclinSig\ttier\texomeFAF\tgenomeFAF\n";

open(FILE, $file)||die "Cannot open $file";
my $head=<FILE>;
while(<FILE>)
{
	chomp;
	my @line=split /\t/, $_;
	my $threshold=$faf_thresholds{$line[5]};
	if (($line[8]>=$threshold)||($line[9]>=$threshold))
	{
		print OUT "$_\n";
	}
}
