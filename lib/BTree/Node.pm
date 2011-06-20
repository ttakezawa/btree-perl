package BTree::Node;
use strict;
use warnings;

use Carp;
use List::Util;

sub new {
	my ($class, $arg_ref) = @_;
	my $self = bless {}, $class;

	$self->{-t} = $arg_ref->{-t} || die "You must specify a order";
	$self->{-keys} = [];
	$self->{-children} = [];
	$self->{-is_leaf} = 1;
	return $self;
}

sub is_leaf {
	my ($self) = @_;
	return $self->{-is_leaf};
}

sub length {
	my ($self) = @_;
	return scalar(@{$self->{-keys}});
}

sub _is_full {
	my ($self) = @_;
	return $self->length() == 2 * $self->{-t} - 1;
}

sub insert {
	my ($self, $key) = @_;
	if ($self->_is_full()) {
		confess "TODO";
	} else {
		$self->_insert_nonfull($key);
	}
}

sub _insert_nonfull {
	my ($self, $key) = @_;
	if ($self->is_leaf()) {
		my $i = List::Util::first { $key < $self->{-keys}[$_] } (0..scalar(@{$self->{-keys}})-1);
		if (defined $i) {
			splice(@{$self->{-keys}}, $i, 0, $key);
		} else {
			push @{$self->{-keys}}, $key;
		}

		# # Implementation by Algorithm Introruction
		# my $i;
		# for ($i = $self->length()-1; $i >= 0 && $key < $self->{-keys}[$i]; $i--) {
		# 	$self->{-keys}[$i+1] = $self->{-keys}[$i];
		# }
		# $self->{-keys}[$i+1] = $key;
	} else {
		confess "TODO";
	}
}

sub split_child {
	my ($self, $i) = @_;
	my $y = $self->{-children}[$i];
	confess "TODO";
}

1;
