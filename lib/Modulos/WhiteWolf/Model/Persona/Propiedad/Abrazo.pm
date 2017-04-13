package Persona::Propiedad::Abrazo;
use strict;
use Data::Dumper;
use base qw(Persona::Propiedad);
use fields qw();

sub new {
	my $class = shift;
	my $params = Saga->params(@_)->params_validos(qw(key));
	$params->key('fecha_abrazo');
  my $self = $class->SUPER::new($params);
  return $self;
}

sub agregar_alteracion {
	my $self = shift;
	my $params = Saga->params(@_)->params_validos('key');
	$params->key('fecha_abrazo');
  $self->SUPER::agregar_alteracion($params);
}

sub valor {
	my $self = shift;
	my $valor = $self->SUPER::valor;
	return $valor;
}

1;