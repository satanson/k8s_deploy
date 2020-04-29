#!/usr/bin/perl

use warnings;
use strict;
use Data::Dumper;

sub route_match($$$){
  my ($ip, $mask, $dest)=@_;
  my @ip=split /\./, $ip;
  my @mask=split /\./, $mask;
  my $dest2=join ".", map {int($ip[$_]) & int($mask[$_])} 0..3;
  #print "ip=$ip, mask=$mask, dest=$dest, dest2=$dest2\n";
  $dest2 eq $dest;
}

sub mask_length($) {
  my $mask = shift;
  length(sprintf("%b%b%b%b", split(/\./, $mask)) =~ tr/0//dr);
}

sub padding($$){
  my ($p,$l)=@_;
  substr $p.(" " x $l), 0, $l;
}

my $ip=shift or die "missing 'target ip'";
my @entries = grep /^\d+(\.\d+){3}/, map {chop;$_} qx(route -n);

#print join "\n", @entries, "\n";
use constant {
  DEST => 0,
  GW =>1,
  MASK=>2,
  FLAGS=>3,
  METRIC=>4,
  REF=>5,
  USE=>6,
  IFACE=>7,
};

my $entries = [map {[split /\s+/]}  @entries];
$entries = [sort {
  my $r=mask_length($a->[MASK]) <=> mask_length($b->[MASK]);
  $r==0?$a->[METRIC] <=> $b->[METRIC]:-$r;
} @$entries];


#print Dumper($entries);

my %selected = map {$_=>1} grep {route_match $ip, $entries->[$_][MASK], $entries->[$_][DEST]} 0..@$entries-1;

printf "%s\t%s\t%s\t\t%s\t%s\t%s\t%s\t%s\n", padding("destination", 15), padding("gateway", 15), padding("netmask", 15), "flags", "metric", "ref", "use","iface";
my $isFirst=1;
for (0..@$entries-1) {
  #print "@$_", "\n";
  my ($beg, $end)=("","");
  if (exists $selected{$_}){
    if (defined($isFirst)){
      ($beg, $end)=("\e[92;100;1m", "\e[m");
      $isFirst=undef;
    } else {
      ($beg, $end)=("\e[93;40;1m", "\e[m");
    }
  } 
  my $e = $entries->[$_];
  printf "$beg%s\t%s\t%s\t\t%s\t%s\t%s\t%s\t%s\n$end", padding($e->[0],15), padding($e->[1],15), padding($e->[2],15), $e->[3], $e->[4], $e->[5], $e->[6], $e->[7];
}
#print Dumper($entries);
