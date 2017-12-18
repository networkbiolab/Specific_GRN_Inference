#!/usr/bin/perl -w
use strict;
use warnings;

#INPUT: CTCF_exp.bed TFBS.gff GENEs.gff 

my $file_CTCF = $ARGV[0];
my $file_filtro_PTMs = $ARGV[1];
	
my %hash_PTMs_GEN = ();

open(my $fh, '<:encoding(UTF-8)', $file_filtro_PTMs) #se abre el archivo a analizar
  or die "Could not open file '$file_filtro_PTMs' $!"; 
  
while (my $row = <$fh>) { #lectura del archivo linea por linea
	chomp $row;
	my @split_row = split ("\t",$row);
	if ($split_row[8] eq 'G'){
		if(!exists $hash_PTMs_GEN{$split_row[0]}{$split_row[1]}{$split_row[4]}){
			my $string = "$split_row[4]_$split_row[7]";
			$hash_PTMs_GEN{$split_row[0]}{$split_row[1]}{$string} = 1;
			#~ @{$hash_PTMs_GEN{$split_row[0]}{$split_row[1]}[0]} = $split_row[4];
		}else{
			my $string = "$split_row[4]-$split_row[7]";
			$hash_PTMs_GEN{$split_row[0]}{$split_row[1]}{$string} ++;
			#~ my $num = scalar @{$hash_PTMs_GEN{$split_row[0]}{$split_row[1]}};
			#~ @{$hash_PTMs_GEN{$split_row[0]}{$split_row[1]}[$num]} = $split_row[4];
		}
	}
	
	
}


open(my $fh2, '<:encoding(UTF-8)', $file_CTCF) #se abre el archivo a analizar
  or die "Could not open file '$file_CTCF' $!"; 
  
while (my $row = <$fh2>) { #lectura del archivo linea por linea
	chomp $row;
	my @split_row =  split ("\t",$row);
	if ($split_row[7] ne '*'){
		my @split_loop_gene = split(',',$split_row[7]);
		print "$split_row[0]\t$split_row[1]\t$split_row[2]\t$split_row[3]\t$split_row[4]\t$split_row[5]\t$split_row[6]\t";
		for (my $i=0;$i<scalar(@split_loop_gene);$i++){
			if(exists $hash_PTMs_GEN{$split_row[0]}{$split_loop_gene[$i]}){
				print "$split_loop_gene[$i](";
				for my $k (keys %{$hash_PTMs_GEN{$split_row[0]}{$split_loop_gene[$i]}}){
					print "$k=$hash_PTMs_GEN{$split_row[0]}{$split_loop_gene[$i]}{$k},";
				}
				print ");";
				
			}else{
				print "$split_loop_gene[$i](NO_PTMs);";
			}
		}
		print "\n";
		
	}
	
}

#~ for my $i (keys %hash_PTMs_GEN){
	#~ for my $j (keys %{$hash_PTMs_GEN{$i}}){
		
		#~ print "$i $j\n";
		#~ for my $k (keys %{$hash_PTMs_GEN{$i}{$j}}){
			#~ print "$k = $hash_PTMs_GEN{$i}{$j}{$k}\n";
		#~ }
		
	#~ }
	
#~ }
