use strict;
use warnings;

### Store variant details
my $file="clinvar_20170905_cardiacPhenotypes.vcf";
my %cardiac_vars_exomes;
my %cardiac_vars_genomes;
open(FILE, $file)||die "Cannot open $file";
while(<FILE>)
{
	chomp;
	my ($chr, $pos, $ref, $alt, $id, $pheno, $clinsig, $tier) = split /\t/, $_;
	my $key = $chr.":".$pos.":".$ref.":".$alt;
	$cardiac_vars_exomes{$key}=0;
	$cardiac_vars_genomes{$key}=0;
}
close(FILE);

### Read through gnomAD files and save popmax FAF
## EXOMES
my $autosome_file_exomes="../gnomad.exomes.r2.0.2.coding_only.chr1-22.faf.tsv";
my $sex_file_exomes="../gnomad.exomes.r2.0.2.coding_only.chrXY.faf.tsv";

# AUTOSOMES
open(AUTOEX, $autosome_file_exomes)||die "Cannot open $autosome_file_exomes";
my $auto_ex_head=<AUTOEX>;
while(<AUTOEX>)
{
	my @auto_line = split /\t/, $_;
	if (exists $cardiac_vars_exomes{$auto_line[0]})
	{
		my $faf=0;
		for (my $n=1; $n<=5; $n++)
		{
			if ($auto_line[$n] eq 'NA'){}
			elsif ($auto_line[$n]>$faf)
			{
				$faf=$auto_line[$n];
			}
		}
		$cardiac_vars_exomes{$auto_line[0]}=$faf;
	}
}

# SEX CHRS
my @exomes_access=(1,4,7,10,13);
open(SEXEX, $sex_file_exomes)||die "Cannot open $sex_file_exomes";
my $sex_ex_head=<SEXEX>;
while(<SEXEX>)
{
	my @sex_line = split /\t/, $_;
	if (exists $cardiac_vars_exomes{$sex_line[0]})
	{
		my $faf=0;
		foreach my $n (@exomes_access)
		{
			if ($sex_line[$n] eq 'NA'){}
			elsif ($sex_line[$n]>$faf)
			{
				$faf=$sex_line[$n];
			}
		}
		$cardiac_vars_exomes{$sex_line[0]}=$faf;
	}
}

## GENOMES
my $autosome_file_genomes="../gnomad.genomes.r2.0.2.coding_only.chr1-22.faf.tsv";
my $sex_file_genomes="../gnomad.genomes.r2.0.2.coding_only.chrX.faf.tsv";

# AUTOSOMES
open(AUTOGE, $autosome_file_genomes)||die "Cannot open $autosome_file_genomes";
my $auto_ge_head=<AUTOGE>;
while(<AUTOGE>)
{
	my @auto_line = split /\t/, $_;
	if (exists $cardiac_vars_genomes{$auto_line[0]})
	{
		my $faf=0;
		for (my $n=1; $n<=4; $n++)
		{
			if ($auto_line[$n] eq 'NA'){}
			elsif ($auto_line[$n]>$faf)
			{
				$faf=$auto_line[$n];
			}
		}
		$cardiac_vars_genomes{$auto_line[0]}=$faf;
	}
}

# SEX CHRS
my @genomes_access=(1,4,7,10);
open(SEXGE, $sex_file_genomes)||die "Cannot open $sex_file_genomes";
my $sex_ge_head=<SEXGE>;
while(<SEXGE>)
{
	my @sex_line = split /\t/, $_;
	if (exists $cardiac_vars_genomes{$sex_line[0]})
	{
		my $faf=0;
		foreach my $n (@genomes_access)
		{
			if ($sex_line[$n] eq 'NA'){}
			elsif ($sex_line[$n]>$faf)
			{
				$faf=$sex_line[$n];
			}
		}
		$cardiac_vars_genomes{$sex_line[0]}=$faf;
	}
}

### Annotate back into variant file 
open(OUT, ">clinvar_20170905_cardiacPhenotypes_withFAF.txt");
print OUT "chr\tpos\tref\talt\tclinvarID\tphenotype\tclinSig\ttier\texomeFAF\tgenomeFAF\n";
open(FILEY, $file)||die "Cannot open $file";
my $header=<FILEY>;
while(<FILEY>)
{
	chomp;
	my ($chr, $pos, $ref, $alt, $id, $pheno, $clinsig, $tier) = split /\t/, $_;
	my $key = $chr.":".$pos.":".$ref.":".$alt;
	my $exome_faf=$cardiac_vars_exomes{$key};
	my $genome_faf=$cardiac_vars_genomes{$key};
	print OUT "$_\t$exome_faf\t$genome_faf\n";
}
