package OMV::WhoisIP::L10N::ja;
# $Id$

use strict;
use base 'OMV::WhoisIP::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (
    'Add links of WHOIS service to investigate IP address of comments and received trackbacks' => 'コメントやトラックバックの IP アドレスを WHOIS サービスで調査するためのリンクを追加します',

    # config.tmpl
    'WHOIS Services' => 'WHOIS サービス',
    '%s will be replaced with IP address to be ivestigated' => '%s は調査対象の IP アドレスに置き換えられます',

    # OMV::WhoisIP::Callbacks
    'Investigate this IP address with WHOIS services below' => 'この IP アドレスを WHOIS サービスで調べる',
);

1;