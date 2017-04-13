package Persona::Propiedad::Sire;
use strict;
use Data::Dumper;
use base qw(Persona::Propiedad);
use fields qw();

sub new {
	my $class = shift;
	my $params = Saga->params(@_)->params_validos(qw(key));
	$params->key('sire');
  my $self = $class->SUPER::new($params);
  return $self;
}

sub valor {
	my $self = shift;
	return $self->persona->fecha_abrazo->valor->rol('sire')->persona;
}
1;