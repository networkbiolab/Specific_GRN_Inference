#!/usr/bin/perl -w
use strict;
use warnings;

my $file_ref_net = $ARGV[0];
my $file_CRMs = $ARGV[1];
my $file_GENEs = $ARGV[2];
my $file_iso = $ARGV[3];
my $D2 = $ARGV[4];


my %hash_ref = ();
my %hash_genes = ();
my %hash_CRMs = ();
my %hash_iso = ();


open(my $fh, $file_iso) #se abre el archivo a analizar
  or die "Could not open file '$file_iso' $!"; 

while (my $row = <$fh>) { #lectura del archivo de genes linea por linea
	chomp $row;
	
	my @split_row = split("\t", $row);
	
	if($split_row[0] =~ "chr"){
		$split_row[0] =~ s/chr//;
		
	}
	
	my @array = ($split_row[1], $split_row[2]);
	
	@{$hash_iso{$split_row[0]}} = @array;
	
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

open(my $fh4, $file_ref_net) #se abre el archivo a analizar
  or die "Could not open file '$file_ref_net' $!"; 

while (my $row = <$fh4>) { #lectura del archivo de genes linea por linea
	chomp $row;
	my $string = "";
	my $iso = "";
	
	
	my @split_row = split("\t", $row);
	
	if($hash_genes{$split_row[1]} eq "+"){
		
		if($split_row[3] =~ ";"){
			
			my @split_coor = split(";",$split_row[3]);
			for(my $i=0; $i<scalar(@split_coor); $i++){
				my @split_coor_2 = split(",",$split_coor[$i]);
				for my $x (keys %{$hash_CRMs{$split_row[4]}}){
					if($hash_CRMs{$split_row[4]}{$x}[0] > ($split_coor_2[0] - $D2) && $hash_CRMs{$split_row[4]}{$x}[1] < $split_coor_2[0]){
						for my $y (keys %hash_iso){
							if($hash_iso{$y}[0] > $hash_CRMs{$split_row[4]}{$x}[1] && $hash_iso{$y}[1] < $split_coor_2[0]){
								$iso = "Y";
								last;
							}else{
								$iso = "N";
							}
						}
						
						
						if(length $string == 0){
							$string = "$x:$iso";
						}elsif($string !~ /\Q$x\E/){
							$string .= ",$x:$iso";
						}
						
						
						
						#~ print "$x\n";
					}
				}
			}
			
		}else{
			my @split_coor_2 = split(",",$split_row[3]);
			for my $x (keys %{$hash_CRMs{$split_row[4]}}){
				if($hash_CRMs{$split_row[4]}{$x}[0] > ($split_coor_2[0] - $D2) && $hash_CRMs{$split_row[4]}{$x}[1] < $split_coor_2[0]){
					for my $y (keys %hash_iso){
						if($hash_iso{$y}[0] > $hash_CRMs{$split_row[4]}{$x}[1] && $hash_iso{$y}[1] < $split_coor_2[0]){
							$iso = "Y";
							last;
						}else{
							$iso = "N";
						}
					}
					
					
					if(length $string == 0){
						$string = "$x:$iso";
					}elsif($string !~ /\Q$x\E/){
						$string .= ",$x:$iso";
					}
					#~ print "$x\n";
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
						for my $y (keys %hash_iso){
							if($hash_iso{$y}[0] > $split_coor_2[1] && $hash_iso{$y}[1] < $hash_CRMs{$split_row[4]}{$x}[0]){
								$iso = "Y";
								last;
							}else{
								$iso = "N";
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
					for my $y (keys %hash_iso){
						if($hash_iso{$y}[0] > $split_coor_2[1] && $hash_iso{$y}[1] < $hash_CRMs{$split_row[4]}{$x}[0]){
							$iso = "Y";
							last;
						}else{
							$iso = "N";
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
	
	if(length $string == 0){
		print "$row\tno_CRM\n";
	}else{
		print "$row\t$string\n";
	}
	$string = "";
	$iso = "";
}


#~ for my $x (keys %hash_CRMs){
	#~ for my $y (keys %{$hash_CRMs{$x}}){
		#~ print "$x\t$y\n";
	
	#~ }
#~ }
