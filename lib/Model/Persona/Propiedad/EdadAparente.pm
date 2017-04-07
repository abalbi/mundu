package Persona::Propiedad::EdadAparente;
use strict;
use Data::Dumper;
use base qw(Persona::Propiedad);
use fields qw();

sub new {
	my $class = shift;
	my $params = Saga->params(@_)->params_validos(qw(key));
	$params->key('edad_aparente');
  my $self = $class->SUPER::new($params);
  return $self;
}

sub valor {
	my $self = shift;
	return Saga->dt($self->persona->abrazo->valor)->year - Saga->dt($self->persona->nacimiento->valor)->year;
}
1;