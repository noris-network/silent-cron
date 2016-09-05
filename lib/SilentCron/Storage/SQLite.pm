package SilentCron::Storage::SQLite;

use strict;
use warnings;
use 5.014;

use DBI;
use Params::Validate qw(validate);

use constant TABLE => 'job_run';
use constant DATETIME_FORMAT => '%Y-%m-%d %H:%M:%S';

sub new {
    my $class = shift;
    validate(@_, {
        debug            => 0,
        storage_location => 0,
    });
    my %opts = @_;
    
    my $self = bless {}, $class;
    $self->{filename} = $opts{storage_location} // 'silent-cron.sqlite3';
    $self->{debug}    = $opts{debug}            // 0;
    return $self;
}

sub timestamp_to_iso {
    my $ts = shift;
}

sub _dbh {
    my $self = shift;
    $self->{dbh} //= $self->_init_db();
    return $self->{dbh};
}

sub _init_db {
    my $self = shift;
    my $dbh = DBI->connect("dbi:SQLite:dbname=" . $self->{filename}, '', '', { RaiseError => 1});

    unless ( $self->_has_table($dbh, TABLE) ) {
        $self->_create_schema($dbh);
    }
    return $dbh;
}

sub _create_schema {
    my ($self, $dbh) = @_;
    for my $block (split /;\n+/, <<SCHEMA) {
CREATE TABLE ${\TABLE} (
    id          INTEGER PRIMARY KEY,
    job_name    VARCHAR NOT NULL,
    start_time  VARCHAR NOT NULL,
    end_time    VARCHAR NOT NULL,
    exit_code   INTEGER NOT NULL,
    output      VARCHAR NOT NULL
);

CREATE INDEX IF NOT EXISTS ${\TABLE}_jobname_exitcode ON ${\TABLE} ( job_name, exit_code );
CREATE INDEX IF NOT EXISTS ${\TABLE}_jobname_endtime ON ${\TABLE} ( job_name, end_time );
SCHEMA
        say $block;
        $dbh->do($block);
    }
}

sub _has_table {
    my ($self, $dbh, $table) = @_;
    my ($row) = $dbh->selectall_array(
        q[SELECT name FROM sqlite_master WHERE type='table' AND name=?],
        undef,
        $table,
    );
    return !!$row && $row->[0];
}

sub record {
    my ( $self, $run ) = @_;

    my $dbh = $self->_dbh;
    my $sth = $dbh->prepare_cached("INSERT INTO ${\TABLE} (job_name, exit_code, output, start_time, end_time) VALUES (?, ?, ?, ?, ?)");

    $sth->execute(
        $run->job_name,
        $run->exit_code,
        $run->output,
        $run->start_time->strftime(DATETIME_FORMAT),
        $run->end_time->strftime(DATETIME_FORMAT),
   );
   $run->id( $dbh->sqlite_last_insert_rowid );
}


1;
