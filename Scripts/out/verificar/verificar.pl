#!/usr/bin/perl -w
use strict;
use warnings;

my $file = $ARGV[0];
my $file_2 = $ARGV[1];

my %hash = ();
my $reg1 = 0;
my $reg2 = 0;

open(my $fh, '<:encoding(UTF-8)', $file) #se abre el archivo a analizar
  or die "Could not open file '$file' $!"; 

while (my $row = <$fh>) { #lectura del archivo linea por linea
	chomp $row;
	
	my @split_row = split("\t",$row);
	$hash{$split_row[0]}{$split_row[1]} = 1;
	$reg1++;
}

open(my $fh2, '<:encoding(UTF-8)', $file_2) #se abre el archivo a analizar
  or die "Could not open file '$file_2' $!"; 

while (my $row = <$fh2>) { #lectura del archivo linea por linea
	chomp $row;
	
	my @split_row = split("\t",$row);
	if(!exists $hash{$split_row[0]}{$split_row[1]}){
		print "$split_row[0]\t$split_row[1]\n";
	}
	$reg2++;
}

print "\n\nREG1: $reg1\nREG2: $reg2\n";
