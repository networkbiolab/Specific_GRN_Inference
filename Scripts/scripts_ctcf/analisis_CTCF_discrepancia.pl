use strict;
use warnings;

#INPUT: .fasta

my $file_discr = $ARGV[0];
my $file_genes_loops = $ARGV[1];
my $file_out_filtro_PTMs = $ARGV[2];
my $file_conf_PTMs = $ARGV[3];

my %hash_discr = ();

open(my $fh, '<:encoding(UTF-8)', $file_discr) #se abre el archivo a analizar
  or die "Could not open file '$file_discr' $!"; 

while (my $row = <$fh>) { #lectura del archivo linea por linea
	chomp $row;
	
	my @split_row = split ("\t",$row);
	my @array = ($split_row[5],$split_row[6]);
	@{$hash_discr{$split_row[0]}{"$split_row[1]\t$split_row[2]\t$split_row[3]\t$split_row[4]"}} = @array;
}

open(my $fh2, '<:encoding(UTF-8)', $file_genes_loops) #se abre el archivo a analizar
  or die "Could not open file '$file_genes_loops' $!"; 

while (my $row = <$fh2>) { #lectura del archivo linea por linea
	chomp $row;
	
	my @split_row = split ("\t",$row);
	if(exists $hash_discr{$split_row[0]}{"$split_row[1]\t$split_row[2]\t$split_row[3]\t$split_row[4]"}){
		my $num = scalar @{$hash_discr{$split_row[0]}{"$split_row[1]\t$split_row[2]\t$split_row[3]\t$split_row[4]"}};
		$hash_discr{$split_row[0]}{"$split_row[1]\t$split_row[2]\t$split_row[3]\t$split_row[4]"}[2] = $split_row[5];
	}
	

}

my %hash_conf = ();
open(my $fh4, '<:encoding(UTF-8)', $file_conf_PTMs) #se abre el archivo a analizar
  or die "Could not open file '$file_conf_PTMs' $!"; 

while (my $row = <$fh4>) { #lectura del archivo linea por linea
	chomp $row;
	
	my @split_row = split ("\t",$row);
	$hash_conf{$split_row[0]} = $split_row[1];
	

}

open(my $fh3, '<:encoding(UTF-8)', $file_out_filtro_PTMs) #se abre el archivo a analizar
  or die "Could not open file '$file_out_filtro_PTMs' $!"; 

my %hash_aux = ();
while (my $row = <$fh3>) { #lectura del archivo linea por linea
	chomp $row;
	
	my @split_row = split ("\t",$row);
	
	#~ for my $i (keys %hash_discr){
		for my $j (keys %{$hash_discr{$split_row[0]}}){
			if($split_row[8] eq 'G'){
				if($hash_discr{$split_row[0]}{$j}[2] =~ $split_row[1]){
					if(exists $hash_conf{$split_row[4]}){
						$hash_aux{$split_row[0]}{$j} .= "[G]$split_row[1]($split_row[4] $hash_conf{$split_row[4]}),";
					}else{
						$hash_aux{$split_row[0]}{$j} .= "[G]$split_row[1]($split_row[4]),";
					}
				}
			}
			if($split_row[8] eq 'P'){
				my @split_coor = split ("\t",$j);
				#~ print "$j\n";
				#~ print "$split_coor[2]\t$split_coor[1]\n";
				if($split_coor[2] >= $split_row[3] && $split_coor[1] <= $split_row[2]){
					if(exists $hash_conf{$split_row[4]}){
						#~ $hash_aux{$split_row[0]}{$j} .= "[P]$split_row[1]($split_row[4] $hash_conf{$split_row[4]}),";
						$hash_aux{$split_row[0]}{$j}++;
					}else{
						$hash_aux{$split_row[0]}{$j}++;
						#~ $hash_aux{$split_row[0]}{$j} .= "[P]$split_row[1]($split_row[4]),";
					}
				}
				
			}
		}
	#~ }
	
	
}


for my $i (keys %hash_aux){
	for my $j (keys %{$hash_aux{$i}}){
		
			print "$i\t$j\t$hash_aux{$i}{$j}\n";	
		
	
	}
}
