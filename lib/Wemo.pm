package Wemo;
use Moo;
use WebService::Belkin::WeMo::Discover;
use WebService::Belkin::WeMo::Device;

my $db = "wemo.db";

sub find {
    my($class, $ip) = @_;

    my $client = WebService::Belkin::WeMo::Discover->new;
    my $meta = $client->load($db)->{$ip};

    $class->new(ip => $ip, meta => $meta, db => $db);
}

sub discover {
    my($class, $refresh) = @_;

    my $client = WebService::Belkin::WeMo::Discover->new;
    my $wemos;
    if (-e $db && !$refresh) {
        $wemos = $client->load($db);
    } else {
        $wemos = $client->search;
        $client->save($db);
    }

    my @wemos;

    for my $ip (sort keys %$wemos) {
        push @wemos, $class->new(ip => $ip, meta => $wemos->{$ip}, db => $db);
    }

    return @wemos;
}

has ip   => (is => 'rw');
has meta => (is => 'rw');
has db   => (is => 'rw');

has device => (is => 'lazy');

sub _build_device {
    my $self = shift;
    WebService::Belkin::WeMo::Device->new(ip => $self->ip, db => $self->db);
}

1;
