package BTree;
use strict;
use warnings;

our $VERSION = '0.01';

use BTree::Node;

sub new {
    my ($class, $arg_ref) = @_;
    my $self = bless {}, $class;
    # $self->{hoge} = $arg_ref->{hoge};
    return $self;
}

1;
