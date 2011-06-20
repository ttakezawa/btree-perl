package BTree::Node;
use strict;
use warnings;

sub new {
    my ($class, $arg_ref) = @_;
    my $self = bless {}, $class;
    # $self->{hoge} = $arg_ref->{hoge};
    return $self;
}

1;
