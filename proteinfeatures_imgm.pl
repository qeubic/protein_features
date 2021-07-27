#! /usr/bin/perl -w
# perl code to convert the NCBI Web Batch Conserved Domain Search (CD-Search) output for data analytics
# including visual analytics, modeling and simulation and statistical analysis.
# Usage example: proteinfeatures_imgm.pl <input_filename> > <ouput file name> & 
# Author: Raphael D. Isokpehi (qeubic -at- gmail.com)  
# https://github.com/qeubic/protein_features/blob/main/README.md
# NCBI Web Batch CD-Search website -  https://www.ncbi.nlm.nih.gov/Structure/bwrpsb/bwrpsb.cgi
# Input file should contain a collection of fasta protein sequences obtained from 
# the Integrated Microbial Genomes & Microbiomes -  https://img.jgi.doe.gov/cgi-bin/mer/main.cgi
# Example - Desulfofvibrio desulfuricans ND132 Protein Coding Genes
# 3470 protein coding gene(s) retrieved.
# https://img.jgi.doe.gov/cgi-bin/mer/main.cgi?section=TaxonDetail&page=proteinCodingGenes&taxon_oid=2503754015
# Limitation: NCBI CD-Search accepts maximum of 4000 protein sequences per request.

$filename = $ARGV[0]; #Check for input file
if ($#ARGV!=0) {
        die "Usage: enter file name\n"; #stop code if filename is not provided as input
}
#Assign data field names to variables
$a="Query Identifier";
$b1="Gene ID";
$b2="Locus Tag";
$b3="Gene Name";
$b4="Genome Name";
$c="Ligand Type";
$d="Ligand Name";
$e="Amino Acid Pattern";
$f="Amino Acid Position Pattern";
$g="Ligand Site Positions";
$h="Source Protein Domain (PSSM-ID)";
$i="Coordinates";

# Print the data fields separated as tabs.
print "$a\t$b1\t$b2\t$b3\t$b4\t$c\t$d\t$e\t$f\t$g\t$h\t$i\n";

# Open the file with the feature output from CD-Search
open (IN, $filename);

while (<IN>) {
	chomp;
	#An example of line to be matched 
	#Q#3470 - >2503784787 DND132_0001 dnaA chromosomal replication initiator protein [Desulfovibrio desulfuricans ND132 (Final JGI assembly) : Ddes_Contig54]	specific	DnaA box-binding interface	R386,R394,N395,R402,S408,L409,K410,K419,H420,S421,T422,K425,T428,K429	15	14	119330
	if (/^Q\#(.*?)\s\-\s(.*?)\t(.*?)\t(.*?)\t(.*?)\t(.*?)\t(.*?)\t(.*)/) { #match line with Query
		#assign identifiers to variables matched in the query (protein sequence) 
		$qid=$1;
		$domain_type=$3;
		$domain_name=$4;
		$bindsites=$5;
		$sourcedomain=$8;
		$imgids1=$2; #Contain IMG/M identifiers for Gene ID and Locus Tags as well as gene and genome descriptions 
		$imgids1=~/\>(.*?)\s(.*?)\s(.*?)\[(.*)\:.*/; # matching of identifiers.
		$geneid=$1;
		$locus_tag=$2;
		$genename=$3;
		$genomename=$4;
       		$label1="$qid\t$geneid\t$locus_tag\t$genename\t$genomename\t$domain_type\t$domain_name"; #Assign variable for printing

		#constructing data fields for amino acid patterns and amino acid position patterns. 
		if ($bindsites=~/(\S)(.*)\-(\S)(.*)/) { # repeats or coils
			$repaa1=$1;
			$repaapos1=$2;
			$repaa2=$3;
			$repaapos2=$4;
			push (@arr3, $repaa1);
			push (@arr3, $repaa2);
			push (@arr4, $repaapos1);
			push (@arr4, $repaapos2);
		} else {
			@arr2=split(/\,/, $bindsites); #binding sites
			$cntligand=@arr2;
			$cnt=0;
			while ($cnt < $cntligand) {
				$sitenum=$cnt+1; #ligand site number
				$siteloc=$arr2[$cnt];
				$siteloc=~/(\S?)(.*)/;
				$siteaa=$1;
				$sitepos=$2;
				push (@arr3, $siteaa); # amino acid at sites
				push (@arr4, $sitepos); # amino acid positions
				$cnt++;
	
			}

		}
		$siteaapa=join "", @arr3; #join the amino acid letters to form a pattern
		$sitepospa=join "_", @arr4; #join the amino acid positions with underscore to form a pattern
		print "Q$label1\t$siteaapa\t$sitepospa\t$sitenum\t$sourcedomain\t$bindsites\n"; # output record
		$sitenum=0;
	
	} 
	#reinitialize arrays.
	@arr2=();
	@arr3=();
	@arr4=();
}
#end of code
