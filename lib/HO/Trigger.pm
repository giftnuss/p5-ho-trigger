package HO::Trigger;
#********************
$VERSION = "0.01";
#*****************
use strict; use warnings;

use Carp;

; my $loaded # flag to store accessor only one time

; my (%TriggerPoints,%TriggerObjects)

; my $enable_trigger = sub
    { $HO::accessor::type{'trigger'} = sub 
        { my ($self,$args) = @_
        ; my $hookedclass = ref $self
        ; my $trigger

        ; if(defined(my $hr = $TriggerPoints{$hookedclass}))
            { if($TriggerObjects{$hookedclass})
                { $trigger = $TriggerObjects{$hookedclass}
                }
              else
                { $trigger = $TriggerObjects{$hookedclass} 
                           = __PACKAGE__->new($self)
                }
            ; my @hooks = @$hr
            ; my $idx = @{$trigger}
            ; no strict 'refs'
            ; foreach my $hook (@hooks)
                { my $hookidx = $idx++
                ; $trigger->[$hookidx] = []
                ; *{"${hookedclass}::_${hook}"} = sub { $hookidx }
                ; *{"${hookedclass}::${hook}"} = hook_method($trigger->[$hookidx])
                }
            ; return $trigger
            }
          else
            { Carp::croak("Trigger object used, but no hooks found for class $hookedclass.")
            }
        }
    ; $HO::accessor::rw_accessor{'trigger'} = sub
        { my ($name,$idx) = @_
        ; return sub 
             { my ($hooked,@args) = @_
             ; my $trigger = $hooked->[$idx]
             ; $hooked->[$idx]
             }
        }
    }

; sub import 
    { my $class = shift;
    ; my $pkg = caller(0);

    ; unless($loaded)
        { $enable_trigger->();
        ; $loaded = 1
        }
    ; $TriggerPoints{$pkg} = [ @_ ] if @_
    }

; sub hook_method
    { my ($triggers) = @_
    ; sub
        { my ($hookedobject,@args) = @_
        ; my @errors
        ; foreach my $call (@$triggers)
            { if($call->[1])
                { $call->[0]->($hookedobject,@args)
                }
              else
                { eval { $call->[0]->($hookedobject,@args) }
                ; push @errors,$@ if $@
                }
            }
        ; return @errors
        }
    }

###############################################################################
; use subs qw/init/

; use HO::class
     _ro => _hooked_object => '$'

; sub init
    { my ($self,$hooked) = @_
    ; $self->[__hooked_object] = $hooked
    ; my $hookedclass = ref $hooked
    ; $self
    }

; sub add_trigger
    { my $self = shift;
    ; my %args
    ; if(@_ == 2)
        { $args{'name'} = $_[0]
        ; $args{'callback'} = $_[1]
        }
      else
        { %args = ( name => undef, callback => undef, abortable => undef, @_ );
        }

    ; my $hook = $args{'name'};
    ; unless(grep { $_ eq $hook } @{$TriggerPoints{ref $self->_hooked_object}})
        { Carp::carp("Adding to a not declared hook '$hook' is ignored.")
        ; return
        }
    ; unless(ref $args{'callback'}) # how about &{} overload
        { Carp::croak("Invalid callback not added.") 
        }
    ; $args{'abortable'} = 1 unless defined $args{'abortable'}

    ; my $triggerstore = "_$hook"
    ; push @{ $self->[$self->_hooked_object->$triggerstore] }, [ $args{'callback'}, $args{'abortable'} ];
    ; $self
    }

; 1

__END__

=head1 NAME

HO::Trigger

=head1 VERSION

0.01

=head1 SYNOPSIS

   package NewsBee;
   use HO::Trigger qw/foo bar/;

   use HO::class _rw => trigger => 'trigger';

   package main;
   my $bee = new NewsBee:: ;

   $bee->trigger->add_trigger('foo',sub { print "push the button\n" });
   $bee->foo;
   $bee->bar;

=head1 DESCRIPTION

This is a port of Class::Trigger for the HO framework. A HO::class is able to contain
a trigger object. The hook names have to be defined with C<use HO::Trigger qw/hooks .../>
before the class composition. Until now the C<_rw> accessor is used for
trigger objects.

=head1 TODO

I'm not able to let Carp::Clan working for me.

Das hier richtig zu machen ist eine umfangreichere Aufgabe als gesdacht.
Daher ist auch nur eine sehr einfache Lösung implementiert.

=head1 SEE ALSO

L<Class::Trigger> by Tatsuhiko Miyagawa

=head1 AUTHOR

Sebastian Knapp, E<lt>rock@ccls-online.deE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Sebastian Knapp.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut


