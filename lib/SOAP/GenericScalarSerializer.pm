package SOAP::GenericScalarSerializer;

use strict;
use vars qw($VERSION);
use SOAP::Defs;

$VERSION = '0.22';

sub new {
    my ($class, $scalar_ref) = @_;
    
    my $self = {
        scalar => $$scalar_ref,
    };
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
    $self->{scalar};
}

1;
__END__


=head1 NAME

SOAP::GenericScalarSerializer - Generic serializer for Perl scalar references

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 AUTHOR

Keith Brown

=cut
