#!/usr/bin/env perl
use strict;
use warnings;

use Test::More tests => 12;
use BTree;

my $btree = BTree->new({-t => 2}); # means `2-3-4 tree`
isa_ok($btree, "BTree");

# test cnt: 1


my $keys = $btree->{-root}{-keys};
$btree->insert(5);
is_deeply($keys, [5],       "insert 1st: 5");
$btree->insert(8);
is_deeply($keys, [5,8],     "insert 2nd: 8");
$btree->insert(1);
is_deeply($keys, [1,5,8],   "insert 3rd: 1");

# test cnt: 3


$btree->insert(7); # splits the root node
is_deeply($btree->{-root}{-keys}, [5]);
is_deeply(scalar(@{$btree->{-root}{-children}}), 2);

isa_ok($btree->{-root}{-children}[0], "BTree::Node");
isa_ok($btree->{-root}{-children}[1], "BTree::Node");

is_deeply($btree->{-root}{-children}[0]->nested_keys(), [1]);
is_deeply($btree->{-root}{-children}[1]->nested_keys(), [7,8]);

is_deeply($btree->keys(), [[1],5,[7,8]]);

# test cnt: 7


### use case (see. http://www.cs.xu.edu/csci220/97f/hw3solns.html )
{
	my @values = qw(F S Q K C L H T V W M R N P A B X Y D Z E);
	my $expected_val = [[["A","B"],"C",["D","E","F","H"],"K",["L","M"]],"N",[["P","Q","R"],"S",["T","V"],"W",["X","Y","Z"]]];

	my $btree = BTree->new({-t => 3});
	my @keys = map ord($_), @values;
	for (@keys) { $btree->insert($_); }
	my $got_val = $btree->keys();

	sub deep_map(&$) {
		my ($code,$ary) = @_;
		my @rt = map { (ref($_) eq "ARRAY") ? deep_map($code,$_) : $code->($_) } @$ary;
		\@rt;
	}
	is_deeply(deep_map(sub{chr($_)}, $got_val), $expected_val);

	# test cnt: 1
}
