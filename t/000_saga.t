use strict;
use lib 'lib';
use Test::More qw(no_plan);
use Test::More::Behaviour;
use Test::Deep;
use Data::Dumper;

use Saga;

describe "Saga" => sub {
  context "DADO un Saga::Params" => sub {
    context "CUANDO no defino un param como valido" => sub {
      my $params = Saga->params();
      it "ENTONCES al consultarlo debo recibir un error" => sub {
        eval {$params->no_valido}; 
        like $@, qr/El param \'no_valido\' no esta definido/;
      };
    };
    context "CUANDO lo paso a Saga::params" => sub {
      my $params1 = Saga->params((valido => 5))->params_validos(qw(valido));
      my $params2 = Saga->params($params1)->params_validos(qw(valido));
      it "ENTONCES debo recibir una instancia distinta" => sub {
        ok $params1 ne $params2;
        is $params2->valido, 5; 
      };
    };
    context "CUANDO defino un param como valido" => sub {
      my $params = Saga->params({valido => 5})->params_validos(qw(valido));
      it "ENTONCES al consultarlo debo recibir el valor" => sub {
        is $params->valido, 5; 
      };
      context "Y le asigno valor" => sub {
        $params->valido(6);
        it "ENTONCES al consultarlo debo recibir el valor" => sub {
          is $params->valido, 6; 
        };
      };
    };
    context "CUANDO defino que son params libres" => sub {
      my $params = Saga->params(valido => 5)->params_libres;
      it "ENTONCES al consultarlo debo recibir el valor" => sub {
        is $params->valido, 5; 
      };
      context "Y CUANDO defino incorrectamente los valores" => sub {
        it "ENTONCES al consultarlo debo recibir un error" => sub {
          eval {my $params = Saga->params('mal')->params_libres}; 
          like $@, qr/Los parametros no se pueden parsear/;
        };
      };
    };
    context "CUANDO defino un param requerido" => sub {
      it "ENTONCES al consultarlo debo recibir el valor" => sub {
        eval {Saga->params->params_requeridos(qw(requeridos))};
        like $@, qr/El param \'requeridos\' es requerido/;
      };
    };
    context "CUANDO defino dos params como excluyentes" => sub {
      it "ENTONCES debo recibir un error si ambos estan asignados" => sub {
        eval {Saga->params(exclu1 => 'valor', exclu2 => 'valor')->params_excluyentes(qw(exclu1 exclu2))};
        like $@, qr/No se puede definir al mismo tiempo los params exclu1,exclu2/;
      };
    };
  };
  context "Saga::en_fecha" => sub {
    context "CUANDO ejecuto nuevo_srand " => sub {
      it "ENTONCES el hacer me debe devolver un numero mejor o igual al enviado" => sub {
        eval { Saga->en_fecha(undef, sub {}) };
        like $@, qr/Fecha es requerido/;
      };
    };
  };
  context "Saga::nuevo_srand" => sub {
    context "CUANDO ejecuto nuevo_srand " => sub {
      my $valor = Saga::nuevo_srand();
      it "ENTONCES el hacer me debe devolver un numero mejor o igual al enviado" => sub {
        like $valor, qr/^\d\d\d\d\d\d\d\d\d\d$/;
      };
    };
  };
  context "Saga::saga_srand" => sub {
    context "CUANDO ejecuto saga_srand " => sub {
      it "ENTONCES el hacer me debe devolver un numero mejor o igual al enviado" => sub {
        my ($srand1, $srand_next1) = Saga::saga_srand();
        is $srand1, $Saga::srand_default;
        my ($srand2, $srand_next2) = Saga::saga_srand('111111111');
        my ($srand3, $srand_next3) = Saga::saga_srand('NEXT');
        my ($srand4, $srand_next4) = Saga::saga_srand('DEFAULT');

      };
    };
  };
  context "Saga::azar" => sub {
    context "CUANDO ejecuto el azar de Util con un numero" => sub {
      my $valor = Saga->azar(10);
      it "ENTONCES el hacer me debe devolver un numero mejor o igual al enviado" => sub {
        cmp_ok $valor, '<=', 10;
      };
    };

    context "CUANDO ejecuto el azar de Util sin parametro" => sub {
      my $valor = Saga->azar();
      it "ENTONCES debe devolver un undef" => sub {
        is $valor, undef;
    };
      };

    context "CUANDO ejecuto el azar de Util con una ref a un array" => sub {
      my $valor = Saga->azar([qw(a b c)]);
      it "ENTONCES el hacer me debe devolver un elemento del array" => sub {
        cmp_deeply $valor, any(qw(a b c));
      };
    };
  };
  context "Saga::dt_random" => sub {
    context "CUANDO pido una fecha al azar con desde y hasta" => sub {
      my $fecha_desde = Saga->dt_string(year => 1971)->datetime;
      my $fecha_hasta = Saga->dt_string(year => 1974)->datetime;
      my $fecha = Saga->dt_random(desde => $fecha_desde, hasta => $fecha_hasta);
      it "ENTONCES el hacer me debe devolver una fecha" => sub {
        cmp_ok(Saga->dt($fecha)->year, '>', 1970);
        cmp_ok(Saga->dt($fecha)->year, '<', 1974);
      };
    };
    context "CUANDO pido una fecha al azar con desde y hasta pero el hasta es menor que desde" => sub {
      my $fecha_desde = Saga->dt_string(year => 1974)->datetime;
      my $fecha_hasta = Saga->dt_string(year => 1971)->datetime;
      it "ENTONCES debo recibir un error" => sub {
        eval {
          my $fecha = Saga->dt_random(desde => $fecha_desde, hasta => $fecha_hasta);
        };
        like $@, qr/Desde .+ debe ser menor que Hasta .+/;
      };
    };
    context "CUANDO pido una fecha al azar con desde" => sub {
      my $fecha_desde = Saga->dt_string(year => 1971)->datetime;
      my $fecha = Saga->dt_random(desde => $fecha_desde);
      it "ENTONCES el hacer me debe devolver una fecha" => sub {
        cmp_ok(Saga->dt($fecha)->year, '>', 1971);
      };
    };
    context "CUANDO pido una fecha al azar con hasta" => sub {
      my $fecha_hasta = Saga->dt_string(year => 1971)->datetime;
      my $fecha = Saga->dt_random(hasta => $fecha_hasta);
      it "ENTONCES el hacer me debe devolver una fecha" => sub {
        cmp_ok(Saga->dt($fecha)->year, '<', 1971);
      };
    };
  };
};