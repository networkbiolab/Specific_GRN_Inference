#!/usr/bin/perl -w
use strict;
use warnings;

#INPUT: coor_file_FlyBase.txt
#OUTPUT: coor.bed

my $file_coor = $ARGV[0];

open(my $fh, '<:encoding(UTF-8)', $file_coor) #se abre el archivo a analizar
  or die "Could not open file '$file_coor' $!"; 

open FILE ,">output.bed";  #archivo de salida
while (my $row = <$fh>) { #lectura del archivo linea por linea
	chomp $row;
	
	if($row !~ '\?'){ #extraccion de coordenadas y escritura del archivo de salida
		my @split_row = split ("\t", $row);
		my @split_coor = split (":",$split_row[1]);
		my @split_coor_2 = split ('\.\.',$split_coor[1]);
		print FILE "$split_coor[0]\t$split_coor_2[0]\t$split_coor_2[1]\n";
	}
}

close FILE;
