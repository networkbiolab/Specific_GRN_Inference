#!/usr/bin/perl -w
use strict;
use warnings;

my $file_rpkm = $ARGV[0];
my $file_conex = $ARGV[1];

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




#~ for my $i (keys %hash_rpkm){
	#~ print "$i\n";
	
	
#~ }
open FILE,">out/output_regulator_expres.tsv";
open FILE2,">out/output_regulator_no_expres.tsv";

open(my $fh2, '<:encoding(UTF-8)', $file_conex) #se abre el archivo a analizar
  or die "Could not open file '$file_conex' $!"; 


while (my $row = <$fh2>) { #lectura del archivo linea por linea
	chomp $row;
	
	my @split_row = split ("\t",$row);
	my @split_conex = split ("-->",$split_row[0]);
	
	if (exists $hash_rpkm{$split_conex[0]}){
		if($hash_rpkm{$split_conex[0]} > 0){
			print FILE "$row\texpresa_regulador\n";
		}else{
			print FILE2 "$row\tno_expresa_regulador\n";
		}
	}else{
		print FILE2 "$row\tno_expresa_regulador\n";
	}
		

}
