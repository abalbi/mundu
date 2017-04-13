use strict;
use lib 'lib';
use Test::More qw(no_plan);
use Test::More::Behaviour;
use Test::Deep;
use Data::Dumper;

use Saga;

#cover -delete; PERL5OPT=-MDevel::Cover=+inc,/Volumes/UFS prove -v -I../lib "$@" && cover

describe "Como desarrollador quiero que mis personas tengan generacion  " => sub {
  context "DADA una persona" => sub {
    context "CUANDO ejecuto un comando generacion" => sub {
      my $persona = Saga->despachar('Persona')->new;
      Saga->despachar('Comando::Agregar::Nacimiento')->new->ejecutar(persona => $persona);
      my $comando = Saga->despachar('Comando::Agregar::Generacion')->new;
      $comando->ejecutar(persona => $persona);
      it "ENTONCES debo tener un vampire con generacion" => sub {
        ok $persona->generacion;
        ok $persona->generacion->valor;
      };
    };
    context "CUANDO ejecuto un comando generacion con valor de generacion" => sub {
      my $persona = Saga->despachar('Persona')->new;
      Saga->despachar('Comando::Agregar::Nacimiento')->new->ejecutar(persona => $persona);
      my $comando = Saga->despachar('Comando::Agregar::Generacion')->new;
      $comando->ejecutar(persona => $persona, generacion => 7);
      it "ENTONCES debo tener un vampire con generacion 7" => sub {
        is $persona->generacion->valor, 7;
      };
    };
  };
  context "CUANDO ejecuto calcula_generacion" => sub {
    my $comando = Saga->despachar('Comando::Agregar::Generacion')->new;
    it "ENTONCES debo rebicir un clan" => sub {
      is $comando->calcula_generacion(10), 13;
      is $comando->calcula_generacion(20), 12;
      is $comando->calcula_generacion(30), 11;
      is $comando->calcula_generacion(45), 10;
      is $comando->calcula_generacion(60), 9;
      is $comando->calcula_generacion(80), 8;
      is $comando->calcula_generacion(90), 7;
    };
  };
};