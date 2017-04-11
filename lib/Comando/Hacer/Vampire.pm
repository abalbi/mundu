package Comando::Vampire;
use strict;
use Data::Dumper;
use fields qw();
use base qw(Comando::Persona);

=item
Crea un vampiro
=cut
sub _ejecutar {
  my $self = shift;
  my $params = Saga->params(@_)
    ->params_requeridos(qw(physical social mental talent skill knowledge background virtue))
    ->params_validos(qw(persona edad_aparente edad fecha_nacimiento clan willpower humanity))
    ->params_excluyentes(qw(fecha_abrazo antiguedad));
  $params = Saga->despachar('Comando::Hacer::Abrazo')->new->ejecutar($params); 
  my $persona = $self->SUPER::_ejecutar($params);
  $params->persona($persona);
  my $situacion;
  Saga->en_fecha($params->fecha_abrazo, sub {
    $situacion = Saga->despachar('Comando::Hacer::Situacion')->new->ejecutar(
      key => 'abrazo',
      sujeto => $persona,
    );
    Saga->despachar('Comando::Agregar::Especie')->new->ejecutar(persona => $persona, especie => 'vampire'); 
    Saga->despachar('Comando::Agregar::Clan')->new->ejecutar(persona => $persona, clan => $params->clan); 
    $persona->agregar(Saga->despachar('Persona::Propiedad::Abrazo')->new);
    $persona->abrazo->agregar_alteracion(valor => $situacion, fecha => Saga->entorno->fecha_actual);
  });
  $persona->agregar(Saga->despachar('Persona::Propiedad::Antiguedad')->new);
  $persona->agregar(Saga->despachar('Persona::Propiedad::EdadAparente')->new);
#  Saga->despachar('Comando::Agregar::Estadisticas::Physical')->new->ejecutar( persona => $persona, puntos => $params->physical );
  Saga->despachar('Comando::Agregar::Estadisticas::Physical')->new->ejecutar($params);
  Saga->despachar('Comando::Agregar::Estadisticas::Social')->new->ejecutar( $params );
  Saga->despachar('Comando::Agregar::Estadisticas::Mental')->new->ejecutar( $params );
  Saga->despachar('Comando::Agregar::Estadisticas::Talent')->new->ejecutar( $params );
  Saga->despachar('Comando::Agregar::Estadisticas::Skill')->new->ejecutar( $params);
  Saga->despachar('Comando::Agregar::Estadisticas::Knowledge')->new->ejecutar( $params );
  Saga->despachar('Comando::Agregar::Estadisticas::Background')->new->ejecutar( $params );
  Saga->despachar('Comando::Agregar::Estadisticas::Virtue')->new->ejecutar( $params );
  Saga->despachar('Comando::Agregar::Estadisticas::Willpower')->new->ejecutar( $params );
  Saga->despachar('Comando::Agregar::Estadisticas::Humanity')->new->ejecutar( $params );
  $persona->template($self->plantilla_descripcion);
  return $persona;
}


sub plantilla_descripcion {
  my $self = shift;
  return <<TMPL ;
[% nombre %]
[% especie %] [% clan %]
edad: [% edad%] 
edad aparente: [% edad_aparente %]
physicals: [%START physical%][%key%]:[%valor%] [%END physical%] 
socials: [%START social%][%key%]:[%valor%] [%END social%] 
mentals: [%START mental%][%key%]:[%valor%] [%END mental%] 
talents: [%START talent%][%key%]:[%valor%] [%END talent%] 
skills: [%START skill%][%key%]:[%valor%] [%END skill%] 
knowledges: [%START knowledge%][%key%]:[%valor%] [%END knowledge%] 
backgrounds: [%START background%][%key%]:[%valor%] [%END background%] 
virtues: [%START virtue%][%key%]:[%valor%] [%END virtue%] 
extras: [%START extra%][%key%]:[%valor%] [%END extra%] 
TMPL
}
1;

