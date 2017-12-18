#!/usr/bin/perl -w
use strict;
use warnings;

#INPUT: CTCF_exp.bed TFBS.gff GENEs.gff 

my $file_CTCF = $ARGV[0];
my $file_TFBSs = $ARGV[1];
my $file_GENEs = $ARGV[2];

my %hash_TFBSs = ();
my %hash_CTCF_coor = ();
my %hash_GENEs = ();
	
open(my $fh, '<:encoding(UTF-8)', $file_TFBSs) #se abre el archivo a analizar
  or die "Could not open file '$file_TFBSs' $!"; 
  
while (my $row2 = <$fh>) { #lectura del archivo linea por linea
	chomp $row2;
	
	my @split_row2 = split("\t",$row2);
	my @split_features = split(';',$split_row2[8]);
	my @coor = ($split_row2[3],$split_row2[4]);
	
	for (my $x=0; $x<scalar(@split_features); $x++){
		if($split_features[$x] =~ "bound_moiety="){
			my @split_id = split('=',$split_features[$x]);
			if($split_id[1] =~ ','){
				my @split_fbgn_0 = split(',',$split_id[1]);
				for (my $y=0; $y<scalar(@split_fbgn_0); $y++){
					my @split_final_fbgn = split(':',$split_fbgn_0[$y]);
					
					if(!exists ($hash_TFBSs{$split_row2[0]}{$split_final_fbgn[1]})){
						@{$hash_TFBSs{$split_row2[0]}{$split_final_fbgn[1]}[0]} = @coor;
					}else{
						my $num = scalar @{$hash_TFBSs{$split_row2[0]}{$split_final_fbgn[1]}};
						@{$hash_TFBSs{$split_row2[0]}{$split_final_fbgn[1]}[$num]} = @coor;
						
					}
					
				}
				
			}else{
				
				my @split_fbgn = split(':',$split_id[1]);
				if(!exists ($hash_TFBSs{$split_row2[0]}{$split_fbgn[1]})){
					@{$hash_TFBSs{$split_row2[0]}{$split_fbgn[1]}[0]} = @coor;
				}else{
					my $num = scalar @{$hash_TFBSs{$split_row2[0]}{$split_fbgn[1]}};
					@{$hash_TFBSs{$split_row2[0]}{$split_fbgn[1]}[$num]} = @coor;
					
				}
				
			}
		}
	}	
	
}

open(my $fh3, '<:encoding(UTF-8)', $file_GENEs) #se abre el archivo a analizar
  or die "Could not open file '$file_GENEs' $!"; 
  
while (my $row = <$fh3>) { #lectura del archivo linea por linea
	chomp $row;
	my @split_row = split ("\t",$row);
	my @split_id = split (';', $split_row[8]);
	my @split_id_2 = split ('=',$split_id[0]);
	my @coor = ($split_row[3],$split_row[4]);
	
	
	@{$hash_GENEs{$split_row[0]}{$split_id_2[1]}} = @coor;
	
	
}

my $var = 500;


#~ open FILE,">output_CTCF_script.txt";

open(my $fh2, '<:encoding(UTF-8)', $file_CTCF) #se abre el archivo a analizar
  or die "Could not open file '$file_CTCF' $!"; 

while (my $row = <$fh2>) { #lectura del archivo linea por linea
	chomp $row;
	

	
	
	my @split_row = split ("\t",$row);
	my $string;
	my $flag = 0;
	
	
	for my $key_2_TFBSs(keys %{$hash_TFBSs{$split_row[0]}}){ #key = gen_tf
		for (my $i=0; $i < scalar (@{$hash_TFBSs{$split_row[0]}{$key_2_TFBSs}}); $i++){ #coordenadas de un mismo gen
			
			
			if($split_row[1] - $var < $hash_TFBSs{$split_row[0]}{$key_2_TFBSs}[$i][0]){
				if($split_row[2] + $var > $hash_TFBSs{$split_row[0]}{$key_2_TFBSs}[$i][0]  && $split_row[2] + $var <= $hash_TFBSs{$split_row[0]}{$key_2_TFBSs}[$i][1]){
					$string.= "$key_2_TFBSs,";
					$flag = 1;

				}
				if($split_row[2] + $var > $hash_TFBSs{$split_row[0]}{$key_2_TFBSs}[$i][1]){
					$string.= "$key_2_TFBSs,";
					$flag = 1;
				}
				
			}
			
			if($split_row[1] - $var > $hash_TFBSs{$split_row[0]}{$key_2_TFBSs}[$i][0]){
				if($hash_TFBSs{$split_row[0]}{$key_2_TFBSs}[$i][1]  > $split_row[1] - $var && $split_row[2] + $var >= $hash_TFBSs{$split_row[0]}{$key_2_TFBSs}[$i][1]){
					$string.= "$key_2_TFBSs,";
					$flag = 1;
				}
				if($split_row[2] + $var < $hash_TFBSs{$split_row[0]}{$key_2_TFBSs}[$i][1]){
					$string.= "$key_2_TFBSs,";
					$flag = 1;
				}	
			}
			
			if($split_row[1] - $var == $hash_TFBSs{$split_row[0]}{$key_2_TFBSs}[$i][0]){
				
				if($split_row[2] + $var > $hash_TFBSs{$split_row[0]}{$key_2_TFBSs}[$i][1]){
					$string.= "$key_2_TFBSs,";
					$flag = 1;
				}
				if($split_row[2] + $var < $hash_TFBSs{$split_row[0]}{$key_2_TFBSs}[$i][1]){
					$string.= "$key_2_TFBSs,";
					$flag = 1;
				}
				if($split_row[2] + $var == $hash_TFBSs{$split_row[0]}{$key_2_TFBSs}[$i][1]){
					$string.= "$key_2_TFBSs,";
					$flag = 1;
				}
				
			}
		}
	}
	if($flag == 1){
		my @array = ($split_row[1], $split_row[2],$string);
		if(!exists $hash_CTCF_coor{$split_row[0]}){
			@{$hash_CTCF_coor{$split_row[0]}[0]} = @array;
		}else{
			my $num = scalar @{$hash_CTCF_coor{$split_row[0]}};
			@{$hash_CTCF_coor{$split_row[0]}[$num]} = @array;
		}
		#~ print FILE "$row\t$string\n";
	}else{
		my @array = ($split_row[1], $split_row[2],'*');
		if(!exists $hash_CTCF_coor{$split_row[0]}){
			@{$hash_CTCF_coor{$split_row[0]}[0]} = @array;
		}else{
			my $num = scalar @{$hash_CTCF_coor{$split_row[0]}};
			@{$hash_CTCF_coor{$split_row[0]}[$num]} = @array;
		}
	}
	
	
}

for my $i (keys %hash_CTCF_coor){
	for(my $k=0; $k<scalar @{$hash_CTCF_coor{$i}};$k++){
		for (my $j=$k+1; $j<scalar @{$hash_CTCF_coor{$i}};$j++){
			my $string = "";
			my $flag = 0;
			print "$i\t$hash_CTCF_coor{$i}[$k][0]\t$hash_CTCF_coor{$i}[$k][1]\t$hash_CTCF_coor{$i}[$j][0]\t$hash_CTCF_coor{$i}[$j][1]\t$hash_CTCF_coor{$i}[$k][2]\t$hash_CTCF_coor{$i}[$j][2]\t";
			for my $x  (keys %{$hash_GENEs{$i}}){
				#~ for (my $y=0;$y<scalar @{$hash_GENEs{$i}{$x}};$y++){
					if($hash_CTCF_coor{$i}[$j][0] > $hash_GENEs{$i}{$x}[1] && $hash_CTCF_coor{$i}[$k][1] < $hash_GENEs{$i}{$x}[0]){
						if($string !~ $x){
							$string.="$x,";
							$flag = 1;
						} 
					}
				#~ }
			}
			if ($flag == 1){
				print "$string\n";
			}else{
				$string.="*";
				print "$string\n";
			}
			last;
		}
			
		
	}
	
}
#~ close FILE;
