package SOAP::Defs;
$VERSION = '0.23';
use vars(qw($VERSION));
require Exporter;
@ISA = qw(Exporter);

#
# Numeric constants from the SOAP spec
#
$soap_status_version_mismatch    = 100;
$soap_status_must_understand     = 200;
$soap_status_invalid_request     = 300;
$soap_status_application_faulted = 400;

#
# Strings from the SOAP spec
#
$soap_namespace         = 'urn:schemas-xmlsoap-org:soap.v1';
$soap_envelope          = 'Envelope';
$soap_body              = 'Body';
$soap_header            = 'Header';
$soap_package           = 'Package';
$soap_id                = 'id';
$soap_href              = 'href';
$soap_must_understand   = 'mustUnderstand';
$soap_runcode_yes       = 'Yes';
$soap_runcode_no        = 'No';
$soap_runcode_maybe     = 'Maybe';
$soap_root_with_id      = 'rootWithId';
$soap_true              = '1';
$soap_false             = '0';

#
# Strings from the XML Schema spec
#
$xsd_namespace     = 'http://www.w3.org/1999/XMLSchema/instance';
$xsd_null          = 'null';
$xsd_type          = 'type';
$xsd_string        = 'string';

#
# SOAP/Perl implementation specific constants
#
$soapperl_accessor_type_simple          = 1;
$soapperl_accessor_type_compound        = 2;
$soapperl_accessor_type_array           = 3;
$soapperl_intrusive_hash_key_typeuri    = 'soap_typeuri';
$soapperl_intrusive_hash_key_typename   = 'soap_typename';

my @soap_spec_numerics =
    qw( $soap_status_version_mismatch
        $soap_status_must_understand
        $soap_status_invalid_request
        $soap_status_application_faulted
        );

my @soap_spec_strings =
    qw( $soap_namespace
        $soap_envelope
        $soap_body
        $soap_header
        $soap_package
        $soap_id
        $soap_href
        $soap_must_understand
        $soap_runcode_yes
        $soap_runcode_no
        $soap_runcode_maybe
        $soap_root_with_id
        $soap_true
        $soap_false
        );

my @xsd_spec_strings =
    qw( $xsd_namespace
        $xsd_type
        $xsd_null
        $xsd_string
        );

my @soapperl_constants =
    qw( $soapperl_accessor_type_simple
        $soapperl_accessor_type_compound
        $soapperl_accessor_type_array
        $soapperl_intrusive_hash_key_typeuri
        $soapperl_intrusive_hash_key_typename
        );

@EXPORT =
    ( @soap_spec_numerics,
      @soap_spec_strings,
      @xsd_spec_strings,
      @soapperl_constants,
    );

1;

__END__

=head1 NAME

SOAP::Defs - Spec-defined constants

=head1 SYNOPSIS

    use SOAP::Defs;

=head1 DESCRIPTION

This is an internal class that exports global symbols needed
by various SOAP/Perl classes. You don't need to import this module
directly unless you happen to be building SOAP plumbing (as opposed
to simply writing a SOAP client or server).

=head1 AUTHOR

Keith Brown

=cut
