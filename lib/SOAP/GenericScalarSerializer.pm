package SOAP::GenericScalarSerializer;

use strict;
use vars qw($VERSION);
use SOAP::Defs;

$VERSION = '0.23';

sub new {
    my ($class, $scalar) = @_;
    
    my $self = \$scalar;
    bless $self, $class;
}

sub get_typeinfo {
    (undef, undef);
}

sub is_package {
    0;
}

sub get_accessor_type {
    $soapperl_accessor_type_simple;
}

sub serialize_as_string {
    my $self = shift;
    $$self;
}

1;
__END__


=head1 NAME

SOAP::GenericScalarSerializer - Generic serializer for Perl scalar references

=head1 SYNOPSIS

Forthcoming

=head1 DESCRIPTION

Forthcoming

=head1 AUTHOR

Keith Brown

=cut
