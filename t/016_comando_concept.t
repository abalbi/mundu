use strict;
use lib 'lib';
use Test::More qw(no_plan);
use Test::More::Behaviour;
use Test::Deep;
use Data::Dumper;

use Saga;
Saga->cargar('WhiteWolf');

#cover -delete; PERL5OPT=-MDevel::Cover=+inc,/Volumes/UFS prove -v -I../lib "$@" && cover

describe "Como desarrollador quiero que mis vampiros tengan concept" => sub {
  context "DADA una persona" => sub {
    context "CUANDO ejecuto un comando concept" => sub {
      my $persona = Saga->despachar('Persona')->new;
      Saga->despachar('Comando::Conceptos::Nacimiento')->new->ejecutar(persona => $persona);
      my $comando = Saga->despachar('Comando::Conceptos::Concept')->new;
      my $params = $comando->ejecutar(persona => $persona);
      it "ENTONCES debo tener un vampire con concept" => sub {
        ok $persona->concept;
      };
    };
    context "CUANDO ejecuto un comando concept" => sub {
      my $persona = Saga->despachar('Persona')->new;
      Saga->despachar('Comando::Conceptos::Nacimiento')->new->ejecutar(persona => $persona);
      my $comando = Saga->despachar('Comando::Conceptos::Concept')->new;
      my $params = $comando->ejecutar(persona => $persona, concept => 'investigator');
      it "ENTONCES debo tener un vampire con concept" => sub {
        ok $persona->concept;
        ok $persona->concept->valor;
        my $valor = $persona->concept->valor;
        ok $persona->es($valor);
        ok scalar grep {$_ == $params->firearms} (2..5); 
      };
    };
    context "CUANDO ejecuto un comando concept" => sub {
      my $persona = Saga->despachar('Persona')->new;
      Saga->despachar('Comando::Conceptos::Nacimiento')->new->ejecutar(persona => $persona);
      my $comando = Saga->despachar('Comando::Conceptos::Concept')->new;
      my $params = $comando->ejecutar(persona => $persona, concept => 'detective');
      it "ENTONCES debo tener un vampire con concept" => sub {
        ok $persona->concept;
        ok $persona->es('investigator');
        ok $persona->es('detective');
        ok scalar grep {$_ == $params->firearms} (2..5); 
      };
    };
  };
};