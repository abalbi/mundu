use strict;
use lib 'lib';
use Test::More qw(no_plan);
use Test::More::Behaviour;
use Test::Deep;
use Data::Dumper;

use Saga;
Saga->cargar('WhiteWolf');
#cover -delete; PERL5OPT=-MDevel::Cover=+inc,/Volumes/UFS prove -v -I../lib "$@" && cover

describe "Como desarrollador quiero fabricar vampiros" => sub {
  context "CUANDO ejecuto un comando vampiro" => sub {
    my $persona = Saga->despachar('Fabrica::Vampire')->hacer(protagonismo => 'principal', );
    it "ENTONCES debo tener una vampiro" => sub {
      is $persona->sum('attribute'), 7 + 5 + 3 + 9;
      is $persona->sum('ability'), 13 + 9 + 5;
      is $persona->sum('background'), 7;
      is $persona->sum('virtue'), 7 + 3;
      is $persona->willpower->valor, $persona->courage->valor;
      is $persona->humanity->valor, $persona->self_control->valor + $persona->conscience->valor;
      ok scalar grep {$persona->generacion->valor == $_} (9..13);
    };
  };
  context "CUANDO ejecuto un comando vampiro con el esteriotipo neonato" => sub {
    my $persona = Saga->despachar('Fabrica::Vampire')->hacer(protagonismo => 'principal', esteriotipo => 'neonato');
    it "ENTONCES debo tener una vampiro" => sub {
      is $persona->sum('attribute'), 7 + 5 + 3 + 9;
      is $persona->sum('ability'), 13 + 9 + 5;
      is $persona->sum('background'), 7;
      is $persona->sum('virtue'), 7 + 3;
      is $persona->willpower->valor, $persona->courage->valor;
      is $persona->humanity->valor, $persona->self_control->valor + $persona->conscience->valor;
      ok scalar grep {$persona->generacion->valor == $_} (9..13);
    };
  };
  context "CUANDO ejecuto un comando vampiro con el esteriotipo neonato" => sub {
    my $persona = Saga->despachar('Fabrica::Vampire')->hacer(protagonismo => 'principal', esteriotipo => 'ancilla');
    it "ENTONCES debo tener una vampiro" => sub {
      is $persona->sum('attribute'), 9 + 6 + 4 + 9;
      is $persona->sum('ability'), 18 + 12 + 6;
      is $persona->sum('background'), 7;
      is $persona->sum('virtue'), 10 + 3;
      is $persona->willpower->valor, 8;
      ok scalar grep {$persona->generacion->valor == $_} (7..9);
    };
  };
  context "CUANDO ejecuto un comando vampiro con el esteriotipo neonato" => sub {
    my $persona = Saga->despachar('Fabrica::Vampire')->hacer(protagonismo => 'principal', esteriotipo => 'elder');
    it "ENTONCES debo tener una vampiro" => sub {
      is $persona->sum('attribute'), 10 + 7 + 5 + 9;
      is $persona->sum('ability'), 21 + 14 + 7;
      is $persona->sum('background'), 12;
      is $persona->sum('virtue'), 6 + 3;
      is $persona->willpower->valor, 9;
      is $persona->humanity->valor, $persona->self_control->valor + $persona->conscience->valor;
      ok scalar grep {$persona->generacion->valor == $_} (5..7);
    };
  };
  context "CUANDO ejecuto un comando vampiro con willpower" => sub {
    my $persona = Saga->despachar('Fabrica::Vampire')->hacer(protagonismo => 'principal', willpower => 10);
    it "ENTONCES debo tener una vampiro" => sub {
      is $persona->willpower->valor, 10;
    };
  };
  context "CUANDO ejecuto un comando vampiro con fecha de abrazo" => sub {
    context "Y CUANDO la fecha de abrazo es menor a 50 años" => sub {
      my $fecha_abrazo = Saga->dt(Saga->entorno->fecha_inicio)->subtract(years => 10)->datetime;
      my $persona = Saga->despachar('Fabrica::Vampire')->hacer(protagonismo => 'principal', fecha_abrazo => $fecha_abrazo);
      it "ENTONCES debo tener una vampiro" => sub {
        is $persona->sum('attribute'), 7 + 5 + 3 + 9;
      };
    };
    context "Y CUANDO la fecha de abrazo es mayor a 50 años" => sub {
      my $fecha_abrazo = Saga->dt(Saga->entorno->fecha_inicio)->subtract(years => 60)->datetime;
      my $persona = Saga->despachar('Fabrica::Vampire')->hacer(protagonismo => 'principal', fecha_abrazo => $fecha_abrazo);
      it "ENTONCES debo tener una vampiro" => sub {
        is $persona->sum('attribute'), 9 + 6 + 4 + 9;
      };
    };
    context "Y CUANDO la fecha de abrazo es mayor a 300 años" => sub {
      my $fecha_abrazo = Saga->dt(Saga->entorno->fecha_inicio)->subtract(years => 360)->datetime;
      my $persona = Saga->despachar('Fabrica::Vampire')->hacer(protagonismo => 'principal', fecha_abrazo => $fecha_abrazo);
      it "ENTONCES debo tener una vampiro" => sub {
        is $persona->sum('attribute'), 10 + 7 + 5 + 9;
      };
    };
  };
  context "CUANDO ejecuto un comando vampiro con esteriotipo" => sub {
    context "Y CUANDO es un neonato" => sub {
      my $persona = Saga->despachar('Fabrica::Vampire')->hacer(
        protagonismo => 'principal',
        esteriotipo => 'neonato',
        background => 8,
        virtue => 4,
      );
      it "ENTONCES debo tener una vampiro" => sub {
        is $persona->sum('background'), 8;
        is $persona->sum('virtue'), 7;
      };
    };
    context "Y CUANDO es un ancilla" => sub {
      my $persona = Saga->despachar('Fabrica::Vampire')->hacer(
        protagonismo => 'principal',
        esteriotipo => 'ancilla',
        background => 8,
        virtue => 4,
        willpower => 4,
      );
      it "ENTONCES debo tener una vampiro" => sub {
        is $persona->sum('background'), 8;
        is $persona->sum('virtue'), 7;
        is $persona->willpower->valor, 4;
      };
    };
    context "Y CUANDO es un elder" => sub {
      my $persona = Saga->despachar('Fabrica::Vampire')->hacer(
        protagonismo => 'principal',
        esteriotipo => 'elder',
        background => 8,
        virtue => 4,
        willpower => 4,
      );
      it "ENTONCES debo tener una vampiro" => sub {
        is $persona->sum('background'), 8;
        is $persona->sum('virtue'), 7;
        is $persona->willpower->valor, 4;
      };
    };
  };
};