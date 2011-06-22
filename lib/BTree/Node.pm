package BTree::Node;
use strict;
use warnings;

use Carp;
use List::Util;

sub new {
	my ($class, $arg_ref) = @_;
	my $self = bless {}, $class;

	$self->{-t} = $arg_ref->{-t} || die "You must specify a order";
	defined $arg_ref->{-is_leaf} || confess "You must specify a is_leaf";
	$self->{-is_leaf} = $arg_ref->{-is_leaf};

	$self->{-keys} = [];
	$self->{-children} = [];
	
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

# データ構造確認用
sub nested_keys {
	my ($self) = @_;
	if ($self->is_leaf()) {
		return $self->{-keys};
	} else {
		my $ary = [];
		for my $i (0..@{$self->{-keys}}-1) {
			push(@$ary, $self->{-children}[$i]->nested_keys());
			push(@$ary, $self->{-keys}[$i]);
		}
		push(@$ary, $self->{-children}[-1]->nested_keys());
		return $ary;
	}
}

sub _is_full {
	my ($self) = @_;
	return $self->length() == 2 * $self->{-t} - 1;
}

# $keyが挿入されているべき位置を返す
sub _locate_to_insert {
	my ($self, $key) = @_;
	my $i = List::Util::first { $key < $self->{-keys}[$_] } (0..@{$self->{-keys}}-1);
	$i = $self->length() unless defined $i;
	return $i;
}

sub _insert_nonfull {
	my ($self, $key) = @_;
	if ($self->is_leaf()) {
		# $selfが葉のときは適切な位置にキーとして挿入するだけ
		splice(@{$self->{-keys}}, $self->_locate_to_insert($key), 0, ($key));

		# # Implementation by Algorithm Introruction
		# my $i;
		# for ($i = $self->length()-1; $i >= 0 && $key < $self->{-keys}[$i]; $i--) {
		# 	$self->{-keys}[$i+1] = $self->{-keys}[$i];
		# }
		# $self->{-keys}[$i+1] = $key;
	} else {
		my $i = $self->_locate_to_insert($key);
		if ($self->{-children}[$i]->_is_full()) {
			$self->split_child($i);
			if ($key > $self->{-keys}[$i]) {
				$i++;
			}
		}
		$self->{-children}[$i]->_insert_nonfull($key);
	}
}

# $selfのi番目の子($y)を分割する
# $yの中央のキーが、$selfのi番目に挿入され、$yと$zで分割される
sub split_child {
	my ($self, $i) = @_;
	my $y = $self->{-children}[$i];
	my $t = $self->{-t};

	# $yからキーと子を分割して新しい節点$zを作成
	my $z = BTree::Node->new({-t => $t, -is_leaf => $y->is_leaf()});
	@{$z->{-keys}} = splice(@{$y->{-keys}}, $t);
	if (!$y->is_leaf()) {
		@{$z->{-children}} = splice(@{$y->{-children}}, $t);
	}

	# $zを$selfのi番目の後ろに子として挿入
	splice(@{$self->{-children}}, $i+1, 0, ($z));
	
	# $yの中央にあったキーを、$selfのi番目に挿入
	my $key = pop @{$y->{-keys}};
	splice(@{$self->{-keys}}, $i, 0, ($key));
}

1;
