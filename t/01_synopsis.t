use strict; use warnings;
use Test::More;

plan skip_all => "Only working with perl 5.8." if $] < 5.008;

plan tests => 2;

   package NewsBee;
   use HO::Trigger qw/foo bar/;

   use HO::class _rw => trigger => 'trigger';

   package main;
   my $bee = new NewsBee:: ;

   my ($fh,$output);
   ok(open($fh,'>',\$output),'open fh');

   $bee->trigger->add_trigger('foo',sub { print $fh "push the button\n" });
   $bee->foo;
   $bee->bar;

   is($output,"push the button\n");