use strict;
use lib 'lib';
use Test::More qw(no_plan);
use Test::More::Behaviour;
use Test::Deep;
use Data::Dumper;

use Saga;
Saga->saga_srand;
#cover -delete; PERL5OPT=-MDevel::Cover=+inc,/Volumes/UFS prove -v -I../lib "$@" && cover

describe "Como desarrollador quiero fabricar vampiros" => sub {
  context "CUANDO ejecuto un comando vampiro" => sub {
    my $comando = Saga->despachar('Comando::Hacer::Abrazo')->new;
    my $params = $comando->ejecutar;
    it "ENTONCES debo tener una vampiro" => sub {
      ok $params->fecha_abrazo;
      ok $params->edad;
    };
  };
  context "CUANDO ejecuto un comando vampiro con fecha de abrazo" => sub {
    my $fecha = Saga->dt(Saga->entorno->fecha_actual)->subtract(years => 2)->datetime;
    my $comando = Saga->despachar('Comando::Hacer::Abrazo')->new;
    my $params = $comando->ejecutar(fecha_abrazo => $fecha);
    it "ENTONCES debo tener un vampiro con esas fecha de abrazo" => sub {
      ok $params->edad;
      is $params->fecha_abrazo, $fecha;
    };
    context "Y CUANDO defino un hasta en la fecha de abrazo" => sub {
      my $edad = 151;
      my $fecha1 = Saga->dt(Saga->entorno->fecha_actual)->subtract(years => $edad)->datetime;
      my $fecha2 = Saga->dt(Saga->entorno->fecha_actual)->subtract(years => 110)->datetime;
      my $comando = Saga->despachar('Comando::Hacer::Abrazo')->new;
      my $params = $comando->ejecutar(fecha_nacimiento => $fecha1, fecha_abrazo => {hasta => $fecha2});
      it "ENTONCES debo tener un vampiro con esas fecha de abrazo" => sub {
        is $params->edad, $edad;
        ok $params->fecha_abrazo;
        cmp_ok(Saga->dt($params->fecha_abrazo)->epoch, '<', Saga->dt($fecha)->epoch);
      };
    };
    context "Y CUANDO defino un desde en la fecha de abrazo" => sub {
      my $fecha = Saga->dt(Saga->entorno->fecha_actual)->subtract(years => 12)->datetime;
      my $comando = Saga->despachar('Comando::Hacer::Abrazo')->new;
      my $params = $comando->ejecutar(fecha_abrazo => {desde => $fecha});
      it "ENTONCES debo tener un vampiro con esas fecha de abrazo" => sub {
        ok $params->edad;
        ok $params->fecha_abrazo;
        cmp_ok(Saga->dt($params->fecha_abrazo)->epoch, '>', Saga->dt($fecha)->epoch);
      };
      context "Y CUANDO defino una fecha de nacimiento" => sub {
        my $comando = Saga->despachar('Comando::Hacer::Abrazo')->new;
        my $fecha_nacimiento = Saga->dt_string(year => 1900)->datetime;
        my $fecha_abrazo_desde = Saga->dt_string(year => 1950)->datetime;
        my $params = $comando->ejecutar(fecha_nacimiento => $fecha_nacimiento, fecha_abrazo => {desde => $fecha_abrazo_desde});
        it "ENTONCES debo tener un vampiro con esa antiguedad, esas edad aparente y una edad acorde a la suma de ambas" => sub {
          ok $params->edad;
          ok $params->fecha_abrazo;
          is $params->edad, Saga->dt(Saga->entorno->fecha_inicio)->year - Saga->dt($fecha_nacimiento)->year;
          cmp_ok(Saga->dt($params->fecha_abrazo)->epoch, '>', Saga->dt($fecha_abrazo_desde)->epoch);
        };
      };
    };
    context "Y CUANDO defino un edad aparente" => sub {
      my $fecha = Saga->dt(Saga->entorno->fecha_actual)->subtract(years => 4)->datetime;
      my $comando = Saga->despachar('Comando::Hacer::Abrazo')->new;
      my $edad_aparente = 30;
      my $params = $comando->ejecutar(fecha_abrazo => $fecha, edad_aparente => $edad_aparente);
      it "ENTONCES debo tener un vampiro con esa antiguedad, esas edad aparente y una edad acorde a la suma de ambas" => sub {
        is $params->fecha_abrazo, $fecha;
        is $params->edad_aparente, $edad_aparente;
        is $params->edad, 4 + $edad_aparente;
      };
    };
  };
  context "CUANDO ejecuto un comando vampiro con antiguedad" => sub {
    my $antiguedad = 5;
    my $fecha = Saga->dt(Saga->entorno->fecha_actual)->subtract(years => $antiguedad)->datetime;
    my $comando = Saga->despachar('Comando::Hacer::Abrazo')->new;
    my $params = $comando->ejecutar(antiguedad => $antiguedad);
    it "ENTONCES debo tener un vampiro con esa antiguedad" => sub {
      ok $params->fecha_abrazo;
      ok $params->edad;
      is $params->fecha_abrazo, $fecha;
      is $params->antiguedad, $antiguedad;
    };
    context "Y CUANDO tengo la antiguedad mal definida" => sub {
      my $comando = Saga->despachar('Comando::Hacer::Abrazo')->new;
      it "ENTONCES debo rebicir un error" => sub {
        eval {my $params = $comando->ejecutar(antiguedad => 'MAL')};
        like $@, qr/El param antiguedad no esta correctamente definifo: \'MAL\'/;
      };
    };
    context "Y CUANDO una edad aparente" => sub {
      my $comando = Saga->despachar('Comando::Hacer::Abrazo')->new;
      my $edad_aparente = 30;
      my $antiguedad = 3;
      my $params = $comando->ejecutar(antiguedad => $antiguedad, edad_aparente => $edad_aparente);
      it "ENTONCES debo tener un vampiro con esa antiguedad, esas edad aparente y una edad acorde a la suma de ambas" => sub {
        ok $params->fecha_abrazo;
        is $params->edad_aparente, $edad_aparente;
        is $params->edad, Saga->dt(Saga->entorno->fecha_inicio)->year - Saga->dt($params->fecha_abrazo)->year + $edad_aparente;
        is $params->antiguedad, $antiguedad;
        is $params->edad, $antiguedad + $edad_aparente;
      };
    };
    context "Y CUANDO defino la antiguedad + edad aparente distinta a edad" => sub {
      my $comando = Saga->despachar('Comando::Hacer::Abrazo')->new;
      it "ENTONCES debo rebicir un error" => sub {
        eval {my $params = $comando->ejecutar(edad_aparente => 10, edad => 10, antiguedad => 11)};
        like $@, qr/La suma de edad aparente \+ antiguedad\(21\) no es igual a la edad\(10\)/;
      };
    };
  };
  context "CUANDO ejecuto un comando vampiro con edad aparente" => sub {
    my $comando = Saga->despachar('Comando::Hacer::Abrazo')->new;
    my $edad_aparente = 30;
    my $params = $comando->ejecutar(edad_aparente => $edad_aparente);
    it "ENTONCES debo tener un vampiro con esa antiguedad, esas edad aparente y una edad acorde a la suma de ambas" => sub {
      ok $params->fecha_abrazo;
      is $params->edad_aparente, $edad_aparente;
      is $params->edad, Saga->dt(Saga->entorno->fecha_inicio)->year - Saga->dt($params->fecha_abrazo)->year + $edad_aparente;
    };
    context "Y CUANDO tengo la edad_aparente mal definida" => sub {
      my $comando = Saga->despachar('Comando::Hacer::Abrazo')->new;
      it "ENTONCES debo rebicir un error" => sub {
        eval {my $params = $comando->ejecutar(edad_aparente => 'MAL')};
        like $@, qr/El param edad_aparente no esta correctamente definifo: \'MAL\'/;
      };
    };
    context "Y CUANDO defino una edad" => sub {
      my $comando = Saga->despachar('Comando::Hacer::Abrazo')->new;
      my $edad_aparente = 30;
      my $edad = 35;
      my $params = $comando->ejecutar(edad_aparente => $edad_aparente, edad => $edad);
      it "ENTONCES debo tener un vampiro con esa antiguedad, esas edad aparente y una edad acorde a la suma de ambas" => sub {
        ok $params->fecha_abrazo;
        is $params->edad_aparente, $edad_aparente;
        is $params->edad, Saga->dt(Saga->entorno->fecha_inicio)->year - Saga->dt($params->fecha_abrazo)->year + $edad_aparente;
      };
      context "Y CUANDO la edad aparente mayor a edad" => sub {
        my $comando = Saga->despachar('Comando::Hacer::Abrazo')->new;
        my $edad_aparente = 35;
        my $edad = 30;
        it "ENTONCES debo recibir un error" => sub {
          eval {my $params = $comando->ejecutar(edad_aparente => $edad_aparente, edad => $edad)};
          like $@, qr/La edad\(30\) no puede ser menor a la edad aparente\(35\)/;
        };
      };
    };
    context "Y CUANDO defino una fecha de nacimiento" => sub {
      my $comando = Saga->despachar('Comando::Hacer::Abrazo')->new;
      my $edad_aparente = 30;
      my $fecha_nacimiento = Saga->dt_string(year => 1900)->datetime;
      my $params = $comando->ejecutar(edad_aparente => $edad_aparente, fecha_nacimiento => $fecha_nacimiento);
      it "ENTONCES debo tener un vampiro con esa antiguedad, esas edad aparente y una edad acorde a la suma de ambas" => sub {
        ok $params->fecha_abrazo;
        is $params->edad_aparente, $edad_aparente;
        is (Saga->dt($params->fecha_abrazo)->year, Saga->dt($fecha_nacimiento)->year + $params->edad_aparente);
        is $params->edad, Saga->dt(Saga->entorno->fecha_inicio)->year - Saga->dt($fecha_nacimiento)->year;
      };
    };
  };
  context "CUANDO ejecuto calcula_edad_aparente debo recibir una edad aparente" => sub {
    my $comando = Saga->despachar('Comando::Hacer::Abrazo')->new;
    it "ENTONCES debo rebicir la edad aparente" => sub {
      cmp_ok $comando->calcula_edad_aparente(10), '<=', 10;
      cmp_ok $comando->calcula_edad_aparente(20), '<=', 20;
      cmp_ok $comando->calcula_edad_aparente(50), '<=', 40;
      cmp_ok $comando->calcula_edad_aparente(70), '<=', 70;
      cmp_ok $comando->calcula_edad_aparente(90), '<=', 100;
    };
  };
};