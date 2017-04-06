package Base;

=item
Logger
=cut
sub logger {
  my $logger = Log::Log4perl->get_logger(__PACKAGE__);
  $logger->level($Saga::LogLevel);
  return $logger;
}

=item
Carga los params
=cut
sub params {
  my $self = shift;
  my $params = Saga->params(@_);
	foreach my $key (sort keys %{$params->items}) {
		$self->{'_'.$key} = $params->$key;
	}
	$self;
}

1;