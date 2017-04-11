package Comando::Agregar::Clan;
use strict;
use Data::Dumper;
use fields qw();
use base qw(Comando);

=item
Agrega nombre
=cut
sub _ejecutar {
	my $self = shift;
  my $params = Saga->params(@_)->params_requeridos(qw(persona))->params_validos(qw(clan fecha));
  my $persona = $params->persona;
  my $fecha = $params->fecha;
  $fecha = Saga->entorno->fecha_actual;
  if(not $persona->tiene('especie')) {
    Saga->despachar('Comando::Agregar::Especie')->new->ejecutar(persona => $persona, especie => 'vampire'); 
  }
  my $clan = $params->clan;
  $clan = $self->calcula_clan if !$clan;
  $persona->agregar(Saga->despachar('Persona::Propiedad::Categoria')->new(key => 'clan'));
  $persona->clan->agregar_alteracion(valor => $clan, fecha => $fecha);
}

sub calcula_clan {
  my $self = shift;
  my $porcentaje = shift;
  $porcentaje = Saga->azar(100) if not defined $porcentaje;
  my $edad_aparente;
  return 'brujah' if $porcentaje <= 15;
  return 'gangrel' if $porcentaje <= 25;
  return 'malkavian' if $porcentaje <= 40;
  return 'nosferatu' if $porcentaje <= 55;
  return 'toreador' if $porcentaje <= 75;
  return 'tremere' if $porcentaje <= 85;
  return 'ventrue';
}

1;

