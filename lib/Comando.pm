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
	$self->validar_persona($params);
	return $self->_ejecutar($params);	
}

=item
Validad propiedades de persona
=cut
sub validar_persona {
  my $self = shift;
  my $params = Saga->params(@_)->params_validos(qw(persona));
	if($params->persona) {
		foreach my $propiedad (@{$self->persona_propiedades_obligatorios}) {
			$self->logger->logconfess("La persona debe tener la propiedad '$propiedad' con valor") if not $params->persona->tiene($propiedad);
		}
	}
	return 1;	
}
1;