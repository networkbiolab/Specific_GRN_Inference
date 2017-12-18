#!/usr/bin/perl

#~ my $ruta = qx (pwd);
#~ my $dir = $ruta;
my $dir = "/home/leandro/Escritorio/redes_finales_10-01";

#~ print "$dir\n";
opendir(DIR, "$dir");
@FILES = readdir(DIR);
foreach $file (@FILES) {
	if($file =~ "GRN\_"){	
		print $file, "\n";
		open(my $fh, '<:encoding(UTF-8)', $file) #se abre el archivo a analizar
		or die "Could not open file '$file' $!"; 
			open FILE,">nuevo_$file";
			while (my $row = <$fh>) { #lectura del archivo linea por linea
				chomp $row;
				my @split_row = split ("\t",$row);
				print FILE "$split_row[0]\t$split_row[1]\t1\t$split_row[2]\t$split_row[3]\t$split_row[4]\t$split_row[5]\n";
			}
	}
}
closedir(DIR);
