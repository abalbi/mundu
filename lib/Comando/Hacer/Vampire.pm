package Comando::Vampire;
use strict;
use Data::Dumper;
use fields qw();
use base qw(Comando::Persona);

=item
Agrega sexo
=cut
sub _ejecutar {
  my $self = shift;
  my $params = Saga->params(@_);
  my $persona = $self->SUPER::_ejecutar($params);
  my $fecha = $params->fecha;
  my $antiguedad = $params->antiguedad;
  if(not defined $fecha) {
  	$antiguedad = $persona->edad->valor - Saga->azar([0..5]) if not defined $antiguedad;
  	$self->logger->logconfess("El param antiguedad no esta correctamente definifo: ". $params->antiguedad) if $antiguedad !~ /^\d+$/;
  	$fecha = Saga->dt(Saga->entorno->fecha_actual)->subtract(years => $antiguedad)->datetime;
  }
  my $situacion;
  Saga->en_fecha($fecha, sub {
  	$situacion = Saga->despachar('Situacion::Fabrica')->hacer(
  		key => 'abrazo',
  		sujeto => $persona,
  	);
  });
  $persona->agregar(Saga->despachar('Persona::Propiedad::Abrazo')->new);
  $persona->abrazo->agregar_alteracion(valor => $situacion);
  $persona->agregar(Saga->despachar('Persona::Propiedad::Antiguedad')->new);
  Saga->despachar('Comando::Agregar::Especie')->new->ejecutar(persona => $persona, especie => 'vampire');	
  return $persona
}

1;

