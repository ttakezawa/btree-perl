#!/usr/bin/env perl
use strict;
use warnings;
use lib 'lib';
use BTree;
my $btree = BTree->new();

use BTree::Node;
my $node = BTree::Node->new({-t => 2});
$node->insert(5);
$node->insert(8);
$node->insert(1);
$node->insert(7);
