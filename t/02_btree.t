#!/usr/bin/env perl
use strict;
use warnings;

use Test::More tests => 1;
use BTree;

my $node = BTree->new(); # {-t => 5};
isa_ok($node, "BTree");
