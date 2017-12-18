#!/usr/bin/perl -w
use strict;
use warnings;

#INPUT file_PTMs.txt(PTMs conocidas) file_TFBSs.gff(coordenadas) file_GENEs.gff(coordenadas) file_exp.bed(coordenadas experimento a analizar)
#OUTPUT output.txt 
#HEADER OUTPUT: Chr	FBgn_TF	Start_TF	End_TF	PTM	Start_PTM	End_PTM	+/-(cromatina abierta/cerrada)
my $file_PTMs = $ARGV[0];
my $file_TFBSs = $ARGV[1];
my $file_GENEs = $ARGV[2];
#~ my $file_EXP = $ARGV[3];

my %hash_PTMs = (); 
my %hash_TFBSs = ();
my %hash_GENEs = ();
my %hash_EXP = ();

open(my $fh, '<:encoding(UTF-8)', $file_PTMs) #se abre el archivo a analizar
  or die "Could not open file '$file_PTMs' $!"; 
  
while (my $row = <$fh>) { #lectura del archivo linea por linea
	chomp $row;
	
	
	my @split_row = split("\t",$row);
	my @array = ($split_row[1],$split_row[2],$split_row[0]);
	if(!exists $hash_PTMs{$split_row[0]}){
		
	@{$hash_PTMs{$split_row[3]}} = @array;
	}
	
}


open(my $fh2, '<:encoding(UTF-8)', $file_TFBSs) #se abre el archivo a analizar
  or die "Could not open file '$file_TFBSs' $!"; 
  
while (my $row2 = <$fh2>) { #lectura del archivo linea por linea
	chomp $row2;
	
	my @split_row2 = split("\t",$row2);
	my @split_features = split(';',$split_row2[8]);
	my @coor = ($split_row2[3],$split_row2[4]);
	
	for (my $x=0; $x<scalar(@split_features); $x++){
		if($split_features[$x] =~ "bound_moiety="){
			my @split_id = split('=',$split_features[$x]);
			if($split_id[1] =~ ','){
				my @split_fbgn_0 = split(',',$split_id[1]);
				for (my $y=0; $y<scalar(@split_fbgn_0); $y++){
					my @split_final_fbgn = split(':',$split_fbgn_0[$y]);
					
					if(!exists ($hash_TFBSs{$split_row2[0]}{$split_final_fbgn[1]})){
						@{$hash_TFBSs{$split_row2[0]}{$split_final_fbgn[1]}[0]} = @coor;
					}else{
						my $num = scalar @{$hash_TFBSs{$split_row2[0]}{$split_final_fbgn[1]}};
						@{$hash_TFBSs{$split_row2[0]}{$split_final_fbgn[1]}[$num]} = @coor;
						
					}
					
				}
				
			}else{
				
				my @split_fbgn = split(':',$split_id[1]);
				if(!exists ($hash_TFBSs{$split_row2[0]}{$split_fbgn[1]})){
					@{$hash_TFBSs{$split_row2[0]}{$split_fbgn[1]}[0]} = @coor;
				}else{
					my $num = scalar @{$hash_TFBSs{$split_row2[0]}{$split_fbgn[1]}};
					@{$hash_TFBSs{$split_row2[0]}{$split_fbgn[1]}[$num]} = @coor;
					
				}
				
			}
		}
	}
	
	
	
}

open(my $fh4, '<:encoding(UTF-8)', $file_GENEs) #se abre el archivo a analizar
  or die "Could not open file '$file_GENEs' $!"; 
  
while (my $row = <$fh4>) { #lectura del archivo linea por linea
	chomp $row;
	my @split_row = split ("\t",$row);
	my @split_id = split (';', $split_row[8]);
	my @split_id_2 = split ('=',$split_id[0]);
	my @coor = ($split_row[3],$split_row[4]);
	
	
	@{$hash_GENEs{$split_row[0]}{$split_id_2[1]}} = @coor;
	
	
}

open FILE,">output_filtro_PTMs.txt";

my $promotor = 0;
my $gen = 0;
for (my $q = 3; $q < scalar @ARGV; $q++){
	$promotor = 0;
	$gen = 0;
	if(exists $hash_PTMs{$ARGV[$q]}){
	
		if($hash_PTMs{$ARGV[$q]}[1] =~ "promotor"){
			$promotor = 1;
			
		}
		if($hash_PTMs{$ARGV[$q]}[1] =~ "gen"){
			$gen = 1;
			
		}
		
		print "=====PROCESANDO=====\n";
		print "PTM = $hash_PTMs{$ARGV[$q]}[2]\n";
		
		open(my $fh3, '<:encoding(UTF-8)', $ARGV[$q]) #se abre el archivo a analizar
		or die "Could not open file '$ARGV[$q]' $!"; 
		  
		while (my $row3 = <$fh3>) { #lectura del archivo linea por linea
			chomp $row3;

			my @split_row3 = split("\t",$row3);

			
			if($promotor == 1){
				for my $key_2_TFBSs(keys %{$hash_TFBSs{$split_row3[0]}}){ #key = gen_tf
					for (my $i=0; $i < scalar (@{$hash_TFBSs{$split_row3[0]}{$key_2_TFBSs}}); $i++){ #coordenadas de un mismo gen
						
						
						if($split_row3[1] < $hash_TFBSs{$split_row3[0]}{$key_2_TFBSs}[$i][0]){
							if($split_row3[2] > $hash_TFBSs{$split_row3[0]}{$key_2_TFBSs}[$i][0]  && $split_row3[2] <= $hash_TFBSs{$split_row3[0]}{$key_2_TFBSs}[$i][1]){
								print FILE "$split_row3[0]\t$key_2_TFBSs\t$hash_TFBSs{$split_row3[0]}{$key_2_TFBSs}[$i][0]\t$hash_TFBSs{$split_row3[0]}{$key_2_TFBSs}[$i][1]\t$hash_PTMs{$ARGV[$q]}[2]\t$split_row3[1]\t$split_row3[2]\t$hash_PTMs{$ARGV[$q]}[0]\tP\n";

							}
							if($split_row3[2] > $hash_TFBSs{$split_row3[0]}{$key_2_TFBSs}[$i][1]){
								print FILE "$split_row3[0]\t$key_2_TFBSs\t$hash_TFBSs{$split_row3[0]}{$key_2_TFBSs}[$i][0]\t$hash_TFBSs{$split_row3[0]}{$key_2_TFBSs}[$i][1]\t$hash_PTMs{$ARGV[$q]}[2]\t$split_row3[1]\t$split_row3[2]\t$hash_PTMs{$ARGV[$q]}[0]\tP\n";
							}
							
						}
						
						if($split_row3[1] > $hash_TFBSs{$split_row3[0]}{$key_2_TFBSs}[$i][0]){
							if($hash_TFBSs{$split_row3[0]}{$key_2_TFBSs}[$i][1]  > $split_row3[1] && $split_row3[2] >= $hash_TFBSs{$split_row3[0]}{$key_2_TFBSs}[$i][1]){
								print FILE "$split_row3[0]\t$key_2_TFBSs\t$hash_TFBSs{$split_row3[0]}{$key_2_TFBSs}[$i][0]\t$hash_TFBSs{$split_row3[0]}{$key_2_TFBSs}[$i][1]\t$hash_PTMs{$ARGV[$q]}[2]\t$split_row3[1]\t$split_row3[2]\t$hash_PTMs{$ARGV[$q]}[0]\tP\n";
							}
							if($split_row3[2] < $hash_TFBSs{$split_row3[0]}{$key_2_TFBSs}[$i][1]){
								print FILE "$split_row3[0]\t$key_2_TFBSs\t$hash_TFBSs{$split_row3[0]}{$key_2_TFBSs}[$i][0]\t$hash_TFBSs{$split_row3[0]}{$key_2_TFBSs}[$i][1]\t$hash_PTMs{$ARGV[$q]}[2]\t$split_row3[1]\t$split_row3[2]\t$hash_PTMs{$ARGV[$q]}[0]\tP\n";
							}	
						}
						
						if($split_row3[1] == $hash_TFBSs{$split_row3[0]}{$key_2_TFBSs}[$i][0]){
							
							if($split_row3[2] > $hash_TFBSs{$split_row3[0]}{$key_2_TFBSs}[$i][1]){
								print FILE "$split_row3[0]\t$key_2_TFBSs\t$hash_TFBSs{$split_row3[0]}{$key_2_TFBSs}[$i][0]\t$hash_TFBSs{$split_row3[0]}{$key_2_TFBSs}[$i][1]\t$hash_PTMs{$ARGV[$q]}[2]\t$split_row3[1]\t$split_row3[2]\t$hash_PTMs{$ARGV[$q]}[0]\tP\n";
							}
							if($split_row3[2] < $hash_TFBSs{$split_row3[0]}{$key_2_TFBSs}[$i][1]){
								print FILE "$split_row3[0]\t$key_2_TFBSs\t$hash_TFBSs{$split_row3[0]}{$key_2_TFBSs}[$i][0]\t$hash_TFBSs{$split_row3[0]}{$key_2_TFBSs}[$i][1]\t$hash_PTMs{$ARGV[$q]}[2]\t$split_row3[1]\t$split_row3[2]\t$hash_PTMs{$ARGV[$q]}[0]\tP\n";
							}
							if($split_row3[2] == $hash_TFBSs{$split_row3[0]}{$key_2_TFBSs}[$i][1]){
								print FILE "$split_row3[0]\t$key_2_TFBSs\t$hash_TFBSs{$split_row3[0]}{$key_2_TFBSs}[$i][0]\t$hash_TFBSs{$split_row3[0]}{$key_2_TFBSs}[$i][1]\t$hash_PTMs{$ARGV[$q]}[2]\t$split_row3[1]\t$split_row3[2]\t$hash_PTMs{$ARGV[$q]}[0]\tP\n";
							}
							
						}
					}
				}
			}
			
			if($gen == 1){
				for my $key_2_GENEs(keys %{$hash_GENEs{$split_row3[0]}}){
					if($hash_GENEs{$split_row3[0]}{$key_2_GENEs}[0] <= $split_row3[1] && $hash_GENEs{$split_row3[0]}{$key_2_GENEs}[1] >= $split_row3[2]){
						print FILE "$split_row3[0]\t$key_2_GENEs\t$hash_GENEs{$split_row3[0]}{$key_2_GENEs}[0]\t$hash_GENEs{$split_row3[0]}{$key_2_GENEs}[1]\t$hash_PTMs{$ARGV[$q]}[2]\t$split_row3[1]\t$split_row3[2]\t$hash_PTMs{$ARGV[$q]}[0]\tG\n";
					}
					
				}
				
			}
		}
	}else{
		print "$ARGV[$q] no se encuentra en el archivo de configuracion\n";
		
	}
}
print "\n";
print "ANALISIS FINALIZADO\n";


close FILE;
	

