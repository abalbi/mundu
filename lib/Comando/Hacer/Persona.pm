package Comando::Persona;
use strict;
use Data::Dumper;
use fields qw();
use base qw(Comando);

=item
Agrega sexo
=cut
sub _ejecutar {
  my $self = shift;
  my $params = Saga->params(@_)->params_libres;
  my $persona = Saga->despachar('Persona')->new;
  Saga->despachar('Comando::Agregar::Nacimiento')->new->ejecutar(persona => $persona, edad => $params->edad, fecha_nacimiento => $params->fecha_nacimiento);
  Saga->despachar('Comando::Agregar::Sexo')->new->ejecutar(persona => $persona, sexo => $params->sexo);
  Saga->despachar('Comando::Agregar::Nombre')->new->ejecutar(persona => $persona, nombre => $params->nombre);
  return $persona;
}

1;

