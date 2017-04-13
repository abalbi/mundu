package WhiteWolf::Comando::Hacer::Vampire;
use strict;
use Data::Dumper;
use fields qw();
use base qw(Comando::Persona);

sub tipo_return {'Persona'};

=item
Crea un vampiro
=cut
sub _ejecutar {
  my $self = shift;
  my $params = Saga->params(@_)
    ->params_requeridos(qw(physical social mental talent skill knowledge background virtue))
    ->params_validos(qw(persona edad_aparente edad fecha_nacimiento clan willpower humanity especie protagonismo))
    ->params_excluyentes(qw(fecha_abrazo antiguedad));
  $params = Saga->despachar('Comando::Conceptos::Abrazo')->new->ejecutar($params); 
  my $persona = $self->SUPER::_ejecutar($params);
  $persona->template($self->plantilla_descripcion);
  $params->persona($persona);
  $params->especie('vampire');
  my $situacion;
  Saga->en_fecha($params->fecha_abrazo, sub {
    Saga->despachar('Comando::Conceptos::Especie')->new->ejecutar($params); 
    Saga->despachar('Comando::Conceptos::Clan')->new->ejecutar($params); 
    Saga->despachar('Comando::Conceptos::Generacion')->new->ejecutar($params);
    my $sire;
    if($persona->generacion->valor > 6) {
      $sire = Saga->despachar('Fabrica::Vampire')->hacer(
        generacion => $persona->generacion->valor - 1,
        clan => $persona->clan->valor,
        fecha_abrazo => {
          desde => Saga->dt(Saga->entorno->fecha_actual)->subtract(years => Saga->azar(500))->datetime,
          hasta => Saga->entorno->fecha_actual,
        },
      );
    }
    $situacion = Saga->despachar('Comando::Hacer::Situacion')->new->ejecutar(
      key => 'abrazo',
      sujeto => $persona,
      sire => $sire,
    );
    $persona->agregar(Saga->despachar('Persona::Propiedad::Abrazo')->new);
    $persona->abrazo->agregar_alteracion(valor => $situacion, fecha => Saga->entorno->fecha_actual);
  });
  $persona->agregar(Saga->despachar('Persona::Propiedad::Antiguedad')->new);
  $persona->agregar(Saga->despachar('Persona::Propiedad::Sire')->new);
  $persona->agregar(Saga->despachar('Persona::Propiedad::EdadAparente')->new);
  if($params->protagonismo eq 'principal') {
    Saga->despachar('Comando::Estadisticas::Physical')->new->ejecutar($params);
    Saga->despachar('Comando::Estadisticas::Social')->new->ejecutar( $params );
    Saga->despachar('Comando::Estadisticas::Mental')->new->ejecutar( $params );
    Saga->despachar('Comando::Estadisticas::Talent')->new->ejecutar( $params );
    Saga->despachar('Comando::Estadisticas::Skill')->new->ejecutar( $params);
    Saga->despachar('Comando::Estadisticas::Knowledge')->new->ejecutar( $params );
  }
  Saga->despachar('Comando::Estadisticas::Background')->new->ejecutar( $params );
  Saga->despachar('Comando::Estadisticas::Virtue')->new->ejecutar( $params );
  Saga->despachar('Comando::Estadisticas::Willpower')->new->ejecutar( $params );
  Saga->despachar('Comando::Estadisticas::Humanity')->new->ejecutar( $params );
  return $persona;
}


sub plantilla_descripcion {
  my $self = shift;
  return <<TMPL ;
[% nombre %]
[% especie %] [% clan %]
generacion: [% generacion %]
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

