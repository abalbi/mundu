use strict;
use lib 'lib';
use Test::More qw(no_plan);
use Test::More::Behaviour;
use Test::Deep;
use Data::Dumper;

use Saga;

#cover -delete; PERL5OPT=-MDevel::Cover=+inc,/Volumes/UFS prove -v -I../lib "$@" && cover

describe "Como usuario quiero consultar el willpower de una persona" => sub {
  context "DADO una persona" => sub {
    context "Y DADO que la persona tiene willpower a 4" => sub {
      my $persona = Saga->despachar('Persona')->new;
      $persona->agregar(Saga->despachar('Persona::Propiedad')->new(key => 'willpower'));
      $persona->willpower->agregar(Saga->despachar('Alteracion')->new(key => 'willpower', valor => 4));
      context "Y CUANDO consulto el willpower de la persona" => sub {
        my $valor = $persona->willpower->valor;
        it "ENTONCES recibo un 4" => sub {
          is $valor, 4;
        };
      };
    };
    context "CUANDO le agrego algo que no es una propiedad" => sub {
      my $persona = Saga->despachar('Persona')->new;
      $persona->agregar(Saga->despachar('Persona::Propiedad')->new(key => 'willpower'));
      it "ENTONCES debo recibir un error" => sub {
        eval { $persona->willpower->agregar("Dummy")};
        like $@, qr/Para agregar a una Persona::Propiedad debe ser una Alteracion/;
      };
    };
    context "Y DADO que la persona tiene willpower a 4 en fecha2" => sub {
      my $fecha1 = Saga->dt_string(year => 1990)->datetime;
      my $fecha2 = Saga->dt_string(year => 1993)->datetime;
      my $fecha3 = Saga->dt_string(year => 1995)->datetime;
      my $persona = Saga->despachar('Persona')->new;
      $persona->agregar(Saga->despachar('Persona::Propiedad')->new(key => 'willpower'));
      $persona->willpower->agregar(Saga->despachar('Alteracion')->new(key => 'willpower', valor => 4, fecha => $fecha2));
      context "Y CUANDO consulto el willpower en fecha posterior a fecha2" => sub {
        it "ENTONCES recibo un 4" => sub {
          my $valor;
          Saga->en_fecha($fecha3, sub {
            $valor = $persona->willpower->valor;
          });
          is $valor, 4;
        };
      };
    };
    context "Y DADO que la persona tiene willpower a 4 en fecha2 con un 2y de vencimiento" => sub {
      my $fecha1 = Saga->dt_string(year => 1990)->datetime;
      my $fecha2 = Saga->dt_string(year => 1993)->datetime;
      my $fecha3 = Saga->dt_string(year => 1995)->datetime;
      my $fecha4 = Saga->dt_string(year => 1996)->datetime;
      my $fecha5 = Saga->dt_string(year => 1998)->datetime;
      my $persona = Saga->despachar('Persona')->new;
      $persona->agregar(Saga->despachar('Persona::Propiedad')->new(key => 'willpower'));
      $persona->willpower->agregar(Saga->despachar('Alteracion')->new(key => 'willpower', valor => 4, fecha => $fecha2 ));
      $persona->willpower->agregar(Saga->despachar('Alteracion')->new(key => 'willpower', valor => 5, fecha => $fecha3, vencimiento => '2y'));
      context "Y CUANDO consulto el willpower en fecha posterior a fecha2" => sub {
        it "ENTONCES recibo valor dependiendo del vencimiento" => sub {
          my $valor;
          Saga->en_fecha($fecha2, sub {
            $valor = $persona->willpower->valor;
          });
          is $valor, 4;
          Saga->en_fecha($fecha3, sub {
            $valor = $persona->willpower->valor;
          });
          is $valor, 5;
          Saga->en_fecha($fecha4, sub {
            $valor = $persona->willpower->valor;
          });
          is $valor, 5;
          Saga->en_fecha($fecha5, sub {
            $valor = $persona->willpower->valor;
          });
          is $valor, 4;
        };
      };
    };
    context "Y DADO que la persona no tiene altura" => sub {
      my $fecha = Saga->entorno->fecha_actual;
      my $persona = Saga->despachar('Persona')->new;
      context "Y CUANDO consulto la altura de la persona" => sub {
        it "ENTONCES recibo un error" => sub {
          eval {$persona->altura};
          like $@, qr/No se encontro Persona::altura en fecha $fecha/;
        };
      };
    };
  };
};


