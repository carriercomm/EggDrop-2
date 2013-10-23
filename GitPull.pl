#!/usr/bin/perl

#use strict;
#use warnings;
use XML::Feed;
use HTML::TagParser;

my $site_head = "https://github.com/";

#list your users to follow
@users = ("Squire.atom","ev0x.atom");

foreach my $user ( @users ) {
	#create teh url
	$url = "$site_head$user";


	my $feed = XML::Feed->parse(URI->new($url)) or die XML::Feed->errstr;
	foreach ($feed->entries) {
		($title) = $_->title, "\n";
		($author) = $_->author, "\n";
		($id) = $_->id, "\n";
		($found) = 0;
		open(GITLOG, 'git.txt');
		if (grep{/$id/i} <GITLOG>) {
			print "found skipping..\n";
			($found) = 1;
		} else {
			($raw_html) = $_->content->body, "\n";
			my $html = HTML::TagParser->new("$raw_html");
			my @list = $html->getElementsByTagName( "blockquote" );
			foreach my $elem ( @list ) {
				($comment) = $elem->innerText;
			}
			my @list = $html->getElementsByTagName( "code" );
			foreach my $elem ( @list ) {
				($rev) = $elem->innerText;
			}
			my @list = $html->getElementsByTagName( "a" );
			foreach my $elem ( @list ) {
				my $tagname = $elem->tagName;
				my $attr = $elem->attributes;
				my $text = $elem->innerText;
				foreach my $key ( sort keys %$attr ) {
					($tkey) = $attr->{$key};
					if (grep{/commit/} $tkey ) {
						($committail) = $tkey;
					}
				}
			}
			if (grep{/master/i} $title) {
				($rep) = "Master";
			}
			$commiturl = "https://github.com$committail";
			$gitio = `curl -s -i http://git.io -F "url=$commiturl" | grep Location | awk -F ":" '{print $2}'`;
			($where) = $title =~ /\/(.*?)$/m;
			print "[GitHub] $where by $author :: [$rep] $rev :: $comment :: $gitio\n";
		}
		close (GITLOG);
		if ($found == 0) {
			open(GITLOG, '>>git.txt');
			print GITLOG "$id\n";
			close (GITLOG);
		}
	}
}
