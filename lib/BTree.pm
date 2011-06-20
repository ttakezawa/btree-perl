package BTree;
use strict;
use warnings;

our $VERSION = '0.01';

use BTree::Node;

sub new {
	my ($class, $arg_ref) = @_;
	my $self = bless {}, $class;

	$self->{-t} = $arg_ref->{-t} || 2;
	$self->{-root} = $self->create_node();
	return $self;
}

sub create_node {
	my ($self) = @_;
	return BTree::Node->new({-t => $self->{-t}});
}

1;
