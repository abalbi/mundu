use strict;
use lib 'lib';
use Test::More qw(no_plan);
use Test::More::Behaviour;
use Test::Deep;
use Data::Dumper;

use Saga;

describe "Saga" => sub {
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
};