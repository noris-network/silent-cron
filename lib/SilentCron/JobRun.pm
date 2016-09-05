package SilentCron::JobRun;

use strict;
use warnings;
use 5.014;

use Moo;


# ID might be supplied later by the DB, so needs to be rw
has id          => (is => 'rw');
has job_name    => (is => 'ro');
has exit_code   => (is => 'ro');
has output      => (is => 'ro');
has start_time  => (is => 'ro');
has end_time    => (is => 'ro');

sub is_success {
    my $self = shift;
    return $self->exit_code == 0;
}

1;
