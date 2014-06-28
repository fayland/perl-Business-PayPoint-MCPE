package Business::PayPoint::MCPE;

use strict;
use 5.008_005;
our $VERSION = '0.01';

use LWP::UserAgent;
use Carp 'croak';

sub new {
    my $class = shift;
    my %args  = @_ % 2 ? %{$_[0]} : @_;

    $args{InstID} or croak "InstID is required.";

    $args{TestMode} ||= 0;
    $args{ua} ||= LWP::UserAgent->new();

    $args{POST_URL} ||= 'https://secure.metacharge.com/mcpe/corporate';
    $args{APIVersion} ||= '1.3';

    bless \%args, $class;
}

sub payment {
    my $self = shift;
    my %args = @_ % 2 ? %{$_[0]} : @_;

    $self->request(
        %args,
        TransType  => 'PAYMENT',
    );
}

sub request {
    my $self = shift;
    my %params = @_ % 2 ? %{$_[0]} : @_;

    my @intFields = ('TestMode', 'InstID', 'TransID', 'AccountID', 'AuthMode', 'CountryIP', 'AVS', 'Status', 'Time', 'CV2', 'Reference', 'Recurs', 'CancelAfter', 'ScheduleID');
    my @fltFields = ('APIVersion', 'Amount', 'OriginalAmount', 'SchAmount', 'FraudScore');
    my @datFields = ('Fulfillment');

    $params{TestMode}   ||= $self->{TestMode};
    $params{InstID}     ||= $self->{InstID};
    $params{APIVersion} ||= $self->{APIVersion};

    my %r;
    foreach my $key (keys %params) {
        if ($key =~ /^(int|flt|str|dat)/) {
            $r{$key} = $params{$key};
        } elsif (grep { $_ eq $key } @intFields) {
            $r{'int' . $key} = $params{$key};
        } elsif (grep { $_ eq $key } @fltFields) {
            $r{'flt' . $key} = $params{$key};
        } elsif (grep { $_ eq $key } @fltFields) {
            $r{'dat' . $key} = $params{$key};
        } else {
            $r{'str' . $key} = $params{$key};
        }
    }

    my $resp = $self->{ua}->post($self->{POST_URL}, \%r);
    use Data::Dumper; print STDERR Dumper(\$resp);
    unless ($resp->is_success) {
        return { error => $resp->status_line };
    }
}

1;
__END__

=encoding utf-8

=head1 NAME

Business::PayPoint::MCPE - Blah blah blah

=head1 SYNOPSIS

  use Business::PayPoint::MCPE;

=head1 DESCRIPTION

Business::PayPoint::MCPE is

=head1 AUTHOR

Fayland Lam E<lt>fayland@gmail.comE<gt>

=head1 COPYRIGHT

Copyright 2014- Fayland Lam

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
