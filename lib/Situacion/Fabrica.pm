package Situacion::Fabrica;
use Saga qw(despachar);
use Data::Dumper;

=item
Hacer situacion
=cut
sub hacer {
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