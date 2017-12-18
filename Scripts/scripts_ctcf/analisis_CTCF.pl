use strict;
use warnings;

#INPUT: .fasta

my $file_out_loops = $ARGV[0];

open(my $fh, '<:encoding(UTF-8)', $file_out_loops) #se abre el archivo a analizar
  or die "Could not open file '$file_out_loops' $!"; 


my $count_1 = 0;
my $count_2 = 0;
while (my $row = <$fh>) { #lectura del archivo linea por linea
	chomp $row;
	my $plus = 0;
	my $minus = 0;
	my $count_plus = 0;
	my $count_minus = 0;
	my @split_row = split("\t",$row);
	

	if($split_row[7] ne '*'){
		$count_2++;
		my @split_ptms = split(',',$split_row[7]);
		for (my $i=0; $i<scalar @split_ptms;$i++){
			#~ print $split_ptms[$i],"\n";
			if($split_ptms[$i] =~ /\+/){
				my @split_aux = split ("\\)",$split_ptms[$i]);
					
					$split_aux[1] =~ s/\(//gi;
					my @split_aux_2 = split("\]",$split_aux[1]);
					$split_aux_2[0] =~ s/\[//gi;
					$count_plus = $count_plus+$split_aux_2[0];
					#~ print "$split_aux[1]\n";
					$plus = $plus+$split_aux_2[1];
				
			}
			if($split_ptms[$i] =~ /\-/){
				my @split_aux = split ("\\)",$split_ptms[$i]);
				$split_aux[1] =~ s/\(//gi;
				my @split_aux_2 = split("\]",$split_aux[1]);
				$split_aux_2[0] =~ s/\[//gi;
				$count_minus = $count_minus+$split_aux_2[0];
				$minus = $minus+$split_aux_2[1];
				
			}
			
			
		}
		#~ print "$split_row[0]\t$split_row[1]\t$split_row[2]\t$split_row[3]\t$split_row[4]\t$plus\t$minus\n";

		if($plus == 0){
			#~ print "$split_row[0]\t$split_row[1]\t$split_row[2]\t$split_row[3]\t$split_row[4]\t\-\n";
			$count_1++;
		}
		if($minus == 0){
			#~ print "$split_row[0]\t$split_row[1]\t$split_row[2]\t$split_row[3]\t$split_row[4]\t\+\n";
			$count_1++;
		}
		if($plus !=0 && $minus !=0){
			#~ print "$row\n";
			print "$split_row[0]\t$split_row[1]\t$split_row[2]\t$split_row[3]\t$split_row[4]\t\[\+\]\($count_plus\)$plus\t\[\-\]\($count_minus\)$minus\n";
		}
		
	
	}
	if($split_row[8] ne '*'){
		
	}
	
	#~ if($plus > 50){
		#~ print "$split_row[0]\t$split_row[1]\t$split_row[2]\t$split_row[3]\t$split_row[4]\t$plus\t$minus\n";
	
	#~ }	
}

#~ print "consenso: $count_1\n";
#~ print "discrepancia:", $count_2 - $count_1,"\n";
