package WhiteWolf::Comando::Conceptos::Generacion;
use strict;
use Data::Dumper;
use fields qw();
use base qw(Comando);

=item
Tipo return
=cut
sub tipo_return {'Persona'}

=item
Agrega nombre
=cut
sub _ejecutar {
	my $self = shift;
  my $params = Saga->params(@_)->params_requeridos(qw(persona))->params_validos(qw(generacion fecha));
  my $persona = $params->persona;
  my $fecha = $params->fecha;
  $fecha = Saga->entorno->fecha_actual;
  my $generacion = $params->generacion;
  $generacion = $self->calcula_generacion if !$generacion;
  $persona->agregar(Saga->despachar('Persona::Propiedad')->new(key => 'generacion'));
  $persona->generacion->agregar_alteracion(valor => $generacion, fecha => $fecha);
  return $persona;
}

sub calcula_generacion {
  my $self = shift;
  my $porcentaje = shift;
  $porcentaje = Saga->azar(100) if not defined $porcentaje;
  return 13 if $porcentaje <= 15;
  return 12 if $porcentaje <= 25;
  return 11 if $porcentaje <= 40;
  return 10 if $porcentaje <= 55;
  return 9 if $porcentaje <= 75;
  return 8 if $porcentaje <= 85;
  return 7;
}

1;

