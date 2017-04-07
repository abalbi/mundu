package Persona;
use Data::Dumper;
use fields qw(_items);
use base qw(Base);

our $AUTOLOAD;

=item
Constructor
=cut
sub new {
  my $class = shift;
  my $params = Saga->params(@_);
  my $self = fields::new($class);
  $self->{_items} = [];
  $self->params($params);
  $self;
}

sub AUTOLOAD {
  my $self = shift;
  my $method = $AUTOLOAD;
  my $params = Saga->params(@_);
  $method =~ s/.*:://;
  my $propiedad = $self->propiedad($method);
  return $propiedad if defined $propiedad;
  $self->logger()->logconfess("No se encontro Persona::$method en fecha ".Saga->entorno->fecha_actual);
}


sub items {
  my $self = shift;
  return $self->{_items};
}

sub agregar {
  my $self = shift;
  my $items = [@_];
  if(scalar grep {not $_->isa('Persona::Propiedad')} @$items) {
    $self->logger->logconfess("Para agregar a una Persona debe ser una Persona::Propiedad");
  }
  push @{$self->items}, @$items;
  foreach my $item (@$items) {
    $item->params(persona => $self);
  }
}

sub propiedad {
  my $self = shift;
  my $key = shift;
  my $propiedad = [grep {$_->key eq $key} @{$self->propiedades}];
  return undef if scalar @{$propiedad} == 0;
  return $propiedad->[0] if scalar @{$propiedad} == 1;
  return $propiedad;
}

sub propiedades {
  my $self = shift;
  my $valor = [grep {$_->isa('Persona::Propiedad')} @{$self->items}];
  return $valor;
}

sub categorias {
  my $self = shift;
  my $valor = [grep {$_->isa('Persona::Propiedad::Categoria')} @{$self->items}];
  return $valor;
}

sub tiene {
  my $self = shift;
  my $key = shift;
  return 1 if scalar grep {$_->key eq $key} @{$self->propiedades};
  return 0;  
}

sub describir {
  my $self = shift;
  my $str;
  $str .= $self->nombre->t;
  $str .= ',';
  $str .= $self->edad->t;
  $str .= ',';
  $str .= $self->sexo->t;
  return $str;
}

sub es {
  my $self = shift;
  my $key = shift;
  return scalar grep {$_->valor eq $key} @{$self->categorias}
}


1;