use strict;
use warnings;
use inc::Module::Install;

name           'BTree';
all_from       'lib/BTree.pm';

test_requires  'Test::More';

WriteAll;
