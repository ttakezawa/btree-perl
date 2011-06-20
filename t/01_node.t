#!/usr/bin/env perl
use strict;
use warnings;

use Test::More tests => 15;
use BTree::Node;

my $order = 2; # means `2-3-4 tree`
my $node = BTree::Node->new({-t => $order});
isa_ok($node, "BTree::Node");

is($node->{-t}, $order);
is_deeply($node->{-keys}, []);
is_deeply($node->{-children}, []);

is($node->length(), 0);
is($node->is_leaf(), 1);

# test cnt: 6


my $keys = $node->{-keys};
$node->insert(5);
is_deeply($keys, [5],       "insert 1st: 5");
$node->insert(8);
is_deeply($keys, [5,8],     "insert 2nd: 8");
$node->insert(1);
is_deeply($keys, [1,5,8],   "insert 3rd: 1");

# test cnt: 9


$node->insert(7); # splits the node
is_deeply($keys, [5]);
is_deeply(scalar(@{$node->{-children}}), 2);

my $left_child = $node->{-children}[0];
isa_ok($left_child, "BTree::Node");
my $right_child = $node->{-children}[1];
isa_ok($right_child, "BTree::Node");

is_deeply($left_child->{-keys}, [1]);
is_deeply($right_child->{-keys}, [7,8]);

# test cnt: 15
