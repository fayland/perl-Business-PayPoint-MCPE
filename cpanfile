requires 'perl', '5.008005';

# requires 'Some::Module', 'VERSION';

requires 'LWP::UserAgent';
requires 'LWP::Protocol::https';
requires 'URI::Escape';

on test => sub {
    requires 'Test::More', '0.96';
};
