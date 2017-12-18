#!/usr/bin/perl -w
use strict;
use warnings;

#INPUT: archivo.bed
#OUTPUT: coor.txt

my $file_bed = $ARGV[0];

open(my $fh, '<:encoding(UTF-8)', $file_bed) #se abre el archivo a analizar
  or die "Could not open file '$file_bed' $!"; 

open FILE, ">Coor.txt"; #archivo de salida
while (my $row = <$fh>) { #lectura del archivo linea por linea
	chomp $row;
	if($row !~ "browser" && $row !~ "track" && length $row != 0){ #extraccion de coordenadas y escritura del archivo
		my @split_row = split ("\t", $row);
		print FILE "$split_row[0]:$split_row[1]-$split_row[2]\n";
	}
	
}
close FILE;
