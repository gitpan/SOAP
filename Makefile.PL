use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'SOAP',
    'VERSION_FROM' => 'lib/SOAP/Defs.pm', # finds $VERSION
);
