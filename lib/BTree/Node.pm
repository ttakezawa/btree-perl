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

sub _insert_nonfull {
	my ($self, $key) = @_;
	if ($self->is_leaf()) {
		# $self���դΤȤ���Ŭ�ڤʰ��֤˥����Ȥ��������������
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
		my $i = List::Util::first { $key < $self->{-keys}[$_] } (0..scalar(@{$self->{-keys}})-1);
		$i = scalar(@{$self->{-keys}}) unless (defined $i);

		if ($self->{-children}[$i]->_is_full()) {
			$self->split_child($i);
			if ($key > $self->{-keys}[$i]) {
				$i++;
			}
		}
		$self->{-children}[$i]->_insert_nonfull($key);
	}
}

# $self ��i���ܤλ�:$y��ʬ�䤹��
# $y������Υ�������$self��i���ܤ��������졢$y��$z��ʬ�䤵���
sub split_child {
	my ($self, $i) = @_;
	my $y = $self->{-children}[$i];
	my $t = $self->{-t};

	# $y���饭���ȻҤ�ʬ�䤷�ƿ���������$z�����
	my $z = BTree::Node->new({-t => $t});
	$z->{-is_leaf} = $y->is_leaf();
	@{$z->{-keys}} = splice(@{$y->{-keys}}, $t);
	if (!$y->is_leaf()) {
		@{$z->{-children}} = splice(@{$y->{-children}}, $t);
	}

	# $z��$self��i���ܤθ��˻ҤȤ�������
	splice(@{$self->{-children}}, $i+1, 0, ($z));
	
	# $y������ˤ��ä�������$self��i���ܤ�����
	my $key = pop @{$y->{-keys}};
	splice(@{$self->{-keys}}, $i, 0, ($key));
}

1;
