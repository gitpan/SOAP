package SOAP::GenericHashSerializer;

use strict;
use vars qw($VERSION);
use SOAP::Defs;

$VERSION = '0.22';

sub new {
    my ($class, $hash) = @_;
    
    my $self = {
        hash => $hash,
    };
    bless $self, $class;
}

my $g_intrusive_hash_keys = {
    $soapperl_intrusive_hash_key_typeuri  => undef,
    $soapperl_intrusive_hash_key_typename => undef,
};

sub serialize {
    my ($self, $stream) = @_;

    my $hash = $self->{hash};

    while (my ($k, $v) = each %$hash) {
        next if exists $g_intrusive_hash_keys->{$k};
        if (ref $v) {
            $stream->reference_accessor(undef, $k, $v);
        }
        else {
            $stream->simple_accessor(undef, $k, undef, undef, $v);
        }
    }
}

sub get_typeinfo {
    my $self = shift;
    my $hash = $self->{hash};

    my $typeuri  = exists $hash->{$soapperl_intrusive_hash_key_typeuri} ?
                          $hash->{$soapperl_intrusive_hash_key_typeuri} : undef;

    my $typename = exists $hash->{$soapperl_intrusive_hash_key_typename} ?
                          $hash->{$soapperl_intrusive_hash_key_typename} : undef;

    ($typeuri, $typename);
}

sub is_package {
    0;
}

sub get_accessor_type {
    $soapperl_accessor_type_compound;
}

1;
__END__


=head1 NAME

SOAP::GenericHashSerializer - Generic serializer for Perl hashes

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 AUTHOR

Keith Brown

=cut
