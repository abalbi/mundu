package Comando::Conceptos::Sexo;
use strict;
use Data::Dumper;
use fields qw();
use base qw(Comando);

=item
Tipo return
=cut
sub tipo_return {'Persona'};

=item
Agrega sexo
=cut
sub _ejecutar {
	my $self = shift;
  my $params = Saga->params(@_)->params_requeridos('persona')->params_validos(qw(sexo));
  my $persona = $params->persona;
  my $sexo = $params->sexo;
  $sexo = Saga->azar([qw(f m)]) if not defined $sexo;
  $persona->agregar(Saga->despachar('Persona::Propiedad')->new(key => 'sexo'));
  my $params_alteracion = {};
  $params_alteracion->{valor} = $sexo;
  $params_alteracion->{fecha} = $persona->fecha_nacimiento->valor;
  $persona->sexo->agregar_alteracion($params_alteracion);
  return $persona;
}

1;

