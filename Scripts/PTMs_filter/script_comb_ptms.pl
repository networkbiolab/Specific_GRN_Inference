#!/usr/bin/perl -w
use strict;
use warnings;

#INPUT: reference_network.tsv filtro_PTMs.txt

my $file_comb_ptms = $ARGV[0];
my $file_conexiones = $ARGV[1];

my %hash_ptms = ();

open(my $fh, '<:encoding(UTF-8)', $file_comb_ptms) #se abre el archivo a analizar
  or die "Could not open file '$file_comb_ptms' $!"; 
 
my $count = 0;
while (my $row = <$fh>) { #lectura del archivo linea por linea
	chomp $row;
	my @split_row = split ("\t",$row);
	my @split_ptms = split (';',$split_row[0]);
	
	my @array;
	for (my $i=0; $i<scalar (@split_ptms);$i++){
		#~ print $split_ptms[$i],"\n";
		push(@array,$split_ptms[$i]);
	}
	
	push(@array,$split_row[1]);
	@{$hash_ptms{$count}} = @array;
	$count++;
	
}
#~ print "$hash_ptms{1}[0]\n";
#~ open FILE,">../out/output_comb_ptms.txt";
open FILE,">out/output_comb_ptms.txt";
open(my $fh2, '<:encoding(UTF-8)', $file_conexiones) #se abre el archivo a analizar
  or die "Could not open file '$file_conexiones' $!"; 
  
  while (my $row = <$fh2>) { #lectura del archivo linea por linea
	chomp $row;
	my @split_row = split ("\t",$row);
	my @split_ptms_2 = split (';',$split_row[1]);
	my @array_P;
	my @array_G;
	for (my $i=0; $i<scalar @split_ptms_2; $i++){
		
		if($split_ptms_2[$i] =~ "\\)P="){
			my @split_ptms_3 = split ("\\(",$split_ptms_2[$i]);
			push (@array_P,$split_ptms_3[0]);
		}
		
		if($split_ptms_2[$i] =~ "\\)G="){
			my @split_ptms_3 = split ("\\(",$split_ptms_2[$i]);
			push (@array_G,$split_ptms_3[0]);
		}
		#~ print "$split_ptms_3[0]\n";
		#~ 
		
	}
	print FILE $row;
	my $var = 0;
	for my $k (keys %hash_ptms){
		if(scalar @{$hash_ptms{$k}} -1 <= scalar @array_P){
			my $count=0;
			for (my $l=0; $l<scalar @{$hash_ptms{$k}} -1;$l++){
				for (my $x=0; $x<scalar @array_P; $x++){
					if($array_P[$x] eq $hash_ptms{$k}[$l]){
						$count ++;
					}
				}
			}
			if($count == scalar @{$hash_ptms{$k}} -1){
				if($var != 1){
					print FILE "\t";
					for (my $y=0; $y<scalar @{$hash_ptms{$k}} -1; $y++){
						print FILE "$hash_ptms{$k}[$y],";
					}
					print FILE $hash_ptms{$k}[scalar @{$hash_ptms{$k}} -1],",P";
					$var =1;
				}else{
					print FILE ";";
					for (my $y=0; $y<scalar @{$hash_ptms{$k}} -1; $y++){
						print FILE "$hash_ptms{$k}[$y],";
					}
					print FILE $hash_ptms{$k}[scalar @{$hash_ptms{$k}} -1],",P";
					
				}
			}
		}
		
	}
	for my $k (keys %hash_ptms){
		if(scalar @{$hash_ptms{$k}} -1 <= scalar @array_G){
			my $count=0;
			for (my $l=0; $l<scalar @{$hash_ptms{$k}} -1;$l++){
				for (my $x=0; $x<scalar @array_G; $x++){
					if($array_G[$x] eq $hash_ptms{$k}[$l]){
						$count ++;
					}
				}
			}
			if($count == scalar @{$hash_ptms{$k}} -1){
				if($var != 1){
					print FILE "\t";
					for (my $y=0; $y<scalar @{$hash_ptms{$k}} -1; $y++){
						print FILE "$hash_ptms{$k}[$y],";
					}
					print FILE $hash_ptms{$k}[scalar @{$hash_ptms{$k}} -1],",G";
					$var =1;
				}else{
					print FILE ";";
					for (my $y=0; $y<scalar @{$hash_ptms{$k}} -1; $y++){
						print FILE "$hash_ptms{$k}[$y],";
					}
					print FILE $hash_ptms{$k}[scalar @{$hash_ptms{$k}} -1],",G";
				}
			}
		}
		
	}
	
	if($var == 0){
		print FILE "\t*";
	}
	
	print FILE "\n";
	
}
close FILE;	
	
