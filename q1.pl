#!/opt/perl/bin/perl
use strict;
use q1 'random_protein';

my ($arg, $length, $result);

print "Length: ";
chomp ($arg = <STDIN>);

if ($arg eq ''){$length = 1 + int(rand(100));}
elsif ($arg =~ /^\d+$/) {$length = $arg;}
else {print "Invalid input. Must be interger."; exit;}

$result = random_protein($length);
print "Sequence: " . $result . "\n";
