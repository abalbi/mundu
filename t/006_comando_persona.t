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
    my $comando = Saga->despachar('Comando::Persona')->new;
    my $persona = $comando->ejecutar;
    it "ENTONCES debo tener una persona" => sub {
      ok $persona->nombre->valor;
      ok $persona->sexo->valor;
      ok $persona->fecha_nacimiento->valor;
      ok $persona->edad->valor;
      my $descripcion = $persona->describir;
      like $descripcion, qr/\w+,\d+,\w/;
      my $nacimiento = $persona->fecha_nacimiento->valor;
      is scalar(grep {$nacimiento eq $_} @{Saga->entorno->items}), 1;
      is scalar(grep {$persona eq $_} @{Saga->entorno->items}), 1;
    };
  };
  context "CUANDO ejecuto un comando persona" => sub {
    my $comando = Saga->despachar('Comando::Persona')->new;
    my $persona = $comando->ejecutar(edad => 27);
    it "ENTONCES debo tener una persona" => sub {
      ok $persona->nombre->valor;
      ok $persona->sexo->valor;
      ok $persona->fecha_nacimiento->valor;
      is $persona->edad->valor, 27;
      my $descripcion = $persona->describir;
      like $descripcion, qr/\w+,\d+,\w/;
    };
  };
};