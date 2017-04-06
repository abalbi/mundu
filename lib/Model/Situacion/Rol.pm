package Situacion::Rol;
use Data::Dumper;
use fields qw(_key _persona);
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

sub params {
  my $self = shift;
  my $params = Saga->params(@_)->params_requeridos(qw(key persona));
	foreach my $key (sort keys %{$params->items}) {
    if($key eq 'persona') {
      my $boo = 1;
      $boo = 0 if not ref $params->$key;
      $boo = 0 if not $params->$key->isa('Persona');
      $self->logger->logconfess('Para agregar a un Rol de una Situacion debe ser una Persona') if !$boo;
    }
  	$self->{'_'.$key} = $params->$key;
	}
	$self;
}

sub key {
  my $self = shift;
  return $self->{_key};
}

sub persona {
  my $self = shift;
  return $self->{_persona};
}

1;