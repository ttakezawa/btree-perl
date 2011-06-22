package BTree;
use strict;
use warnings;

our $VERSION = '0.01';

use BTree::Node;

sub new {
	my ($class, $arg_ref) = @_;
	my $self = bless {}, $class;

	$self->{-t} = $arg_ref->{-t} || 2;
	$self->{-root} = $self->_create_node();
	return $self;
}

sub insert {
	my ($self, $key) = @_;
	if ($self->{-root}->_is_full()) {
		# $self->{-root}を分割し、新しい節点$sをrootとする
		my $s = BTree::Node->new({-t => $self->{-t}});
		$s->{-is_leaf} = 0;
		@{$s->{-children}} = ($self->{-root});
		$s->split_child(0);
		$s->_insert_nonfull($key);
		$self->{-root} = $s;
	} else {
		$self->{-root}->_insert_nonfull($key);
	}
}

sub _create_node {
	my ($self) = @_;
	return BTree::Node->new({-t => $self->{-t}});
}

1;
