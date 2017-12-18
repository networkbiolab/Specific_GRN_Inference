use strict;
use warnings;

#INPUT: .fasta

my $file_orient_CTCF = $ARGV[0];
my $file_conf_PTMs = $ARGV[1];
my $file_comb_PTMs = $ARGV[2];

my %hash_conf = ();
my %hash_loops = ();

open(my $fh2, '<:encoding(UTF-8)', $file_conf_PTMs) #se abre el archivo a analizar
  or die "Could not open file '$file_conf_PTMs' $!"; 

while (my $row = <$fh2>) { #lectura del archivo linea por linea
	chomp $row;
	
	my @split_row = split ("\t",$row);
	my $string = $split_row[0];
	$string .= "($split_row[1])";
	$hash_conf{$split_row[3]} = $string;
	#~ print "$split_row[2]\n";
	
}

#~ for my $i (keys %hash_conf){
	#~ print $hash_conf{$i},"\n";
#~ }


open(my $fh, '<:encoding(UTF-8)', $file_orient_CTCF) #se abre el archivo a analizar
  or die "Could not open file '$file_orient_CTCF' $!"; 



while (my $row = <$fh>) { #lectura del archivo linea por linea
	chomp $row;
	
	my @split_row = split ("\t",$row);
	if($split_row[5] ne "*" && $split_row[6] ne "*"){
		my @split_motivo_1 = split (',', $split_row[5]);
		my @split_no_compl = split ("\\(",$split_motivo_1[0]);
		my @split_compl = split ("\\(",$split_motivo_1[1]);
		my $no_compl = $split_no_compl[1];
		$no_compl =~ s/\)//gi;
		my $compl = $split_compl[1];
		$compl =~ s/\)//gi;
		
		
		my @split_motivo_2 = split (',', $split_row[6]);
		my @split_no_compl_2 = split ("\\(",$split_motivo_2[0]);
		my @split_compl_2 = split ("\\(",$split_motivo_2[1]);
		my $no_compl_2 = $split_no_compl_2[1];
		$no_compl_2 =~ s/\)//gi;
		my $compl_2 = $split_compl_2[1];
		$compl_2 =~ s/\)//gi;
	
	
		if($no_compl != 0 && $compl_2 != 0){
			my @array = ($split_row[1],$split_row[2],$split_row[3],$split_row[4],$no_compl,$compl_2);
			if (!exists $hash_loops{$split_row[0]}){
				@{$hash_loops{$split_row[0]}[0]} = @array;
				#~ print "$split_row[0]\t$split_row[1]\t$split_row[2]\t$split_row[3]\t$split_row[4]\t$no_compl\t$compl_2\n";
			}else{
				my $num = scalar @{$hash_loops{$split_row[0]}};
				@{$hash_loops{$split_row[0]}[$num]} = @array;
				
			}
		}
		
	}
	
	#~ print "$no_compl $compl\t$no_compl_2 $compl_2\n";
}
my %hash_aux=();
my %hash_coor_PTMs = ();
for (my $i=3;$i<scalar @ARGV;$i++){
	#~ print $ARGV[$i],"\n";
	if(exists $hash_conf{$ARGV[$i]}){
		print "===ANALIZANDO $hash_conf{$ARGV[$i]}===\n";
		open(my $fh3, '<:encoding(UTF-8)', $ARGV[$i]) #se abre el archivo a analizar
		  or die "Could not open file '$ARGV[$i]' $!"; 

		while (my $row = <$fh3>) { #lectura del archivo linea por linea
			chomp $row;
			my @split_row = split ("\t",$row);
			if(exists $hash_loops{$split_row[0]}){
				#~ my $count = 0;
				for (my $j=0;$j<scalar @{$hash_loops{$split_row[0]}};$j++){
					
						#~ print "EXISTE\n";
						#~ print scalar @{$hash_loops{$split_row[0]}},"\n";
						#DENTRO DEL LOOP
						if($hash_loops{$split_row[0]}[$j][2] >= $split_row[2] && $hash_loops{$split_row[0]}[$j][1] <= $split_row[1]){
							#~ $count ++;
							$hash_loops{$split_row[0]}[$j][6].="$hash_conf{$ARGV[$i]},";
							#~ $hash_loops{$split_row[0]}[$j][7].="$hash_conf{$ARGV[$i]}\[$split_row[1];$split_row[2]\],";
							$hash_coor_PTMs{"$split_row[0]\t$hash_loops{$split_row[0]}[$j][0]\t$hash_loops{$split_row[0]}[$j][1]\t$hash_loops{$split_row[0]}[$j][2]\t$hash_loops{$split_row[0]}[$j][3]\t$hash_loops{$split_row[0]}[$j][4]\t$hash_loops{$split_row[0]}[$j][5]"} .= "$hash_conf{$ARGV[$i]}\[$split_row[1];$split_row[2]\],";
							
						}
						
						#ENTRE LOOP
						
						if($j != (scalar @{$hash_loops{$split_row[0]}})-1){
							if($hash_loops{$split_row[0]}[$j+1][0] >= $split_row[2] && $hash_loops{$split_row[0]}[$j][3] <= $split_row[1]){
								$hash_aux{"$split_row[0]\t$hash_loops{$split_row[0]}[$j][2]\t$hash_loops{$split_row[0]}[$j][3]\t$hash_loops{$split_row[0]}[$j+1][0]\t$hash_loops{$split_row[0]}[$j+1][1]"}.="$hash_conf{$ARGV[$i]},";
									#~ print "$hash_conf{$ARGV[$i]}\n";
								
							}
						}
						
						
				}
							
			
				
				#~ print "$hash_loops{$split_row[0]}[$j][2]\t$hash_loops{$split_row[0]}[$j][1]\n";
				#~ if($hash_loops{$split_row[0]}[$j][2] > $split_row[2] && $hash_loops{$split_row[0]}[$j][1] < $split_row[1]){
					#~ $hash_loops{$split_row[0]}[$j][6].="$hash_conf{$ARGV[$i]},";
				#~ }
				
			}
			
		}
		print "ANALISIS FINALIZADO\n";
	}else{
		print "EL ARCHIVO INGRESADO NO SE ENCUENTRA EN EL ARCHIVO DE CONF\n";
	}
}

open FILE_0,">output_loops_coor_PTMs.txt";
for my $q (keys %hash_coor_PTMs){
	#~ for (my $j=0;$j<scalar @{$hash_coor_PTMs{$q}};$j++){
		print FILE_0 "$q\t$hash_coor_PTMs{$q}\n";
	#~ }
	
}
close FILE_0;





open FILE_1,">output_entre_loops.txt";
for my $o (keys %hash_aux){
	#~ print "$o\t$hash_aux{$o}\n";
	print FILE_1 "$o\t";
	my @split_contenido = split (',',$hash_aux{$o});
	my %hash_x = ();
	for (my $p=0;$p<@split_contenido;$p++){
		if(!exists $hash_x{$split_contenido[$p]}){
			$hash_x{$split_contenido[$p]} = 1;
		}else{
			$hash_x{$split_contenido[$p]}++;
		}
	}
	
	for my $d (keys %hash_x){
		my $porc = $hash_x{$d}*100/scalar @split_contenido;
		$porc = sprintf ("%.2f",$porc);
		print FILE_1 "$d($porc),";
	}
	print FILE_1 "\n";
	
}
close FILE_1;


my %hash_comb_PTMs = ();

open(my $fh4, '<:encoding(UTF-8)', $file_comb_PTMs) #se abre el archivo a analizar
  or die "Could not open file '$file_comb_PTMs' $!"; 

while (my $row = <$fh4>) { #lectura del archivo linea por linea
	chomp $row;
	my @split_row = split("\t",$row);
	my @split_comb = split(';',$split_row[0]);
	push (@split_comb,$split_row[1]);
	
	@{$hash_comb_PTMs{$split_row[0]}} = @split_comb;
	
}



open FILE,">output_loops.txt";
for my $i (keys %hash_loops){
	
	for (my $j=0;$j<scalar @{$hash_loops{$i}};$j++){
		print FILE "$i\t";
		
		
		
		print FILE "$hash_loops{$i}[$j][0]\t$hash_loops{$i}[$j][1]\t$hash_loops{$i}[$j][2]\t$hash_loops{$i}[$j][3]\t$hash_loops{$i}[$j][4]\t$hash_loops{$i}[$j][5]\t";
		
		
		my $flag = 0;
		if(scalar @{$hash_loops{$i}[$j]} == 7){
		#~ print scalar $hash_loops{$i}[$j],"\n";
			my %hash_aux = ();
			my @split_aux = split (',',$hash_loops{$i}[$j][6]);
			
			for (my $x=0;$x<scalar @split_aux;$x++){
				if(!exists $hash_aux{$split_aux[$x]}){
					$hash_aux{$split_aux[$x]} = 1;
				}else{
					$hash_aux{$split_aux[$x]}++;
				}
					
			}
			my $count_hash = 0;
			my @array_aux;
			for my $y (keys %hash_aux){
				$count_hash++;
				my $porc = $hash_aux{$y}*100/scalar @split_aux;
				$porc = sprintf("%.2f",$porc);
				print FILE "$y\[$hash_aux{$y}\]($porc),";
				my $string = $y;
				$string =~ s/\)//gi;
				$string =~ s/\(//gi;
				$string =~ s/\+//gi;
				$string =~ s/\-//gi;
				
				#~ print "$string>>>>>>>>>>>>>>>>>>>>>>>>\n";
				
				push (@array_aux,$string);
			}
			
			#~ print "$count_hash\n";
			for my $u (keys %hash_comb_PTMs){
				my $count = 0;
				if($count_hash == (scalar @{$hash_comb_PTMs{$u}})-1){
					for (my $t=0; $t<(scalar @{$hash_comb_PTMs{$u}})-1; $t++){
						for (my $r=0;$r<scalar @array_aux;$r++){
							#~ print "$hash_comb_PTMs{$u}[$t] eq $array_aux[$r]\n";
							
							if($hash_comb_PTMs{$u}[$t] eq $array_aux[$r]){
								$count++;
							}
						}
						
					}
				
				}
				#~ print "count<<<<<<<<<<<<<<$count\n";
				#~ print "$u\n";
				if($count == (scalar @{$hash_comb_PTMs{$u}})-1){
					print FILE "\t$u(",$hash_comb_PTMs{$u}[(scalar @{$hash_comb_PTMs{$u}})-1],")";
					print  "\t$u(",$hash_comb_PTMs{$u}[(scalar @{$hash_comb_PTMs{$u}})-1],")";
					$flag = 1;
				}
			}
		}else{
			print FILE "*\t*";
			$flag = 1;
		}
		if($flag == 1){
			print FILE "\n";
		}else{
			print FILE "\t*\n";
		}
	}
	#~ print "\n";
	
	
}

#~ for my $i (keys %hash_comb_PTMs){
	#~ print "$i $hash_comb_PTMs{$i}\n";
#~ }
