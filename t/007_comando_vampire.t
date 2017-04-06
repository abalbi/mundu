use strict;
use lib 'lib';
use Test::More qw(no_plan);
use Test::More::Behaviour;
use Test::Deep;
use Data::Dumper;

use Saga;

#cover -delete; PERL5OPT=-MDevel::Cover=+inc,/Volumes/UFS prove -v -I../lib "$@" && cover

describe "Como desarrollador quiero fabricar personas" => sub {
  context "CUANDO ejecuto un comando persona" => sub {
    my $comando = Saga->despachar('Comando::Vampire')->new;
    my $persona = $comando->ejecutar;
    it "ENTONCES debo tener una persona" => sub {
      is $persona->especie->valor, 'vampire';
      ok $persona->es('vampire');
      ok $persona->abrazo->valor;
      ok $persona->antiguedad->valor;
    };
  };
  context "CUANDO ejecuto un comando persona" => sub {
    my $fecha = Saga->dt(Saga->entorno->fecha_actual)->subtract(years => 2);
    my $comando = Saga->despachar('Comando::Vampire')->new;
    my $persona = $comando->ejecutar(fecha => $fecha);
    it "ENTONCES debo tener una persona" => sub {
      is $persona->especie->valor, 'vampire';
      ok $persona->es('vampire');
      is $persona->abrazo->valor, $fecha;
      is $persona->antiguedad->valor, 2;
    };
  };
  context "CUANDO ejecuto un comando persona" => sub {
    my $fecha = Saga->dt(Saga->entorno->fecha_actual)->subtract(years => 3);
    my $comando = Saga->despachar('Comando::Vampire')->new;
    my $persona = $comando->ejecutar(antiguedad => 3);
    it "ENTONCES debo tener una persona" => sub {
      is $persona->especie->valor, 'vampire';
      ok $persona->es('vampire');
      is $persona->abrazo->valor, $fecha;
      is $persona->antiguedad->valor, 3;
    };
  };
  context "CUANDO ejecuto un comando persona" => sub {
    my $comando = Saga->despachar('Comando::Vampire')->new;
    it "ENTONCES debo tener una persona" => sub {
      eval {my $persona = $comando->ejecutar(antiguedad => 'MAL')};
      like $@, qr/El param antiguedad no esta correctamente definifo: MAL/;
    };
  };
};