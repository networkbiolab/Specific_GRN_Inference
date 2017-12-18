#!/usr/bin/perl -w
use strict;
use warnings;

my $ref_net = $ARGV[0];
my $file_exp = $ARGV[1];
my $score = $ARGV[2];

my %hash = ();
my %hash_genes = ();
my $count = 0;

open(my $fh, $file_exp) #se abre el archivo a analizar
  or die "Could not open file '$file_exp' $!"; 

while (my $row = <$fh>) { #lectura del archivo de genes linea por linea
	chomp $row;
	
	
	if($row !~ "track"){
		my @split_row = split ("\t", $row);
		
		if($split_row[0] =~ "chr"){
			$split_row[0] =~ s/chr//;
		}
		
		if($split_row[4] >= $score){
			if(!exists $hash{$split_row[0]}{$count}){
				my @array = ($split_row[1],$split_row[2],$split_row[4]);
				@{$hash{$split_row[0]}{$count}} = @array; 
				$count++;
			}
		}
	}
	
}


open FILE, ">out/reg_dnase.txt";
open FILE_2, ">out/tmp.tsv";

open(my $fh3, $ref_net)
	or die "Could not open file '$ref_net' $!";
	
while (my $row = <$fh3>) { #lectura del archivo de genes linea por linea
	chomp $row;
	
	my @coor;
	my $strand;
	my $flag = 0;
	my $flag_2 = 0;
	my $x_aux;
	my @split_row = split("\t",$row);
	if($split_row[3] =~ ";"){
		@coor = split(";",$split_row[3]);
	}else{
		$coor[0] = $split_row[3];
	}
	
	for(my $i=0; $i<scalar(@coor); $i++){
		my @split_coor = split(",",$coor[$i]);
		for my $x (keys %{$hash{$split_row[4]}}){
			if($split_coor[0] < $hash{$split_row[4]}{$x}[0]){
				if($split_coor[1] > $hash{$split_row[4]}{$x}[0] && $split_coor[1] <= $hash{$split_row[4]}{$x}[1]){
					$flag = 1;
					$flag_2 = 1;
					$x_aux = $x;
				}
				if($split_coor[1] > $hash{$split_row[4]}{$x}[1]){
					$flag = 1;
					$flag_2 = 1;
					$x_aux = $x;
				}
			}
			
			if($split_coor[0] > $hash{$split_row[4]}{$x}[0]){
				if($hash{$split_row[4]}{$x}[1] > $split_coor[0] && $split_coor[1] >= $hash{$split_row[4]}{$x}[1]){
					$flag = 1;
					$flag_2 = 1;
					$x_aux = $x;
				}
				if($split_coor[1] < $hash{$split_row[4]}{$x}[1]){
					$flag = 1;
					$flag_2 = 1;
					$x_aux = $x;
				}
			}
			
			if($split_coor[0] == $hash{$split_row[4]}{$x}[0]){
				if($split_coor[0] > $hash{$split_row[4]}{$x}[1]){
					$flag = 1;
					$flag_2 = 1;
					$x_aux = $x;
				}
				if($split_coor[0] < $hash{$split_row[4]}{$x}[1]){
					$flag = 1;
					$flag_2 = 1;
					$x_aux = $x;
				}
				if($split_coor[0] == $hash{$split_row[4]}{$x}[1]){
					$flag = 1;
					$flag_2 = 1;
					$x_aux = $x;
				}
			}
			if($flag == 1){
				print FILE "$split_row[4]\t$split_row[0]\t$split_coor[0]\t$split_coor[1]\t$hash{$split_row[4]}{$x_aux}[0]\t$hash{$split_row[4]}{$x_aux}[1]\t$hash{$split_row[4]}{$x_aux}[2]\n";
				$flag = 0;
			}
		}
		
		
	}
	if($flag_2 == 1){
		print FILE_2 "$row\n";
		$flag_2 = 0;
	}
	
		
	
	
}

system ("rm $ref_net");
system ("mv out/tmp.tsv $ref_net");

close FILE;
close FILE_2;

