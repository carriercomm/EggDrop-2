#!/usr/bin/perl

#use strict;
#use warnings;
use XML::Feed;
use HTML::TagParser;

my $site_head = "https://github.com/";

#list your users to follow
@users = ("Squire.atom","ev0x.atom","jawr.atom","omegaservices.atom");

foreach my $user ( @users ) {
	$url = "$site_head$user";

	my $feed = XML::Feed->parse(URI->new($url)) or die XML::Feed->errstr;
	foreach ($feed->entries) {
		($title) = $_->title, "\n";
		($author) = $_->author, "\n";
		($id) = $_->id, "\n";
		($found) = 0;
		open(GITLOG, 'git.txt');
		if (grep{/$id/i} <GITLOG>) {
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
				($branch) = "Master";
			}
			if (grep{/created repository/i} $title) {
				($branch) = "Master";
				($rep) = $title =~ /created repository (.*?)$/m;
				($title) = "NEW REPO: $rep";
			} elsif (grep{/created branch/i} $title) {
				($branch) = $title =~ /created branch (.*?)  at/m;
				($rep) = $title =~ /\/(.*?)$/m;
				($title) = "NEW BRANCH in $rep";
			} elsif (grep{/pushed to/i} $title) {
				($branch) = $title =~ /pushed to (.*?) at/m;
			} elsif (grep{/commented on/i} $title) {
				($bypass) = 1;
			} elsif (grep{/opened pull request/i} $title) {
				($bypass) = 1;
			}
			$commiturl = "https://github.com$committail";
			$gitio = `curl -s -i http://git.io -F "url=$commiturl" | grep Location | awk -F ":" '{print $2}'`;
			chomp($gitio);
			if (grep{/NEW REPO/i} $title) {
				($where) = $title;
			} elsif (grep{/NEW BRANCH/i} $title) {
				($where) = $title;
			} else {
				($where) = $title =~ /\/(.*?)$/m;
			}
			if ( "$bypass" == 1 ) {
				print "[\x0311GitHub\x03] \x02$title :: $comment\x02\n";
			} else {
				print "[\x0311GitHub\x03] \x02$where\x02 \x0314by\x03 \x02$author\x02 :: [\x0304$branch\x03] \x02$rev\x02 :: \x02$comment\x02 :: \x0304$gitio\x03";
			}
		}
		close (GITLOG);
		if ($found == 0) {
			open(GITLOG, '>>git.txt');
			print GITLOG "$id\n";
			close (GITLOG);
		}
	}
}
