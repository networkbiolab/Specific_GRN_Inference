#!/usr/bin/perl -w
use strict;
use warnings;

my $ref_net = $ARGV[1];
my $file_exp = $ARGV[0];
my $option = $ARGV[2];
my $file = $ARGV[3];

#option 1: dnase, 2: meth

my %hash = ();
my $count = 0;

open(my $fh, $file_exp) #se abre el archivo a analizar
  or die "Could not open file '$file_exp' $!"; 

while (my $row = <$fh>) { #lectura del archivo de genes linea por linea
	chomp $row;
	
	my @split_row = split ("\t", $row);
	
	if($split_row[0] =~ "chr"){
		$split_row[0] =~ s/chr//;
	}
	
	if(!exists $hash{$split_row[0]}{$count}){
		my @array = ($split_row[1],$split_row[2]);
		@{$hash{$split_row[0]}{$count}} = @array; 
		$count++;
	}
	
	
}


my $flag = 0;

#~ open FILE , ">$file";

open(my $fh2, $ref_net) #se abre el archivo a analizar
  or die "Could not open file '$ref_net' $!"; 

while (my $row = <$fh2>) { #lectura del archivo de genes linea por linea
	chomp $row;
	
	my @split_row = split("\t",$row);
	
	if($split_row[3] =~ ";"){
		my @split_coor = split(";",$split_row[3]);
		for(my $x=0; $x<scalar(@split_coor); $x++){
			my @split_coor_2 = split(",",$split_coor[$x]);
			for my $j (keys %{$hash{$split_row[4]}}){
				if($split_coor_2[0] < $hash{$split_row[4]}{$j}[0]){
					if($split_coor_2[1] > $hash{$split_row[4]}{$j}[0] && $split_coor_2[1] <= $hash{$split_row[4]}{$j}[1]){
						$flag = 1;
						last;
					}
					if($split_coor_2[1] > $hash{$split_row[4]}{$j}[1]){
						$flag = 1;
						last;
					}
				}
				
				if($split_coor_2[0] > $hash{$split_row[4]}{$j}[0]){
					if($hash{$split_row[4]}{$j}[1] > $split_coor_2[0] && $split_coor_2[1] >= $hash{$split_row[4]}{$j}[1]){
						$flag = 1;
						last;
					}
					if($split_coor_2[1] < $hash{$split_row[4]}{$j}[1]){
						$flag = 1;
						last;
					}
				}
				
				if($split_coor_2[0] == $hash{$split_row[4]}{$j}[0]){
					if($split_coor_2[0] > $hash{$split_row[4]}{$j}[1]){
						$flag = 1;
						last;
					}
					if($split_coor_2[0] < $hash{$split_row[4]}{$j}[1]){
						$flag = 1;
						last;
					}
					if($split_coor_2[0] == $hash{$split_row[4]}{$j}[1]){
						$flag = 1;
						last;
					}
				}
			}
			
			if($flag == 1){
				last;
			}
		}
	}else{
		my @split_coor_2 = split(",",$split_row[3]);
		for my $j (keys %{$hash{$split_row[4]}}){
			if($split_coor_2[0] < $hash{$split_row[4]}{$j}[0]){
				if($split_coor_2[1] > $hash{$split_row[4]}{$j}[0] && $split_coor_2[1] <= $hash{$split_row[4]}{$j}[1]){
					$flag = 1;
					last;
				}
				if($split_coor_2[1] > $hash{$split_row[4]}{$j}[1]){
					$flag = 1;
					last;
				}
			}
			
			if($split_coor_2[0] > $hash{$split_row[4]}{$j}[0]){
				if($hash{$split_row[4]}{$j}[1] > $split_coor_2[0] && $split_coor_2[1] >= $hash{$split_row[4]}{$j}[1]){
					$flag = 1;
					last;
				}
				if($split_coor_2[1] < $hash{$split_row[4]}{$j}[1]){
					$flag = 1;
					last;
				}
			}
			
			if($split_coor_2[0] == $hash{$split_row[4]}{$j}[0]){
				if($split_coor_2[0] > $hash{$split_row[4]}{$j}[1]){
					$flag = 1;
					last;
				}
				if($split_coor_2[0] < $hash{$split_row[4]}{$j}[1]){
					$flag = 1;
					last;
				}
				if($split_coor_2[0] == $hash{$split_row[4]}{$j}[1]){
					$flag = 1;
					last;
				}
			}
		}
		
	}
	
	if($option == 1){
		if($flag == 1){
			print "$row\n";
			$flag = 0;
		}
	}elsif($option == 2){ 
		if($flag == 0){
			print "$row\n";
		}else{
			$flag = 0;
		}
	}
}
	



#~ for my $i (keys %hash){
	#~ for my $j (keys %{$hash{$i}}){
		#~ print "$i\t$j\t$hash{$i}{$j}[0]\t$hash{$i}{$j}[1]\n";
	#~ }
	
#~ }
