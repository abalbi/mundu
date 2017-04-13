package WhiteWolf::Comando::Conceptos::Concept;
use strict;
use Data::Dumper;
use fields qw();
use base qw(Comando);

=item
Tipo return
=cut
sub tipo_return {'Saga::Params'};

=item
Agrega nombre
=cut
sub _ejecutar {
	my $self = shift;
  my $params = shift->params_requeridos(qw(persona))->params_validos(qw(concept fecha));
  my $persona = $params->persona;
  my $fecha = $params->fecha;
  $fecha = Saga->entorno->fecha_actual;
  $params->concept($self->calcula_concept) if !$params->concept;
  my $sub = 'completar_'.$params->concept;
  $self->$sub($params) if $self->can($sub);
  my $categoria = Saga->despachar('Persona::Propiedad::Categoria')->new(key => 'concept');
  $persona->agregar($categoria);
  $categoria->agregar_alteracion(valor => $params->concept, fecha => $fecha);
  return $params;
}

sub calcula_concept {
  my $self = shift;
  my $porcentaje = shift;
  $porcentaje = Saga->azar(100) if not defined $porcentaje;
  my $edad_aparente;
  return 'detective';
}

sub completar_detective {
  my $self = shift;
  my $params = shift;
  my $concept = $params->concept;
  $params->merge(Saga->despachar('Comando::Conceptos::Concept')->new->ejecutar(concept => 'investigator', persona => $params->persona));
}

sub completar_investigator {
  my $self = shift;
  my $params = shift->params_validos(qw(firearms));
  my $concept = $params->concept;
  $params->firearms(Saga->azar([2..5]));
}

1;

