
use strict;
use lib 'lib';
use Test::More qw(no_plan);
use Test::More::Behaviour;
use Test::Deep;
use Data::Dumper;

use Saga;

#cover -delete; PERL5OPT=-MDevel::Cover=+inc,/Volumes/UFS prove -v -I../lib "$@" && cover

describe "Como desarrollador quiero que mis personas tengan sexo" => sub {
  context "DADA una persona" => sub {
    context "CUANDO ejecuto un comando sexo" => sub {
      my $persona = Saga->despachar('Persona')->new;
      Saga->despachar('Comando::Conceptos::Nacimiento')->new->ejecutar(persona => $persona);
      my $comando = Saga->despachar('Comando::Conceptos::Sexo')->new;
      $comando->ejecutar(persona => $persona);
      it "ENTONCES debo tener una situacion con la persona como sujeto" => sub {
        ok $persona->sexo->valor;
      };
    };
    context "CUANDO ejecuto un comando sexo dando un sexo" => sub {
      my $persona = Saga->despachar('Persona')->new;
      Saga->despachar('Comando::Conceptos::Nacimiento')->new->ejecutar(persona => $persona);
      my $comando = Saga->despachar('Comando::Conceptos::Sexo')->new;
      $comando->ejecutar(persona => $persona, sexo => 'f');
      it "ENTONCES debo tener una situacion con la persona como sujeto" => sub {
        is $persona->sexo->valor, 'f';
      };
    };
    context "CUANDO ejecuto un comando sexo sin nacimiento" => sub {
      my $persona = Saga->despachar('Persona')->new;
      my $comando = Saga->despachar('Comando::Conceptos::Sexo')->new;
      it "ENTONCES debo tener una situacion con la persona como sujeto" => sub {
        eval {$comando->ejecutar(persona => $persona)};
        like $@, qr/No se encontro Persona::fecha_nacimiento en fecha 1990-01-01T00:00:00/;
      };
    };
  };
};