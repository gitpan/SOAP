##! perl -d
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..3\n"; }
END {print "not ok 1\n" unless $loaded;}
use XML::Parser::Expat;
use SOAP::EnvelopeMaker;
use SOAP::Transport::HTTP::CGI;
use SOAP::Parser;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

use ExtUtils::MakeMaker qw(prompt);

unless (test2()) { print 'not ' }
print "ok test 2\n";


#
# test 2 - try to make a SOAP request to soapl.develop.com
#        
#
sub test2() {
    my $soap_perl_server = 'soapl.develop.com';
    my $test_endpoint = 'http://' . $soap_perl_server . '/soap?class=Geometry';
    print qq[

This test sends a live SOAP call to $soap_perl_server, calculating the area
of a rectangle passed in the request packet. If you're not connected to the
internet, please skip this test.

];
    my $skip_test = ExtUtils::MakeMaker::prompt('Do you want me to skip this test?', 'no');
    return 1 if $skip_test =~ /^\s*y/i;

    print "Testing your connection by pinging $soap_perl_server...\n";

    #
    # first verify that we're connected to the internet
    #
    eval { use Net::Ping; };
    if ($@) {
        print "\n\nCouldn't load the Net::Ping module to test your connection.\n";
        my $skip_test = ExtUtils::MakeMaker::prompt('Do you want me to skip this test?', 'yes');
        return 1 if $skip_test =~ /^\s*y/i;
        print "\nOk, we'll barge on anyway :-)\n";
    }
    else {
        my $icmp = Net::Ping->new('icmp', 5);
        unless ($icmp->ping($soap_perl_server)) {
            print "\n\nCouldn't ping $soap_perl_server, so I'll skip this test.\n";
            return 1;
        }
    }

    print "\nOk, I can ping $soap_perl_server.\n";

    print "\nMaking a SOAP call to $soap_perl_server: calculateArea()...\n";

    eval {
        print "\n\nCalling the CGI version of the server 15 times:\n";
        for (my $i = 0; $i < 15; ++$i) {
            make_call("http://soapl.develop.com/cgi-bin/ServerDemo.pl?class=Geometry");
        }
        print "\n\nCalling the mod_perl version of the server 15 times:\n";
        for ($i = 0; $i < 15; ++$i) {
            make_call("http://soapl.develop.com/soap?class=Geometry");
        }
    };
    if ($@) {
        print $@;
        return;
    }
    print "Success!\n";

    1;
}

sub make_call {
  use SOAP::EnvelopeMaker;

  my ($endpoint)    = @_;
  my $method_uri  = "urn:schemas-develop-com:geometry";
  my $method_name = "calculateArea";

  my $soap_request = '';
  my $output_fcn = sub {
    $soap_request .= shift;
  };
  my $em = SOAP::EnvelopeMaker->new($output_fcn);

  my $body = {
    origin => { x => 10, y => 20 },
    corner => { x => 100, y => 200 },
  };
  my $expected_result = ($body->{corner}{x} - $body->{origin}{x}) *
                        ($body->{corner}{y} - $body->{origin}{y});

  $em->set_body($method_uri, $method_name, 0, $body);

  use SOAP::Transport::HTTP::Client;

  my $soap_on_http = SOAP::Transport::HTTP::Client->new();

  my $soap_response = $soap_on_http->send_receive($endpoint,
                                                $method_uri,
                                                $method_name,
                                                $soap_request);

  use SOAP::Parser;
  my $soap_parser = SOAP::Parser->new();
  $soap_parser->parsestring($soap_response);

  $body = $soap_parser->get_body();

  if (exists $body->{area}) {
    my $area = $body->{area};
    unless ($area == $expected_result) { die "Hmm. My math must be getting bad. I expected to get $expected_result, and instead, got $area" }
    print "The area is: $area\n";
  }
  else {
    my $faultcode   = $body->{faultcode};
    my $faultstring = $body->{faultstring};
    my $runcode     = $body->{runcode};
    my $detail      = $body->{detail};
    
    die <<"END_MSG";
Whoops, something bad happened:
  faultcode   = $faultcode
  faultstring = $faultstring
  runcode     = $runcode
  detail      = $detail
END_MSG
  }
}
