#!/usr/bin/perl -w
use strict;
use warnings;

my $ref_net = $ARGV[0];
my $file_exp = $ARGV[1];
my $GENEs = $ARGV[2];
my $porc_meth = $ARGV[3];

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
		
		if($split_row[10] >= $porc_meth){
			if(!exists $hash{$split_row[0]}{$split_row[5]}{$count}){
				my @array = ($split_row[1],$split_row[2],$split_row[10]);
				@{$hash{$split_row[0]}{$split_row[5]}{$count}} = @array; 
				$count++;
			}
		}
	}
	
}


open(my $fh2, $GENEs) #se abre el archivo a analizar
  or die "Could not open file '$GENEs' $!"; 

while (my $row = <$fh2>) { #lectura del archivo de genes linea por linea
	chomp $row;
	
	my @split_row = split("\t",$row);
	my @split_id = split(";",$split_row[8]);
	$split_id[0] =~ s/ID=//;
	
	if($split_row[0] =~ "chr"){
		$split_row[0] =~ s/chr//;
	}
	
	
	if(!exists $hash_genes{$split_row[0]}{$split_id[0]}){
		$hash_genes{$split_row[0]}{$split_id[0]} = $split_row[6];
		
	}
	
}

open FILE, ">out/reg_meth.txt";
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
	
	if(exists $hash_genes{$split_row[4]}{$split_row[1]}){
		$strand = $hash_genes{$split_row[4]}{$split_row[1]};
		for(my $i=0; $i<scalar(@coor); $i++){
			my @split_coor = split(",",$coor[$i]);
			for my $x (keys %{$hash{$split_row[4]}{$strand}}){
				if($split_coor[0] < $hash{$split_row[4]}{$strand}{$x}[0]){
					if($split_coor[1] > $hash{$split_row[4]}{$strand}{$x}[0] && $split_coor[1] <= $hash{$split_row[4]}{$strand}{$x}[1]){
						$flag = 1;
						$flag_2 = 1;
						$x_aux = $x;
					}
					if($split_coor[1] > $hash{$split_row[4]}{$strand}{$x}[1]){
						$flag = 1;
						$flag_2 = 1;
						$x_aux = $x;
					}
				}
				
				if($split_coor[0] > $hash{$split_row[4]}{$strand}{$x}[0]){
					if($hash{$split_row[4]}{$strand}{$x}[1] > $split_coor[0] && $split_coor[1] >= $hash{$split_row[4]}{$strand}{$x}[1]){
						$flag = 1;
						$flag_2 = 1;
						$x_aux = $x;
					}
					if($split_coor[1] < $hash{$split_row[4]}{$strand}{$x}[1]){
						$flag = 1;
						$flag_2 = 1;
						$x_aux = $x;
					}
				}
				
				if($split_coor[0] == $hash{$split_row[4]}{$strand}{$x}[0]){
					if($split_coor[0] > $hash{$split_row[4]}{$strand}{$x}[1]){
						$flag = 1;
						$flag_2 = 1;
						$x_aux = $x;
					}
					if($split_coor[0] < $hash{$split_row[4]}{$strand}{$x}[1]){
						$flag = 1;
						$flag_2 = 1;
						$x_aux = $x;
					}
					if($split_coor[0] == $hash{$split_row[4]}{$strand}{$x}[1]){
						$flag = 1;
						$flag_2 = 1;
						$x_aux = $x;
					}
				}
				if($flag == 1){
				print FILE "$split_row[4]\t$split_row[0]\t$split_coor[0]\t$split_coor[1]\t$hash{$split_row[4]}{$strand}{$x_aux}[0]\t$hash{$split_row[4]}{$strand}{$x_aux}[1]\t$hash{$split_row[4]}{$strand}{$x_aux}[2]\n";
					#~ print "$split_row[4]\t$split_row[0]\t$split_coor[0]\t$split_coor[1]\t$hash{$split_row[4]}{$strand}{$x_aux}[0]\t$hash{$split_row[4]}{$strand}{$x_aux}[1]\t$hash{$split_row[4]}{$strand}{$x_aux}[2]\n";
					$flag = 0;
				}
			}
			
			
		}
		if($flag_2 == 0){
			print FILE_2 "$row\n";
			#~ print  "$row\n";
		}else{
			$flag_2 = 0;
		}
		
	}else{
		print "$split_row[4] $split_row[1] not exist in genes file\n";
		print FILE_2 "$row\n";
	}
	
}

system ("rm $ref_net");
system ("mv out/tmp.tsv $ref_net");

close FILE;
close FILE_2;

