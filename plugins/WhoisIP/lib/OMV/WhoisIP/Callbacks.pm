package OMV::WhoisIP::Callbacks;
# WhoisIP (C) 2012 Piroli YUKARINOMIYA (Open MagicVox.net)
# This program is distributed under the terms of the GNU General Public License, version 3.
# $Id$

use strict;
use warnings;
use MT;

use vars qw( $VENDOR $MYNAME $FULLNAME );
$FULLNAME = join '::',
        (($VENDOR, $MYNAME) = (split /::/, __PACKAGE__)[0, 1]);

sub instance { MT->component($FULLNAME); }



### template_source.edit_{comment|ping}
sub template_source_edit_comment {
    my ($cb, $app, $tmpl) = @_;

    #
    chomp (my $new = <<"MTMLHEREDOC");
<mt:setvarblock name="html_head" append="1">
<!-- $FULLNAME -->
<style type="text/css">
#omv_whois_ip {
        margin-top:0.5em; }
    #omv_whois_ip ul {
            margin-top:0.5em; margin-left:2em; }
</style>
</mt:setvarblock>
MTMLHEREDOC
    $$tmpl =~ s!^!$new!;
}

### template_param.edit_{comment|ping}
sub template_param_edit_comment {
    my ($cb, $app, $param, $tmpl) = @_;

    #
    my $ip = $tmpl->getElementById('ip') || $tmpl->getElementById('source_ip')
        or return;
    my $omv_whois_ip = $tmpl->createTextNode (&instance->translate_templatized (<<'HTMLHEREDOC'));
<mt:if name="whois_ip"><!-- $FULLNAME -->
<div id="omv_whois_ip">
    <label><__trans phrase="Investigate this IP address with WHOIS services below"></label>
    <ul><mt:loop name="whois_ip">
        <li><a class="icon-left icon-related" href="<mt:var name="url" escape="html">" blank="omv_whois_ip"><mt:var name="name" escape="html"></a></li></mt:loop>
    </ul>
</div></mt:if>
HTMLHEREDOC
    $ip->appendChild ($omv_whois_ip);

    #
    my @whois;
    my $whois = &instance->get_config_value ('whois') || '';
    foreach (split /[\r\n]/, $whois) {
        s!^\s+|\s+$!!g;
        my ($url, $name) = ($_, $_);
        if (/\s/) {
            ($url, $name) = $url =~ /(.+?)\s+(.*)/;
        } else {
            ($name) = $url =~ m!(https?://.+?/)!;
        }
        next unless length $url;
        next unless length $name;
        $url =~ s/%s/$param->{ip}/g;
        push @whois, {
            name => $name,
            url => $url,
        };
    }
    $param->{whois_ip} = \@whois if @whois;

    # Force enable ShowIPInformation directive
    $app->config('ShowIPInformation', 1);
}

1;