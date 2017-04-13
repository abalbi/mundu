use strict;
use lib 'lib';
use Test::More qw(no_plan);
use Test::More::Behaviour;
use Test::Deep;
use Data::Dumper;

use Saga;

#cover -delete; PERL5OPT=-MDevel::Cover=+inc,/Volumes/UFS prove -v -I../lib "$@" && cover


describe "Como desarrollador quiero que mis personas tengan nacimiento" => sub {
  context "DADA una persona" => sub {
    context "CUANDO ejecuto un comando nacimiento con una fecha" => sub {
      my $persona = Saga->despachar('Persona')->new;
      my $fecha = Saga->dt_string(year => 1970)->datetime;
      my $comando = Saga->despachar('Comando::Conceptos::Nacimiento')->new;
      my $situacion = $comando->ejecutar(
        persona => $persona,
        fecha_nacimiento => $fecha,
      );
      it "ENTONCES debo tener una situacion con la persona como sujeto" => sub {
        isa_ok $situacion, 'Situacion';
        is $situacion->rol('sujeto')->persona, $persona;
      };
      it "Y ENTONCES la persona tiene que tener el nacimiento" => sub {
        is $persona->fecha_nacimiento->valor->fecha, $fecha;
      };
    };
    context "CUANDO ejecuto un comando nacimiento" => sub {
      my $persona = Saga->despachar('Persona')->new;
      my $comando = Saga->despachar('Comando::Conceptos::Nacimiento')->new;
      my $situacion = $comando->ejecutar(
        persona => $persona,
      );
      it "Y ENTONCES la persona tiene que tener el nacimiento" => sub {
        ok $persona->fecha_nacimiento->valor;
        isa_ok $persona->fecha_nacimiento->valor, 'Situacion';
      };
    };
    context "CUANDO ejecuto un comando nacimiento con edad" => sub {
      my $fecha = Saga->dt_string(year => 1971)->datetime;
      my $persona = Saga->despachar('Persona')->new;
      my $comando = Saga->despachar('Comando::Conceptos::Nacimiento')->new;
      my $situacion = $comando->ejecutar(
        persona => $persona,
        edad => 19,
      );
      it "Y ENTONCES la persona tiene que tener el nacimiento coherente con la edad" => sub {
        is $persona->fecha_nacimiento->valor->fecha, $fecha;
        is $persona->edad->valor, 19;
        Saga->en_fecha(Saga->dt_string(year => 1981)->datetime, sub {
          is $persona->fecha_nacimiento->valor->fecha, $fecha;
          is $persona->edad->valor, 10;
        });
      };
    };
    context "CUANDO ejecuto un comando nacimiento con rango de edades" => sub {
      my $fecha = Saga->dt_string(year => 1971)->datetime;
      my $persona = Saga->despachar('Persona')->new;
      my $comando = Saga->despachar('Comando::Conceptos::Nacimiento')->new;
      my $situacion = $comando->ejecutar(
        persona => $persona,
        edad => [30..35],
      );
      it "Y ENTONCES la persona tiene que tener el nacimiento coherente con la edad" => sub {
        cmp_ok(Saga->dt($persona->fecha_nacimiento->valor->fecha)->year, '>', 1955);
        cmp_ok(Saga->dt($persona->fecha_nacimiento->valor->fecha)->year, '<', 1960);
      };
    };
    context "CUANDO ejecuto un comando nacimiento con rango de fechas" => sub {
      my $fecha_desde = Saga->dt_string(year => 1971)->datetime;
      my $fecha_hasta = Saga->dt_string(year => 1974)->datetime;
      my $persona = Saga->despachar('Persona')->new;
      my $comando = Saga->despachar('Comando::Conceptos::Nacimiento')->new;
      my $situacion = $comando->ejecutar(
        persona => $persona,
        fecha_nacimiento => {
          desde => $fecha_desde,
          hasta => $fecha_hasta,
        },
      );
      it "Y ENTONCES la persona tiene que tener el nacimiento coherente con la edad" => sub {
        cmp_ok(Saga->dt($persona->fecha_nacimiento->valor->fecha)->year, '>', 1970);
        cmp_ok(Saga->dt($persona->fecha_nacimiento->valor->fecha)->year, '<', 1974);
      };
    };
    context "CUANDO ejecuto un comando nacimiento con edad mal definido" => sub {
      my $fecha = Saga->dt_string(year => 1971)->datetime;
      my $persona = Saga->despachar('Persona')->new;
      my $comando = Saga->despachar('Comando::Conceptos::Nacimiento')->new;
      it "Y ENTONCES la persona tiene que tener el nacimiento coherente con la edad" => sub {
        eval {
          my $situacion = $comando->ejecutar(
            persona => $persona,
            edad => 'MAL',
          );
        };
        like $@, qr/El param edad no esta correctamente definifo: MAL/;
      };
    };
  };
  context "CUANDO tengo un comando que no devuelve el tipo que debe devolver" => sub {
    my $comando = Comando::Dummy->new;
    it "ENTONCES debo recibir un error" => sub {
      eval {$comando->ejecutar};
      like $@, qr/Se espera que Comando::Dummy.* devuelva un tipo Persona/;
    };
  };
};


package Comando::Dummy;
use base qw(Comando);
sub tipo_return{'Persona'}
sub _ejecutar {
  return Saga->params;
}
1;