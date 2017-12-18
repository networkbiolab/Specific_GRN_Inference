use strict;
use warnings;

my $synonym = $ARGV[0];
my $CRMs = $ARGV[1];
my %hash_synonym = ();





open(my $fh3, '<:encoding(UTF-8)', $synonym) #se abre el archivo a analizar
  or die "Could not open file '$synonym' $!"; 
  
while (my $row3 = <$fh3>) { #lectura del archivo linea por linea
	chomp $row3;
	
	if ($row3 !~ "##" && length $row3 != 0){
		my @split_row3 = split ("\t", $row3);
		if($split_row3[0] =~ "FBgn"){
			if($split_row3[1] !~ /\\/){	
				for(my $var=1; $var<scalar @split_row3; $var++){
					if(length $split_row3[$var] != 0 && $split_row3[$var] ne '.'){
						#~ if($split_row3[$var] =~ "Dmel"){
							my @split_synonym = split (',',$split_row3[$var]);
							for(my $var2=0; $var2<scalar @split_synonym; $var2++){
								my $string = lc($split_synonym[$var2]);
								$hash_synonym{$string} = $split_row3[0]; #hash_synonym{name_gene} = Fbgn
							#~ }
						}	
						#~ $hash_synonym{$split_row3[0]}.= "$split_row3[$var],";
					}
				}
			}
		
		}
	}
	
}



open(my $fh2, '<:encoding(UTF-8)', $CRMs) #se abre el archivo a analizar
  or die "Could not open file '$CRMs' $!"; 

open FILE,">CRMs_synonym.txt";

while (my $row = <$fh2>) { #lectura del archivo linea por linea
	chomp $row;
	#~ print "$row\n";
	#~ print "hola\n";
	my @split_row = split ("\t",$row);	
	if($split_row[3] ne "CRMName"){	
		#~ print ">>>>>>>>>>>>>>>>>>>>>>>>\n";
		
		
		
		my $string = lc($split_row[4]);
		if (exists $hash_synonym{$string}){
			print FILE "$split_row[0]\t$split_row[1]\t$split_row[2]\t$split_row[3]\t$hash_synonym{$string}\n";
			#~ print "$hash_synonym{$string}\n";
			
		}else{
			print "$string NO EXISTE\n";
			
		}
	}else{
		print FILE "$row\n";
		print "$row\n";
		
	}
}

close FILE;
#~ for my $i (keys %hash_synonym){
	#~ print "$i\t$hash_synonym{$i}\n";
#~ }
