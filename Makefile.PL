use 5.010;
use strict;
use warnings;
use ExtUtils::MakeMaker;

my %parms = (
    NAME                => 'silent-cron',
    AUTHOR              => 'Moritz Lenz <moritz.lenz@noris.de>',
    ABSTRACT            => 'A wrapper to silence jobs that occasionally fail',
    VERSION_FROM        => 'bin/silent-cron',
    EXE_FILES           => [ 'bin/silent-cron'],
    MIN_PERL_VERSION    => 5.014,
    PREREQ_PM => {
        'IPC::Run'              => 0,
        'DBI'                   => 0,
        'DBD::SQLite'           => 0,
        'Moo'                   => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'nytprof*' },
);

if ( $ExtUtils::MakeMaker::VERSION =~ /^\d\.\d\d$/ and $ExtUtils::MakeMaker::VERSION > 6.30 ) {
    $parms{LICENSE} = 'gpl_3';
}

WriteMakefile( %parms );

