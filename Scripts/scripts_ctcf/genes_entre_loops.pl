use strict;
use warnings;

#INPUT: .fasta

my $file_GENEs = $ARGV[0];
my $file_loops = $ARGV[1];

my %hash_GENEs = ();
my %hash_loops = ();

open(my $fh, '<:encoding(UTF-8)', $file_GENEs) #se abre el archivo a analizar
  or die "Could not open file '$file_GENEs' $!"; 

while (my $row = <$fh>) { #lectura del archivo linea por linea
	chomp $row;
	
	my @split_row = split ("\t",$row);
	my @split_id = split (';', $split_row[8]);
	my @split_id_2 = split ('=',$split_id[0]);
	my @coor = ($split_row[3],$split_row[4]);
	
	
	@{$hash_GENEs{$split_row[0]}{$split_id_2[1]}} = @coor;
	
}



open(my $fh2, '<:encoding(UTF-8)', $file_loops) #se abre el archivo a analizar
  or die "Could not open file '$file_loops' $!"; 

while (my $row = <$fh2>) { #lectura del archivo linea por linea
	chomp $row;
	my @split_row = split("\t",$row);
	my @array = ($split_row[1],$split_row[2],$split_row[3],$split_row[4]);
	
	if(!exists $hash_loops{$split_row[0]}){
		@{$hash_loops{$split_row[0]}[0]} = @array;
	}else{
		my $num = scalar @{$hash_loops{$split_row[0]}};
		@{$hash_loops{$split_row[0]}[$num]} = @array;
	}
	
	
}

my %hash_aux = ();
my %hash_aux_2 = ();
my %hash_aux_3 = ();
for my $i (keys %hash_loops){
	
	for (my $j=0;$j<scalar @{$hash_loops{$i}};$j++){
		if($j != (scalar @{$hash_loops{$i}})-1){
			for my $x (keys %{$hash_GENEs{$i}}){
				if($hash_loops{$i}[$j+1][0] >= $hash_GENEs{$i}{$x}[1] && $hash_loops{$i}[$j][3] <= $hash_GENEs{$i}{$x}[0]){
					#~ if(!exists $hash_aux{$i}{"$hash_loops{$i}[$j][2]\t$hash_loops{$i}[$j][3]\t$hash_loops{$i}[$j+1][0]\t$hash_loops{$i}[$j+1][1]"}){
						$hash_aux{$i}{"$hash_loops{$i}[$j][2]\t$hash_loops{$i}[$j][3]\t$hash_loops{$i}[$j+1][0]\t$hash_loops{$i}[$j+1][1]"}.="$x,";
					#~ }
				
				}
				
			}
		}
		for my $x (keys %{$hash_GENEs{$i}}){
			if($hash_loops{$i}[$j][2] >= $hash_GENEs{$i}{$x}[1] && $hash_loops{$i}[$j][1] <= $hash_GENEs{$i}{$x}[0]){
				#~ print "$i\t$hash_loops{$i}[$j][0]\t$hash_loops{$i}[$j][1]\t$hash_loops{$i}[$j][2]\t$hash_loops{$i}[$j][3]";
				$hash_aux_2{$i}{"$hash_loops{$i}[$j][0]\t$hash_loops{$i}[$j][1]\t$hash_loops{$i}[$j][2]\t$hash_loops{$i}[$j][3]"}.="$x,";
				$hash_aux_3{$i}{"$hash_loops{$i}[$j][0]\t$hash_loops{$i}[$j][1]\t$hash_loops{$i}[$j][2]\t$hash_loops{$i}[$j][3]"}.="$x\($hash_GENEs{$i}{$x}[0];$hash_GENEs{$i}{$x}[1]\),";
			}
		}
		
		
		
	}
	
}

open FILE_1,">output_genes_entre_loops.txt";
for my $y (keys %hash_aux){
	for my $z (keys %{$hash_aux{$y}}){
		print FILE_1 "$y\t$z\t$hash_aux{$y}{$z}\n";
	}
	
}
close FILE_1;

#~ print "###################################\n";
#~ print "###################################\n";

open FILE_2,">output_genes_loops.txt";
for my $y (keys %hash_aux_2){
	for my $z (keys %{$hash_aux_2{$y}}){
		print FILE_2 "$y\t$z\t$hash_aux_2{$y}{$z}\n";
	}
	
}
close FILE_2;

open FILE_3,">output_genes_loops_coor.txt";
for my $y (keys %hash_aux_3){
	for my $z (keys %{$hash_aux_3{$y}}){
		print FILE_3 "$y\t$z\t$hash_aux_3{$y}{$z}\n";
	}
	
}
close FILE_3;
