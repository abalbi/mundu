package Persona;
use Data::Dumper;
use fields qw(_items _tpl);
use base qw(Base);
use Template::Simple;

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
  my $keys = shift;
  $keys = [$keys] if not ref $keys eq 'ARRAY';
  foreach my $key (@$keys) {
    return 0 if not scalar grep {$_->key eq $key} @{$self->propiedades};
  }
  return 1;  
}

sub describir {
  my $self = shift;
  my $str;
  if($self->template) {
    my $data = $self->hash_tagged;
    $str = ${Template::Simple->new->render( \$self->template, $data )};
    $str =~ s/\n\n/\n/g while $str =~ /\n\n/;
  } else {
    $str .= $self->nombre->t;
    $str .= ',';
    $str .= $self->edad->t;
    $str .= ',';
    $str .= $self->sexo->t;
  }
  return $str;
}

sub es {
  my $self = shift;
  my $key = shift;
  return scalar grep {$_->valor eq $key} @{$self->categorias}
}

sub hash {
  my $self = shift;
  my $keys = [@_];
  my $hash = {};
  if(not scalar @$keys) {
    $keys = [map {$_->key} @{$self->propiedades}];
  }
  map {
    $hash->{$_} = $self->$_->valor->fecha if ref $self->$_->valor eq 'Situacion';
    $hash->{$_} = $self->$_->valor->nombre->valor if ref $self->$_->valor eq 'Persona';
    $hash->{$_} = $self->$_->valor if not exists $hash->{$_} && $self->$_->valor;
  } @$keys;
  return $hash;
}

sub hash_tagged {
  my $self = shift;
  $hash = $self->hash(@_);
  my $hash_tagged = {};
  foreach my $key (sort keys %$hash) {
    my $flags = $self->$key->flags;
    if(scalar @$flags) {
      foreach my $flag (@$flags) {
        $hash_tagged->{$flag} = [] if !$hash_tagged->{$flag};
        push @{$hash_tagged->{$flag}}, {key => $key, valor => $hash->{$key}};
      }
    } else {
      $hash_tagged->{$key} = $hash->{$key}      
    }
  }
  return $hash_tagged;
}

sub sum {
  my $self = shift;
  my $key = shift;
  my $keys = [];
  foreach my $item (@{$self->propiedades}) {
    if($item->es($key)) {
      push @$keys, $item->key;
    }
  }
  return Saga->sum($self->hash(@$keys));
}

sub template {
  my $self = shift;
  my $tpl = shift;
  $self->{_tpl} = $tpl if defined $tpl;
  $self->{_tpl};
}
1;