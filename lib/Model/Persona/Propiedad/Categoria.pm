package Persona::Propiedad::Categoria;
use strict;
use Data::Dumper;
use base qw(Persona::Propiedad);
use fields qw();

sub new {
	my $class = shift;
	my $params = Saga->params(@_)->params_requeridos(qw(key));
  my $self = $class->SUPER::new($params);
  return $self;
}

1;