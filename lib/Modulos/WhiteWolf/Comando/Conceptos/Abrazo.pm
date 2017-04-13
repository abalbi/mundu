package WhiteWolf::Comando::Conceptos::Abrazo;
use strict;
use Data::Dumper;
use fields qw();
use base qw(Comando);

=item
Tipo return
=cut
sub tipo_return {'Saga::Params'};

=item
Agrega nombre
=cut
sub _ejecutar {
  my $self = shift;
  my $params = Saga->params(@_)
    ->params_validos(qw(edad_aparente fecha_nacimiento edad))
    ->params_excluyentes(qw(fecha_abrazo antiguedad));
  my $fecha_nacimiento = $params->fecha_nacimiento;
  my $edad = $params->edad;
  my $fecha_abrazo = $params->fecha_abrazo;
  my $antiguedad = $params->antiguedad;
  my $edad_aparente = $params->edad_aparente;
  if($edad_aparente && $edad_aparente !~ /^\d+$/) {
    $self->logger->logconfess("El param edad_aparente no esta correctamente definifo: '$edad_aparente'");
  }
  if($edad && $edad !~ /^\d+$/) {
    $self->logger->logconfess("El param edad no esta correctamente definifo: '$edad'");
  }
  if($antiguedad && $antiguedad !~ /^\d+$/) {
    $self->logger->logconfess("El param antiguedad no esta correctamente definifo: '$antiguedad'");
  }
  if($edad && $edad_aparente && ($edad < $edad_aparente)) {
    $self->logger->logconfess("La edad($edad) no puede ser menor a la edad aparente($edad_aparente)");
  }
  if($edad && $edad_aparente && $antiguedad && ($edad != $antiguedad + $edad_aparente)) {
    $self->logger->logconfess("La suma de edad aparente + antiguedad(",$antiguedad + $edad_aparente,") no es igual a la edad($edad)");
  }
  if(ref $fecha_abrazo eq 'HASH') {
    if($fecha_nacimiento) {
      $fecha_nacimiento = Saga->dt_random($fecha_nacimiento);
      $fecha_abrazo->{desde} = $fecha_nacimiento;
    }
  }
  $fecha_nacimiento = Saga->dt_random($fecha_nacimiento) if $fecha_nacimiento;
  $fecha_abrazo = Saga->dt_random($fecha_abrazo) if $fecha_abrazo;
  while (!($edad && $edad_aparente && $antiguedad && $fecha_nacimiento && $fecha_abrazo)) {
    if(!$fecha_nacimiento) {
      $fecha_nacimiento = Saga->dt(Saga->entorno->fecha_inicio)->subtract(years => $edad)->datetime if $edad;
    } else {
      $edad = Saga->dt(Saga->entorno->fecha_inicio)->year - Saga->dt($fecha_nacimiento)->year;
    }
    if(!$fecha_abrazo) {
      $fecha_abrazo = Saga->dt(Saga->entorno->fecha_inicio)->subtract(years => $antiguedad)->datetime if $antiguedad;
    } else {
      $antiguedad = Saga->dt(Saga->entorno->fecha_inicio)->year - Saga->dt($fecha_abrazo)->year;
    }
    if($fecha_nacimiento && $fecha_abrazo) {
      $edad_aparente = Saga->dt($fecha_abrazo)->year -  Saga->dt($fecha_nacimiento)->year if !$edad_aparente;
    }
    $antiguedad = $edad - $edad_aparente if $edad && $edad_aparente; 
    $edad = $antiguedad + $edad_aparente if $antiguedad && $edad_aparente;
    $edad_aparente = $edad - $antiguedad if $edad && $antiguedad;

    $edad_aparente = $self->calcula_edad_aparente if !$edad_aparente;
    $antiguedad = Saga->azar([1..50]) if !$antiguedad;
    $edad = $antiguedad + $edad_aparente if !$edad;

    $params->fecha_nacimiento($fecha_nacimiento);
    $params->fecha_abrazo($fecha_abrazo);
    $params->antiguedad($antiguedad);
    $params->edad($edad);
    $params->edad_aparente($edad_aparente);
  }
  $params->fecha_nacimiento($fecha_nacimiento);
  $params->fecha_abrazo($fecha_abrazo);
  $params->borrar('edad');
  $params->borrar('edad_aparente');
  $params->borrar('antiguedad');
  return $params;  
}

=item
Calcula la edad aparente
=cut
sub calcula_edad_aparente {
  my $self = shift;
  my $porcentaje = shift;
  $porcentaje = Saga->azar(100) if not defined $porcentaje;
  my $edad_aparente;
  return Saga->azar([1..10]) if $porcentaje <= 10;
  return Saga->azar([10..20]) if $porcentaje <= 30;
  return Saga->azar([20..40]) if $porcentaje <= 60;
  return Saga->azar([40..70]) if $porcentaje <= 80;
  return Saga->azar([80..90]);
}
1;

 