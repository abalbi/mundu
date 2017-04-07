use strict;
use lib 'lib';
use Test::More qw(no_plan);
use Test::More::Behaviour;
use Test::Deep;
use Data::Dumper;

use Saga;

#cover -delete; PERL5OPT=-MDevel::Cover=+inc,/Volumes/UFS prove -v -I../lib "$@" && cover

describe "Como usuario quiero tener un Entorno que tenga Situaciones" => sub {
  context "DADO un Saga" => sub {
    context "CUANDO pido el Entorno" => sub {
      my $entorno = Saga->entorno;
      it "ENTONCES debo recibir un Entorno" => sub {
        isa_ok $entorno, 'Entorno';
      };
    };
  };
  context "DADO un Entorno" => sub {
    my $entorno = Saga->entorno;
    context "Y DAA una Situacion" => sub {
      my $c = scalar @{$entorno->situaciones};
      my $situacion = Saga->despachar('Situacion')->new(fecha => Saga->entorno->fecha_actual);
      context "CUANDO la agrego al Entorno" => sub {
        $entorno->agregar($situacion);
        it "ENTONCES debo tener una situacion mas" => sub {
          is scalar @{$entorno->situaciones}, $c + 1;
        };
      };
    };
    context "CUANDO agrego al Entorno al que no es una situacion" => sub {
      it "ENTONCES debo recibir un error" => sub {
        eval { $entorno->agregar("Dummy") };
        like $@, qr/Para agregar a un Entorno debe ser una Situacion/;
      };
    };
  };
  context "DADA una Situacion" => sub {
    context "Y DADA una Persona" => sub {
      my $situacion = Saga->despachar('Situacion')->new(fecha => Saga->entorno->fecha_actual);
      my $persona = Saga->despachar('Persona')->new;
      context "CUANDO agrego una Persona a un rol en una Situacion" => sub {
        $situacion->rol("sujeto", $persona);
        it "ENTONCES debo tener el rol con esa Persona" => sub {
          isa_ok $situacion->rol('sujeto'), 'Situacion::Rol';
          isa_ok $situacion->rol('sujeto')->persona, 'Persona';
        };
      };
    };
    context "Y DADA dos Personas con el mismo rol" => sub {
      my $situacion = Saga->despachar('Situacion')->new(fecha => Saga->entorno->fecha_actual);
      my $persona1 = Saga->despachar('Persona')->new;
      my $persona2 = Saga->despachar('Persona')->new;
      context "CUANDO agrego una Persona a un rol en una Situacion" => sub {
        $situacion->rol("sujeto", $persona1);
        $situacion->rol("sujeto", $persona2);
        it "ENTONCES debo tener el rol con esa Persona" => sub {
          isa_ok $situacion->rol('sujeto'), 'ARRAY';
          isa_ok $situacion->rol('sujeto')->[0], 'Situacion::Rol';
          isa_ok $situacion->rol('sujeto')->[0]->persona, 'Persona';
        };
      };
    };
    context "CUANDO agrego a la Situacion algo que no es una persona" => sub {
      my $situacion = Saga->despachar('Situacion')->new(fecha => Saga->entorno->fecha_actual);
      it "ENTONCES debo recibir un error" => sub {
        eval { $situacion->rol("sujeto", "Dummmy") };
        like $@, qr/Para agregar a un Rol de una Situacion debe ser una Persona/;
      };
    };
  };
  context "DADA una Persona" => sub {
    my $persona = Saga->despachar('Persona')->new;
    context "Y DADA una Propiedad" => sub {
      my $propiedad = Saga->despachar('Persona::Propiedad')->new(key => 'willpower');
      context "CUANDO agrego una Propiedad a una Persona" => sub {
        $persona->agregar($propiedad);
        it "ENTONCES debo la propiedad en la persona" => sub {
          isa_ok $persona->willpower, 'Persona::Propiedad';
        };
      };
    };
    context "Y DADAS 2 Propiedades del mismo key" => sub {
      my $propiedad1 = Saga->despachar('Persona::Propiedad')->new(key => 'willpower');
      my $propiedad2 = Saga->despachar('Persona::Propiedad')->new(key => 'willpower');
      context "CUANDO agrego una Propiedad a una Persona" => sub {
        $persona->agregar($propiedad1);
        $persona->agregar($propiedad2);
        it "ENTONCES debo la propiedad en la persona" => sub {
          isa_ok $persona->willpower, 'ARRAY';
          isa_ok $persona->willpower->[0], 'Persona::Propiedad';
          isa_ok $persona->willpower->[1], 'Persona::Propiedad';
        };
      };
    };
    context "CUANDO consulto una propiedad que no tiene" => sub {
      it "ENTONCES debo recibir un error" => sub {
        eval { $persona->dummy };
        like $@, qr/No se encontro Persona::dummy en fecha 1990-01-01T00:00:00/;
      }
    };
    context "CUANDO agrego a la Situacion algo que no es una persona" => sub {
      it "ENTONCES debo recibir un error" => sub {
        eval { $persona->agregar("Dummmy") };
        like $@, qr/Para agregar a una Persona debe ser una Persona::Propiedad/;
      };
    };
  };
};

