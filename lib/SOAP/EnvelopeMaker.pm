package SOAP::EnvelopeMaker;

use strict;
use vars qw($VERSION);
use SOAP::Defs;
use SOAP::TypeMapper;
use SOAP::Envelope;

$VERSION = '0.22';

sub new {
    my ($class, $print_fcn, $type_mapper) = @_;
    
    $type_mapper ||= SOAP::TypeMapper->defaultMapper();

    my $self = {
        envelope    => undef,
        print_fcn   => $print_fcn,
        type_mapper => $type_mapper,
    };
    bless $self, $class;
}

sub add_header {
    my ($self, $accessor_uri, $accessor_name,
               $must_understand, $is_package,
               $object) = @_;

    my $serializer = $self->{type_mapper}->get_serializer($object);
    my ($typeuri, $typename) = $serializer->get_typeinfo();

    my @namespaces_to_preload;
    push @namespaces_to_preload, $accessor_uri if $accessor_uri;
    push @namespaces_to_preload, $typeuri      if $typeuri;

    my $env = $self->_get_envelope(\@namespaces_to_preload);

    my $stream = $env->header($accessor_uri, $accessor_name,
                              $typeuri, $typename,
                              $must_understand, $is_package, $object);
    if ($stream) {
        $serializer->serialize($stream);
        $stream->term();
    }
}

sub set_body {
    my ($self, $accessor_uri, $accessor_name,
               $is_package, $object) = @_;

    my $serializer = $self->{type_mapper}->get_serializer($object);
    my ($typeuri, $typename) = $serializer->get_typeinfo();

    my @namespaces_to_preload;
    push @namespaces_to_preload, $accessor_uri if $accessor_uri;
    push @namespaces_to_preload, $typeuri      if $typeuri;

    my $env = $self->_get_envelope(\@namespaces_to_preload);

    my $stream = $env->body($accessor_uri, $accessor_name,
                            $typeuri, $typename,
                            $is_package, $object);
    if ($stream) {
        $serializer->serialize($stream);
        $stream->term();
    }
    $env->term();
    $self->{envelope} = undef;
}

sub _get_envelope {
    my ($self, $namespaces_to_preload) = @_;

    if (my $env = $self->{envelope}) {
        return $env;
    }
    my $env = $self->{envelope} = SOAP::Envelope->new($self->{print_fcn},
                                                      $namespaces_to_preload,
                                                      $self->{type_mapper});
}

1;
__END__

=head1 NAME

SOAP::EnvelopeMaker - Creates SOAP envelopes

=head1 SYNOPSIS

use SOAP::EnvelopeMaker;

my $soap_request = '';
my $output_fcn = sub {
    $soap_request .= shift;
};
my $em = SOAP::EnvelopeMaker->new($output_fcn);

my $body = {
    origin => { x => 10, y => 20 },
    corner => { x => 100, y => 200 },
};

$em->set_body("urn:com-develop-geometry", "calculateArea", 0, $body);

my $endpoint    = "http://soapl.develop.com/soap?class=Geometry";
my $method_uri  = "urn:com-develop-geometry";
my $method_name = "calculateArea";

use SOAP::Transport::HTTP::Client;

my $soap_on_http = SOAP::Transport::HTTP::Client->new();

my $soap_response = $soap_on_http->send_receive($endpoint,
                                                $method_uri,
                                                $method_name,
                                                $soap_request);
use SOAP::Parser;
my $soap_parser = SOAP::Parser->new();
$soap_parser->parse($soap_response);

my $area = $soap_parser->get_body()->{area};

print "The area is: $area\n";

=head1 DESCRIPTION

=head1 DEPENDENCIES

SOAP::Envelope

=head1 AUTHOR

Keith Brown

=head1 SEE ALSO

SOAP::Envelope

=cut
