use strict;
use lib 'lib';
use Test::More qw(no_plan);
use Test::More::Behaviour;
use Test::Deep;
use Data::Dumper;

use Saga;
Saga->cargar('WhiteWolf');

#cover -delete; PERL5OPT=-MDevel::Cover=+inc,/Volumes/UFS prove -v -I../lib "$@" && cover

describe "Como desarrollador quiero que mis personas tengan humanity" => sub {
  context "DADA una persona" => sub {
    context "CUANDO ejecuto un comando humanity" => sub {
      my $persona = Saga->despachar('Persona')->new;
      Saga->despachar('Comando::Conceptos::Nacimiento')->new->ejecutar(persona => $persona);
      my $comando = Saga->despachar('Comando::Estadisticas::Humanity')->new;
      $comando->ejecutar(persona => $persona);
      it "ENTONCES debo tener un vampire con humanity" => sub {
        ok $persona->humanity;
        ok $persona->humanity->valor;
      };
    };
    context "CUANDO ejecuto un comando humanity con valor de humanity" => sub {
      my $persona = Saga->despachar('Persona')->new;
      Saga->despachar('Comando::Conceptos::Nacimiento')->new->ejecutar(persona => $persona);
      my $comando = Saga->despachar('Comando::Estadisticas::Humanity')->new;
      $comando->ejecutar(persona => $persona, humanity => 7);
      it "ENTONCES debo tener un vampire con humanity 7" => sub {
        is $persona->humanity->valor, 7;
      };
    };
    context "CUANDO ejecuto un comando humanity con valor de self control y conscience" => sub {
      my $persona = Saga->despachar('Persona')->new;
      Saga->despachar('Comando::Conceptos::Nacimiento')->new->ejecutar(persona => $persona);
      Saga->despachar('Comando::Estadisticas::Virtue')->new->ejecutar(persona => $persona, puntos => 7);
      my $comando = Saga->despachar('Comando::Estadisticas::Humanity')->new;
      $comando->ejecutar(persona => $persona);
      it "ENTONCES debo tener un vampire con humanity igual a la suma de self control y conscience " => sub {
        is $persona->humanity->valor, $persona->self_control->valor + $persona->conscience->valor;
      };
    };
  };
};