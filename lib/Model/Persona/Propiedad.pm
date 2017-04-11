package Persona::Propiedad;
use Data::Dumper;
use fields qw(_key _items _persona _flags);
use base qw(Base);

=item
Constructor
=cut
sub new {
  my $class = shift;
  my $params = Saga->params(@_)->params_requeridos(qw(key));
  my $self = fields::new($class);
  $self->{_items} = [];
  $self->params($params);
  $self;
}

sub params {
  my $self = shift;
  my $params = Saga->params(@_)->params_validos(qw(persona));
  $self->SUPER::params($params);
}

sub key {
  my $self = shift;
  return $self->{_key};
}

sub agregar_alteracion {
  my $self = shift;
  my $params = Saga->params(@_)->params_validos(qw(key));
  $params->key($self->key);
  my $alteracion = Saga->despachar('Alteracion')->new($params);
  $self->agregar($alteracion);  
}

sub agregar {
  my $self = shift;
  my $items = [@_];
  if(scalar grep {not $_->isa('Alteracion')} @$items) {
    $self->logger->logconfess("Para agregar a una Persona::Propiedad debe ser una Alteracion");
  }
  push @{$self->items}, @$items;
}

sub items {
  my $self = shift;
  $self->{_items};
}

sub alteraciones {
  my $self = shift;
  my $valor = [grep {$_->isa('Alteracion')} @{$self->items}];
  return $valor;
}

sub valor {
  my $self = shift;
  my $fecha = Saga->dt(Saga->entorno->fecha_actual);
  my $valor;
  foreach my $alteracion (sort {$a->fecha cmp $b->fecha} grep {$_->key eq $self->key} @{$self->alteraciones}) {
    my $fecha_alteracion = Saga->dt($alteracion->fecha);
    if($fecha_alteracion) {
      next if $fecha->epoch < $fecha_alteracion->epoch;
    }
    if(defined $alteracion->fecha_vencimiento) {
      next if $fecha->epoch > Saga->dt($alteracion->fecha_vencimiento)->epoch;
    }
    $valor = $alteracion->valor;
  }
  return $valor;
}

sub t {
  my $self = shift;
  $self->valor;
}

sub persona {
  my $self = shift;
  return $self->{_persona};
}

sub es {
  my $self = shift;
  my $key = shift;
  return scalar grep {$key eq $_} @{$self->flags};  
}

sub flags {
  my $self = shift;
  $self->{_flags} = [] if not $self->{_flags};
  return $self->{_flags};  
}
1;