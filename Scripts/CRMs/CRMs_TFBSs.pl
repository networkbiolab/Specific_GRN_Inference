#!/usr/bin/perl -w
use strict;
use warnings;

my $file_tfbs = $ARGV[0];
my $file_CRMs = $ARGV[1];

my %hash_tfbs = ();
my %hash_tfbs_count = ();

open(my $fh, '<:encoding(UTF-8)', $file_tfbs) #se abre el archivo a analizar
  or die "Could not open file '$file_tfbs' $!"; 
  
while (my $row2 = <$fh>) { #lectura del archivo linea por linea
	chomp $row2;
	
	my $num = 0;
	my @split_row2 = split("\t", $row2);
	my @split_features2 = split(';',$split_row2[8]);
	if(scalar @split_features2 == 5){
		$num = 4;
	}else{
		$num = 5;
	}
	my @split_id_gen2 = split('=',$split_features2[$num]);
	if($num == 5){ 
		my @split_feat = split(',',$split_id_gen2[1]);#en un mismo tfbs se pueden unir más de un tf
		for(my $i=0; $i<scalar @split_feat; $i++){
			
			my @split_id_1 = split (':',$split_feat[$i]);
			my @array2 = ($split_row2[3],$split_row2[4]);#coor_I,coor_E
	
			$hash_tfbs_count{$split_row2[0]}{$split_id_1[1]}{$split_row2[3]}{$split_row2[4]}++;#hash_tfbs_count{chr}{FBgn}{coor_i}{coor_E}
			
			if (!exists ($hash_tfbs{$split_row2[0]}{$split_id_1[1]})){
				@{$hash_tfbs{$split_row2[0]}{$split_id_1[1]}[0]} = @array2;#hash_tfbs{chr}{Fbgn}[0] -->array debido a que un tf puede tener distintos tfbs
			}else{
				my $num2 = scalar (@{$hash_tfbs{$split_row2[0]}{$split_id_1[1]}});
				@{$hash_tfbs{$split_row2[0]}{$split_id_1[1]}[$num2]} = @array2;
			}
		}
	}else{
		my @split_id = split(':',$split_id_gen2[1]);
		
		my @array2 = ($split_row2[3],$split_row2[4]);
		
		$hash_tfbs_count{$split_row2[0]}{$split_id[1]}{$split_row2[3]}{$split_row2[4]}++;
		
		if (!exists ($hash_tfbs{$split_row2[0]}{$split_id[1]})){
			@{$hash_tfbs{$split_row2[0]}{$split_id[1]}[0]} = @array2;
		}else{
			my $num2 = scalar (@{$hash_tfbs{$split_row2[0]}{$split_id[1]}});
			@{$hash_tfbs{$split_row2[0]}{$split_id[1]}[$num2]} = @array2;
		}
	}
	
	
}

my %hash_result = ();

open(my $fh2, '<:encoding(UTF-8)', $file_CRMs) #se abre el archivo a analizar
  or die "Could not open file '$file_CRMs' $!"; 
  
while (my $row = <$fh2>) { #lectura del archivo linea por linea
	chomp $row;
	
	my @split_row = split ("\t",$row);
	if($split_row[3] ne "CRMName"){
		for my $i (keys %{$hash_tfbs{$split_row[0]}}){
			for(my $j=0; $j<scalar(@{$hash_tfbs{$split_row[0]}{$i}}); $j++){
				if(($split_row[1]-150)<$hash_tfbs{$split_row[0]}{$i}[$j][0]){
					if(($split_row[2]+150)>$hash_tfbs{$split_row[0]}{$i}[$j][0] && ($split_row[2]+150)<=$hash_tfbs{$split_row[0]}{$i}[$j][1]){
						if(!exists $hash_result{$i}{$split_row[4]}){
							my @aux = (1,"$hash_tfbs{$split_row[0]}{$i}[$j][0],$hash_tfbs{$split_row[0]}{$i}[$j][1]",$split_row[0],"TFBS");
							@{$hash_result{$i}{$split_row[4]}} = @aux; 
						}else{
							$hash_result{$i}{$split_row[4]}[1] .= ";$hash_tfbs{$split_row[0]}{$i}[$j][0],$hash_tfbs{$split_row[0]}{$i}[$j][1]"; 
						}
					}
					
					if(($split_row[2]+150)>$hash_tfbs{$split_row[0]}{$i}[$j][1]){
						if(!exists $hash_result{$i}{$split_row[4]}){
							my @aux = (1,"$hash_tfbs{$split_row[0]}{$i}[$j][0],$hash_tfbs{$split_row[0]}{$i}[$j][1]",$split_row[0],"TFBS");
							@{$hash_result{$i}{$split_row[4]}} = @aux; 
						}else{
							$hash_result{$i}{$split_row[4]}[1] .= ";$hash_tfbs{$split_row[0]}{$i}[$j][0],$hash_tfbs{$split_row[0]}{$i}[$j][1]"; 
						}
					}
					
				}
				if(($split_row[1]-150)>$hash_tfbs{$split_row[0]}{$i}[$j][0]){
					if($hash_tfbs{$split_row[0]}{$i}[$j][1]>($split_row[1]-150) && ($split_row[2]+150)>=$hash_tfbs{$split_row[0]}{$i}[$j][1]){
						if(!exists $hash_result{$i}{$split_row[4]}){
							my @aux = (1,"$hash_tfbs{$split_row[0]}{$i}[$j][0],$hash_tfbs{$split_row[0]}{$i}[$j][1]",$split_row[0],"TFBS");
							@{$hash_result{$i}{$split_row[4]}} = @aux; 
						}else{
							$hash_result{$i}{$split_row[4]}[1] .= ";$hash_tfbs{$split_row[0]}{$i}[$j][0],$hash_tfbs{$split_row[0]}{$i}[$j][1]"; 
						}
					}
					if(($split_row[2]+150)<$hash_tfbs{$split_row[0]}{$i}[$j][1]){
						if(!exists $hash_result{$i}{$split_row[4]}){
							my @aux = (1,"$hash_tfbs{$split_row[0]}{$i}[$j][0],$hash_tfbs{$split_row[0]}{$i}[$j][1]",$split_row[0],"TFBS");
							@{$hash_result{$i}{$split_row[4]}} = @aux; 
						}else{
							$hash_result{$i}{$split_row[4]}[1] .= ";$hash_tfbs{$split_row[0]}{$i}[$j][0],$hash_tfbs{$split_row[0]}{$i}[$j][1]"; 
						}
					}
				}
				if(($split_row[1]-150)==$hash_tfbs{$split_row[0]}{$i}[$j][0]){
					if(($split_row[2]+150)>$hash_tfbs{$split_row[0]}{$i}[$j][1]){
						if(!exists $hash_result{$i}{$split_row[4]}){
							my @aux = (1,"$hash_tfbs{$split_row[0]}{$i}[$j][0],$hash_tfbs{$split_row[0]}{$i}[$j][1]",$split_row[0],"TFBS");
							@{$hash_result{$i}{$split_row[4]}} = @aux; 
						}else{
							$hash_result{$i}{$split_row[4]}[1] .= ";$hash_tfbs{$split_row[0]}{$i}[$j][0],$hash_tfbs{$split_row[0]}{$i}[$j][1]"; 
						}
					}
					if(($split_row[2]+150)<$hash_tfbs{$split_row[0]}{$i}[$j][1]){
						if(!exists $hash_result{$i}{$split_row[4]}){
							my @aux = (1,"$hash_tfbs{$split_row[0]}{$i}[$j][0],$hash_tfbs{$split_row[0]}{$i}[$j][1]",$split_row[0],"TFBS");
							@{$hash_result{$i}{$split_row[4]}} = @aux; 
						}else{
							$hash_result{$i}{$split_row[4]}[1] .= ";$hash_tfbs{$split_row[0]}{$i}[$j][0],$hash_tfbs{$split_row[0]}{$i}[$j][1]"; 
						}
					}
					if(($split_row[2]+150)==$hash_tfbs{$split_row[0]}{$i}[$j][1]){
						if(!exists $hash_result{$i}{$split_row[4]}){
							my @aux = (1,"$hash_tfbs{$split_row[0]}{$i}[$j][0],$hash_tfbs{$split_row[0]}{$i}[$j][1]",$split_row[0],"TFBS");
							@{$hash_result{$i}{$split_row[4]}} = @aux; 
						}else{
							$hash_result{$i}{$split_row[4]}[1] .= ";$hash_tfbs{$split_row[0]}{$i}[$j][0],$hash_tfbs{$split_row[0]}{$i}[$j][1]"; 
						}
					}
				}
			}
		}
	}
}

open FILE,">out/output_CRMs_TFBSs.tsv";

for my $x (keys %hash_result){
	for my $y (keys %{$hash_result{$x}}){
		#~ for(my $z=0;$z<scalar @{$hash_result{$x}{$y};$z++){
			print FILE "$x\t$y\t$hash_result{$x}{$y}[0]\t$hash_result{$x}{$y}[1]\t$hash_result{$x}{$y}[2]\t$hash_result{$x}{$y}[3]\n";
		#~ }
	}
	
}
close FILE;
