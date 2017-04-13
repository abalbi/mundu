package Comando;
use strict;
use Data::Dumper;
use fields qw();
use base qw(Base);

=item
Constructor
=cut
sub new {
  my $class = shift;
  my $params = Saga->params(@_);
  my $self = fields::new($class);
  $self->params($params);
  $self;
}

=item
Ejecuta la validacion y ejecuta el comando especifico
=cut
sub ejecutar {
  my $self = shift;
  my $params = Saga->params(@_);
	my $res = $self->_ejecutar($params);
	if(not $res->isa($self->tipo_return)) {
		$self->logger->logconfess("Se espera que $self devuelva un tipo ". $self->tipo_return);
	}
	return $res;	
}

1;