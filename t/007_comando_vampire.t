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
    my $comando = Saga->despachar('Comando::Vampire')->new;
    my $persona = $comando->ejecutar;
    it "ENTONCES debo tener una vampiro" => sub {
      is $persona->especie->valor, 'vampire';
      ok $persona->es('vampire');
      ok $persona->abrazo;
      ok $persona->antiguedad;
      ok $persona->edad_aparente;
      cmp_ok(Saga->dt($persona->nacimiento->valor)->epoch, '<', Saga->dt($persona->abrazo->valor)->epoch);
    };
  };
  context "CUANDO ejecuto un comando vampiro con fecha de abrazo" => sub {
    my $fecha = Saga->dt(Saga->entorno->fecha_actual)->subtract(years => 2)->datetime;
    my $comando = Saga->despachar('Comando::Vampire')->new;
    my $persona = $comando->ejecutar(fecha_abrazo => $fecha);
    it "ENTONCES debo tener un vampiro con esas fecha de abrazo" => sub {
      is $persona->especie->valor, 'vampire';
      ok $persona->es('vampire');
      is $persona->abrazo->valor, $fecha;
      is $persona->antiguedad->valor, 2;
      cmp_ok(Saga->dt($persona->nacimiento->valor)->epoch, '<', Saga->dt($persona->abrazo->valor)->epoch);
    };
    context "Y CUANDO defino un hasta en la fecha de abrazo" => sub {
      my $fecha1 = Saga->dt(Saga->entorno->fecha_actual)->subtract(years => 151)->datetime;
      my $fecha2 = Saga->dt(Saga->entorno->fecha_actual)->subtract(years => 110)->datetime;
      my $comando = Saga->despachar('Comando::Vampire')->new;
      my $persona = $comando->ejecutar(fecha_nacimiento => $fecha1, fecha_abrazo => {hasta => $fecha2});
      it "ENTONCES debo tener un vampiro con esas fecha de abrazo" => sub {
        cmp_ok(Saga->dt($persona->abrazo->valor)->year, '>', Saga->dt($persona->nacimiento->valor)->year);
        cmp_ok(Saga->dt($persona->abrazo->valor)->year, '<', Saga->dt($fecha2)->year);
        cmp_ok(Saga->dt($persona->nacimiento->valor)->epoch, '<', Saga->dt($persona->abrazo->valor)->epoch);
      };
    };
    context "Y CUANDO defino un desde en la fecha de abrazo" => sub {
      my $fecha = Saga->dt(Saga->entorno->fecha_actual)->subtract(years => 12)->datetime;
      my $comando = Saga->despachar('Comando::Vampire')->new;
      my $persona = $comando->ejecutar(fecha_abrazo => {desde => $fecha});
      it "ENTONCES debo tener un vampiro con esas fecha de abrazo" => sub {
        cmp_ok(Saga->dt($persona->abrazo->valor)->year, '>', Saga->dt($persona->nacimiento->valor)->year);
        cmp_ok(Saga->dt($persona->abrazo->valor)->year, '<', 1988);
        cmp_ok(Saga->dt($persona->nacimiento->valor)->epoch, '<', Saga->dt($persona->abrazo->valor)->epoch);
      };
      context "Y CUANDO defino una fecha de nacimiento" => sub {
        my $comando = Saga->despachar('Comando::Vampire')->new;
        my $fecha_nacimiento = Saga->dt_string(year => 1900)->datetime;
        my $fecha_abrazo_desde = Saga->dt_string(year => 1950)->datetime;
        my $persona = $comando->ejecutar(fecha_nacimiento => $fecha_nacimiento, fecha_abrazo => {desde => $fecha_abrazo_desde});
        it "ENTONCES debo tener un vampiro con esa antiguedad, esas edad aparente y una edad acorde a la suma de ambas" => sub {
          is $persona->nacimiento->valor, $fecha_nacimiento;
          cmp_ok(Saga->dt($persona->nacimiento->valor)->epoch, '<', Saga->dt($fecha_abrazo_desde)->epoch);
          cmp_ok(Saga->dt($persona->nacimiento->valor)->epoch, '<', Saga->dt($persona->abrazo->valor)->epoch);
        };
      };
    };
    context "Y CUANDO defino un edad aparente" => sub {
      my $fecha = Saga->dt(Saga->entorno->fecha_actual)->subtract(years => 4)->datetime;
      my $comando = Saga->despachar('Comando::Vampire')->new;
      my $edad_aparente = 30;
      my $persona = $comando->ejecutar(fecha_abrazo => $fecha, edad_aparente => $edad_aparente);
      it "ENTONCES debo tener un vampiro con esa antiguedad, esas edad aparente y una edad acorde a la suma de ambas" => sub {
        is $persona->antiguedad->valor, 4;
        is $persona->edad_aparente->valor, $edad_aparente;
        is $persona->edad->valor, 4 + $edad_aparente;
        cmp_ok(Saga->dt($persona->nacimiento->valor)->epoch, '<', Saga->dt($persona->abrazo->valor)->epoch);
      };
    };
  };
  context "CUANDO ejecuto un comando vampiro con antiguedad" => sub {
    my $fecha = Saga->dt(Saga->entorno->fecha_actual)->subtract(years => 3)->datetime;
    my $comando = Saga->despachar('Comando::Vampire')->new;
    my $persona = $comando->ejecutar(antiguedad => 3);
    it "ENTONCES debo tener un vampiro con esa antiguedad" => sub {
      is $persona->especie->valor, 'vampire';
      ok $persona->es('vampire');
      is $persona->abrazo->valor, $fecha;
      is $persona->antiguedad->valor, 3;
      cmp_ok(Saga->dt($persona->nacimiento->valor)->epoch, '<', Saga->dt($persona->abrazo->valor)->epoch);
    };
    context "Y CUANDO tengo la antiguedad mal definida" => sub {
      my $comando = Saga->despachar('Comando::Vampire')->new;
      it "ENTONCES debo rebicir un error" => sub {
        eval {my $persona = $comando->ejecutar(antiguedad => 'MAL')};
        like $@, qr/El param antiguedad no esta correctamente definifo: \'MAL\'/;
      };
    };
    context "Y CUANDO una edad aparente" => sub {
      my $comando = Saga->despachar('Comando::Vampire')->new;
      my $edad_aparente = 30;
      my $antiguedad = 3;
      my $persona = $comando->ejecutar(antiguedad => $antiguedad, edad_aparente => $edad_aparente);
      it "ENTONCES debo tener un vampiro con esa antiguedad, esas edad aparente y una edad acorde a la suma de ambas" => sub {
        is $persona->antiguedad->valor, $antiguedad;
        is $persona->edad_aparente->valor, $edad_aparente;
        is $persona->edad->valor, $antiguedad + $edad_aparente;
        cmp_ok(Saga->dt($persona->nacimiento->valor)->epoch, '<', Saga->dt($persona->abrazo->valor)->epoch);
      };
    };
    context "Y CUANDO defino la antiguedad + edad aparente distinta a edad" => sub {
      my $comando = Saga->despachar('Comando::Vampire')->new;
      it "ENTONCES debo rebicir un error" => sub {
        eval {my $persona = $comando->ejecutar(edad_aparente => 10, edad => 10, antiguedad => 11)};
        like $@, qr/La suma de edad aparente \+ antiguedad\(21\) no es igual a la edad\(10\)/;
      };
    };
  };
  context "CUANDO ejecuto un comando vampiro con edad aparente" => sub {
    my $comando = Saga->despachar('Comando::Vampire')->new;
    my $edad_aparente = 30;
    my $persona = $comando->ejecutar(edad_aparente => $edad_aparente);
    it "ENTONCES debo tener un vampiro con esa antiguedad, esas edad aparente y una edad acorde a la suma de ambas" => sub {
      is $persona->edad_aparente->valor, $edad_aparente;
      cmp_ok(Saga->dt($persona->nacimiento->valor)->epoch, '<', Saga->dt($persona->abrazo->valor)->epoch);
    };
    context "Y CUANDO tengo la edad_aparente mal definida" => sub {
      my $comando = Saga->despachar('Comando::Vampire')->new;
      it "ENTONCES debo rebicir un error" => sub {
        eval {my $persona = $comando->ejecutar(edad_aparente => 'MAL')};
        like $@, qr/El param edad_aparente no esta correctamente definifo: \'MAL\'/;
      };
    };
    context "Y CUANDO defino una edad" => sub {
      my $comando = Saga->despachar('Comando::Vampire')->new;
      my $edad_aparente = 30;
      my $edad = 35;
      my $persona = $comando->ejecutar(edad_aparente => $edad_aparente, edad => $edad);
      it "ENTONCES debo tener un vampiro con esa antiguedad, esas edad aparente y una edad acorde a la suma de ambas" => sub {
        is $persona->edad_aparente->valor, $edad_aparente;
        is $persona->edad->valor, $edad;
        cmp_ok(Saga->dt($persona->nacimiento->valor)->epoch, '<', Saga->dt($persona->abrazo->valor)->epoch);
      };
      context "Y CUANDO la edad aparente mayor a edad" => sub {
        my $comando = Saga->despachar('Comando::Vampire')->new;
        my $edad_aparente = 35;
        my $edad = 30;
        it "ENTONCES debo recibir un error" => sub {
          eval {my $persona = $comando->ejecutar(edad_aparente => $edad_aparente, edad => $edad)};
          like $@, qr/La edad\(30\) no puede ser menor a la edad aparente\(35\)/;
        };
      };
    };
    context "Y CUANDO defino una fecha de nacimiento" => sub {
      my $comando = Saga->despachar('Comando::Vampire')->new;
      my $edad_aparente = 30;
      my $fecha_nacimiento = Saga->dt_string(year => 1900)->datetime;
      my $persona = $comando->ejecutar(edad_aparente => $edad_aparente, fecha_nacimiento => $fecha_nacimiento);
      it "ENTONCES debo tener un vampiro con esa antiguedad, esas edad aparente y una edad acorde a la suma de ambas" => sub {
        is $persona->nacimiento->valor, $fecha_nacimiento;
        is $persona->edad_aparente->valor, $edad_aparente;
        cmp_ok(Saga->dt($persona->nacimiento->valor)->epoch, '<', Saga->dt($persona->abrazo->valor)->epoch);
      };
    };
  };
  context "CUANDO ejecuto calcula_edad_aparente debo recibir una edad aparente" => sub {
    my $comando = Saga->despachar('Comando::Vampire')->new;
    it "ENTONCES debo rebicir la edad aparente" => sub {
      cmp_ok $comando->calcula_edad_aparente(10), '<=', 10;
      cmp_ok $comando->calcula_edad_aparente(20), '<=', 20;
      cmp_ok $comando->calcula_edad_aparente(50), '<=', 40;
      cmp_ok $comando->calcula_edad_aparente(70), '<=', 70;
      cmp_ok $comando->calcula_edad_aparente(90), '<=', 100;
    };
  };
};