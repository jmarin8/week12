#!/opt/perl/bin/perl 
use warnings;
use strict;

use Bio::SearchIO;
use Bio::DB::GenBank;
use Bio::Tools::Run::RemoteBlast;

STDOUT->autoflush(1);

if ($#ARGV != 1 ) {
	print "INPUT:\n" . 
			"\t ./q6.pl accession_number e-value_cutoff\n";
	exit;
}
 
my $accession = $ARGV[0]; 
my $e_value = $ARGV[1];


my $db = Bio::DB::GenBank->new();
my $factory = Bio::Tools::Run::RemoteBlast->new( 
				-prog       => 'blastp'  ,
				-data       => 'nr'      ,
				-expect     => $e_value  ,
				-readmethod => 'SearchIO' );

my $seq = $db->get_Seq_by_acc($accession);	
print "Submitting BLAST..."; 
$factory->submit_blast($seq);
print "DONE\n";
print "Gathering Data";
while (my @rids = $factory->each_rid){
	foreach my $rid (@rids){
		my $results = $factory->retrieve_blast($rid);
		if(!ref($results)){print "."; sleep 5;}
		elsif($results<0){$factory->remove_rid($rid);}
		else{ 
			print "DONE\n";
			$factory->remove_rid($rid);
			my $result = $results->next_result;
			my @hits;
			while( my $hit = $result->next_hit ) {push (@hits, $hit);}
			if (!@hits){print "No hits satisfy e-value cutoff!\n"; exit;}
			else{
				my $i = 1;
				foreach my $h (@hits) {
					my $file = $h->accession . ".txt";
					open (FILE, ">$file") or die $!;
					while ( my $hsp = $h->next_hsp ) {
						print FILE 
							"RANK: #"     . $hsp->rank               . "\n"      .
							"HIT: "       . $h->name 		 . "\n"      . 
							"ACCESSION: " . $h->accession            . "\t"      .
							"LENGTH: "    . $hsp->length('hit')      . "\t"      .
							"SCORE: "     . $hsp->bits               . " bits\t" .
							"IDENTITY: "  . $hsp->percent_identity   . "%\t"     .
							"E-VALUE: "   . $hsp->evalue             . "\n"      ;
						printf FILE ("%10s: %s\n" , "Query" , $hsp->query_string)    ;
						printf FILE ("%10s: %s\n" , ""      , $hsp->homology_string) ;
						printf FILE ("%10s: %s\n" , "Sbjct" , $hsp->hit_string)      ;
					}
					close (FILE);
					print "Record for HIT#" . $i . 
						  " Location: " . $file . "\n"; 
					$i++;					
				}
			}
			print scalar @hits . "Total!\n";
		}
	}
}
