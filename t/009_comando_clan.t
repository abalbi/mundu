use strict;
use lib 'lib';
use Test::More qw(no_plan);
use Test::More::Behaviour;
use Test::Deep;
use Data::Dumper;

use Saga;

#cover -delete; PERL5OPT=-MDevel::Cover=+inc,/Volumes/UFS prove -v -I../lib "$@" && cover

describe "Como desarrollador quiero que mis vampiros tengan clan" => sub {
  context "DADA una persona" => sub {
    context "CUANDO ejecuto un comando clan" => sub {
      my $persona = Saga->despachar('Persona')->new;
      Saga->despachar('Comando::Agregar::Nacimiento')->new->ejecutar(persona => $persona);
      my $comando = Saga->despachar('Comando::Agregar::Clan')->new;
      $comando->ejecutar(persona => $persona);
      it "ENTONCES debo tener un vampire con clan" => sub {
        is $persona->especie->valor, 'vampire';
        ok $persona->clan->valor;
        ok $persona->es('vampire');
      };
    };
    context "CUANDO ejecuto un comando clan y le defino un clan" => sub {
      my $persona = Saga->despachar('Persona')->new;
      Saga->despachar('Comando::Agregar::Nacimiento')->new->ejecutar(persona => $persona);
      my $comando = Saga->despachar('Comando::Agregar::Clan')->new;
      $comando->ejecutar(persona => $persona, clan => 'brujah');
      it "ENTONCES debo tener un vampire con clan" => sub {
        is $persona->clan->valor, 'brujah';
        ok $persona->es('brujah');
      };
    };
    context "CUANDO ejecuto un comando clan en una persona con especie" => sub {
      my $persona = Saga->despachar('Persona')->new;
      Saga->despachar('Comando::Agregar::Nacimiento')->new->ejecutar(persona => $persona);
      Saga->despachar('Comando::Agregar::Especie')->new->ejecutar(persona => $persona, especie => 'vampire'); 
      my $comando = Saga->despachar('Comando::Agregar::Clan')->new;
      $comando->ejecutar(persona => $persona);
      it "ENTONCES debo tener un vampire con clan" => sub {
        ok $persona->clan->valor;
      };
    };
  };
  context "CUANDO ejecuto calcula_clan" => sub {
    my $comando = Saga->despachar('Comando::Agregar::Clan')->new;
    it "ENTONCES debo rebicir un clan" => sub {
      is $comando->calcula_clan(10), 'brujah';
      is $comando->calcula_clan(20), 'gangrel';
      is $comando->calcula_clan(30), 'malkavian';
      is $comando->calcula_clan(45), 'nosferatu';
      is $comando->calcula_clan(60), 'toreador';
      is $comando->calcula_clan(80), 'tremere';
      is $comando->calcula_clan(90), 'ventrue';
    };
  };

};