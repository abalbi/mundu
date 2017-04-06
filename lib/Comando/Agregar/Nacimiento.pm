package Comando::Agregar::Nacimiento;
use strict;
use Data::Dumper;
use fields qw();
use base qw(Comando);


=item
Agrega nacimiento y edad a persona
=cut
sub _ejecutar {
	my $self = shift;
  my $params = Saga->params(@_)->params_requeridos('persona')->params_validos(qw(fecha edad));
  my $persona = $params->persona;
  my $fecha = $params->fecha;
  my $edad = $params->edad;
  if(not defined $fecha) {
  	$edad = Saga->azar([13..30]) if not defined $edad;
  	$edad = Saga->azar($edad) if ref $edad eq 'ARRAY';
  	$self->logger->logconfess("El param edad no esta correctamente definifo: ". $params->edad) if $edad !~ /^\d+$/;
  	$fecha = Saga->dt(Saga->entorno->fecha_actual)->subtract(years => $edad)->datetime;
  }
  my $situacion;
  Saga->en_fecha($fecha, sub {
  	$situacion = Saga->despachar('Comando::Hacer::Situacion')->new->ejecutar(
  		key => 'nacimiento',
  		sujeto => $persona,
  	);
  });
  $persona->agregar(Saga->despachar('Persona::Propiedad::Nacimiento')->new);
  $persona->nacimiento->agregar_alteracion(valor => $situacion);
  $persona->agregar(Saga->despachar('Persona::Propiedad::Edad')->new);
	return $situacion;	
}

=item
Propiedades obligatorias para personas
=cut
sub persona_propiedades_obligatorios {
  return [];
}
1;

