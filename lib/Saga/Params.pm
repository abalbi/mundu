package Saga::Params;
use base qw(Base);
use Data::Dumper;
use fields qw(_items _fields _params_libres _params_validos _params_requeridos _params_excluyentes);

our $AUTOLOAD;

=item
Constructor
=cut
sub new {
  my $class = shift;
  my $fields = shift;
  my $params = shift;
  my $self = fields::new($class);
  $self->{_items} = {};
  $self->{_fields} = $fields;
  foreach my $key (sort keys %$params) {
    $self->{_items}->{$key} = $params->{$key};
  }
  $self;
}

=item
Serializa en un string los parametros
=cut
sub serializar {
  my $self = shift;
  my @str;
  foreach my $key (sort keys %{$self->items}) {
    push @str, $key.': '.$self->items->{$key};
  }
  return join ', ', @str;
}

=item
Devuelve items
=cut
sub items {
  my $self = shift;
  return $self->{_items};
}

sub AUTOLOAD {
  my $method = $AUTOLOAD;
  my $self = shift;
  my $valor = shift;
  $method =~ s/.*:://;
  my $propiedad = $method;
  $self->params_validar($propiedad);
  $self->items->{$propiedad} = $valor if defined $valor;
  return $self->items->{$propiedad};
}

=item
Valida si fueron definidos los parametros validos
=cut
sub params_validar {
  my $self = shift;
  my $propiedad = shift;
  my $args = $self->{_fields}->{$propiedad};
  if(!$self->{_params_libres}) {
    if(not scalar grep {$propiedad eq $_} @{$self->{_params_validos}}) {
      logger()->logconfess("El param '$propiedad' no esta definido");
    }
  }
}

=item
Define params requeridos y lo valida
=cut
sub params_requeridos {
  my $self = shift;
	push @{$self->{_params_requeridos}}, @_;
	push @{$self->{_params_validos}}, @_;
	foreach my $key (@{$self->{_params_requeridos}}) {
		logger()->logconfess("El param '$key' es requerido") if not defined $self->$key;
	}
	return $self;
}

=item
Define params validos
=cut
sub params_validos {
  my $self = shift;
	push @{$self->{_params_validos}}, @_;
	return $self;
}

=item
Desactiva params_validar
=cut
sub params_libres {
  my $self = shift;
	@{$self->{_params_libres}} = 1;
	return $self;
}

=item
Define params que se excluyen entre si
=cut
sub params_excluyentes {
  my $self = shift;
  push @{$self->{_params_excluyentes}}, @_;
  push @{$self->{_params_validos}}, @_;
  my $excluyentes = [];
  foreach my $key (@{$self->{_params_excluyentes}}) {
    push @$excluyentes, $key if defined $self->$key;
  }
  $self->logger()->logconfess("No se puede definir al mismo tiempo los params ".join(',', @$excluyentes)."") if scalar @$excluyentes > 1;
  return $self;
}

=item
Logger
=cut
sub logger {
  my $logger = Log::Log4perl->get_logger(__PACKAGE__);
  $logger->level($Saga::LogLevel);
  return $logger;
}

=item
Convierte los items de un objeto Params a un hash 
=cut
sub en_hash {
  my $self = shift;
	return %{$self->{_items}};	
}

=item
Borra params
=cut
sub borrar {
  my $self = shift;
  my $key = shift;
  delete $self->items->{$key};  
}
1;