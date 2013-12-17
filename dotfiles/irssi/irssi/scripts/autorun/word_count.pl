#! /usr/bin/perl
# -*- mode:perl; coding:utf-8 -*-
#
# char_count.pl -
#
# Copyright(C) 2010 by mzp
# Author: MIZUNO Hiroki / mzpppp at gmail dot com
# http://howdyworld.org
#
# Timestamp: 2010/02/13 10:59:59
#
# This program is free software; you can redistribute it and/or
# modify it under MIT Lincence.
#

use strict;
use Encode qw(decode);
use Irssi;
use vars qw($VERSION %IRSSI);

$VERSION = '1.00';

%IRSSI = (
    authors     => 'mzp',
    contact     => 'mzp.ppp@gmail.com',
    name        => 'word count',
    description => 'count words',
    license     => 'Public Domain',
    );

sub word_count($$){
    my ($item, $get_size_only) = @_;
    my $line = decode(Irssi::settings_get_str('word_count_encode'),
		      Irssi::parse_special('$L'));

    if(Irssi::settings_get_bool('word_count_bitly')){
	$line =~
	    s|https?://[-_.!~*'()a-zA-Z0-9;\/?:\@&=+\$,%#]+|http://bit.ly/123456|g;
    }
    my $len = length $line;
    $item->default_handler($get_size_only, "(${len})", 0, 1);
}

Irssi::settings_add_bool('word_count', 'word_count_bitly', 1);
Irssi::settings_add_str('word_count' , 'word_count_encode', 'utf-8');

Irssi::signal_add_last 'gui key pressed' => sub{
    Irssi::statusbar_items_redraw('word_count');
};

Irssi::statusbar_item_register('word_count', undef, 'word_count');
Irssi::statusbars_recreate_items();
