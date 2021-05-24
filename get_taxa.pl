#!/usr/bin/perl

#use lib "/projects/sate3/tools/bin/bioPerl-1.5.2/lib/perl5";
#use lib "/u/bayzid/Research/simulation_study/tools/bioPerl-1.5.2/lib/perl5";

#use lib "/projects/sate3/tools/bin/bioPerl-1.5.1-rc3";
#use lib "/u/bayzid/Research/simulation_study/tools/bioPerl-1.5.1-rc3/";  # eta korte hobe export PERL5LIB=/u/bayzid/Research/simulation_study/tools/bioperl-1.5.1-rc3/

#use lib "/u/bayzid/Research/simulation_study/tools/BioPerl-1.5.9._2/";
use lib "/Users/ali_nayeem/Lib/BioPerl-1.6.901/";
use lib "/Users/ali_nayeem/Lib/BioPerl-1.6.901/Bio"; #BioPerl-1.6.901
# use lib "/home/ali_nayeem/Lib/BioPerl-1.6.901/Bio/TreeIO.pm";

use Bio::TreeIO;
use Bio::Tree::TreeFunctionsI;
use strict;
#use Bio::AlignIO;
use warnings;
use Getopt::Long;

use List::MoreUtils qw(uniq);

sub badInput {
  my $message = "Usage: perl $0 takes a newick tree and outputs the set of taxa
	-i=<tree>  #input trees
	-o=<output>"; # a file containing the set of taxa
  print STDERR $message;
  die "\n";
}

GetOptions(
	"i=s"=>\my $input,
	"o=s"=>\my $output,
);

badInput() if not defined $input;
badInput() if not defined $output;

my $in = Bio::TreeIO->new(-file => "$input",
			   -format => 'newick');

#my $tree = $in->next_tree;
my @taxa;
while( my $tree = $in->next_tree )
	{

	my @taxa_tree_id = $tree->get_leaf_nodes;  # id ..not name

#	my @taxa;
	foreach my $leaf (@taxa_tree_id)
		{
			my $name = $leaf->id;    # name of the taxa
			push(@taxa, $name);
		}
	}

my @uniq_taxa = uniq(@taxa);

open(OUT, ">", $output) or die "can't open $output: $!";
my $mappingname = "S";
my $start = 1;
 foreach my $taxon(@uniq_taxa)
	{
		#print OUT "$taxon\n";
		print OUT "$taxon $mappingname$start\n";  # this is for mpest
		$start = $start +1;
	}

#print "\ndone\n";
