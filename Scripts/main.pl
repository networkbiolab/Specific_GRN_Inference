#!/usr/bin/perl -w
use strict;
use warnings;

#~ sub getopt{
	#~ my $var;
	#~ while(@ARGV){
		#~ my $t = shift @ARGV;
		
		#~ if($t eq "-t"){
			#~ print "hola\n";
			#~ $var = shift @ARGV;
		#~ }
		#~ if($t eq "-r"){
			#~ print "hola\n";
			#~ $var = shift @ARGV;
		#~ }
		
	#~ }
	
	#~ return $var;
#~ }

#~ print getopt;

use Getopt::Std;
my %options=();
getopts("str:",\%options);


#~ print "NO TA!!!!\n" if not defined $options{r};
my $flag = 0;
my $input;

if(defined $options{r}){
	if(-e $options{r}){
		$input = $options{r};
		print "\n";
		print "Config File loaded\n";
		print "\n";
		$flag = 1;
	}else{
		#~ print "File not exist, please enter the location of the config file\n";
		die "File not exist, please enter the location of the config file\n";
	}
}

#~ if(-e $options{r}){
#~ }else{
	
#~ }




if(defined $options{t} && $options{t} == 1 && not defined $options{r}){
                                                                                                                                                                                                                                                                                                                             
	print "\n";                                                                                                                                                                
	print "\n";                                                                                                                                                                
	print "\n";                                                                                                                                                                
																																																																																				
	print "\t###########################################\n";         
	print "\t||            INFERENCE GRNs             ||\n";
	print "\t||      TIME & SPECIFIC LOCATION         ||\n";
	print "\t###########################################\n";         
							
	print "\n";                                 
	print "\n";                                 
	print "\n";                                 
	print "#################################################################\n";
	print "|| Contact: leomurgas_12\@hotmail.com | proteinomano\@gmail.com  ||\n";
	print "#################################################################\n";
	print "\n";
	print "Welcome to the methodology for the inference of GRNs time & specific
		 location with the integration of experimental data\n";
	print "\n";
	print "Please, enter the location of the config.txt file or ENTER if the file is in the folder:\n";


	chomp($input = <STDIN>);

	if (length($input) == 0){
			#~ print ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n";

		$input = "config.txt";
	}

	if(-e $input){
		print "\n";
		print "Config File loaded\n";
		print "\n";
		$flag = 1;
	}else{
		print "\n";
		#~ print "File not exist, please enter the location of the config file\n";
		die "File not exist, please enter the location of the config file\n";
		print "\n";
	}
}

my $ref_TFBS_target = "";
my $ref_miRNA_target = "";
my $PTMs_filter = "";
my $comb_PTMs_filter = "";
my $TF_expre = "";
my $miRNA_expre = "";
my $CRMs = "";
my $DNAse_hyper = "";
my $Meth = "";
my $Iso_filter = "";

my $GENEs_file = "null";
my $TFBSs_file = "null";
my $synonyms_file = "null";
my $D_region = "null";
my $case = "null";
my $miRecords_file = "null";
my $mirTarbase_file = "null";
my $Tarbase_file = "null";
my $config_PTMs = "null";
my $config_comb_PTMs = "null";
my $RPKM_file = "null";
my $CRMs_file = "null";
my $iso_file = "null";
my $D_iso = "null";
my $DNAse_file = "null";
my $Meth_file = "null";
my $porc_meth = "null";
my $score_dnase = "null";

my $x = 0;
my $x_2 = 0;


if($flag == 1){
	open (my $fh, $input)
		or die "Could not open file '$input' $!"; 
		
	while (my $row = <$fh>) { 
		chomp $row;
		
		#~ print "$row\n";
		
		if($row !~ "#" && length($row) != 0){
			
			if($row !~ '\"'){
				$row =~ s/\s//g;
			}
			my @array = split("=", $row);

			####OPTIONS####
			if($array[0] eq "ref_TFBS_target"){
				#~ my @array = split("=", $row);
				$ref_TFBS_target = $array[1];
			}
			if($array[0] eq "ref_miRNA_target"){
				#~ my @array = split("=", $row);
				$ref_miRNA_target = $array[1];
			}
			if($array[0] eq "PTMs_filter"){
				#~ my @array = split("=", $row);
				$PTMs_filter = $array[1];
				#~ print "$PTMs_filter\n";
				#~ print "#################\n";
			}
			if($array[0] eq "comb_PTMs_filter"){
				#~ my @array = split("=", $row);
				$comb_PTMs_filter = $array[1];
			}
			if($array[0] eq "TF_express_filter"){
				#~ my @array = split("=", $row);
				$TF_expre = $array[1];
			}
			if($array[0] eq "miRNAs_express_filter"){
				#~ my @array = split("=", $row);
				$miRNA_expre = $array[1];
			}
			if($array[0] eq "CRMs"){
				#~ my @array = split("=", $row);
				$CRMs = $array[1];
			}
			if($array[0] eq "DNAse_hyper"){
				#~ my @array = split("=", $row);
				$DNAse_hyper = $array[1];
			}
			if($array[0] eq "Meth"){
				#~ my @array = split("=", $row);
				$Meth = $array[1];
			}
			if($array[0] eq "Iso_filter"){
				#~ my @array = split("=", $row);
				$Iso_filter = $array[1];
			}
			####LOCATION_FILES####
			if($array[0] eq "GENEs_file"){
				#~ my @array = split("=", $row);
				if(scalar @array > 1){
					$GENEs_file = $array[1];
				}
			}
			if($array[0] eq "TFBSs_file"){
				#~ my @array = split("=", $row);
				if(scalar @array > 1){
					$TFBSs_file = $array[1];
				}
			}
			if($array[0] eq "synonyms_file"){
				#~ my @array = split("=", $row);
				if(scalar @array > 1){
					$synonyms_file = $array[1];
				}
			}
			if($array[0] eq "D_region"){
				#~ my @array = split("=", $row);
				if(scalar @array > 1){
					$D_region = $array[1];
				}
			}
			if($array[0] eq "case"){
				#~ my @array = split("=", $row);
				if(scalar @array > 1){
					$case = $array[1];
				}
			}
			if($array[0] eq "miRecords_file"){
				#~ my @array = split("=", $row);
				if(scalar @array > 1){
					$miRecords_file = $array[1];
				}
			}
			if($array[0] eq "mirTarbase_file"){
				#~ my @array = split("=", $row);
				if(scalar @array > 1){
					$mirTarbase_file = $array[1];
				}
			}
			if($array[0] eq "Tarbase_file"){
				#~ my @array = split("=", $row);
				if(scalar @array > 1){
					$Tarbase_file = $array[1];
				}
			}
			if($array[0] eq "config_PTMs"){
				#~ my @array = split("=", $row);
				$x = 1;

				if(scalar @array > 1){
					$config_PTMs = $array[1];
					open FILE_1 ,">$config_PTMs";
				}
			}
			if($array[0] eq "config_comb_PTMs"){
				#~ my @array = split("=", $row);
				if($x != 0){	
					$x = 0;
					close FILE_1;
				}
				$x_2 = 1;
				if(scalar @array > 1){
					$config_comb_PTMs = $array[1];
					open FILE_2 ,">$config_comb_PTMs";
				}
			}
			if($array[0] eq "RPKM_file"){
				#~ my @array = split("=", $row);
				if($x_2 != 0){
					$x_2 = 0;
					close FILE_2;
				}
				if(scalar @array > 1){
					$RPKM_file = $array[1];
				}
			}
			if($array[0] eq "CRMs_file"){
				#~ my @array = split("=", $row);
				if(scalar @array > 1){			
					$CRMs_file = $array[1];
				}
			}
			if($array[0] eq "iso_file"){
				#~ my @array = split("=", $row);
				if(scalar @array > 1){
					$iso_file = $array[1];
				}
			}
			if($array[0] eq "D_iso"){
				#~ my @array = split("=", $row);
				if(scalar @array > 1){
					$D_iso = $array[1];
				}
			}
			if($array[0] eq "DNAse_file"){
				#~ my @array = split("=", $row);
				if(scalar @array > 1){
					$DNAse_file = $array[1];
				}
			}
			if($array[0] eq "Meth_file"){
				#~ my @array = split("=", $row);
				if(scalar @array > 1){
					$Meth_file = $array[1];
				}
			}
			if($array[0] eq "porc_meth"){
				#~ my @array = split("=", $row);
				if(scalar @array > 1){
					$porc_meth = $array[1];
				}
			}
			
			if($array[0] eq "score_dnase"){
				#~ my @array = split("=", $row);
				if(scalar @array > 1){
					$score_dnase = $array[1];
				}
			}
			
			if($x == 1 && $PTMs_filter eq "Y" && $row !~ "config_PTMs"){
				$row =~ s/\"//;
				$row =~ s/\"//;
				#~ print FILE_1 "$row\n";
				my @aux = split (",", $row);
				for(my $i=0; $i<scalar @aux; $i++){
					print FILE_1 "$aux[$i]\n";
				}
			}
			if($x_2 == 1 && $comb_PTMs_filter eq "Y" && $row !~ "config_comb_PTMs"){
				#~ print FILE_2 "$row\n";
				$row =~ s/\"//;
				$row =~ s/\"//;
				#~ print FILE_1 "$row\n";
				my @aux = split (",", $row);
				for(my $i=0; $i<scalar @aux; $i++){
					print FILE_2 "$aux[$i]\n";
				}
			}
			
			
			
			
		}
		
	}	
}

my $exit = 0;

if($ref_TFBS_target eq "Y" || $PTMs_filter eq "Y"){
	if(length $GENEs_file != 0){
		if(-e $GENEs_file){
		}else{
			print "GENEs file not exist, please enter the location in the config file\n";
			$exit = 1;
		}
	}
	if(-e $TFBSs_file){		
	}else{
		print "TFBSs file not exist, please enter the location in the config file\n";
		$exit = 1;
	}
}

if($ref_TFBS_target eq "Y" || $ref_miRNA_target eq "Y"){
	if(-e $synonyms_file){
	}else{
		print "Synonyms file not exist, please enter the location in the config file\n";
		$exit = 1;
	}
}

if($ref_TFBS_target eq "Y"){
	if($D_region !~ /^[+-]?\d+$/){
		print "The D_region is not numeric, please check the config file\n";
		$exit = 1;
	}
	if($case !~ /^[+-]?\d+$/){
		print "The case is not numeric, please check the config file\n";
		$exit = 1;
	}elsif($case != 1 && $case != 2){
		print "Case invalid, please choice option 1 or 2\n";
		$exit = 1;
	}
	
}

if($ref_miRNA_target eq "Y"){
	if(-e $miRecords_file){
	}else{
		print "miRecords file not exist, please enter the location in the config file\n";
		$exit = 1;
	}
	if(-e $mirTarbase_file){
	}else{
		print "mirTarbase file not exist, please enter the location in the config file\n";
		$exit = 1;
	}
	if(-e $Tarbase_file){
	}else{
		print "Tarbase file not exist, please enter the location in the config file\n";
		$exit = 1;
	}
}

if($PTMs_filter eq "Y"){
	if(-e $config_PTMs){
	}else{
		print "config_PTMs file not exist, please enter the location in the config file\n";
		$exit = 1;
	}
}

if($comb_PTMs_filter eq "Y"){
	if(-e $config_comb_PTMs){
	}else{
		print "config_comb_PTMs file not exist, please enter the location in the config file\n";
		$exit = 1;
	}
}

if($CRMs eq "Y"){
	if(-e $CRMs_file){
	}else{
		print "CRMs file not exist, please enter the location in the config file\n";
		$exit = 1;
	}
	if(-e $TFBSs_file){
	}else{
		print "TFBSs file not exist, please enter the location in the config file\n";
		$exit = 1;
	}
}

if($Iso_filter eq "Y"){
	if(-e $CRMs_file){
	}else{
		print "CRMs file not exist, please enter the location in the config file\n";
		$exit = 1;
	}
	if(-e $GENEs_file){
	}else{
		#~ print ">>>>>>>>>>>\n";
		print "GENEs file not exist, please enter the location in the config file\n";
		$exit = 1;
	}
	
	if(-e $iso_file){
	}else{
		print "Iso file not exist, please enter the location in the config file\n";
		$exit = 1;
	}
	if($D_iso !~ /^[+-]?\d+$/){
		print "The D_iso is not numeric, please check the config file\n";
		$exit = 1;
	}
}

if($Meth eq "Y"){
	if(-e $Meth_file){
	}else{
		print "Meth file not exist, please enter the location in the config file\n";
		$exit = 1;
	}
	if($porc_meth !~ /^[+-]?\d+$/){
		print "The porc_meth is not numeric, please check the config file\n";
		$exit = 1;
	}
}

if($DNAse_hyper eq "Y"){
	if(-e $DNAse_file){
	}else{
		print "DNAse file not exist, please enter the location in the config file\n";
		$exit = 1;
	}
	if($score_dnase !~ /^[+-]?\d+$/){
		print "The score_dnase is not numeric, please check the config file\n";
		$exit = 1;
	}
}





if($exit == 1){
	system (exit);
}

if($ref_TFBS_target eq "Y"){
	print "============NETWORK TFBS-TARGET============\n\n";
	my $a =`perl TFBS_GEN_net/TFBS_network_v5.3_nuevo.pl $GENEs_file $TFBSs_file $synonyms_file $D_region $case`;
	print $a;
	if($? != 0){
		die "$a";
	}
	print "\nDONE!\n";
	
}

if($CRMs eq "Y" && $ref_TFBS_target eq "Y"){
	print "\n============CRMs ANALYSIS============\n\n";
	my $a = `perl CRMs/CRMs_TFBSs.pl $TFBSs_file $CRMs_file`;
	print $a;
	if($? != 0){
		die "$a";
	}
	if($ref_TFBS_target eq "Y"){
		system ("cat out/out_TFBS_network.tsv out/output_CRMs_TFBSs.tsv > out/TFBSs_CRMs_network.tsv");
	}else{
		system ("mv out/output_CRMs_TFBSs.tsv out/TFBSs_CRMs_network.tsv");
		system ("rm out/output_CRMs_TFBSs.tsv");
	}
	print "DONE!\n";

}

if($ref_miRNA_target eq "Y"){
	print "\n============NETWORK miRNA-TARGET============\n\n";
	my $a = `perl miRNA_net/microRNA_network.pl $synonyms_file $miRecords_file $mirTarbase_file $Tarbase_file`;
	print $a;
	if($? != 0){
		die "$a";
	}
	print "DONE!\n";
}
my $ref_net;
if($CRMs eq "Y"){
	$ref_net = "out/TFBSs_CRMs_network.tsv";
}else{
	$ref_net = "out/out_TFBS_network.tsv";
}

if($Meth eq "Y"){
	if($ref_TFBS_target eq "Y" || $CRMs eq "Y"){
		print "\n============DNA METHYLATION ANALYSIS============\n\n";
		my $a = `perl DNAse_hyper_Meth/DNAse.pl $ref_net $DNAse_file $GENEs_file $porc_meth`;
		print $a;
		if($? != 0){
			die "$a";
		}
		print "DONE!\n";
		
	}else{
		print "NO REFERENCE NETWORK EXISTS\n";
	}
	
}

if($DNAse_hyper eq "Y"){
	if($ref_TFBS_target eq "Y" || $CRMs eq "Y"){
		print "\n============DNAse I HYPERSENSITIVE ANALYSIS============\n\n";
		my $a = `perl DNAse_hyper_Meth/Meth.pl $ref_net $Meth_file $DNAse_file $score_dnase`;
		print $a;
		if($? != 0){
			die "$a";
		}
		print "DONE!\n";
		
	}else{
		print "NO REFERENCE NETWORK EXISTS\n";
	}
	
}

if($Iso_filter eq "Y"){
	if($ref_TFBS_target eq "Y" || $CRMs eq "Y"){
		print "\n============ISOLATOR FILTER============\n\n";
		my $a = `perl iso_module/isolators_v2.pl $ref_net $CRMs_file $GENEs_file $iso_file $D_iso`;
		print $a;
		if($? != 0){
			die "$a";
		}
		print "DONE!\n";
	}else{
		print "NO REFERENCE NETWORK EXISTS\n";
	}
	
}


my $PTMs_analysis = 0;
my $exp_ptms;

if($PTMs_filter eq "Y" && $ref_TFBS_target eq "Y"){
	print "\n============PTMs-FILTER============\n\n";

	open(my $fh, '<:encoding(UTF-8)', $config_PTMs) #se abre el archivo a analizar
	  or die "Could not open file '$config_PTMs' $!"; 
	  
	while (my $row = <$fh>) { #lectura del archivo linea por linea
		chomp $row;
		
		my @split_row = split("\t",$row);
		$exp_ptms .= "$split_row[3] ";
	}
	
	
	my $a = `perl PTMs_filter/filtro_PTMs_vfinal.pl $config_PTMs $TFBSs_file $GENEs_file $exp_ptms`;
	print $a;
	if($? != 0){
		die "$a";
	}
	
	my $b = `perl PTMs_filter/conexiones_v2.pl $ref_net out/output_filter_PTMs.txt`;
	print $b;
	if($? != 0){
		die "$b";
	}
	
	print "DONE!\n";
	$PTMs_analysis++;
}

if($PTMs_filter eq "Y" && $ref_TFBS_target eq "Y" && $comb_PTMs_filter eq "Y"){
	print "\n============COMB PTMs-FILTER============\n\n";
	print "$config_comb_PTMs\n";
	my $a = `perl PTMs_filter/script_comb_ptms.pl $config_comb_PTMs out/output_connect.txt`;
	print $a;
	if($? != 0){
		die "$a";
	}
	print "DONE!\n";
	$PTMs_analysis++;
}


if($PTMs_analysis == 1){
	print "\n============CONNECTION ANALYSIS============\n\n";
	my $a = `perl Connection_analysis/analisis_conexiones.pl out/output_connect.txt $PTMs_analysis`;
	print $a;
	if($? != 0){
		die "$a";
	}
	print "DONE!\n";
}elsif($PTMs_analysis == 2){
	print "\n============CONNECTION ANALYSIS============\n\n";
	my $a = `perl Connection_analysis/analisis_conexiones.pl out/output_comb_ptms.txt $PTMs_analysis`;
	print $a;
	if($? != 0){
		die "$a";
	}
	print "DONE!\n";
}

if($TF_expre eq "Y"){
	if($ref_TFBS_target eq "Y" || $CRMs eq "Y"){
		if($PTMs_filter eq "Y"){
			print "\n============REGULATOR EXPRESSION ANALYSIS============\n\n";
			my $a = `perl Expression_filter/expresion_reguladores.pl $RPKM_file out/output_analisis_conexiones_seguro.tsv`;
			if($? != 0){
				die "$a";
			}
			print "DONE!\n";
		}else{
			print "\n============REGULATOR EXPRESSION ANALYSIS============\n\n";
			my $a = `perl Expression_filter/expresion_reguladores.pl $RPKM_file $ref_net`;
			if($? != 0){
				die "$a";
			}
			print "DONE!\n";
		}
		
	}else{
		print "NO REFERENCE NETWORK EXISTS\n";
	}
}

if($miRNA_expre eq "Y"){
	if($ref_miRNA_target eq "Y"){
		print "\n============miRNAs EXPRESSION ANALYSIS============\n\n";
		my $a = `perl Expression_filter/expresion_reguladores_microRNA.pl $RPKM_file out/out_microRNA_network.tsv`;
		if($? != 0){
			die "$a";
		}
		print "DONE!\n";

	}else{
		print "NO miRNAs REFERENCE NETWORK EXISTS\n";
	}
	
}

if($TF_expre eq "Y" && $miRNA_expre eq "Y"){
	system ("cat out/output_regulator_expres.tsv out/output_miRNA_expres.tsv > out/specific_GRN.tsv");
}elsif($TF_expre eq "Y" && $miRNA_expre ne "Y"){
	system ("mv out/output_regulator_expres.tsv out/specific_GRN.tsv");
}elsif($miRNA_expre eq "Y" && $TF_expre ne "Y"){
	system ("mv out/output_miRNA_expres.tsv out/specific_GRN.tsv");
}
