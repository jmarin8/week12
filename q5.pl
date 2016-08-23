#!/opt/perl/bin/perl 
use warnings;
use strict;

use Bio::SearchIO;
use Bio::DB::GenBank;
use Bio::Tools::Run::RemoteBlast;

STDOUT->autoflush(1);


if ($#ARGV != 2 ) {
	print "USAGE:\n" . 
			"\t ./q5.pl search_type data_type accession_number\n" . 
			"\t for example: $ ./q5.pl blastn protein accession_number ";
	exit;
}

my $prog	  = $ARGV[0]; 
my $type	  = $ARGV[1]; 
my $accession = $ARGV[2]; 

if ($prog !~ /blastn|blastx|tblastx|blastp|tblastn/i){
	print "ERROR: " . $prog . " search type INCORRECT\n"; exit;
}elsif ($type !~ /dna|protein/i){
	print "ERROR: " . $type . "data type INCORRECT\n"; exit;
}elsif ($type =~ /dna/i && $prog !~ /blastn|blastx|tblastx/i){
	print "ERROR: Arguments ($type AND $prog) do not match\n"; exit;
}elsif ($type =~ /protein/i && $prog !~ /blastp|tblastn/i){
	print "ERROR: Arguments ($type AND $prog) do not match\n"; exit;
}else{
	my $db = Bio::DB::GenBank->new();
	my $factory = Bio::Tools::Run::RemoteBlast->new( 
			-prog       => $prog     ,
			-data       => 'nr'      ,
			-expect     => '1e-10'   ,
			-readmethod => 'SearchIO' );

	my $seq = $db->get_Seq_by_acc($accession);	
	print "Submitting BLAST...";
	$factory->submit_blast($seq);
	print "DONE\n";
	print "Gathering Data";
	while (my @rids = $factory->each_rid){
		foreach my $rid (@rids){
			my $results = $factory->retrieve_blast($rid);
			if(!ref($results)){print "."; sleep 3;}
			elsif( $results<0 ){$factory->remove_rid($rid);}
			else{ 
				print "DONE\n";
				$factory->remove_rid($rid);
				my $result = $results->next_result;
				my $report = $result->query_name . "_" . $prog . ".txt";
				$factory->save_output($report);
				print "BLAST Report: " . $report . "\n";
			}
		}
	}
}
