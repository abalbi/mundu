use strict;
use lib 'lib';
use Test::More qw(no_plan);
use Test::More::Behaviour;
use Test::Deep;
use Data::Dumper;

use Saga;
Saga->cargar('WhiteWolf');

#cover -delete; PERL5OPT=-MDevel::Cover=+inc,/Volumes/UFS prove -v -I../lib "$@" && cover

describe "Como desarrollador quiero que mis personas tengan willpower" => sub {
  context "DADA una persona" => sub {
    context "CUANDO ejecuto un comando willpower" => sub {
      my $persona = Saga->despachar('Persona')->new;
      Saga->despachar('Comando::Conceptos::Nacimiento')->new->ejecutar(persona => $persona);
      my $comando = Saga->despachar('Comando::Estadisticas::Willpower')->new;
      $comando->ejecutar(persona => $persona);
      it "ENTONCES debo tener un vampire con willpower" => sub {
        ok $persona->willpower;
        ok $persona->willpower->valor;
      };
    };
    context "CUANDO ejecuto un comando willpower con valor de willpower" => sub {
      my $persona = Saga->despachar('Persona')->new;
      Saga->despachar('Comando::Conceptos::Nacimiento')->new->ejecutar(persona => $persona);
      my $comando = Saga->despachar('Comando::Estadisticas::Willpower')->new;
      $comando->ejecutar(persona => $persona, willpower => 7);
      it "ENTONCES debo tener un vampire con willpower 7" => sub {
        is $persona->willpower->valor, 7;
      };
    };
    context "CUANDO ejecuto un comando humanity con valor de courage" => sub {
      my $persona = Saga->despachar('Persona')->new;
      Saga->despachar('Comando::Conceptos::Nacimiento')->new->ejecutar(persona => $persona);
      Saga->despachar('Comando::Estadisticas::Virtue')->new->ejecutar(persona => $persona, puntos => 7);
      my $comando = Saga->despachar('Comando::Estadisticas::Willpower')->new;
      $comando->ejecutar(persona => $persona);
      it "ENTONCES debo tener un vampire con humanity igual a la suma de courage " => sub {
        is $persona->willpower->valor, $persona->courage->valor;
      };
    };
  };
};