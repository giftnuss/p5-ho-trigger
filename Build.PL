use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'HO::Trigger',
    license             => 'perl',
    dist_abstract => 'Triggers for hierarchical objects',
    dist_author         => 'Sebastian Knapp <rock@ccls-online.de>',
    dist_version        => '0.00005',
    requires => {
        'perl' => '5.008',
        'HO::class' => 0.05
    },
    build_requires => {
        'Test::More' => 0,
        'Test::UseAllModules' => '0.12'
    },
    add_to_cleanup      => [ 'HO-Trigger-*' ],
    create_makefile_pl  => 'traditional',
    meta_add => {
        resources => {
            repository => 'git://github.com/giftnuss/p5-ho-trigger.git',
            homepage => 'http://github.com/giftnuss/p5-ho-trigger/tree/master'
        }
    }
);

$builder->create_build_script();
