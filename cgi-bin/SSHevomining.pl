#!/usr/bin/perl
use strict;

my $yourgenomes=$ARGV[0]; 
my $yourRAST=$ARGV[1]; 
my $yourcentral=$ARGV[2];

print "startEvoMining.pl  -g $yourgenomes -r $yourRAST -c $yourcentral \n";
system "startEvoMining.pl  -g $yourgenomes -r $yourRAST -c $yourcentral\n";
