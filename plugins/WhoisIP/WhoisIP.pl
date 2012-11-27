package MT::Plugin::Admin::OMV::WhoisIP;
# WhoisIP (C) 2012 Piroli YUKARINOMIYA (Open MagicVox.net)
# This program is distributed under the terms of the GNU Lesser General Public License, version 3.
# $Id$

use strict;
use warnings;
use MT 5;

use vars qw( $VENDOR $MYNAME $FULLNAME $VERSION );
$FULLNAME = join '::',
        (($VENDOR, $MYNAME) = (split /::/, __PACKAGE__)[-2, -1]);
(my $revision = '$Rev$') =~ s/\D//g;
$VERSION = 'v0.10'. ($revision ? ".$revision" : '');

use base qw( MT::Plugin );
my $plugin = __PACKAGE__->new ({
    id => $FULLNAME,
    key => $FULLNAME,
    name => $MYNAME,
    version => $VERSION,
    author_name => 'Open MagicVox.net',
    author_link => 'http://www.magicvox.net/',
    plugin_link => 'http://www.magicvox.net/archive/2012/11271557/', # Blog
    doc_link => "http://lab.magicvox.net/trac/mt-plugins/wiki/$MYNAME", # tracWiki
    description => <<'HTMLHEREDOC',
<__trans phrase="Add links of WHOIS service to investigate IP address of comments and received trackbacks">
HTMLHEREDOC
    l10n_class => "${FULLNAME}::L10N",
    system_config_template => "$VENDOR/$MYNAME/config.tmpl",
    settings => new MT::PluginSettings([
        [ 'whois', { Default => <<PERLHEREDOC,, Scope => 'system' }],
http://whois.nic.ad.jp/cgi-bin/whois_gw?type=NET&key=%s JPNIC WHOIS Gateway
http://whois.arin.net/rest/ip/%s ARIN WHOIS
http://lacnic.net/cgi-bin/lacnic/whois?query=%s LACNIC WHOIS
http://whois.domaintools.com/%s DomainTools
PERLHEREDOC
    ]),
    registry => {
        applications => {
            cms => {
                callbacks => {
                    # Comment
                    'template_source.edit_comment' => "${FULLNAME}::Callbacks::template_source_edit_comment",
                    'template_param.edit_comment' => "${FULLNAME}::Callbacks::template_param_edit_comment",
                    # Trackback
                    'template_source.edit_ping' => "${FULLNAME}::Callbacks::template_source_edit_comment",
                    'template_param.edit_ping' => "${FULLNAME}::Callbacks::template_param_edit_comment",
                    # Log
#                    'MT::App::CMS::template_output.view_log' => \&_cb_template_source_view_log,
                },
            },
        },
    },
});
MT->add_plugin ($plugin);

sub instance { $plugin; }

1;