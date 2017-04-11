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
    ->params_requeridos(qw(physical social mental talent skill knowledge))
    ->params_validos(qw(persona edad_aparente edad fecha_nacimiento clan))
    ->params_excluyentes(qw(fecha_abrazo antiguedad));
  $params = Saga->despachar('Comando::Hacer::Abrazo')->new->ejecutar($params); 
  my $persona = $self->SUPER::_ejecutar($params);
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
  Saga->despachar('Comando::Agregar::Estadisticas::Physical')->new->ejecutar( persona => $persona, puntos => $params->physical );
  Saga->despachar('Comando::Agregar::Estadisticas::Social')->new->ejecutar( persona => $persona, puntos => $params->social );
  Saga->despachar('Comando::Agregar::Estadisticas::Mental')->new->ejecutar( persona => $persona, puntos => $params->mental );
  Saga->despachar('Comando::Agregar::Estadisticas::Talent')->new->ejecutar( persona => $persona, puntos => $params->talent );
  Saga->despachar('Comando::Agregar::Estadisticas::Skill')->new->ejecutar( persona => $persona, puntos => $params->skill );
  Saga->despachar('Comando::Agregar::Estadisticas::Knowledge')->new->ejecutar( persona => $persona, puntos => $params->knowledge );
  return $persona;
}

1;

