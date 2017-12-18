use strict;
use warnings;

#si existen discrepancias se pone signo "?"
#dos archivos 1) datos seguros, 2) datos duda (con discrepancias)
my $count = 0;
my $file_out_comb_PTMs = $ARGV[0];
my $option = $ARGV[1];

open FILE,">out/output_analisis_conexiones_seguro.tsv";
open FILE_2,">out/output_analisis_conexiones_no_seguro.tsv";
open(my $fh, '<:encoding(UTF-8)', $file_out_comb_PTMs) #se abre el archivo a analizar
  or die "Could not open file '$file_out_comb_PTMs' $!"; 

while (my $row = <$fh>) { #lectura del archivo linea por linea
	chomp $row;
	
	if($option == 1){
		my @split_row = split ("\t",$row);
		
		if($split_row[1] =~ "P=" && $split_row[1] =~ "\\+"){
			my @conect = split("-->", $split_row[0]);
			print FILE "$conect[0]\t$conect[1]\t$split_row[1]\t*\tSE UNE\n";
		}
	}
	
	if($option == 2){
		my @split_row = split ("\t",$row);
		my @split_PTMs = split (";",$split_row[1]);
		my $count_plus = 0;
		my $count_minus = 0;
		
		
		my @split_conexion = split ("-->",$split_row[0]);
		
		for (my $i=0; $i<scalar @split_PTMs; $i++){
			if($split_PTMs[$i] =~ "P="){
				my @split_aux = split ("=",$split_PTMs[$i]);
				if($split_aux[0] =~ "\\+"){
					$count_plus = $count_plus + $split_aux[1];
				}
				if($split_aux[0] =~ "\\-"){
					$count_minus = $count_minus + $split_aux[1];
				}
			}
			
		}
		
		if($count_minus == 0 && $count_plus != 0){
			$count ++;
			print FILE "$split_conexion[0]\t$split_conexion[1]\t$split_row[1]\t$split_row[2]\tSE UNE\n";
		}else{
			if($split_row[2] ne "*"){
				if($split_row[2] =~ ",P"){
					if($split_row[2] !~ "\\-"){
						print FILE "$split_conexion[0]\t$split_conexion[1]\t$split_row[1]\t$split_row[2]\tSE UNE\n";
						
					}
				}
			}
			
		}
		
		
		
		
		if($count_plus > $count_minus){
			if($split_row[2] ne "*"){
				if($split_row[2] =~ ",P"){
					if($split_row[2] !~ "\\-"){
						print FILE_2 "$split_conexion[0]\t$split_conexion[1]\t$split_row[1]\t$split_row[2]\t\?\n";
					}
				}
			}else{
				print FILE_2 "$split_conexion[0]\t$split_conexion[1]\t$split_row[1]\t$split_row[2]\t\?\n";
			}
		}
		
		if($count_plus == $count_minus){
			if($split_row[2] ne "*"){
				if($split_row[2] =~ ",P"){
					if($split_row[2] !~ "\\-"){
						print FILE_2 "$split_conexion[0]\t$split_conexion[1]\t$split_row[1]\t$split_row[2]\t\?\n";
					}
				}else{
					print FILE_2 "$split_conexion[0]\t$split_conexion[1]\t$split_row[1]\t$split_row[2]\t\?\n";
				}
			}
		}
	}
}

#~ print "$count\n";
if($option == 2){
	close FILE;
	close FILE_2;
}
