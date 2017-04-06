package Saga;
use Data::Dumper;
use Log::Log4perl;
use DateTime;
use DateTime::Format::Strptime;
use String::Random qw(random_regex);

use base qw(Base);
use Comando;
use Comando::Agregar::Especie;
use Comando::Agregar::Nacimiento;
use Comando::Agregar::Nombre;
use Comando::Agregar::Sexo;
use Comando::Hacer::Persona;
use Comando::Hacer::Vampire;
use Model::Alteracion;
use Model::Entorno;
use Model::Persona;
use Model::Persona::Propiedad;
use Model::Persona::Propiedad::Abrazo;
use Model::Persona::Propiedad::Antiguedad;
use Model::Persona::Propiedad::Categoria;
use Model::Persona::Propiedad::Edad;
use Model::Persona::Propiedad::Nacimiento;
use Model::Situacion;
use Model::Situacion::Rol;
use Situacion::Fabrica;
use Saga::Params;


our $LogLevel = 'FATAL';
our $entorno;

Log::Log4perl->init("log.conf");

=item
Devuelve el entorno activo
=cut
sub entorno {
  my $class = shift;
  $entorno = despachar('Entorno')->new() if not $entorno;
  return $entorno;
}

=item
Despacha el nombre de un package
=cut
sub despachar {
  my $class = shift if $_[0] eq 'Saga';
  my $package = shift;
  return $package;
}

=item
Devuelve un objeto Saga::Params segun los parametros recibidos
=cut
sub params {
  my $class = shift;
  my (@params) = @_; 
  my $params;
  my $fields = {};
  if(scalar @params == 1 && ref $params[0] eq 'Saga::Params') {
    return $params[0];
  } elsif(scalar @params == 1 && ref $params[0] eq 'HASH') {
    $params = $params[0];
  } elsif (scalar @params > 1) {
    $params = {@params};
  } else {
    Saga->logger()->logconfess("Los parametros no se pueden parsear") if scalar @params;
  }
  my $objeto = Saga::Params->new($fields,$params);
  my $metodo = [caller(1)]->[3];
  Saga->logger()->trace($metodo, ' => { '.$objeto->serializar.' }') if $objeto->serializar;
  return $objeto;
}

=item
Genera un DateTime segun los params
=cut
sub dt_string {
  my $class = shift;
  my $params = Saga->params(@_)->params_validos(qw(epoch));
  if($params->epoch) {
    return DateTime->from_epoch(epoch => $params->epoch);
  }
  return DateTime->new($params->en_hash);
}

=item
Genera un DateTime desde un string de fecha
=cut
sub dt {
  my $class = shift;
  my $datetime = shift;
  my $dt = DateTime::Format::Strptime->new(pattern => '%FT%T')->parse_datetime($datetime) if $datetime;
  return $dt;
}

=item
Setea la fecha del entorno, ejecuta el codigo y recupera la fecha anterior
=cut
sub en_fecha {
  my $class = shift;
  my $fecha = shift;
  my $code  = shift;
  $class->logger->logconfess("Fecha es requerido") if not defined $fecha;
  my $bak = Saga->entorno->fecha_actual;
  Saga->entorno->fecha_actual($fecha);
  my $valor = &$code;
  Saga->entorno->fecha_actual($bak);
  return $valor
}

=item
Codigos a segundos
=cut
sub code2seconds {
  my $class = shift;
  my $string = shift;
  my $seg = $string;
  $seg =~ s/y/ \* 365d/g;
  $seg =~ s/d/ \* 24h/g;
  $seg =~ s/h/ \* 60m/g;
  $seg =~ s/m/ \* 60/g;
  eval "\$seg \= $seg";
  return $seg;
}

our $srand_default = 24170987;
our $srand_asignado = 0;
our $srand_next;
our $srand;

=item
Azar
=cut
sub azar {
  my $self = shift;
  my $valor = shift;
  saga_srand();
  return $valor->[int rand scalar @$valor] if ref $valor eq 'ARRAY'; 
  return int rand $valor + 1 if $valor =~ /^\d+$/;
  return undef;
}

sub saga_srand {
  my $srand_param = shift;
  my $generar_next = 1;
  my $log_msg = 'DEFAULT';
  if($srand_param eq 'NEXT') {
    $srand_asignado = 0;
    $srand = $srand_next;
    $log_msg = 'NEXT   ';
  }
  if($srand_param eq 'DEFAULT') {
    $srand_asignado = 0;
    $srand = $srand_default;
    $log_msg = 'DEFAULT';
  }
  if($srand_param) {
    $srand_asignado = 0;
    $srand = $srand_param;
    $generar_next = 0;
    $log_msg = 'CUSTOM ';
  }
  if(!$srand_asignado) {
    $srand = $srand_default if !$srand;
    srand(int($srand));
    $srand_next = nuevo_srand() if $generar_next;
    $srand_asignado = 1;
    Saga->logger()->trace($log_msg.' => srand:', $srand, ' srand_next:', $srand_next);
  }
  return $srand, $srand_next; 
}

=item
Nuevo srand
=cut
sub nuevo_srand {
  my $string = random_regex('\d\d\d\d\d\d\d\d\d\d');
  return $string;
}

1;