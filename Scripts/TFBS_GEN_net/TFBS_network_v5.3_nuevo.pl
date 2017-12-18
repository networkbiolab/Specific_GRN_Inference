#!/usr/bin/perl -w
use strict;
use warnings;

#Entrada GENES.gff TFBS.gff synonym.tsv
#OUTPUT out_TFBS_network.tsv
#HEADER: FBgn_source	FBgn_target	interaction	replicates	Chromosome
my $file_gen = $ARGV[0];
my $file_tfbs = $ARGV[1];
my $file_synonym = $ARGV[2];
my $x = 0;
my $D = $ARGV[3];
my %hash_gen = ();
my %hash_tfbs = ();
my %hash_tfbs_count = ();
my %hash_result = ();

#~ print "Presione ENTER para valor por defecto (2000)\n";


#~ while($x == 0){
	
	#~ print "Ingrese valor D: ";
	#~ my $in = <STDIN>;
	#~ chomp $in;

	#~ if ($in =~ /^[0-9]+$/){
		#~ $D = $in;
		#~ $x = 1;  
	#~ } else {
		#~ if(length $in != 0){  
			#~ print "Valor invalido, ingrese nuevamente \n";
		#~ }
	#~ } 
	
	#~ if (length $in == 0){
		#~ $x = 1;
	#~ }
	
#~ }    

my $option = $ARGV[4];
#~ while ($option != 1 && $option != 2){
	#~ print "\n";

	#~ print "Limite TSS [1]\n";
	#~ print "Limite E [2]\n";
	#~ my $in2 = <STDIN>;
	#~ chomp $in2;
	#~ if ($in2 =~ /^[0-9]+$/){
		#~ $option = $in2;
	#~ }else{
		#~ $option = 0;
	#~ }
	
	
	
	
#~ }
   
print "D_region = $D \n";
#~ print "<<<<<<<<<<<<<<<<<<<< \n";

open(my $fh, '<:encoding(UTF-8)', $file_gen) #se abre el archivo a analizar
  or die "Could not open file '$file_gen' $!"; 


while (my $row = <$fh>) { #lectura del archivo linea por linea
	chomp $row;
	
	my @split_row = split("\t", $row);
	my @split_features = split(';',$split_row[8]);
	my @split_id_gen = split('=',$split_features[0]);

	my @array = ($split_row[3], $split_row[4]); #coor I, coor E
	if (!exists ($hash_gen{$split_row[0]}{$split_row[6]}{$split_id_gen[1]})){ #hash_gen{chr}{strand}{Fbgn}
		@{$hash_gen{$split_row[0]}{$split_row[6]}{$split_id_gen[1]}[0]} = @array;
	}else{
		my $num = scalar (@{$hash_gen{$split_row[0]}{$split_row[6]}{$split_id_gen[1]}});
		@{$hash_gen{$split_row[0]}{$split_row[6]}{$split_id_gen[1]}[$num]} = @array;
	}
	
	
}


open(my $fh2, '<:encoding(UTF-8)', $file_tfbs) #se abre el archivo a analizar
  or die "Could not open file '$file_tfbs' $!"; 
  
while (my $row2 = <$fh2>) { #lectura del archivo linea por linea
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


for my $k (keys %hash_tfbs){
	for my $l (keys %{$hash_tfbs{$k}}){
		for (my $x=0; $x<scalar @{$hash_tfbs{$k}{$l}}; $x++){	
			for my $m (keys %{$hash_gen{$k}{'+'}}){
					my $D_TSS = $hash_gen{$k}{'+'}{$m}[0][0] - $D;
					if($option == 1){
						if($hash_tfbs{$k}{$l}[$x][0] > $D_TSS && $hash_tfbs{$k}{$l}[$x][1] < $hash_gen{$k}{'+'}{$m}[0][0]){
							if(!exists $hash_result{$l}{$m}{$k}){
								$hash_result{$l}{$m}{$k} = "$hash_tfbs{$k}{$l}[$x][0],$hash_tfbs{$k}{$l}[$x][1]";
							}else{
								$hash_result{$l}{$m}{$k}.= ";$hash_tfbs{$k}{$l}[$x][0],$hash_tfbs{$k}{$l}[$x][1]";
							}
						} 
						if($hash_tfbs{$k}{$l}[$x][0] < $D_TSS && $hash_tfbs{$k}{$l}[$x][1] < $hash_gen{$k}{'+'}{$m}[0][0] && $hash_tfbs{$k}{$l}[$x][1] > $D_TSS){
							if(!exists $hash_result{$l}{$m}){
								$hash_result{$l}{$m}{$k} = "$hash_tfbs{$k}{$l}[$x][0],$hash_tfbs{$k}{$l}[$x][1]";
							}else{
								$hash_result{$l}{$m}{$k} .= ";$hash_tfbs{$k}{$l}[$x][0],$hash_tfbs{$k}{$l}[$x][1]";
							}	
						}
					}
					if($option == 2){
						if($hash_tfbs{$k}{$l}[$x][0] > $D_TSS && $hash_tfbs{$k}{$l}[$x][1] < $hash_gen{$k}{'+'}{$m}[0][1]){
							if(!exists $hash_result{$l}{$m}{$k}){
								$hash_result{$l}{$m}{$k} = "$hash_tfbs{$k}{$l}[$x][0],$hash_tfbs{$k}{$l}[$x][1]";
							}else{
								$hash_result{$l}{$m}{$k} .= ";$hash_tfbs{$k}{$l}[$x][0],$hash_tfbs{$k}{$l}[$x][1]";
							}
						} 
						if($hash_tfbs{$k}{$l}[$x][0] < $D_TSS && $hash_tfbs{$k}{$l}[$x][1] < $hash_gen{$k}{'+'}{$m}[0][1] && $hash_tfbs{$k}{$l}[$x][1] > $D_TSS){
							if(!exists $hash_result{$l}{$m}{$k}){
								$hash_result{$l}{$m}{$k} = "$hash_tfbs{$k}{$l}[$x][0],$hash_tfbs{$k}{$l}[$x][1]";
							}else{
								$hash_result{$l}{$m}{$k} .= ";$hash_tfbs{$k}{$l}[$x][0],$hash_tfbs{$k}{$l}[$x][1]";
							}	
						}
						
						
					}
			}
			for my $n (keys %{$hash_gen{$k}{'-'}}){
				my $TSS_D = $hash_gen{$k}{'-'}{$n}[0][1] + $D;
				if($option == 1){
					if($hash_tfbs{$k}{$l}[$x][1] < $TSS_D && $hash_tfbs{$k}{$l}[$x][0] > $hash_gen{$k}{'-'}{$n}[0][1]){
						if(!exists $hash_result{$l}{$n}{$k}){
							$hash_result{$l}{$n}{$k} = "$hash_tfbs{$k}{$l}[$x][0],$hash_tfbs{$k}{$l}[$x][1]";
						}else{
							$hash_result{$l}{$n}{$k} .= ";$hash_tfbs{$k}{$l}[$x][0],$hash_tfbs{$k}{$l}[$x][1]";
						}
					}
					if($hash_tfbs{$k}{$l}[$x][1] > $TSS_D && $hash_tfbs{$k}{$l}[$x][0] > $hash_gen{$k}{'-'}{$n}[0][1] && $hash_tfbs{$k}{$l}[$x][0] < $TSS_D){
						if(!exists $hash_result{$l}{$n}{$k}){
							$hash_result{$l}{$n}{$k} = "$hash_tfbs{$k}{$l}[$x][0],$hash_tfbs{$k}{$l}[$x][1]";
						}else{
							$hash_result{$l}{$n}{$k} .= ";$hash_tfbs{$k}{$l}[$x][0],$hash_tfbs{$k}{$l}[$x][1]";
						}
						
					}
				}
				if($option == 2){
					if($hash_tfbs{$k}{$l}[$x][1] < $TSS_D && $hash_tfbs{$k}{$l}[$x][0] > $hash_gen{$k}{'-'}{$n}[0][0]){
						if(!exists $hash_result{$l}{$n}{$k}){
							$hash_result{$l}{$n}{$k} = "$hash_tfbs{$k}{$l}[$x][0],$hash_tfbs{$k}{$l}[$x][1]";
						}else{
							$hash_result{$l}{$n}{$k} .= ";$hash_tfbs{$k}{$l}[$x][0],$hash_tfbs{$k}{$l}[$x][1]";
						}
					}
					if($hash_tfbs{$k}{$l}[$x][1] > $TSS_D && $hash_tfbs{$k}{$l}[$x][0] > $hash_gen{$k}{'-'}{$n}[0][0] && $hash_tfbs{$k}{$l}[$x][0] < $TSS_D){
						if(!exists $hash_result{$l}{$n}{$k}){
							$hash_result{$l}{$n}{$k} = "$hash_tfbs{$k}{$l}[$x][0],$hash_tfbs{$k}{$l}[$x][1]";
						}else{
							$hash_result{$l}{$n}{$k} .= ";$hash_tfbs{$k}{$l}[$x][0],$hash_tfbs{$k}{$l}[$x][1]";
						}
						
					}
					
					
				}
				
			}
			
		}
	}
	
}

my %hash_synonym = ();

open(my $fh3, '<:encoding(UTF-8)', $file_synonym) #se abre el archivo a analizar
  or die "Could not open file '$file_synonym' $!"; 
  
while (my $row3 = <$fh3>) { #lectura del archivo linea por linea
	chomp $row3;
	
	if ($row3 !~ "##" && length $row3 != 0){
		my @split_row3 = split ("\t", $row3);
		if($split_row3[0] =~ "FBgn"){
			for(my $var=1; $var<scalar @split_row3; $var++){
				$hash_synonym{$split_row3[0]}.= "$split_row3[$var],";
			}
		
		}
	}
	
}


my %hash_nodes = ();

open FILE, ">out/out_TFBS_network.tsv";

for my $k (keys %hash_result){
	if(!exists $hash_nodes{$k}){
		$hash_nodes{$k} = $hash_synonym{$k};
	}
	for my $l (keys %{$hash_result{$k}}){
		if(!exists $hash_nodes{$l}){
			$hash_nodes{$l} = $hash_synonym{$l};
		}
		for my $o (keys %{$hash_result{$k}{$l}}){
			print FILE "$k\t$l\t1\t$hash_result{$k}{$l}{$o}\t$o\tTFBS\n";
		}
	}
	
}

close FILE;

open FILE2, ">out/nodes_TFBS_network.tsv";

for my $q (keys %hash_nodes){
	print FILE2 "$q\t$hash_nodes{$q}\n";
	
}

close FILE2;

