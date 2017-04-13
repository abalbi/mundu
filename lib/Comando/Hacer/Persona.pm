package Comando::Persona;
use strict;
use Data::Dumper;
use fields qw();
use base qw(Comando);


sub tipo_return {'Persona'};

=item
Agrega sexo
=cut
sub _ejecutar {
  my $self = shift;
  my $params = Saga->params(@_)->params_libres;
  my $persona = Saga->despachar('Persona')->new;
  Saga->despachar('Comando::Conceptos::Nacimiento')->new->ejecutar(persona => $persona, edad => $params->edad, fecha_nacimiento => $params->fecha_nacimiento);
  Saga->despachar('Comando::Conceptos::Sexo')->new->ejecutar(persona => $persona, sexo => $params->sexo);
  Saga->despachar('Comando::Conceptos::Nombre')->new->ejecutar(persona => $persona, nombre => $params->nombre);
	Saga->entorno->agregar($persona);
  return $persona;
}

1;

