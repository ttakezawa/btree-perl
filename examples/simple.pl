#!/usr/bin/env perl
use strict;
use warnings;
use lib 'lib';
use BTree;
my $btree = BTree->new({-t => 2});
$btree->insert(5);
$btree->insert(8);
$btree->insert(1);
$btree->insert(7);

print $btree->keys_to_json(), "\n";
