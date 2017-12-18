#!/usr/bin/perl -w
use strict;
use warnings;

#INPUT: file_agilent.txt
#OUTPUT: coor.bed

my $archivo = $ARGV[0];

open(my $fh, '<:encoding(UTF-8)', $archivo) #se abre el archivo a analizar
  or die "Could not open file '$archivo' $!"; 

my $x = 0;
my $num = 0;
my $num_2 = 0;

print "Ingrese nombre archivo salida \n"; #se solicita al usuario que ingrese nombre de archivo de salida junto con su extension
my $file_name = <STDIN>; #lectura terminal
chomp $file_name;
open FILE, ">$file_name";

while (my $row = <$fh>) { #lectura del archivo linea por linea
	chomp $row;
	
	my @array_split = split("\t",$row); #separacion elementos linea
	
	if($x == 1 && $array_split[$num_2] <= (5*(10**-2)) && $array_split[$num] =~ "chr"){ #se seleccionan solo coordenadas cuyo p-value sea <= a 0.05
		print FILE "$array_split[$num]\n";

	}
	
	if($x == 0){
		for (my $y = 0; $y < scalar (@array_split); $y++){ #busqueda columna coordenadas
			if($array_split[$y] =~ "GeneName" || $array_split[$y] =~ "SystematicName"){
				$num = $y;
				last;
			}
		}
		for (my $z = 0; $z < scalar (@array_split); $z++){ #busqueda columna p-value
			if($array_split[$z] =~ "PValueLogRatio"){
				$num_2 = $z;
				$x = 1;
				last;
			}
		}
	}


	
}

close FILE;
