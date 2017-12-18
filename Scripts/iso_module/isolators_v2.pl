#!/usr/bin/perl -w
use strict;
use warnings;

my $file_ref_net = $ARGV[0];
my $file_CRMs = $ARGV[1];
my $file_GENEs = $ARGV[2];
my $file_iso = $ARGV[3];
my $D2 = $ARGV[4];


my %hash_genes = ();
my %hash_CRMs = ();
my %hash_iso = ();

my $count = 0;

open(my $fh, $file_iso) #se abre el archivo a analizar
  or die "Could not open file '$file_iso' $!"; 

while (my $row = <$fh>) { #lectura del archivo de genes linea por linea
	chomp $row;
	
	my @split_row = split("\t", $row);
	
	if($split_row[0] =~ "chr"){
		$split_row[0] =~ s/chr//;
		
	}
	
	my @array = ($split_row[1], $split_row[2]);
	
	@{$hash_iso{$split_row[0]}{$count}} = @array;
	
	$count++;
}

open(my $fh2, $file_GENEs) #se abre el archivo a analizar
  or die "Could not open file '$file_GENEs' $!"; 

while (my $row = <$fh2>) { #lectura del archivo de genes linea por linea
	chomp $row;
	
	my @split_row = split("\t", $row);
	my @split_id = split(";", $split_row[8]);
	
	$split_id[0] =~ s/ID=//;
	
	$hash_genes{$split_id[0]} = $split_row[6];
	
}

open(my $fh3, $file_CRMs) #se abre el archivo a analizar
  or die "Could not open file '$file_CRMs' $!"; 

while (my $row = <$fh3>) { #lectura del archivo de genes linea por linea
	chomp $row;
	
	if($row !~ "Start"){
		my @split_row = split("\t", $row);
		my @array = ($split_row[1], $split_row[2]);
		@{$hash_CRMs{$split_row[0]}{$split_row[3]}} = @array; 
		
	}
}


open FILE_1 ,">out/tmp.tsv";
open FILE_2 ,">out/isolator_connect_info.tsv";

open(my $fh4, $file_ref_net) #se abre el archivo a analizar
  or die "Could not open file '$file_ref_net' $!"; 

while (my $row = <$fh4>) { #lectura del archivo de genes linea por linea
	chomp $row;
	my $string = "";
	my $iso = "N";
	
	
	my @split_row = split("\t", $row);
	
	if($hash_genes{$split_row[1]} eq "+"){
		
		if($split_row[3] =~ ";"){
			
			my @split_coor = split(";",$split_row[3]);
			for(my $i=0; $i<scalar(@split_coor); $i++){
				my @split_coor_2 = split(",",$split_coor[$i]);
				for my $x (keys %{$hash_CRMs{$split_row[4]}}){
					if($hash_CRMs{$split_row[4]}{$x}[0] > ($split_coor_2[0] - $D2) && $hash_CRMs{$split_row[4]}{$x}[1] < $split_coor_2[0]){
						for my $y (keys %{$hash_iso{$split_row[4]}}){
							if($hash_iso{$split_row[4]}{$y}[0] > $hash_CRMs{$split_row[4]}{$x}[1] && $hash_iso{$split_row[4]}{$y}[1] < $split_coor_2[0]){
								$iso = "Y";
								last;
							}
						}
						
						if(length $string == 0){
							$string = "$x:$iso";
						}elsif($string !~ /\Q$x\E/){
							$string .= ",$x:$iso";
						}						
					}
				}
			}
			
		}else{
			my @split_coor_2 = split(",",$split_row[3]);
			for my $x (keys %{$hash_CRMs{$split_row[4]}}){
				if($hash_CRMs{$split_row[4]}{$x}[0] > ($split_coor_2[0] - $D2) && $hash_CRMs{$split_row[4]}{$x}[1] < $split_coor_2[0]){
					for my $y (keys %{$hash_iso{$split_row[4]}}){
						if($hash_iso{$split_row[4]}{$y}[0] > $hash_CRMs{$split_row[4]}{$x}[1] && $hash_iso{$split_row[4]}{$y}[1] < $split_coor_2[0]){
							$iso = "Y";
							last;
						}
					}
					
					
					if(length $string == 0){
						$string = "$x:$iso";
					}elsif($string !~ /\Q$x\E/){
						$string .= ",$x:$iso";
					}
				}
			}
		}
		
	}else{
		if($split_row[3] =~ ";"){
			
			my @split_coor = split(";",$split_row[3]);
			for(my $i=0; $i<scalar(@split_coor); $i++){
				my @split_coor_2 = split(",",$split_coor[$i]);
				for my $x (keys %{$hash_CRMs{$split_row[4]}}){
					if($hash_CRMs{$split_row[4]}{$x}[1] < ($split_coor_2[1] + $D2) && $hash_CRMs{$split_row[4]}{$x}[0] > $split_coor_2[1]){
						for my $y (keys %{$hash_iso{$split_row[4]}}){
							if($hash_iso{$split_row[4]}{$y}[0] > $split_coor_2[1] && $hash_iso{$split_row[4]}{$y}[1] < $hash_CRMs{$split_row[4]}{$x}[0]){
								$iso = "Y";
								last;
							}
						}
						
						
						if(length $string == 0){
							$string = "$x:$iso";
						}elsif($string !~ /\Q$x\E/){
							$string .= ",$x:$iso";
						}
					}
				}
			}
			
		}else{
			my @split_coor_2 = split(",",$split_row[3]);
			for my $x (keys %{$hash_CRMs{$split_row[4]}}){
				if($hash_CRMs{$split_row[4]}{$x}[1] < ($split_coor_2[1] + $D2) && $hash_CRMs{$split_row[4]}{$x}[0] > $split_coor_2[1]){
					for my $y (keys %{$hash_iso{$split_row[4]}}){
						if($hash_iso{$split_row[4]}{$y}[0] > $split_coor_2[1] && $hash_iso{$split_row[4]}{$y}[1] < $hash_CRMs{$split_row[4]}{$x}[0]){
							$iso = "Y";
							last;
						}
					}
					
					
					if(length $string == 0){
						$string = "$x:$iso";
					}elsif($string !~ /\Q$x\E/){
						$string .= ",$x:$iso";
					}
				}
			}
		}
		
	}
	

	
	if(length($string) == 0){
		print FILE_2 "$split_row[0]\t$split_row[1]\t$split_row[4]\tno_CRM\n";
	}else{
		print FILE_2 "$split_row[0]\t$split_row[1]\t$split_row[4]\t$string\n";
	}
	
	
	
	if($string !~ ":Y"){
		print FILE_1 "$row\n";
	}
	
	
	$string = "";
	$iso = "N";
}

system ("rm $file_ref_net");
system ("mv out/tmp.tsv $file_ref_net");

close FILE_1;
close FILE_2;

#~ for my $x (keys %hash_iso){
	#~ for my $y (keys %{$hash_iso{$x}}){
		#~ print "$x\t$y\t$hash_iso{$x}{$y}[0]\t$hash_iso{$x}{$y}[1]\n";
	#~ }
#~ }
