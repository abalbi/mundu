use strict;
use lib 'lib';
use Test::More qw(no_plan);
use Test::More::Behaviour;
use Test::Deep;
use Data::Dumper;

use Saga;
Saga->cargar('WhiteWolf');
#cover -delete; PERL5OPT=-MDevel::Cover=+inc,/Volumes/UFS prove -v -I../lib "$@" && cover

describe "Como desarrollador quiero fabricar vampiros" => sub {
  my $persona = Saga->despachar('Fabrica::Vampire')->hacer;
  context "CUANDO ejecuto un comando vampiro" => sub {
    it "ENTONCES debo tener una vampiro" => sub {
      is $persona->sum('attribute'), 7 + 5 + 3 + 9;
      is $persona->sum('ability'), 13 + 9 + 5;
      is $persona->sum('background'), 5;
      is $persona->sum('virtue'), 7 + 3;
      is $persona->willpower->valor, $persona->courage->valor;
      is $persona->humanity->valor, $persona->self_control->valor + $persona->conscience->valor;
    };
  };
};