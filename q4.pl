#!/opt/perl/bin/perl
use strict;
use Bio::SeqIO;

if ($#ARGV != 1 ) {
	print "TO RUN:\n" . 
		"\t $ ./format_convert ./genbank-data.gb fasta \n" . 
		"\t for example: ./q4.pl sequence.typeone typetwo\n";
	exit;
}

my $in_file   = $ARGV[0];
my $out_format  = $ARGV[1];

my ($in_name) = $in_file =~ (/^(.*?)\./); 
my $out_file = $in_name . "." . $out_format;
 
print "INPUT: " . $in_file . "\n";
print "OUTPUT FORMAT: " . $out_format . "\n";
 
my $input = Bio::SeqIO->new(
                            -file   => "<" . $in_file,
                            );
							 
my $output = Bio::SeqIO->new(
                            -file   => ">" . $out_file,
                            -format => $out_format
                            );
							 
while (my $inseq = $input->next_seq) {
	$output->write_seq($inseq);
	print "WROTE: " . $out_file . "\n";
}
