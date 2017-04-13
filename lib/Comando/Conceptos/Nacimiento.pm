package Comando::Conceptos::Nacimiento;
use strict;
use Data::Dumper;
use fields qw();
use base qw(Comando);

=item
Tipo return
=cut
sub tipo_return {'Situacion'};

=item
Agrega nacimiento y edad a persona
=cut
sub _ejecutar {
	my $self = shift;
  my $params = Saga->params(@_)->params_requeridos('persona')->params_excluyentes(qw(fecha_nacimiento edad));
  my $persona = $params->persona;
  my $fecha_nacimiento = $self->parsea_fecha_nacimiento($params->fecha_nacimiento);
  my $edad = $params->edad;
  if(not defined $fecha_nacimiento) {
  	$edad = Saga->azar([13..30]) if not defined $edad;
  	$edad = Saga->azar($edad) if ref $edad eq 'ARRAY';
  	$self->logger->logconfess("El param edad no esta correctamente definifo: ". $params->edad) if $edad !~ /^\d+$/;
  	$fecha_nacimiento = Saga->dt(Saga->entorno->fecha_actual)->subtract(years => $edad)->datetime;
  }
  my $situacion;
  Saga->en_fecha($fecha_nacimiento, sub {
  	$situacion = Saga->despachar('Comando::Hacer::Situacion')->new->ejecutar(
  		key => 'nacimiento',
  		sujeto => $persona,
  	);
    $persona->agregar(Saga->despachar('Persona::Propiedad::Nacimiento')->new);
    $persona->nacimiento->agregar_alteracion(valor => $situacion, fecha => Saga->entorno->fecha_actual);
  });
  $persona->agregar(Saga->despachar('Persona::Propiedad::Edad')->new);
	return $situacion;
}

sub parsea_fecha_nacimiento {
  my $self = shift;
  my $params = Saga->params(@_) if ref $_[0] eq 'HASH';
  return shift @_ if not defined $params;
  Saga->dt_random($params);
}
1;

