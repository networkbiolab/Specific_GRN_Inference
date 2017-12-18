#!/usr/bin/perl -w
use strict;
use warnings;

my $archivo = $ARGV[0];

my %hash = ();
my %hash_RNAsource = ();
my @array_hash = [];

open(my $fh, '<:encoding(UTF-8)', $archivo) #se abre el archivo a analizar
  or die "Could not open file '$archivo' $!"; 


while (my $row = <$fh>) { #lectura del archivo linea por linea
	chomp $row;
	
	if($row !~ "##" && $row !~ "WARNING"){
	
		my @array = split ("\t", $row);
		my @array_aux = [];
		$array_aux[0] = $array[1]; #Fbgn
		$array_aux[1] = $array[2]; #GeneSymbol
		$array_aux[2] = $array[5]; #RNASource_FBlc
		$array_aux[3] = $array[7]; #RPKM_value
		if(scalar @array != 0){ #Al momento de haber lineas vacias no exista warning
			if(!exists $hash {$array[6]}){ #almacenamiento de archivo RPKM en tabla hash 
				push ( @{$hash {$array[6]}[0]}, @array_aux); 
				$hash_RNAsource {$array[6]} = $array[5];
				
			}else{
				my $num = scalar(@{$hash{$array[6]}});
				push( @{ $hash {$array[6]}[$num]}, @array_aux);
			}
			

		}
		
	}
}

foreach my $llave (keys %hash_RNAsource){
	
	system "wget http://flybase.org/reports/$hash_RNAsource{$llave}.html"; #descarga de .html con la informacion necesaria
	
	open(my $fh, '<:encoding(UTF-8)', "$hash_RNAsource{$llave}.html") #se abre el archivo a analizar
	or die "Could not open file '$archivo' $!"; 


	while (my $row = <$fh>) { #lectura del archivo .html linea por linea 
		chomp $row;
		
		if($row =~ "<div class=\"tap_stage\"><a href="){
			my @stage_split = split ("href=",$row);
			$hash_RNAsource{$llave} .= "\t";
			for(my $x=1; $x<scalar @stage_split; $x++){
				my @stage_split_2 = split ('>',$stage_split[$x]);
				my @stage_split_3 = split ('<',$stage_split_2[1]);
				$hash_RNAsource{$llave} .= ":$stage_split_3[0]";
				
			}
		}
		
		if($row =~ "<div class=\"noborder-line-wrapper\"><a href="){
			my @tissue_split = split ("href=",$row);
			$hash_RNAsource{$llave} .= "\t";
			for(my $y=1; $y<scalar @tissue_split; $y++){
				my @tissue_split_2 = split ('>',$tissue_split[$y]);
				my @tissue_split_3 = split ('<',$tissue_split_2[1]);
				$hash_RNAsource{$llave} .= ":$tissue_split_3[0]";
				
			}
			
			
		}
		
		if($row =~ "<div class=\"tap_noborder-line-wrapper tap_notes\"><span"){
			my @comment_split = split ("Comment:</span>",$row);
			$hash_RNAsource{$llave} .= "\tcomment:$comment_split[1]";
			
			
		} 
		
		if($row =~ "<div class=\"onecol\"><a href=\"/reports/FBtc"){
			my @tc_split = split ("\"", $row);
			system "wget http://flybase.org$tc_split[3]";
			my @tc_split_2 = split ("/",$tc_split[3]);
		
			open(my $fh3, '<:encoding(UTF-8)', $tc_split_2[2]) #se abre el archivo a analizar
			or die "Could not open file '$tc_split_2[2]' $!"; 
			
			my $count = 0;
			my $tissue = "";
			my $stage = "";
			
			while (my $row2 = <$fh3>) { #lectura del archivo linea por linea
				chomp $row2;
				if($row2 =~ "<th class=\"field_label\">Tissue Source</th>"){
					$count = 1;	
				}
				if($row2 =~ "<th class=\"field_label\">Developmental Stage</th>"){
					$count = 2;
				}
				
				if($row2 =~ "<div class=\"twocol_c_item_one\"><a href=" && $count == 1){
					my @tissource_split = split ("href=",$row2);
					my @tissource_split_2 = split ('>',$tissource_split[1]);
					my @tissource_split_3 = split ('<',$tissource_split_2[1]);
					$tissue = $tissource_split_3[0];
					$count = 0;
					
				}
				
				if($row2 =~ "<div class=\"twocol_c_item_one\"><a href=" && $count == 2){
					my @stasource_split = split ("href=",$row2);
					my @stasource_split_2 = split ('>',$stasource_split[1]);
					my @stasource_split_3 = split ('<',$stasource_split_2[1]);
					$stage = $stasource_split_3[0];
					$count = 0;
					
				}
				
			}
			$hash_RNAsource{$llave} .= "\t:$stage";
			$hash_RNAsource{$llave} .= "\t:$tissue";
			system "rm $tc_split_2[2]";
		
		}
		
	}
	my @RNAsource_split = split (" ",$hash_RNAsource{$llave});
	system "rm $RNAsource_split[0].html";
}

foreach my $llave2 (keys %hash_RNAsource){
	print "$llave2\t$hash_RNAsource{$llave2} \n";
}

