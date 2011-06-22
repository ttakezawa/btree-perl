#!/usr/bin/env perl
use strict;
use warnings;

use Test::More tests => 6;
use BTree::Node;

my $order = 2; # means `2-3-4 tree`
my $node = BTree::Node->new({-t => $order, -is_leaf => 1});
isa_ok($node, "BTree::Node");

is($node->{-t}, $order);
is_deeply($node->{-keys}, []);
is_deeply($node->{-children}, []);

is($node->length(), 0);
is($node->is_leaf(), 1);

# test cnt: 6
