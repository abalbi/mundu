package Comando::Agregar::Nombre;
use strict;
use Data::Dumper;
use fields qw();
use base qw(Comando);

=item
Agrega nombre
=cut
sub _ejecutar {
	my $self = shift;
  my $params = Saga->params(@_)->params_requeridos('persona')->params_validos(qw(nombre));
  my $persona = $params->persona;
  my $nombre = $params->nombre;
  my $nacimiento = $persona->nacimiento->valor;
  my $sexo = $persona->sexo->valor;
  $nombre = Saga->azar(Saga->entorno->persona_nombres($sexo)) if not defined $nombre;
  $persona->agregar(Saga->despachar('Persona::Propiedad')->new(key => 'nombre'));
  my $params_alteracion = {};
  $params_alteracion->{valor} = $nombre;
  $params_alteracion->{fecha} = $nacimiento;
  $persona->nombre->agregar_alteracion($params_alteracion);
}

1;

