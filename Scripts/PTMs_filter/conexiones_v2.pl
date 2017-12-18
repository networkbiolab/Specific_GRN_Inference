#!/usr/bin/perl -w
use strict;
use warnings;

#INPUT: reference_network.tsv filtro_PTMs.txt

my $file_ref_net = $ARGV[0];
my $file_filtro_PTMs = $ARGV[1];

my %hash_filtro_PTMs = ();
my %hash_ref_net = ();
my %hash_ref_net_gen = ();


open(my $fh, '<:encoding(UTF-8)', $file_ref_net) #se abre el archivo a analizar
  or die "Could not open file '$file_ref_net' $!"; 
  
while (my $row = <$fh>) { #lectura del archivo linea por linea
	chomp $row;
	my @split_row = split ("\t",$row);
	if("TFBS" eq $split_row[5]){
		
		#~ print "$split_row[3]\n";
		 if($split_row[3] =~ "\;"){
			 #~ print "<<<<<<<<<\n";
			 my @split_coor = split (';',$split_row[3]);
			 for (my $x = 0; $x < scalar @split_coor; $x++){
				 my @split_coor_2 = split (',',$split_coor[$x]);
				 if(!exists $hash_ref_net{$split_row[4]}{$split_row[0]}{$split_coor_2[0]}{$split_coor_2[1]}){
					 #~ print "hash_ref_net{$split_row[4]}{$split_row[0]}{$split_coor_2[0]}{$split_coor_2[1]} EXISTE!!\n";
					 $hash_ref_net{$split_row[4]}{$split_row[0]}{$split_coor_2[0]}{$split_coor_2[1]} = $split_row[1]; #chr,source,coor_i,coor_t
				 }else{
					 $hash_ref_net{$split_row[4]}{$split_row[0]}{$split_coor_2[0]}{$split_coor_2[1]} .= ";$split_row[1]"; #chr,source,coor_i,coor_t
				 }
				 
				 #~ print "hash_ref_net{$split_row[4]}{$split_row[0]}{$split_coor_2[0]}{$split_coor_2[1]}\n";
			 }
			 
		 }else{
			 my @split_coor_3 = split (',',$split_row[3]);
			 if(!exists $hash_ref_net{$split_row[4]}{$split_row[0]}{$split_coor_3[0]}{$split_coor_3[1]}){
					 #~ print "hash_ref_net{$split_row[4]}{$split_row[0]}{$split_coor_3[0]}{$split_coor_3[1]} EXISTE!!\n";
				$hash_ref_net{$split_row[4]}{$split_row[0]}{$split_coor_3[0]}{$split_coor_3[1]} = $split_row[1]; #chr,source,coor_i,coor_t
			 }else{
				 $hash_ref_net{$split_row[4]}{$split_row[0]}{$split_coor_3[0]}{$split_coor_3[1]} .= ";$split_row[1]"; #chr,source,coor_i,coor_t
			 }
			 
		 }
		 if(!exists $hash_ref_net_gen {$split_row[4]}{$split_row[1]}){
			 $hash_ref_net_gen {$split_row[4]}{$split_row[1]} = $split_row[0];
			 #~ print "hash_ref_net_gen {$split_row[4]}{$split_row[1]}EXISTE\n";
		 }else{
			 $hash_ref_net_gen {$split_row[4]}{$split_row[1]} .= ";$split_row[0]";
			 
		 }
		 
		 
	}
}

#~ for my $i (keys %hash_ref_net_gen){
	#~ for my $j (keys %{$hash_ref_net_gen{$i}}){
		#~ print "$i\t$j\t$hash_ref_net_gen{$i}{$j}\n";
	#~ }
#~ }

my %hash_result = ();

open(my $fh2, '<:encoding(UTF-8)', $file_filtro_PTMs) #se abre el archivo a analizar
  or die "Could not open file '$file_filtro_PTMs' $!"; 
  
while (my $row = <$fh2>) { #lectura del archivo linea por linea
	chomp $row;
	my @split_row = split("\t",$row);

	if("P" eq $split_row[8]){
	
		if(exists $hash_ref_net{$split_row[0]}{$split_row[1]}{$split_row[2]}{$split_row[3]}){
			
			if($hash_ref_net{$split_row[0]}{$split_row[1]}{$split_row[2]}{$split_row[3]} =~ ';'){
				my @split_source = split (';',$hash_ref_net{$split_row[0]}{$split_row[1]}{$split_row[2]}{$split_row[3]});
				for (my $i=0; $i < scalar(@split_source); $i++){
					my $key_1 = "$split_row[1]-->$split_source[$i]";
					my $key_2 = "$split_row[4]($split_row[7])$split_row[8]";
					if(!exists $hash_result{$key_1}{$key_2}){
						$hash_result{$key_1}{$key_2} = 1;

					}else{
						$hash_result{$key_1}{$key_2}++;
					}
					
				}
				
			}else{
			
				my $key_1 = "$split_row[1]-->$hash_ref_net{$split_row[0]}{$split_row[1]}{$split_row[2]}{$split_row[3]}";
				my $key_2 = "$split_row[4]($split_row[7])$split_row[8]";
				if(!exists $hash_result{$key_1}{$key_2}){
					$hash_result{$key_1}{$key_2} = 1;

				}else{
					$hash_result{$key_1}{$key_2}++;
				}
			}
			
			
		}
		
	}
	if("G" eq $split_row[8]){
		
		if(exists $hash_ref_net_gen{$split_row[0]}{$split_row[1]}){
			
			if($hash_ref_net_gen{$split_row[0]}{$split_row[1]} =~ ';'){
				my @split_source = split (';',$hash_ref_net_gen{$split_row[0]}{$split_row[1]});
				for (my $i=0; $i < scalar(@split_source); $i++){
					my $key_3 = "$split_source[$i]-->$split_row[1]";
					my $key_4 = "$split_row[4]($split_row[7])$split_row[8]";
					if(!exists $hash_result{$key_3}{$key_4}){
						$hash_result{$key_3}{$key_4} = 1;
					}else{
						$hash_result{$key_3}{$key_4}++;
					}
				}
				
				
				
				
			}else{
			
				my $key_3 = "$hash_ref_net_gen{$split_row[0]}{$split_row[1]}-->$split_row[1]";
				my $key_4 = "$split_row[4]($split_row[7])$split_row[8]";
				if(!exists $hash_result{$key_3}{$key_4}){
					$hash_result{$key_3}{$key_4} = 1;
				}else{
					$hash_result{$key_3}{$key_4}++;
				}
			}
			
		}
	
	}
	
}


open FILE, ">out/output_connect.txt";
for my $i (keys %hash_result){
	#~ print ">>>>>>>>>>>>>>>>>>>>>>>\n";

	print FILE "$i\t";
	for my $j(keys %{$hash_result{$i}}){
		print FILE "$j=$hash_result{$i}{$j};";
	}
	print FILE "\n";
	
}
close FILE;
