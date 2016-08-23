#!/opt/perl/bin/perl
use strict; 
use Random_Q3;

my ($seq, $arg, $length, $result);

print "Length:";
chomp ($arg = <STDIN>);

if ($arg eq ''){$length = 1 + int(rand(100));}
elsif ($arg =~ /^\d+$/) {$length = $arg;}
else {print "Invalid input, must be integer. Please re-enter.\n"; exit;}

$seq = Random_Q3->new(length => "$length");
$result = $seq->random_protein($length);
print "Sequence:" . $result . "\n";
