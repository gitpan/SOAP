package SOAP::Transport::HTTP::Client;

use strict;
use vars qw($VERSION);
$VERSION = '0.22';

use SOAP::Defs;
use LWP::UserAgent;
use Carp;

sub new {
    my ($class) = @_;

    my $self = {
        debug_request => 0,
    };
    bless $self, $class;

    $self;
}

sub debug_request {
    my ($self) = @_;
    $self->{debug_request} = 1;
}

sub send_receive {
    my ($self, $endpoint, $method_uri, $method_name, $soap_request) = @_;

    my $ua = LWP::UserAgent->new();
    my $post = HTTP::Request->new('POST', $endpoint, new HTTP::Headers, $soap_request);

    $post->header('SOAPMethodName' => $method_uri . '#' . $method_name);

    if ($self->{debug_request}) {
        $post->header('DebugRequest' => '1');
    }

    #
    # TBD: content-length isn't taking into consideration CRLF translation
    #
    $post->content_type  ('text/xml');
    $post->content_length(length($soap_request));
    
    my $http_response = $ua->request($post);

    my $code = $http_response->code();
    unless (200 == $code) {
        #
        # TBD: need to deal with redirects, M-POST retrys, anything else?
        #
        my $content =$http_response->content();
        croak 'HTTP ' . $post->method() . ' failed: ' . $http_response->code() .
              ' (' . $http_response->message() .
              "), in SOAP method call. Content of response:\n$content";
    }
    my $soap_response = $http_response->content();

    ($code, $http_response->content());
}

1;
__END__

=head1 NAME

SOAP::Transport::HTTP::Client - Client side HTTP support for SOAP/Perl

=head1 SYNOPSIS

    use SOAP::Transport::HTTP::Client;

=head1 DESCRIPTION

Forthcoming...

=head1 DEPENDENCIES

LWP::UserAgent
SOAP::Defs

=head1 AUTHOR

Keith Brown

=head1 SEE ALSO


=cut
