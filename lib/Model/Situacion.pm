package Situacion;
use Data::Dumper;
use fields qw(_roles _fecha _key);
use base qw(Base);
=item
Constructor
=cut
sub new {
  my $class = shift;
  my $params = Saga->params(@_)->params_requeridos(qw(fecha))->params_validos(qw(key));
  my $self = fields::new($class);
  $self->{_roles} = [];
  $self->params($params);
  $self;
}

sub rol {
  my $self = shift;
	my $key = shift;
	my $persona = shift;
	my $rol = Saga->despachar('Situacion::Rol')->new(key => $key, persona => $persona) if defined $persona;
	push @{$self->roles}, $rol if defined $rol;
	my $roles = [grep {$_->key eq $key} @{$self->roles}];
	return $roles->[0] if scalar @$roles == 1;
	return $roles;
}

sub roles {
  my $self = shift;
  return $self->{_roles};
}

sub fecha {
  my $self = shift;
  return $self->{_fecha};
}
1;