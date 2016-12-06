From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: buildlib/cbuild missing yaml on SLE12SP2
Date: Tue, 6 Dec 2016 14:01:04 -0600
Message-ID: <02cc01d24ffb$79ad93d0$6d08bb70$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey Jason, 

I'm trying to run buildlib/cbuild build-images travis on rdma-core, and I'm
missing yaml.  But I think I have it installed.  At least I have perl_YAML
installed.  This is with SLE12 SP2 RC1.

stevo4-asicdesigners-com:/usr/local/src/rdma-core # zypper search yaml
Loading repository data...
Reading installed packages...

S | Name                 | Summary                                    | Type
--+----------------------+--------------------------------------------+---------
--
  | libyaml              | A YAML 1.1 parser and emitter written in C |
srcpackage
i | libyaml-0-2          | Shared library from libyaml                | package
i | libyaml-devel        | Development files for libyaml              | package
  | perl-Bootloader-YAML | YAML interface for perl-Bootloader         | package
i | perl-YAML            | YAML Ain't Markup Language (tm)            | package
  | perl-YAML            | YAML Ain't Markup Language (tm)            |
srcpackage
i | perl-YAML-LibYAML    | YAML::LibYAML Perl module                  | package
  | perl-YAML-LibYAML    | YAML::LibYAML Perl module                  |
srcpackage
  | perl-YAML-Syck       | Fast, lightweight YAML loader and dumper   | package
  | perl-YAML-Syck       | Fast, lightweight YAML loader and dumper   |
srcpackage

stevo4-asicdesigners-com:/usr/local/src/rdma-core # rpm -ql perl-YAML
/usr/lib/perl5/vendor_perl/5.18.2/Test
/usr/lib/perl5/vendor_perl/5.18.2/Test/YAML.pm
/usr/lib/perl5/vendor_perl/5.18.2/YAML
/usr/lib/perl5/vendor_perl/5.18.2/YAML.pm
/usr/lib/perl5/vendor_perl/5.18.2/YAML/Any.pm
/usr/lib/perl5/vendor_perl/5.18.2/YAML/Dumper
/usr/lib/perl5/vendor_perl/5.18.2/YAML/Dumper.pm
/usr/lib/perl5/vendor_perl/5.18.2/YAML/Dumper/Base.pm
/usr/lib/perl5/vendor_perl/5.18.2/YAML/Error.pm
/usr/lib/perl5/vendor_perl/5.18.2/YAML/Loader
/usr/lib/perl5/vendor_perl/5.18.2/YAML/Loader.pm
/usr/lib/perl5/vendor_perl/5.18.2/YAML/Loader/Base.pm
/usr/lib/perl5/vendor_perl/5.18.2/YAML/Marshall.pm
/usr/lib/perl5/vendor_perl/5.18.2/YAML/Mo.pm
/usr/lib/perl5/vendor_perl/5.18.2/YAML/Node.pm
/usr/lib/perl5/vendor_perl/5.18.2/YAML/Tag.pm
/usr/lib/perl5/vendor_perl/5.18.2/YAML/Types.pm
/usr/lib/perl5/vendor_perl/5.18.2/x86_64-linux-thread-multi
/usr/share/doc/packages/perl-YAML
/usr/share/doc/packages/perl-YAML/Changes
/usr/share/doc/packages/perl-YAML/LICENSE
/usr/share/doc/packages/perl-YAML/README
/usr/share/man/man3/Test::YAML.3pm.gz
/usr/share/man/man3/YAML.3pm.gz
/usr/share/man/man3/YAML::Any.3pm.gz
/usr/share/man/man3/YAML::Dumper.3pm.gz
/usr/share/man/man3/YAML::Dumper::Base.3pm.gz
/usr/share/man/man3/YAML::Error.3pm.gz
/usr/share/man/man3/YAML::Loader.3pm.gz
/usr/share/man/man3/YAML::Loader::Base.3pm.gz
/usr/share/man/man3/YAML::Marshall.3pm.gz
/usr/share/man/man3/YAML::Node.3pm.gz
/usr/share/man/man3/YAML::Tag.3pm.gz
/usr/share/man/man3/YAML::Types.3pm.gz


Any ideas?


Thanks,

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
