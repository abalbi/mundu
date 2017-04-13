package Comando::Agregar::Estadisticas;
use strict;
use Data::Dumper;
use fields qw(_min _max);
use base qw(Comando);

=item
Tipo return
=cut
sub tipo_return {'Persona'};

=item
Agrega sexo
=cut
sub _ejecutar {
  my $self = shift;
  my $params = Saga->params(@_)->params_requeridos(qw(persona atributos min max puntos))->params_libres;
  my $persona = $params->persona;
  my $atributos = $params->atributos;
  $self->min($params->min);
  $self->max($params->max);
  my $puntos = $params->puntos;
  my $hash = {};
  map {$hash->{$_} = $self->min} @{$atributos};
  map {$hash->{$_} = $params->$_ if defined $params->$_} @{$atributos};
  my $sum_preasignados = 0;
  map {$sum_preasignados = ($sum_preasignados - $self->min + $params->$_) if defined $params->$_} @$atributos;
  my $sum_defaults = 0;
  map {$sum_defaults += $self->min} grep {not defined $params->$_} @$atributos;
  my $sum_libres = 0;
  map {$sum_libres += (5 - $self->min)} grep {not defined $params->$_} @$atributos;
  my $puntos_asignables = $puntos - $sum_preasignados;
  if($sum_preasignados > $puntos) {
    $self->logger->logconfess("Se preasignaron mas puntos($sum_preasignados) que los puntos a asignar($puntos)");
  }
  if($puntos_asignables > $sum_libres) {
    $self->logger->logconfess("Los puntos asignables($puntos_asignables) son mas que los espacios disponibles($sum_libres)");
  }
  foreach my $atributo (@$atributos) {
    if (defined $params->$atributo && not $self->validar_valor($params->$atributo)) {
      $self->logger->logconfess("El atributo $atributo(".$params->$atributo.") no esta entre al min(".$self->min.") y max(".$self->max.")")
    }
  }
  while (Saga->sum($hash) < $puntos + (scalar @$atributos * $self->min)) {
    my $atr = Saga->azar($atributos);
    if(not defined $params->$atr) {
      $hash->{$atr}++;
    }
  }
  foreach my $atributo (@{$atributos}) {
    $persona->agregar(Saga->despachar('Persona::Propiedad')->new(key => $atributo, flags => $params->flags));
    if($hash->{$atributo}) {
      my $params_alteracion = {};
      $params_alteracion->{valor} = $hash->{$atributo};
      $params_alteracion->{fecha} = Saga->entorno->fecha_inicio;
      $persona->$atributo->agregar_alteracion($params_alteracion);
    }
  }
  return $persona;
}

sub validar_valor {
  my $self = shift;
  my $valor = shift;
  my $min = $self->min;
  my $max = $self->max;
  return scalar grep {$_ == $valor} ($min..$max);
}

sub min {
  my $self = shift;
  my $valor = shift;
  $self->{_min} = 0 if !$self->{_min};
  $self->{_min} = $valor if defined $valor;
  return $self->{_min};
}

sub max {
  my $self = shift;
  my $valor = shift;
  $self->{_max} = 10 if !$self->{_max};
  $self->{_max} = $valor if defined $valor;
  return $self->{_max};
}
1;

