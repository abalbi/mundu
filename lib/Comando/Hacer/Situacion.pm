package Comando::Hacer::Situacion;
use strict;
use Data::Dumper;
use fields qw();
use base qw(Comando);

=item
Tipo return
=cut
sub tipo_return {'Situacion'}

sub _ejecutar {
	my $self = shift;
	my $params = Saga->params(@_)->params_requeridos(qw(key))->params_libres;
	my $situacion = Saga->despachar('Situacion')->new(fecha => Saga->entorno->fecha_actual, key => $params->key);
	foreach my $key (sort keys %{$params->items}) {
		my $param = $params->$key;
		if(scalar grep {$_ ne $key} qw(key)) {
			$situacion->rol($key, $param);
		}
	}
	Saga->entorno->agregar($situacion);
	return $situacion;
}
1;