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
    context "CUANDO ejecuto un comando nombre con sexo masculino" => sub {
      my $persona = Saga->despachar('Persona')->new;
      Saga->despachar('Comando::Agregar::Nacimiento')->new->ejecutar(persona => $persona);
      Saga->despachar('Comando::Agregar::Sexo')->new->ejecutar(persona => $persona, sexo => 'm');
      my $comando = Saga->despachar('Comando::Agregar::Nombre')->new;
      $comando->ejecutar(persona => $persona);
      it "ENTONCES debo tener un nombre" => sub {
        ok $persona->nombre->valor;
      };
    };
    context "CUANDO ejecuto un comando nombre con sexo masculino" => sub {
      my $persona = Saga->despachar('Persona')->new;
      Saga->despachar('Comando::Agregar::Nacimiento')->new->ejecutar(persona => $persona);
      Saga->despachar('Comando::Agregar::Sexo')->new->ejecutar(persona => $persona, sexo => 'f');
      my $comando = Saga->despachar('Comando::Agregar::Nombre')->new;
      $comando->ejecutar(persona => $persona);
      it "ENTONCES debo tener un nombre" => sub {
        ok $persona->nombre->valor;
      };
    };
    context "CUANDO ejecuto un comando nombre con un nombre definido" => sub {
      my $persona = Saga->despachar('Persona')->new;
      Saga->despachar('Comando::Agregar::Nacimiento')->new->ejecutar(persona => $persona);
      Saga->despachar('Comando::Agregar::Sexo')->new->ejecutar(persona => $persona, sexo => 'f');
      my $comando = Saga->despachar('Comando::Agregar::Nombre')->new;
      $comando->ejecutar(persona => $persona, nombre => 'Maria');
      it "ENTONCES debo tener un nombre" => sub {
        is $persona->nombre->valor, 'Maria';
      };
    };
  };
};