package HTML::Template::LZE::Template;

# use strict;
# use warnings;
use CGI::LZE qw(init translate);

require Exporter;
use vars qw($tmp $DefaultClass @EXPORT_OK @ISA);
@ISA                                    = qw(Exporter);
@HTML::Template::LZE::Template::EXPORT  = qw(initTemplate appendHash Template initArray);
%LZE::TabWidget::EXPORT_TAGS            = ('all' => [qw(initTemplate appendHash Template initArray  )]);
$HTML::Template::LZE::Template::VERSION = '0.24';
$DefaultClass                           = 'HTML::Template::LZE::Template' unless defined $HTML::Template::LZE::Template::DefaultClass;
our %tmplate;

=head1 NAME

HTML::Template::LZE::Template.pm

=head1 SYNOPSIS

       use strict;

       use HTML::Template::LZE::Template;

       my %template = (

       path     => "path",

       style    => "style"

       template => "index.html",

       name => 'window'

       );

       initTemplate(\%template);

       my @data =(

       {

       name   => 'header',

       },

       {

       name  => 'links',

       style => 'Crystal',

       text  => '<a href="news.html" class="menuLink">News</a>',

       title => 'News',

       },

       {
       name   => 'currentLink',

       style   => 'Crystal',

       text => '<a href="news.html" class="menuLink">Downs</a>',

       title => 'Downloads',

       },

       {
       name   => 'footer',

       },

       );

       print initArray(\@data);

=head1 BUGS


=head2 new


=cut

sub new {
        my ($class, @initializer) = @_;
        my $self = {};
        bless $self, ref $class || $class || $DefaultClass;
        $self->initTemplate(@initializer) if(@initializer);
        return $self;
}

=head2 initTemplate 

       my %template = (

       path     => "path",

       style    => "style"

       template => "index.html",

       );
       initTemplate(\%template);

=cut

sub initTemplate {
        my ($self, @p) = getSelf(@_);
        my $hash = $p[0];
        $DefaultClass = $self;
        use Fcntl qw(:flock);
        use Symbol;
        my $fh   = gensym;
        my $file = "$hash->{path}/$hash->{style}/$hash->{template}";
        open $fh, "$file" or warn "$!: $file";
        seek $fh, 0, 0;
        my @lines = <$fh>;
        close $fh;
        my ($text, $o);

        for(@lines) {
                $text .= chomp $_;
              SWITCH: {
                        if($_ =~ /\[([^\/|\]]+)\]([^\[\/\1\]]*)/) {
                                $tmplate{$1} = $2;
                                $o = $1;
                                last SWITCH;
                        }
                        if(defined $o) {
                                if($_ =~ /[^\[\/$o\]]/) {
                                        $tmplate{$o} .= $_;
                                        last SWITCH;
                                }
                        }
                }
        }
        $self->initArray($p[1]) if(defined $p[1]);
}

=head2 Template()


=cut

sub Template {
        my ($self, @p) = getSelf(@_);
        return $self->initArray(@p);
}

=head2 appendHash()

appendHash(\%hash);

=cut

sub appendHash {
        my ($self, @p) = getSelf(@_);
        my $hash = $p[0];
        my $text = $tmplate{$hash->{name}};
        foreach my $key (keys %{$hash}) {
                if(defined $text && defined $hash->{$key}) {

                        if(defined $key && defined $hash->{$key}) {
                                $text =~ s/\[($key)\/\]/$hash->{$key}/g;

                                if($text =~ /\[tr=(\w*)\/\]/) {

                                        my $e = CGI::LZE::translate($1);
                                        $text =~ s/\[tr=$1\/\]/$e/;
                                }
                        }
                }
        }
        return $text;
}

=head2 initArray()

=cut

sub initArray {
        my ($self, @p) = getSelf(@_);
        my $tree = $p[0];
        $tmp = undef if(defined $tmp);
        for(my $i = 0 ; $i < @$tree ; $i++) {
                $tmp .= $self->appendHash(\%{@$tree[$i]});
        }
        return $tmp;
}

=head2 getSelf()

=cut

sub getSelf {
        return @_ if defined($_[0]) && (!ref($_[0])) && ($_[0] eq 'HTML::Template::LZE::Template');
        return (defined($_[0]) && (ref($_[0]) eq 'HTML::Template::LZE::Template' || UNIVERSAL::isa($_[0], 'HTML::Template::LZE::Template'))) ? @_ : ($HTML::Template::LZE::Template::DefaultClass->new, @_);
}

=head1 AUTHOR

Dirk Lindner <lindnerei@o2online.de>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by Hr. Dirk Lindner

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public License
as published by the Free Software Foundation; 
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

=cut

1;

