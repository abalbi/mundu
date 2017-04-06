package Alteracion;
use base qw(Base);
use Data::Dumper;
use fields qw(_key _valor _fecha _vencimiento);

our $AUTOLOAD;

sub new {
  my $class = shift;
  my $params = Saga->params(@_)->params_validos(qw(key valor fecha vencimiento));
  my $self = fields::new($class);
  $self->params($params);
  $self;
}


sub key {
  my $self = shift;
  return $self->{_key};
}

sub valor {
  my $self = shift;
  return $self->{_valor};
}

sub fecha {
  my $self = shift;
  return $self->{_fecha};
}

sub vencimiento {
  my $self = shift;
  return $self->{_vencimiento};
}

sub fecha_vencimiento {
  my $self = shift;
  return undef if not defined $self->vencimiento;
	my $fecha_vencimiento = Saga->dt_string(epoch => Saga->dt($self->fecha)->epoch + Saga->code2seconds($self->vencimiento))->datetime;
	return $fecha_vencimiento;	
}


1;