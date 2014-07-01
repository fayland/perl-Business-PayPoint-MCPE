#!/usr/bin/perl

use strict;
use warnings;
use FindBin qw/$Bin/;
use lib "$Bin/../lib";
use Business::PayPoint::MCPE;
use Data::Dumper;

my $bpm = Business::PayPoint::MCPE->new(
    TestMode => 1,
    InstID => '258210',
);

my $data = $bpm->payment(
    CartID => 654321,
    Desc   => 'description of goods',
    Amount => '10.00',
    Currency => 'GBP',
    CardHolder => 'Joe Bloggs',
    Postcode   => 'BA12BU',
    Email      => 'test@paypoint.net',
    CardNumber => '1234123412341234',
    CV2        => '707',
    ExpiryDate => '0616',
    CardType   => 'VISA',
    Country    => 'GB',
);
print Dumper(\$data);

1;