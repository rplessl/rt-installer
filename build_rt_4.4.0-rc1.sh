#!/bin/bash

export PREFIX=`pwd`

. `dirname $0`/sdbs/sdbs.inc

# Build Perl 5.22 as basic perl
cd sdbs
./build_perl-5.22.sh
cd ..

#################
### Libraries ###
#################

########################
### for Ubuntu 14.04 ###
########################

RELEASE=`lsb_release -d`
if [[ $RELEASE =~ "Ubuntu 14.04.3 LTS" ]]; then
   cat << 'EOT'

# Install necessary Services with Debian packages

sudo locale-gen en_US.UTF-8
sudo locale-gen de_CH.UTF-8

sudo apt-get install -y graphviz-dev
sudo apt-get install -y libgd-dev
sudo apt-get install -y libssl-dev

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
sudo apt-key add -
echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >  /etc/apt/sources.list.d/pgdg.list
sudo apt-get update

sudo apt-get install -y postgresql-9.4
sudo apt-get install -y libpq-dev
EOT
fi

#########################
### SSL Functionality ###
#########################

cpanm Crypt::SSLeay
cpanm LWP::Protocol::https

#######################
### RT Dependencies ###
#######################

# CLI dependencies:
cpanm HTTP::Request::Common
cpanm Term::ReadKey
cpanm Text::ParseWords
cpanm Term::ReadLine
cpanm LWP
cpanm Getopt::Long
# CORE dependencies:
cpanm DateTime::Locale
cpanm Scope::Upper
cpanm Apache::Session
cpanm CGI::Emulate::PSGI
cpanm HTML::FormatText::WithLinks
cpanm File::Spec
cpanm Time::HiRes
cpanm CGI
cpanm Text::Password::Pronounceable
cpanm Net::CIDR
cpanm HTML::RewriteAttributes
cpanm HTML::Mason::PSGIHandler
cpanm Encode
cpanm HTML::Entities
cpanm Role::Basic
cpanm Business::Hours
cpanm Regexp::Common
cpanm File::ShareDir
cpanm Data::Page::Pageset
cpanm Text::Wrapper
cpanm Data::GUID
cpanm Locale::Maketext::Fuzzy
cpanm HTML::FormatText::WithLinks::AndTables
cpanm Module::Versions::Report
cpanm Digest::SHA
cpanm CSS::Minifier::XS
cpanm Text::Quoted
cpanm XML::RSS
cpanm Regexp::Common::net::CIDR
cpanm HTML::Quoted
cpanm DBIx::SearchBuilder
cpanm CGI::PSGI
cpanm UNIVERSAL::require
cpanm File::Glob
cpanm Text::Template
cpanm Time::ParseDate
cpanm Email::Address::List
cpanm LWP::Simple
cpanm Text::WikiFormat
cpanm Plack
cpanm Scalar::Util
cpanm Devel::StackTrace
cpanm Date::Extract
cpanm Mail::Mailer
cpanm Symbol::Global::Name
cpanm Net::IP
cpanm IPC::Run3
cpanm Email::Address
cpanm Locale::Maketext
cpanm JSON
cpanm Devel::GlobalDestruction
cpanm CSS::Squish
cpanm HTML::Mason
cpanm Mail::Header
cpanm HTTP::Message
cpanm Crypt::Eksblowfish
cpanm List::MoreUtils
cpanm Date::Manip
cpanm DBI
cpanm DateTime
cpanm JavaScript::Minifier::XS
cpanm Locale::Maketext::Lexicon
cpanm Plack::Handler::Starlet
cpanm Log::Dispatch
cpanm Digest::base
cpanm Tree::Simple
cpanm File::Temp
cpanm CGI::Cookie
cpanm Module::Refresh
cpanm Regexp::IPv6
cpanm Class::Accessor::Fast
cpanm MIME::Entity
cpanm Errno
cpanm Storable
cpanm DateTime::Format::Natural
cpanm Sys::Syslog
cpanm Digest::MD5
cpanm HTML::Scrubber
# DASHBOARDS dependencies:
cpanm MIME::Types
cpanm URI
cpanm URI::QueryParam
# FASTCGI dependencies:
cpanm FCGI
cpanm FCGI::ProcManager
# GPG dependencies:
cpanm File::Which
cpanm PerlIO::eol
cpanm GnuPG::Interface
# ICAL dependencies:
cpanm Data::ICal
# MAILGATE dependencies:
cpanm LWP::UserAgent
cpanm Getopt::Long
cpanm Net::SSL
cpanm Mozilla::CA
cpanm Crypt::SSLeay
cpanm Pod::Usage
cpanm LWP::Protocol::https
# PG dependencies:
cpanm DBIx::SearchBuilder
cpanm DBD::Pg
# SMIME dependencies:
cpanm Crypt::X509
cpanm File::Which
cpanm String::ShellQuote
# USERLOGO dependencies:
cpanm Convert::Color
# GD missing dependencies:
cpanm GD
cpanm GD::Text
cpanm GD::Graph

# RT
if prepare https://download.bestpractical.com/pub/rt/devel rt-4.4.0rc1.tar.gz; then
	./configure --prefix=$PREFIX \
                --with-my-user-group \
                --enable-gd \
                --enable-gpg \
                --with-db-type=Pg

    make testdeps
    make install RT_LIB_PATH=$PREFIX/lib/perl5
    # remove unneeded files
    rm -rf $PREFIX/lib/perl/t
    # copy docs
    cp -a docs $PREFIX
    cp README $PREFIX/docs
    # fix permissions
    chmod -R a+rX $PREFIX
fi

cpanm SMS::Send::Twilio
cpanm RT::Extension::SMSNotify
