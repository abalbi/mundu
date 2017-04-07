package Comando::Vampire;
use strict;
use Data::Dumper;
use fields qw();
use base qw(Comando::Persona);

=item
Crea un vampiro
=cut
sub _ejecutar {
  my $self = shift;
  my $params = Saga->params(@_)
    ->params_validos(qw(persona edad_aparente edad fecha_nacimiento))
    ->params_excluyentes(qw(fecha_abrazo antiguedad));
  my $fecha_abrazo = $self->calcula_fecha_abrazo($params);
  my $persona = $self->SUPER::_ejecutar($params);
  my $situacion;
  Saga->en_fecha($fecha_abrazo, sub {
    $situacion = Saga->despachar('Comando::Hacer::Situacion')->new->ejecutar(
      key => 'abrazo',
      sujeto => $persona,
    );
  });
  Saga->despachar('Comando::Agregar::Especie')->new->ejecutar(persona => $persona, especie => 'vampire'); 
  $persona->agregar(Saga->despachar('Persona::Propiedad::Antiguedad')->new);
  $persona->agregar(Saga->despachar('Persona::Propiedad::Abrazo')->new);
  $persona->abrazo->agregar_alteracion(valor => $situacion);
  $persona->agregar(Saga->despachar('Persona::Propiedad::EdadAparente')->new);
  return $persona;
}

sub calcula_fecha_abrazo {
  my $self = shift;
  my $params = shift;
  my $antiguedad = $params->antiguedad;
  my $fecha_abrazo = $params->fecha_abrazo;
  my $edad_aparente = $params->edad_aparente;
  my $fecha_nacimiento = $params->fecha_nacimiento;
  if (defined $antiguedad && $antiguedad !~ /^\d+$/) {
    $self->logger->logconfess("El param antiguedad no esta correctamente definifo: '". $params->antiguedad."'")
  }
  if (defined $edad_aparente && $edad_aparente !~ /^\d+$/) {
    $self->logger->logconfess("El param edad_aparente no esta correctamente definifo: '". $params->edad_aparente."'")
  }
  if($fecha_nacimiento) {
    $fecha_nacimiento = Saga->dt_random($params->fecha_nacimiento);
    $params->edad(Saga->dt(Saga->entorno->fecha_inicio)->year - Saga->dt($fecha_nacimiento)->year);
    $params->borrar('fecha_nacimiento');
    if(ref $fecha_abrazo eq 'HASH') {
      $fecha_abrazo->{desde} = $fecha_nacimiento if !$fecha_abrazo->{desde};
    }
  }
  if($fecha_abrazo) {
    $fecha_abrazo = Saga->dt_random($fecha_abrazo);
    if($params->edad) {
    } else {
      $edad_aparente = $self->calcula_edad_aparente if !$edad_aparente;
      $fecha_nacimiento = Saga->dt_string(year => Saga->dt($fecha_abrazo)->year - $edad_aparente)->datetime;
      $params->edad(Saga->dt(Saga->entorno->fecha_inicio)->year - Saga->dt($fecha_nacimiento)->year);
    }
    $antiguedad = Saga->dt(Saga->entorno->fecha_inicio)->year - Saga->dt($fecha_abrazo)->year;
    $edad_aparente = $params->edad - $antiguedad if !$edad_aparente;
  }
  $edad_aparente = $self->calcula_edad_aparente if !$edad_aparente;
  if(not defined $antiguedad) {
    if($params->edad) {
      $antiguedad = $params->edad - $edad_aparente;
    } else {
      $antiguedad = Saga->azar(100);
    }
  }
  if(not defined $params->edad) {
    $params->edad($edad_aparente + $antiguedad);
  }
  if($params->edad < $edad_aparente) {
    $self->logger->logconfess("La edad(".$params->edad.") no puede ser menor a la edad aparente($edad_aparente)");
  }
  if($edad_aparente + $antiguedad != $params->edad) {
    $self->logger->logconfess("La suma de edad aparente + antiguedad(".($edad_aparente + $antiguedad).") no es igual a la edad(".$params->edad.")");    
  }
  $fecha_abrazo = Saga->dt_string(year => Saga->dt(Saga->entorno->fecha_inicio)->year - $params->edad + $edad_aparente)->datetime;
  $fecha_abrazo = Saga->dt_random($fecha_abrazo);
  return $fecha_abrazo;  
}

sub calcula_edad_aparente {
  my $self = shift;
  my $porcentaje = shift;
  $porcentaje = Saga->azar(100) if not defined $porcentaje;
  my $edad_aparente;
  return Saga->azar([1..10]) if $porcentaje <= 10;
  return Saga->azar([10..20]) if $porcentaje <= 20;
  return Saga->azar([20..40]) if $porcentaje <= 50;
  return Saga->azar([40..70]) if $porcentaje <= 70;
  return Saga->azar([80..100]);
}
1;

