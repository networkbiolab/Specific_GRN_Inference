#!/usr/bin/perl -w
use strict;
use warnings;

#INPUT: n-replicas.bed
#OUTPUT: sobrelap.bed
#HEADER: chr coor_I coor_T n_sobrelap tamano files_replica

my %hash_replicas = ();
#~ my @sizes;

for(my $i=0;$i<scalar @ARGV;$i++){

	
	open(my $fh, '<:encoding(UTF-8)', $ARGV[$i]) #se abre el archivo a analizar
	  or die "Could not open file '$ARGV[$i]' $!"; 
	  
	
	while (my $row = <$fh>) { #lectura del archivo linea por linea
		chomp $row;
		
		my @split_row = split("\t",$row);
		my @coor = ($split_row[1],$split_row[2],1,$ARGV[$i]); #coor_i,coor_t
		
		if($split_row[0] eq "X" || $split_row[0] eq "2L" || $split_row[0] eq "2R" || $split_row[0] eq "4" || $split_row[0] eq "3L" || $split_row[0] eq "3R"){    
			
			
			if(!exists $hash_replicas{$split_row[0]}){ #key hash = {chr}
				@{$hash_replicas{$split_row[0]}[0]} = @coor; #almacenamiento de las coordenadas en el hash
			}else{
				my $num = scalar (@{$hash_replicas{$split_row[0]}});
				@{$hash_replicas{$split_row[0]}[$num]} = @coor; #hash_replicas{chr}
			}	
		}
	}
	
	
	
}



my $var = 150;
my $option = 0;
my @values = (0,150,300,600,1500);
my $in = 0;

#~ print "Presione ENTER para valor por defecto (150)\n";
#~ while ($option == 0){
	#~ print "Ingrese valor: ";
	#~ my $in = <STDIN>;
	#~ chomp $in;

	#~ if ($in =~ /^[0-9]+$/){
		#~ $var = $in;
		#~ $option = 1;  
	#~ } else {
		#~ if(length $in != 0){  
			#~ print "Valor invalido, ingrese nuevamente \n";
		#~ }
	#~ } 
	
	#~ if (length $in == 0){
		#~ $option = 1;
	#~ }
	
	
#~ }

#~ print scalar @{$hash_replicas{"chr2R"}},"\n";

for my $k (keys %hash_replicas){
	for (my $first=0; $first<scalar @{$hash_replicas{$k}};$first++){
	
		my $coor_I = $hash_replicas{$k}[$first][0] - $var;
		my $coor_T = $hash_replicas{$k}[$first][1] + $var;
		my $repl = $hash_replicas{$k}[$first][2];
		my $file = $hash_replicas{$k}[$first][3];
	
		
		#~ print "first = $first\n";
		for (my $sec=$first+1; $sec<scalar @{$hash_replicas{$k}};$sec++){
			#~ print "sec= $sec scalar= ",scalar @{$hash_replicas{$k}},"\n";
			my $x=0;
			#~ print "SEC!!!!!!!!!!!!!!!!!!! $sec\n";
			if($coor_I < $hash_replicas{$k}[$sec][0] - $var && $x == 0){
				if($coor_T > $hash_replicas{$k}[$sec][0] -$var && $coor_T <= $hash_replicas{$k}[$sec][1] + $var && $x == 0){
					$coor_I = $hash_replicas{$k}[$sec][0] - $var;
					$repl = ($repl + 1);
					if($file !~ $hash_replicas{$k}[$sec][3]){
						$file .= ",$hash_replicas{$k}[$sec][3]";
						
					}
				
					
					splice @{$hash_replicas{$k}}, $sec, 1;
					$sec--;
					$x=1;
					#~ last;
				}
				if($coor_T > $hash_replicas{$k}[$sec][1] + $var && $x == 0){
					$coor_I = $hash_replicas{$k}[$sec][0] - $var;
					$coor_T = $hash_replicas{$k}[$sec][1] + $var;
					$repl = ($repl + 1);
					if($file !~ $hash_replicas{$k}[$sec][3]){
						$file .= ",$hash_replicas{$k}[$sec][3]";
						
					}
					
					
					splice @{$hash_replicas{$k}}, $sec, 1;
					$sec--;
					$x=1;
					#~ last;
				}
				
			}
			#~ print "$coor_I $hash_replicas{$k}[$sec][0]\n";
			if($coor_I > $hash_replicas{$k}[$sec][0] - $var && $x == 0){
				if($hash_replicas{$k}[$sec][1] + $var > $coor_I && $coor_T >= $hash_replicas{$k}[$sec][1] + $var && $x == 0){
					$coor_T = $hash_replicas{$k}[$sec][1] + $var;
					$repl = ($repl + 1);
					if($file !~ $hash_replicas{$k}[$sec][3]){
						$file .= ",$hash_replicas{$k}[$sec][3]";
						
					}
					
					
					splice @{$hash_replicas{$k}}, $sec, 1;
					$sec--;
					$x=1;
					#~ last;
				}
				if($coor_T < $hash_replicas{$k}[$sec][1] + $var && $x == 0){
					$repl = ($repl + 1);
					if($file !~ $hash_replicas{$k}[$sec][3]){
						$file .= ",$hash_replicas{$k}[$sec][3]";
						
					}
					
					
					splice @{$hash_replicas{$k}}, $sec, 1;
					$sec--;
					$x=1;
					#~ last;
				
				}	
			}
			#~ print "$coor_I $hash_replicas{$k}[$sec][0]\n";
			if($coor_I == $hash_replicas{$k}[$sec][0] - $var && $x == 0){
				#~ print "/////////////////////\n";
				if($coor_T > $hash_replicas{$k}[$sec][1] + $var && $x == 0){
					$coor_I = $hash_replicas{$k}[$sec][0] - $var;
					$coor_T =  $hash_replicas{$k}[$sec][1] + $var;
					$repl = ($repl + 1);
					if($file !~ $hash_replicas{$k}[$sec][3]){
						$file .= ",$hash_replicas{$k}[$sec][3]";
						
					}
					
			
					splice @{$hash_replicas{$k}}, $sec, 1;
					$sec--;
					$x=1;
					#~ last;
				}
				if($coor_T < $hash_replicas{$k}[$sec][1] + $var && $x == 0){
					$repl = ($repl + 1);
					if($file !~ $hash_replicas{$k}[$sec][3]){
						$file .= ",$hash_replicas{$k}[$sec][3]";
						
					}
					
					splice @{$hash_replicas{$k}}, $sec, 1;
					$sec--;
					$x=1;
					#~ last;
				}
				if($coor_T == $hash_replicas{$k}[$sec][1] + $var && $x == 0){
					$repl = ($repl + 1);
					if($file !~ $hash_replicas{$k}[$sec][3]){
						$file .= ",$hash_replicas{$k}[$sec][3]";
						
					}
					
					splice @{$hash_replicas{$k}}, $sec, 1;
					$sec--;
					$x=1;
					#~ last;
				}
				
			}
		
			
		}
	
		
		my @coor = ($coor_I, $coor_T, $repl,$file);
		@{$hash_replicas{$k}[$first]} = @coor;

		
		
	}
}	
open FILE, ">out_sobrelap.bed";
for my $l (keys %hash_replicas){
	for (my $m=0; $m<scalar @{$hash_replicas{$l}};$m++){
		my $count = 0;
		for(my $i=0; $i<scalar @ARGV; $i++){
			if($hash_replicas{$l}[$m][3] =~ $ARGV[$i]){
				$count++;
			}
			
		}
		if($count == scalar @ARGV){
			print FILE "$l\t$hash_replicas{$l}[$m][0]\t";
			print FILE "$hash_replicas{$l}[$m][1]\t$hash_replicas{$l}[$m][2]\t";
			print FILE $hash_replicas{$l}[$m][1] - $hash_replicas{$l}[$m][0],"\t";
			print FILE $hash_replicas{$l}[$m][3],"\n";
		}
	}
}
close FILE;
