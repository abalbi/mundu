use strict;
use lib 'lib';
use Test::More qw(no_plan);
use Test::More::Behaviour;
use Test::Deep;
use Data::Dumper;
use List::Util qw(shuffle);

use Saga;
Saga->saga_srand;
#cover -delete; PERL5OPT=-MDevel::Cover=+inc,/Volumes/UFS prove -v -I../lib "$@" && cover

Saga->cargar('WhiteWolf');

describe "Como desarrollador quiero fabricar vampiros" => sub {
  context "CUANDO ejecuto un comando vampiro con params" => sub {
    my $attributes = [shuffle(qw(7 5 3))];
    my $physical = shift @$attributes;
    my $social = shift @$attributes;
    my $mental = shift @$attributes;
    my $abilities = [shuffle(qw(13 9 5))];
    my $talents = shift @$abilities;
    my $skills = shift @$abilities;
    my $knowledge = shift @$abilities;
    my $background = 5;
    my $virtues = 7;
    my $comando = Saga->despachar('Comando::Hacer::Vampire')->new;
    my $persona = $comando->ejecutar(
      protagonismo => 'principal',
      physical => $physical,
      social => $social,
      mental => $mental,
      talent => $talents,
      skill => $skills,
      knowledge => $knowledge,
      background => $background,
      virtue => $virtues,
    );
    it "ENTONCES debo tener una vampiro" => sub {
      is $persona->especie->valor, 'vampire';
      ok $persona->es('vampire');
      ok $persona->abrazo;
      ok $persona->abrazo->valor;
      isa_ok $persona->abrazo->valor, 'Situacion';
      ok $persona->sire;
      ok $persona->sire->valor;
      isa_ok $persona->sire->valor, 'Persona';
      ok $persona->generacion;
      ok $persona->generacion->valor;
      ok $persona->antiguedad;
      ok $persona->antiguedad->valor;
      ok $persona->edad_aparente;
      ok $persona->edad_aparente->valor;
      cmp_ok(Saga->dt($persona->nacimiento->valor->fecha)->epoch, '<', Saga->dt($persona->abrazo->valor->fecha)->epoch);
      ok $persona->strength->valor;
      ok $persona->dexterity->valor;
      ok $persona->stamina->valor;
      ok $persona->charisma;
      ok $persona->manipulation;
      ok $persona->appearance;
      ok $persona->perception;
      ok $persona->intelligence;
      ok $persona->wits;
      is $persona->sum('physical'), $physical + 3;
      is $persona->sum('social'), $social + 3;
      is $persona->sum('mental'), $mental + 3;
      is $persona->sum('attribute'), $physical + $social + $mental + 9;
      is $persona->sum('talent'), $talents;
      is $persona->sum('skill'), $skills;
      is $persona->sum('knowledge'), $knowledge;
      is $persona->sum('ability'), $talents + $skills + $knowledge;
      is $persona->sum('background'), $background;
      is $persona->sum('virtue'), $virtues + 3;
      is $persona->willpower->valor, $persona->courage->valor;
      is $persona->humanity->valor, $persona->self_control->valor + $persona->conscience->valor;
      like $persona->describir, qr/generacion/;
    };
  };
};