#!/usr/bin/perl -w

use Getopt::Long; # http://perldoc.perl.org/Getopt/Long.html
use Pod::Usage; # http://perldoc.perl.org/pod2usage.html

### start-configuration-part ###
my $opts = {
    name   => 'unknown',__goto__
    age    => 10,
    switch => 0,
    files  => [],
};
### end-configuration-part ###

my $version = '0.01';
my $author = '__user__';
$opts->{man}     = 0;
$opts->{help}    = 0;
$opts->{version} = 0;

GetOptions(
    'help|?'  => \$opts->{help},
    'version' => \$opts->{version},
    'man'     => \$opts->{man},
    'name=s'  => \$opts->{name},
    'age=i'   => \$opts->{age},
    'switch'  => \$opts->{switch}, # 0|1
) or pod2usage(2);
push(@{$opts->{files}}, @ARGV);

pod2usage(1) if $opts->{help};
pod2usage(-exitstatus => 0, -verbose => 2) if $opts->{man};

if ( $opts->{version} ) {
    print "$0 $version\nAuthor $author\n";
    exit;
}

# code
print "$opts->{name}\n";
print "$opts->{age}\n";
print "$opts->{switch}\n";
print "Other parameters: @{$opts->{files}}\n";

__END__

=head1 NAME

__basename__ Summary

This program has the following dependencies:
  Debian package: perl-doc (Getopt::Long, Pod::Usage)

=head1 SYNOPSIS

__basename__ [options] [file ...]

Program description

Options:

  -name name       Parameter description
  -age age         Parameter description
  -switch          Parameter description
  -help            Help
  -version         Show program version
  -man             Show manpage

=head1 OPTIONS

=over 8

=item B<-name name> or B<--name=name>

Parameter description

=item B<-age age> or B<--age=age>

Parameter description

=item B<-switch>

Parameter description

=item B<-help>

Show help and exit program.

=item B<-version>

Show program version and exit program.

=item B<-man>

Show manpage and exit program.

=back

=head1 DESCRIPTION

B<__basename__> Programm description

=cut

