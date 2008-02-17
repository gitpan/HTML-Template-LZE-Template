use strict;
use Module::Build;
my $class = new Module::Build(
                              module_name => 'HTML::Template::LZE::Template',
                              requires    => {'Test::More' => 0, 'Test::Signature' => 1.10, 'Module::Build' => 0, 'CGI::LZE' => '0.24',},
                              ($] >= 5.005 ? (AUTHOR => 'Dirk Lindner <lindnerei@o2online.de>') : ()),
                              dist_abstract      => "Simple HTML Template",
                              license            => "lgpl",
                              create_makefile_pl => 'passthrough',
#                               sign               => 1,
)->create_build_script;
