package Comando::Agregar::Especie;
use strict;
use Data::Dumper;
use fields qw();
use base qw(Comando);

=item
Agrega nombre
=cut
sub _ejecutar {
	my $self = shift;
  my $params = Saga->params(@_)->params_requeridos(qw(persona))->params_validos(qw(especie fecha));
  my $persona = $params->persona;
  my $fecha = $params->fecha;
  $fecha = Saga->entorno->fecha_actual;
  my $especie = $params->especie;
  $especie = 'humano' if not defined $especie;
  $persona->agregar(Saga->despachar('Persona::Propiedad::Categoria')->new(key => 'especie'));
  my $params_alteracion = {};
  $params_alteracion->{valor} = $especie;
  $params_alteracion->{fecha} = $fecha;
  $persona->especie->agregar_alteracion($params_alteracion);

}

1;

