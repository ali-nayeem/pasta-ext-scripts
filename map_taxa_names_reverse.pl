#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;

sub printUsage {
    my $msg = "$0 -i <file> -m <mapping> -o <file>";
    die $msg;
}

GetOptions(
  "i=s"=>\my $infile,
  "m=s"=>\my $mappingfile,
  "o=s"=>\my $outfile,
);
printUsage() unless(defined($infile) && defined($mappingfile) && defined($outfile));


my $file_contents = `cat $infile`;
my %mapping = %{get_mapping($mappingfile)};
do_mapping(\$file_contents, \%mapping);
write_to_file(\$file_contents, $outfile);

#print "done.\n";

sub get_mapping {
 my ($mappingfile) = @_;
 my %mapping;

 open(MAP, $mappingfile) or die "can't open $mappingfile: $!";
 while(my $line = <MAP>) {
  if($line =~ /^(.*) (.*)$/) {
   $mapping{$1} = $2;
  }
  else {
	#print "\n$line\n";
   die "can't parse mapping entry: $line\n";
  }
 }
 close(MAP);

 return \%mapping;
}

sub do_mapping {
 #my $FILTER = "a-zA-Z";	
 my $FILTER = "(),:";	
 my ($file_contents_ref, $mapping_ref)  = @_;
 my $contents = ${$file_contents_ref};

 foreach my $key (keys %{$mapping_ref}) {
  #${$file_contents_ref} =~ s/([^$FILTER]+)($key)([^$FILTER]+)/$mapping_ref->{$key}/g;
 # ${$file_contents_ref} =~ s/([^$FILTER]+)($key)([^$FILTER]+)/$1$mapping_ref->{$2}$3/g;
	#print "\nthis is key: $key";
	#print"\n this is map: $mapping_ref->{$key}";
#	${$file_contents_ref} =~ s/$key/$mapping_ref->{$key}/g;
	${$file_contents_ref} =~ s/([$FILTER])($key)([$FILTER])/$1$mapping_ref->{$key}$3/g;
	#print "\n${$file_contents_ref}";
 }
}

sub write_to_file {
 my ($file_contents_ref, $file) = @_;

 open(FILE, ">", $file) or die "can't open $file: $!";
 print FILE ${$file_contents_ref};
 close(FILE);
}
