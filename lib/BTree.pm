package BTree;
use strict;
use warnings;

our $VERSION = '0.01';

use JSON::Syck;
use BTree::Node;

sub new {
	my ($class, $arg_ref) = @_;
	my $self = bless {}, $class;

	$self->{-t} = $arg_ref->{-t} || 2;
	$self->{-root} = BTree::Node->new({-t => $self->{-t}, -is_leaf => 1});
	return $self;
}

sub insert {
	my ($self, $key) = @_;
	if ($self->{-root}->_is_full()) {
		# $self->{-root}を分割し、新しい節点$sをrootとする
		my $s = BTree::Node->new({-t => $self->{-t}, -is_leaf => 0});
		@{$s->{-children}} = ($self->{-root});
		$s->split_child(0);
		$s->_insert_nonfull($key);
		$self->{-root} = $s;
	} else {
		$self->{-root}->_insert_nonfull($key);
	}
}

sub search {
	my ($self, $key) = @_;
	return $self->{-root}->search($key);
}

sub keys {
	my ($self) = @_;
	return $self->{-root}->nested_keys();
}

sub keys_to_json {
	my ($self) = @_;
	return JSON::Syck::Dump($self->keys());
}

1;
