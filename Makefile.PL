use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'HO::Trigger',
    AUTHOR        => 'Sebastian Knapp <rock@ccls-online.de>',
    VERSION_FROM  => 'lib/HO/Trigger.pm',
    ABSTRACT_FROM => 'lib/HO/Trigger.pm',
    PREREQ_PM => {
        'Test::More'          => '0.47',
        'Test::UseAllModules' => '0.10',
    },
    ($ExtUtils::MakeMaker::VERSION >= 6.31
        ? ( LICENSE => 'perl' )
        : ()
    ),
);
