package Entorno;
use Data::Dumper;
use fields qw(_items _fecha_actual _fecha_inicio);
use base qw(Base);

our $nombres_mujer  = [qw(Lucia Maria Martina Paula Daniela Sofia Valeria Carla Sara Alba Julia Noa Emma Claudia Carmen Marta Valentina Irene Adriana Ana Laura Elena Alejandra Ines Marina Vera Candela Laia Ariadna Lola Andrea Rocio Angela Vega Nora Jimena Blanca Alicia Clara Olivia Celia Alma Eva Elsa Leyre Natalia Victoria Isabel Cristina Lara Abril Triana Nuria Carolina Manuela Chloe Mia Mar Gabriela Mara Africa Iria Naia Helena Paola Noelia Nahia Miriam Salma)];
our $nombres_hombre = [qw(Hugo Daniel Pablo Alejandro Alvaro Adrian David Martin Mario Diego Javier Manuel Lucas Nicolas Marcos Leo Sergio Mateo Izan Alex Iker Marc Jorge Carlos Miguel Antonio Angel Gonzalo Juan Ivan Eric Ruben Samuel Hector Victor Enzo Jose Gabriel Bruno Dario Raul Adam Guillermo Francisco Aaron Jesus Oliver Joel Aitor Pedro Rodrigo Erik Marco Alberto Pau Jaime Luis Rafael Mohamed Dylan Marti Ian Pol Ismael Oscar Andres Alonso Biel Rayan Jan Fernando Thiago Arnau Cristian Gael Ignacio Joan)];


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

sub fecha_inicio {
  my $self = shift;
	$self->{_fecha_inicio} = Saga->dt_string(year => 1990)->datetime if not defined $self->{_fecha_inicio};
	return $self->{_fecha_inicio};	
}

sub fecha_actual {
  my $self = shift;
	my $fecha = shift;
	$self->{_fecha_actual} = $fecha if defined $fecha;
	$self->{_fecha_actual} = $self->fecha_inicio if not defined $self->{_fecha_actual};
	return $self->{_fecha_actual};	
}

sub situaciones {
	my $self = shift;
	return [grep {$_->isa('Situacion')} @{$self->items}];
}

sub items {
	my $self = shift;
	return $self->{_items};
}

sub agregar {
	my $self = shift;
	my $items = [@_];
	if(scalar grep {not $_->isa('Situacion')} grep {not $_->isa('Persona')} @$items) {
		$self->logger->logconfess("Para agregar a un Entorno debe ser una Situacion o Persona");
	}
	push @{$self->items}, @$items;
}

sub persona_nombres {
	my $self = shift;
	my $sexo = shift;
	return $nombres_hombre if $sexo eq 'm';	
	return $nombres_mujer;
}
1;