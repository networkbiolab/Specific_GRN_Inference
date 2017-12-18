#!/usr/bin/perl -w
use strict;
use warnings;

my $file_rpkm = $ARGV[0];
my $file_microRNA_net = $ARGV[1];

my %hash_rpkm = ();


open(my $fh, '<:encoding(UTF-8)', $file_rpkm) #se abre el archivo a analizar
  or die "Could not open file '$file_rpkm' $!"; 


while (my $row = <$fh>) { #lectura del archivo linea por linea
	chomp $row;
	
	my @split_row = split ("\t", $row);
	my @array_aux = ($split_row[1], $split_row[7]);
	if(!exists $hash_rpkm{$split_row[1]}){
		$hash_rpkm{$split_row[1]} = $split_row[7];
	}else{
		$hash_rpkm{$split_row[1]} = $hash_rpkm{$split_row[1]} + $split_row[7];
		
	}
	
}

open FILE,">out/output_miRNA_expres.tsv";
open FILE2,">out/output_miRNA_no_expres.tsv";

open(my $fh2, '<:encoding(UTF-8)', $file_microRNA_net) #se abre el archivo a analizar
  or die "Could not open file '$file_microRNA_net' $!"; 


while (my $row = <$fh2>) { #lectura del archivo linea por linea
	chomp $row;
	my @split_row = split ("\t",$row);
	#print "$split_row[0]-->$split_row[1]\t*\t*\t";
	
	if (exists $hash_rpkm{$split_row[0]}){
		if($hash_rpkm{$split_row[0]} > 0){
			print FILE "$split_row[0]\t$split_row[1]\t*\t*\t*\texpresa_regulador\n";
		}else{
			print FILE2 "$split_row[0]-->$split_row[1]\t*\t*\t*\tno_expresa_regulador\n";
		}
	}else{
		print FILE2 "$split_row[0]-->$split_row[1]\t*\t*\t*\tno_expresa_regulador\n";
	}
	
}
