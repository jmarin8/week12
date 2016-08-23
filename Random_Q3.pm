package Random_Q3;

sub new {
	my($class , %attribs) = (@_);
	my $self = {length => $attribs{length} || die("Need 'length'!")};
	return bless $self , $class;
}

sub random_protein{
	my $self = shift;
	my $seq;
	my @aa = qw(A C D E F G H I K L M N P Q R S T V W Y);
	for(my $i=0; $i<$self->{length}; $i++){
        $seq .= $aa[rand(@aa)];
    }
    return $seq;
}

sub DESTROY {
	my( $self ) = ( @_ );
	print "DESTROY activated.\n";
	$self->{length} = undef if ($self->{length});
	print "Object has been destroyed.\n";
}

1;
