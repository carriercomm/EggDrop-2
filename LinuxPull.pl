#!/usr/bin/perl
#linuxpull.pl by ev0x
# use a tcl script to echo onto channels you want

use utf8;
binmode STDOUT, ":utf8";
use XML::Feed;
use HTML::TagParser;
use Digest::Perl::MD5 'md5_hex';

my $site_head = "http://distrowatch.com/news/";

@rss_a = ("dw.xml","dwd.xml","dwp.xml");

foreach my $rss ( @rss_a ) {
        $url = "$site_head$rss";

        my $feed = XML::Feed->parse(URI->new($url)) or die XML::Feed->errstr;
        foreach ($feed->entries) {
                ($title) = $_->title, "\n";
                ($link) = $_->link, "\n";
		($found) = 0;
		#no id to pull so lets hack one up so we can use in a fsdb
		$idr = "$title$link$url";
		$id = md5_hex($idr);
#		$id =~ s/(.)/sprintf("%x",ord($1))/eg;
                open(NIXLOG, 'nix.txt');
                if (grep{/$id/i} <NIXLOG>) {
                        ($found) = 1;
                } else {
			if (grep{/dwd/i} $url ) {
				print "[\x0311Latest distribution releases\x03] \x02$title\x02 :: \x03$link\x03\n";
			} elsif (grep{/dwp/i} $url ) {
				($cont) = $_->content->body, "\n";
				print "[\x0311Latest package releases\x03] \x02$title\x02 :: \x03$link\x03\n$cont\n";
			} elsif (grep{/dw\.xml/i} $url ) {
				($cont) = $_->content->body, "\n";
	                        print "[\x0311Latest linux news\x03] \x02$title\x02 :: \x03$link\x03\n$cont\n";
			}
		}
                close (NIXLOG);
                if ($found == 0) {
                        open(NIXLOG, '>>nix.txt');
                        print NIXLOG "$id\n";
                        close (NIXLOG);
                }
	}
}
