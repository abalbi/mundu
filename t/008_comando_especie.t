use strict;
use lib 'lib';
use Test::More qw(no_plan);
use Test::More::Behaviour;
use Test::Deep;
use Data::Dumper;

use Saga;

#cover -delete; PERL5OPT=-MDevel::Cover=+inc,/Volumes/UFS prove -v -I../lib "$@" && cover

describe "Como desarrollador quiero que mis personas tengan nombre" => sub {
  context "DADA una persona" => sub {
    context "CUANDO ejecuto un comando especie" => sub {
      my $persona = Saga->despachar('Persona')->new;
      Saga->despachar('Comando::Agregar::Nacimiento')->new->ejecutar(persona => $persona);
      my $comando = Saga->despachar('Comando::Agregar::Especie')->new;
      $comando->ejecutar(persona => $persona);
      it "ENTONCES debo tener un nombre" => sub {
        is $persona->especie->valor, 'humano';
        ok $persona->es('humano');
      };
    };
  };
};