#!/usr/bin/perl -w
use strict;
use warnings;

#Orden entrada synonym.tsv mirecords.tsv mirtarbase.tsv tarbase.csv
my $file_synonym = $ARGV[0];
my $file_mirecords = $ARGV[1];
my $file_mirTarbase = $ARGV[2];
my $file_tarbase = $ARGV[3];

my %hash_synonym = ();
my %hash_result = ();


open(my $fh3, '<:encoding(UTF-8)', $file_synonym) #se abre el archivo a analizar
  or die "Could not open file '$file_synonym' $!"; 
  
while (my $row3 = <$fh3>) { #lectura del archivo linea por linea
	chomp $row3;
	
	if ($row3 !~ "##" && length $row3 != 0){
		my @split_row3 = split ("\t", $row3);
		if($split_row3[0] =~ "FBgn"){
			if($split_row3[1] !~ /\\/){	
				for(my $var=1; $var<scalar @split_row3; $var++){
					if(length $split_row3[$var] != 0 && $split_row3[$var] ne '.'){
						#~ if($split_row3[$var] =~ "Dmel"){
							my @split_synonym = split (',',$split_row3[$var]);
							for(my $var2=0; $var2<scalar @split_synonym; $var2++){
								my $string = lc($split_synonym[$var2]);
								$hash_synonym{$string} = $split_row3[0]; #hash_synonym{name_gene} = Fbgn
								#~ $hash_synonym{$split_synonym[$var2]} = $split_row3[0]; #hash_synonym{name_gene} = Fbgn
							#~ }
						}	
						#~ $hash_synonym{$split_row3[0]}.= "$split_row3[$var],";
					}
				}
			}
		
		}
	}
	
	#~ if ($row3 !~ "##" && length $row3 != 0){
		#~ my @split_row3 = split ("\t", $row3);
		#~ if($split_row3[0] =~ "FBgn"){
			#~ for(my $var=1; $var<scalar @split_row3; $var++){
				#~ if(length $split_row3[$var] != 0 && $split_row3[$var] ne '.'){
					#~ my @split_synonym = split (',',$split_row3[$var]);
					#~ for(my $var2=0; $var2<scalar @split_synonym; $var2++){
						#~ $hash_synonym{$split_synonym[$var2]} = $split_row3[0]; #hash_synonym{name_gene} = Fbgn
					#~ }
					
				#~ }
			#~ }
		
		#~ }
	#~ }
	
}
	

	
open(my $fh, $file_mirecords) #se abre el archivo a analizar
  or die "Could not open file '$file_mirecords' $!"; 


while (my $row = <$fh>) { #lectura del archivo linea por linea
	chomp $row;
	if($row !~ "Pubmed_id"){
		my @split_row = split ("\t",$row);
		if($split_row[1] =~ "Drosophila melanogaster"){
			my $string_1 = lc($split_row[6]);
			my $string_2 = lc($split_row[2]);
			if(!exists $hash_result{$string_1}{$string_2}){
				$hash_result{$string_1}{$string_2} = 1;
			}else{
				$hash_result{$string_1}{$string_2}++;
			}
		}	
	}	
}

open(my $fh2, $file_mirTarbase) #se abre el archivo a analizar
  or die "Could not open file '$file_mirTarbase' $!"; 


while (my $row2 = <$fh2>) { #lectura del archivo linea por linea
	chomp $row2;
	if($row2 !~ "miRTarBase ID"){
		my @split_row2 = split ("\t",$row2);
		if($split_row2[5] =~ "Drosophila melanogaster"){
			my $string_1 = lc($split_row2[1]);
			my $string_2 = lc($split_row2[3]);
			
			if(!exists $hash_result{$string_1}{$string_2}){
				$hash_result{$string_1}{$string_2} = 1;
			}else{
				$hash_result{$string_1}{$string_2}++;
			}
		}	
	
	}	
}


open(my $fh4, $file_tarbase) #se abre el archivo a analizar
  or die "Could not open file '$file_mirTarbase' $!"; 


while (my $row4 = <$fh4>) { #lectura del archivo linea por linea
	chomp $row4;
	if($row4 !~ "geneId"){
		my @split_row4 = split ("\t",$row4);
		if($split_row4[3] =~ "Drosophila melanogaster"){
			my $string_1 = lc($split_row4[2]);
			my $string_2 = lc($split_row4[0]);
			
			if(!exists $hash_result{$string_1}{$string_2}){
				$hash_result{$string_1}{$string_2} = 1;
			}else{
				$hash_result{$string_1}{$string_2}++;
			}
		}	
	
	}	
}

open FILE, ">out/out_microRNA_network.tsv";

for my $y (keys %hash_result){
	#~ $y = lc($y);
	#~ print "$y\n";
	for my $w (keys %{$hash_result{$y}}){
		#~ $w = lc($w);
		#~ print "$w\n";
		if(exists $hash_synonym{$w}){
			
			if(exists $hash_synonym{$y}){
				print FILE "$hash_synonym{$y}\t$hash_synonym{$w}\t1\t$hash_result{$y}{$w}\n";
			}else{
				#~ print FILE "------->$y\t$hash_synonym{$w}\t1\t$hash_result{$y}{$w}\n";
				#~ my @split_y = split ("\-",$y);
				my $string = $y;
				#~ for (my $x=0; $x<scalar @split_y; $x++){
					#~ if($x==(scalar @split_y-1)){
						#~ $string .= "$split_y[$x]";
					#~ }else{
						#~ $string .= "$split_y[$x]-";
					#~ }
				#~ }
				#~ $string =~ s/dme-//;
				$string =~ tr/A-Z/a-z/;
				$string =~ s/\[//;
				$string =~ s/\]//;
				if($string =~ "\-5p"){
					$string =~ s/-5p//; #se elimina -5p
				
					
				}
				if($string =~ "\-3p"){
					$string =~ s/-3p//; #se elimina -3p
					
					
				}
				
				if(exists $hash_synonym{$string}){
					print FILE "$hash_synonym{$string}\t$hash_synonym{$w}\t1\t$hash_result{$y}{$w}\n";
					
				}else{
					#~ print FILE "microRNA synonym no existe STRING=$string $y\t$hash_synonym{$w}\t1\t$hash_result{$y}{$w}\n";
					if($string =~ "dme-"){
							#print "$string--->";
							$string =~ s/dme\-//;
							#print "$string\n";
							if(exists $hash_synonym{$string}){
								print FILE "$hash_synonym{$string}\t$hash_synonym{$w}\t1\t$hash_result{$y}{$w}\n";
								
							}else{
								print FILE "microRNA synonym no existe STRING=$string $y\t$hash_synonym{$w}\t1\t$hash_result{$y}{$w}\n";
							}
						}else{
							print FILE "microRNA synonym no existe STRING=$string $y\t$hash_synonym{$w}\t1\t$hash_result{$y}{$w}\n";
						}
				}
			}
		}else{
			if($w =~ "FBgn" || $w =~ "fbgn"){
				my $aux = $w;
				if($w =~ "fbgn"){
					$aux =~ s/fb/FB/;
				}
				if(exists $hash_synonym{$y}){
					print FILE "$hash_synonym{$y}\t$aux\t1\t$hash_result{$y}{$w}\n";
				}else{
					my $string = $y;
					#~ $string =~ s/dme-//;
					$string =~ tr/A-Z/a-z/;
					$string =~ s/\[//;
					$string =~ s/\]//;
					if($string =~ "\-5p"){
						$string =~ s/-5p//;
					
						
					}
					if($string =~ "\-3p"){
						$string =~ s/-3p//;
						
						
					}
					
					if(exists $hash_synonym{$string}){
						print FILE "$hash_synonym{$string}\t$aux\t1\t$hash_result{$y}{$w}\n";
						
					}else{
						
						if($string =~ "dme-"){
							#print "$string--->";
							$string =~ s/dme\-//;
							#print "$string\n";
							if(exists $hash_synonym{$string}){
								print FILE "$hash_synonym{$string}\t$aux\t1\t$hash_result{$y}{$w}\n";
								
							}else{
								print FILE "microRNA synonym no existe STRING=$string $y\t$aux\t1\t$hash_result{$y}{$w}\n";
							}
						}else{
							print FILE "microRNA synonym no existe STRING=$string $y\t$aux\t1\t$hash_result{$y}{$w}\n";
						}
					}
				}
				
			}else{
				print FILE "NO existe $w\n";
			}
		}
		
		#~ print "{$y}{$w} = $hash_result{$y}{$w}\n";
		
		
	}
	
}

close FILE;
