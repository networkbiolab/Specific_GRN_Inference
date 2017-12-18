#!/usr/bin/perl -w
use strict;
use warnings;

#INPUT: output_CTCF_parte2.txt file_motivo_CTCF.txt

my $file_output_parte2 = $ARGV[0];
my $file_all_chr_CTCF = $ARGV[1];

my %hash_CTCF = ();

open(my $fh, '<:encoding(UTF-8)', $file_all_chr_CTCF) #se abre el archivo a analizar
  or die "Could not open file '$file_all_chr_CTCF' $!"; 
  
while (my $row = <$fh>) { #lectura del archivo de motivos CTCF linea por linea
	chomp $row;
	
	my @split_row = split ("\t",$row); #elementos de cada linea son separados
	my @array = ($split_row[1],$split_row[2],$split_row[3]); 
	
	if(!exists $hash_CTCF{$split_row[0]}){ #almacenamiento de datos del archivo por cromosoma
		@{$hash_CTCF{$split_row[0]}[0]} = @array; 
	}else{
		my $num = scalar @{$hash_CTCF{$split_row[0]}};
		@{$hash_CTCF{$split_row[0]}[$num]} = @array;
	}
	
}

open(my $fh2, '<:encoding(UTF-8)', $file_output_parte2) #se abre el archivo a analizar
  or die "Could not open file '$file_output_parte2' $!"; 
  
while (my $row = <$fh2>) { #lectura del archivo output_CTCF_parte2 linea por linea
	chomp $row;
	
	my @split_row = split ("\t",$row); #elementos de cada linea son separados
	
	print "$split_row[0]\t$split_row[1]\t$split_row[2]\t$split_row[3]\t$split_row[4]\t"; #se imprime el cromosoma y las coordenadas
	my $no_compl = 0;
	my $compl = 0;
	my $no_compl_2 = 0;
	my $compl_2 = 0;
	my $flag = 0;
	my $flag_2 = 0;
	
	for (my $j=0; $j<scalar @{$hash_CTCF{$split_row[0]}};$j++){ #busqueda de sobrelapamientos entre coordenadas
		my @split_porc = split("\\(", $hash_CTCF{$split_row[0]}[$j][2]);
		my $porc = $split_porc[1];
		$porc =~ s/\)//gi;
		if($split_row[1]  < $hash_CTCF{$split_row[0]}[$j][0]){
			if($split_row[2]  > $hash_CTCF{$split_row[0]}[$j][0]  && $split_row[2]  <= $hash_CTCF{$split_row[0]}[$j][1]){
					
					
				if($split_porc[0] eq "no_compl"){
					if($no_compl < $porc){
						$no_compl = $porc;
					}
				}else{
					if($compl < $porc){
						$compl = $porc;
					}
				}
				$flag = 1;

			}
			if($split_row[2]  > $hash_CTCF{$split_row[0]}[$j][1]){
				if($split_porc[0] eq "no_compl"){
					if($no_compl < $porc){
						$no_compl = $porc;
					}
				}else{
					if($compl < $porc){
						$compl = $porc;
					}
				}
				$flag = 1;
			}
			
		}
		
		if($split_row[1]  > $hash_CTCF{$split_row[0]}[$j][0]){
			if($hash_CTCF{$split_row[0]}[$j][1]  > $split_row[1]  && $split_row[2]  >= $hash_CTCF{$split_row[0]}[$j][1]){
				if($split_porc[0] eq "no_compl"){
					if($no_compl < $porc){
						$no_compl = $porc;
					}
				}else{
					if($compl < $porc){
						$compl = $porc;
					}
				}
				
			}
			if($split_row[2]  < $hash_CTCF{$split_row[0]}[$j][1]){
				if($split_porc[0] eq "no_compl"){
					if($no_compl < $porc){
						$no_compl = $porc;
					}
				}else{
					if($compl < $porc){
						$compl = $porc;
					}
				}
				$flag = 1;
			}	
		}
		
		if($split_row[1]  == $hash_CTCF{$split_row[0]}[$j][0]){
			
			if($split_row[2]  > $hash_CTCF{$split_row[0]}[$j][1]){
				if($split_porc[0] eq "no_compl"){
					if($no_compl < $porc){
						$no_compl = $porc;
					}
				}else{
					if($compl < $porc){
						$compl = $porc;
					}
				}
				$flag = 1;
			}
			if($split_row[2]  < $hash_CTCF{$split_row[0]}[$j][1]){
				if($split_porc[0] eq "no_compl"){
					if($no_compl < $porc){
						$no_compl = $porc;
					}
				}else{
					if($compl < $porc){
						$compl = $porc;
					}
				}
				$flag = 1;
			}
			if($split_row[2]  == $hash_CTCF{$split_row[0]}[$j][1]){
				if($split_porc[0] eq "no_compl"){
					if($no_compl < $porc){
						$no_compl = $porc;
					}
				}else{
					if($compl < $porc){
						$compl = $porc;
					}
				}
				$flag = 1;
			}
			
		}
		#########################################################################
		
		if($split_row[3]  < $hash_CTCF{$split_row[0]}[$j][0]){
			if($split_row[4]  > $hash_CTCF{$split_row[0]}[$j][0]  && $split_row[4]  <= $hash_CTCF{$split_row[0]}[$j][1]){
				if($split_porc[0] eq "no_compl"){
					if($no_compl_2 < $porc){
						$no_compl_2 = $porc;
					}
				}else{
					if($compl_2 < $porc){
						$compl_2 = $porc;
					}
				}
				$flag_2 = 1;

			}
			if($split_row[4]  > $hash_CTCF{$split_row[0]}[$j][1]){
				if($split_porc[0] eq "no_compl"){
					if($no_compl_2 < $porc){
						$no_compl_2 = $porc;
					}
				}else{
					if($compl_2 < $porc){
						$compl_2 = $porc;
					}
				}
				$flag_2 = 1;
			}
			
		}
		
		if($split_row[3]  > $hash_CTCF{$split_row[0]}[$j][0]){
			if($hash_CTCF{$split_row[0]}[$j][1]  > $split_row[3]  && $split_row[4]  >= $hash_CTCF{$split_row[0]}[$j][1]){
				if($split_porc[0] eq "no_compl"){
					if($no_compl_2 < $porc){
						$no_compl_2 = $porc;
					}
				}else{
					if($compl_2 < $porc){
						$compl_2 = $porc;
					}
				}
				$flag_2 = 1;
			}
			if($split_row[4]  < $hash_CTCF{$split_row[0]}[$j][1]){
				if($split_porc[0] eq "no_compl"){
					if($no_compl_2 < $porc){
						$no_compl_2 = $porc;
					}
				}else{
					if($compl_2 < $porc){
						$compl_2 = $porc;
					}
				}
				$flag_2 = 1;
			}	
		}
		
		if($split_row[3]  == $hash_CTCF{$split_row[0]}[$j][0]){
			
			if($split_row[4]  > $hash_CTCF{$split_row[0]}[$j][1]){
				if($split_porc[0] eq "no_compl"){
					if($no_compl_2 < $porc){
						$no_compl_2 = $porc;
					}
				}else{
					if($compl_2 < $porc){
						$compl_2 = $porc;
					}
				}
				$flag_2 = 1;
			}
			if($split_row[4]  < $hash_CTCF{$split_row[0]}[$j][1]){
				if($split_porc[0] eq "no_compl"){
					if($no_compl_2 < $porc){
						$no_compl_2 = $porc;
					}
				}else{
					if($compl_2 < $porc){
						$compl_2 = $porc;
					}
				}
				$flag_2 = 1;
			}
			if($split_row[4]  == $hash_CTCF{$split_row[0]}[$j][1]){
				if($split_porc[0] eq "no_compl"){
					if($no_compl_2 < $porc){
						$no_compl_2 = $porc;
					}
				}else{
					if($compl_2 < $porc){
						$compl_2 = $porc;
					}
				}
				$flag_2 = 1;
			}
			
		}
	}
	
	if($flag == 1){	#se imprime * si no se encontro sobrelapamiento o un string que contiene la orientacion del motivo si se encuentra sobrelapamiento
		print "no_compl($no_compl),compl($compl)\t"; 
	}else{
		print "*\t";
	}
	
	if($flag_2 == 1){
		print "no_compl($no_compl_2),compl($compl_2)\n";
	}else{
		print "*\n";
	}
		
	
}




