use strict;
use lib 'lib';
use Test::More qw(no_plan);
use Test::More::Behaviour;
use Test::Deep;
use Data::Dumper;

use Saga;
Saga->cargar('WhiteWolf');

#cover -delete; PERL5OPT=-MDevel::Cover=+inc,/Volumes/UFS prove -v -I../lib "$@" && cover

describe "Como desarrollador quiero que mis personas tengan atributos" => sub {
  context "DADA una persona" => sub {
    context "CUANDO ejecuto un comando atributos physical" => sub {
      my $persona = Saga->despachar('Persona')->new;
      my $comando = Saga->despachar('Comando::Estadisticas::Physical')->new;
      $comando->ejecutar( persona => $persona, physical => 7 );
      it "ENTONCES debo tener una persona con atributos" => sub {
        ok $persona->strength;
        ok $persona->dexterity;
        ok $persona->stamina;
        is(Saga->sum($persona->hash(qw(strength dexterity stamina))), 10);
      };
    };
    context "CUANDO ejecuto un comando atributos physical con un atributo asignado" => sub {
      my $persona = Saga->despachar('Persona')->new;
      my $comando = Saga->despachar('Comando::Estadisticas::Physical')->new;
      $comando->ejecutar( persona => $persona, puntos => 7, strength => 5 );
      it "ENTONCES debo tener una persona con atributos" => sub {
        is $persona->strength->valor, 5;
        is(Saga->sum($persona->hash(qw(dexterity stamina))), 5);
        is(Saga->sum($persona->hash(qw(strength dexterity stamina))), 10);
      };
      context "Y CUANDO asigno un valor mayor al maximo" => sub {
        it "ENTONCES debo tener una persona con atributos" => sub {
          eval { $comando->ejecutar( persona => $persona, puntos => 7, strength => 6 ) };
          like $@, qr/El atributo strength\(6\) no esta entre al min\(1\) y max\(5\)/;
        };
      };
      context "Y CUANDO asigno un valor menor al minimo" => sub {
        it "ENTONCES debo tener una persona con atributos" => sub {
          eval { $comando->ejecutar( persona => $persona, puntos => 7, strength => 0 ) };
          like $@, qr/El atributo strength\(0\) no esta entre al min\(1\) y max\(5\)/;
        };
      };
    };
    context "CUANDO ejecuto un comando atributos physical asignando los atributos con mas valor que los puntos" => sub {
      my $persona = Saga->despachar('Persona')->new;
      my $comando = Saga->despachar('Comando::Estadisticas::Physical')->new;
      it "ENTONCES debo recibir un error" => sub {
        eval {
          $comando->ejecutar( persona => $persona, puntos => 7, strength => 5, dexterity => 5 );
        };
        like $@, qr/Se preasignaron mas puntos\(8\) que los puntos a asignar\(7\)/;
      };
    };
    context "CUANDO ejecuto un comando atributos physical asignando los atributos con menos valor que los puntos" => sub {
      my $persona = Saga->despachar('Persona')->new;
      my $comando = Saga->despachar('Comando::Estadisticas::Physical')->new;
      it "ENTONCES debo recibir un error" => sub {
        eval {
          $comando->ejecutar( persona => $persona, puntos => 7, strength => 1, dexterity => 1 );
        };
        like $@, qr/Los puntos asignables\(7\) son mas que los espacios disponibles\(4\)/;
      };
    };
  };
};