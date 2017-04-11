package Comando::Agregar::Willpower;
use strict;
use Data::Dumper;
use fields qw();
use base qw(Comando);

=item
Agrega sexo
=cut
sub _ejecutar {
	my $self = shift;
  my $params = Saga->params(@_)->params_requeridos('persona')->params_validos(qw(willpower));
  my $persona = $params->persona;
  my $willpower = $params->willpower;
  $willpower = Saga->azar([1..10]) if not defined $willpower;
  $persona->agregar(Saga->despachar('Persona::Propiedad')->new(key => 'willpower'));
  my $params_alteracion = {};
  $params_alteracion->{valor} = $willpower;
  $params_alteracion->{fecha} = $persona->nacimiento->valor;
  $persona->willpower->agregar_alteracion($params_alteracion);
}

1;

