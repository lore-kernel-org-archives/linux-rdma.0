From: owner-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org (Debian Bug Tracking System)
Subject: Bug#881731: marked as done (rdma-core: FTBFS on armhf and mips*:
 missing providers that need coherent DMA)
Date: Thu, 16 Nov 2017 12:39:03 +0000
Message-ID: <handler.881731.D881731.151083566020165.ackdone@bugs.debian.org>
References: <E1eFJN2-000FNY-O1@fasolo.debian.org>
 <151067381730.19157.7563136692092597267.reportbug@ghostwheel.internal.ucko.debian.net>
Reply-To: 881731-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----------=_1510835943-22710-0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format...

------------=_1510835943-22710-0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Your message dated Thu, 16 Nov 2017 12:34:16 +0000
with message-id <E1eFJN2-000FNY-O1-zBwJlDMnrE7yUObV3Cmqeti2O/JbrIOy@public.gmane.org>
and subject line Bug#881731: fixed in rdma-core 15-2
has caused the Debian Bug report #881731,
regarding rdma-core: FTBFS on armhf and mips*: missing providers that need =
coherent DMA
to be marked as done.

This means that you claim that the problem has been dealt with.
If this is not the case it is now your responsibility to reopen the
Bug report if necessary, and/or fix the problem forthwith.

(NB: If you are a system administrator and have no idea what this
message is talking about, this may indicate a serious mail system
misconfiguration somewhere. Please contact owner-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org
immediately.)


--=20
881731: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D881731
Debian Bug Tracking System
Contact owner-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org with problems

------------=_1510835943-22710-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at submit) by bugs.debian.org; 14 Nov 2017 15:37:02 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.1-bugs.debian.org_2005_01_02
	(2015-04-28) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=4.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FROMDEVELOPER,RCVD_IN_DNSWL_MED,XMAILER_REPORTBUG,X_DEBBUGS_CC
	autolearn=ham autolearn_force=no version=3.4.1-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 26; hammy, 150; neutral, 139; spammy,
	0. spammytokens: hammytokens:0.000-+--UD:init.d, 0.000-+--initd,
	0.000-+--init.d, 0.000-+--armhf, 0.000-+--mipsel
Return-path: <ucko-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Received: from a2i371.smtp2go.com ([103.47.205.115])
	by buxtehude.debian.org with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.89)
	(envelope-from <ucko-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>)
	id 1eEdGn-0007Te-9K
	for submit-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org; Tue, 14 Nov 2017 15:37:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=smtpservice.net; s=m59lw0.a1-4.dyn; x=1510674721; h=Feedback-ID:
	X-Smtpcorp-Track:Date:Message-ID:Subject:To:From:Reply-To:Sender:
	List-Unsubscribe; bh=mL/ReWT1qNzGMU++2KTbXTxDf5REIlQqwvu3DI5H5iE=; b=OiwXQVzC
	ynyt+Z9s0pivWpo7KQy0bxf0O57C4hqUvoDYIGA/Y6tlsHfnNnEonTlJpqSGStuB5t1Q9FfBecxE8
	bmtlOhGXYXn8LYSuBFH0Eo+DWrwabqUmNTD0HihGm6T0UbAXq6KfKJ7yPCb7hf/5XMQ0e9/P5cSLh
	IFC/XNdixSmRDjaOUXVYiYccuEHdMRnhtArBmH7IB36Ag8wZNC+ZlIniAQBToHwOKdl7l/QX3PJyZ
	iCd7vUiwwVV3v6Hxz/mamDLX4r8EeDM6R1fX6JXOBZMNtZXoFkneMANSqHOGST/fFN9hWD0ufv3+/
	o5EVbfmJHF6sNMFHY4YSZITJOQ==;
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Aaron M. Ucko" <ucko-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
To: Debian Bug Tracking System <submit-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org>
Subject: rdma-core: FTBFS on armhf and mips*: missing providers that need coherent DMA
Message-ID: <151067381730.19157.7563136692092597267.reportbug-zzSRVt8NT6e1HqDL4FJmnCRvllpaP1wPhfTf9rENOI/R7s880joybQ@public.gmane.org>
X-Mailer: reportbug 7.1.7
Date: Tue, 14 Nov 2017 10:36:57 -0500
X-Debbugs-Cc: ucko-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org
X-Smtpcorp-Track: 1-EdGMmPZwuwVC.C02Y4Vhgn
Feedback-ID: 245732m:245732aR6ZNzQ:245732s7-nJemP9O:SMTPCORP
X-Report-Abuse: Please forward a copy of this message, including all
 headers, to <abuse-contact-TfCdKtXZGdpBDgjK7y7TUQ@public.gmane.org>
Delivered-To: submit-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org

Source: rdma-core
Version: 15-1
Severity: important
Tags: upstream
Justification: fails to build from source
User: debian-mips-0aAXYlwwYIJuHlm7Suoebg@public.gmane.org
Usertags: mips mips64el mipsel

Builds of rdma-core for armhf and mips* have been failing:

  -- Performing Test HAVE_COHERENT_DMA
  -- Performing Test HAVE_COHERENT_DMA - Failed
  [...]
  -- Missing Optional Items:
  --  Compiler attribute ifunc NOT supported
  --  Architecture NOT able to do coherent DMA (check util/udma_barrier.h) some providers disabled!
  [...]
  dh_install --fail-missing -X"etc/init.d/srpd" -X"usr/sbin/run_srp_daemon" -X"usr/sbin/srp_daemon.sh"
  dh_install: Please use dh_missing --list-missing/--fail-missing instead
  dh_install: This feature will be removed in compat 12.
  dh_install: Cannot find (any matches for) "etc/modprobe.d/mlx4.conf" (tried in ., debian/tmp)
  [...]
  dh_install: libibverbs-dev missing files: usr/share/man/man7/mlx5dv.7
  dh_install: missing files, aborting
  debian/rules:45: recipe for target 'override_dh_install' failed
  make[1]: *** [override_dh_install] Error 25

As the log indicates, upstream compensates for udma_barrier.h's
limited architecture coverage by disabling providers that need
coherent DMA rather than failing the build altogether.  As such, one
possibility would be to accommodate these providers' potential absence
by (e.g.) wildcarding more aggressively.  However, it would of course
be better to teach udma_barrier.h about these architectures.  I don't
know what appropriate definitions of udma_to_device_barrier,
udma_from_device_barrier, and mmio_flush_writes would be there, but
I'm usertagging porters who presumably will know what to use.

Could you please take a look?

Thanks!

-- 
Aaron M. Ucko, KB1CJC (amu at alum.mit.edu, ucko at debian.org)
http://www.mit.edu/~amu/ | http://stuff.mit.edu/cgi/finger/?amu-KmzlPT+mPuP2fBVCVOL8/A@public.gmane.org

------------=_1510835943-22710-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at 881731-close) by bugs.debian.org; 16 Nov 2017 12:34:20 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.1-bugs.debian.org_2005_01_02
	(2015-04-28) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=4.0 tests=BAYES_00,DIGITS_LETTERS,
	FOURLA,FVGT_m_MULTI_ODD,HAS_BUG_NUMBER,HEADER_FROM_DIFFERENT_DOMAINS,
	MD5_SHA1_SUM,NEEDED,PGPSIGNATURE,RCVD_IN_DNSWL_MED,RP_MATCHES_RCVD,URIBL_CNKR
	autolearn=ham autolearn_force=no version=3.4.1-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 84; hammy, 150; neutral, 209; spammy,
	0. spammytokens: hammytokens:0.000-+--HX-Debian:DAK,
	0.000-+--H*rp:D*ftp-master.debian.org, 0.000-+--HX-DAK:process-upload,
	0.000-+--Hx-spam-relays-external:sk:envelop, 0.000-+--H*r:138.16.160
Return-path: <envelope-Lx6IQGP78c/Z1gQgfCZkLYSLwOllVvif@public.gmane.org>
Received: from mailly.debian.org ([2001:41b8:202:deb:6564:a62:52c3:4b72])
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=mailly.debian.org,EMAIL=hostmaster-8l77nVeZ4z/yUObV3Cmqeti2O/JbrIOy@public.gmane.org (verified)
	by buxtehude.debian.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.89)
	(envelope-from <envelope-Lx6IQGP78c/Z1gQgfCZkLYSLwOllVvif@public.gmane.org>)
	id 1eFJN6-0005Ek-1H
	for 881731-close-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org; Thu, 16 Nov 2017 12:34:20 +0000
Received: from [138.16.160.17] (helo=fasolo.debian.org)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster-zBwJlDMnrE7yUObV3Cmqeti2O/JbrIOy@public.gmane.org (verified)
	by mailly.debian.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.89)
	(envelope-from <envelope-Lx6IQGP78c/Z1gQgfCZkLYSLwOllVvif@public.gmane.org>)
	id 1eFJN3-0006Ef-P2; Thu, 16 Nov 2017 12:34:18 +0000
Received: from dak by fasolo.debian.org with local (Exim 4.89)
	(envelope-from <envelope-Lx6IQGP78c/Z1gQgfCZkLYSLwOllVvif@public.gmane.org>)
	id 1eFJN2-000FNY-O1; Thu, 16 Nov 2017 12:34:16 +0000
From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
To: 881731-close-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: rdma-core
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Bug#881731: fixed in rdma-core 15-2
Message-Id: <E1eFJN2-000FNY-O1-zBwJlDMnrE7yUObV3Cmqeti2O/JbrIOy@public.gmane.org>
Date: Thu, 16 Nov 2017 12:34:16 +0000

Source: rdma-core
Source-Version: 15-2

We believe that the bug you reported is fixed in the latest version of
rdma-core, which is due to be installed in the Debian FTP archive.

A summary of the changes between this version and the previous one is
attached.

Thank you for reporting the bug, which will now be closed.  If you
have further comments please address them to 881731-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org,
and the maintainer will reopen the bug report if appropriate.

Debian distribution maintenance software
pp.
Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org> (supplier of updated rdma-core package)

(This message was generated automatically at their request; if you
believe that there is a problem with it please contact the archive
administrators by mailing ftpmaster-Lx6IQGP78c/Z1gQgfCZkLYSLwOllVvif@public.gmane.org)


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 1.8
Date: Thu, 16 Nov 2017 12:55:28 +0100
Source: rdma-core
Binary: rdma-core ibacm ibverbs-providers ibverbs-utils libibverbs-dev libibverbs1 libibcm-dev libibcm1 libibumad-dev libibumad3 librdmacm-dev librdmacm1 rdmacm-utils srptools
Architecture: source
Version: 15-2
Distribution: unstable
Urgency: medium
Maintainer: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Changed-By: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Description:
 ibacm      - InfiniBand Communication Manager Assistant (ACM)
 ibverbs-providers - User space provider drivers for libibverbs
 ibverbs-utils - Examples for the libibverbs library
 libibcm-dev - Development files for the libibcm library
 libibcm1   - InfiniBand Communication Manager (CM) library
 libibumad-dev - Development files for libibumad
 libibumad3 - InfiniBand Userspace Management Datagram (uMAD) library
 libibverbs-dev - Development files for the libibverbs library
 libibverbs1 - Library for direct userspace use of RDMA (InfiniBand/iWARP)
 librdmacm-dev - Development files for the librdmacm library
 librdmacm1 - Library for managing RDMA connections
 rdma-core  - RDMA core userspace infrastructure and documentation
 rdmacm-utils - Examples for the librdmacm library
 srptools   - Tools for Infiniband attached storage (SRP)
Closes: 881731
Changes:
 rdma-core (15-2) unstable; urgency=medium
 .
   * Do not build ibacm for non-Linux architectures
   * Do not require valgrind if not available
   * Let libibverbs1 15 break ibverbs-providers 14
   * Drop dh-systemd build dependency
   * Bump Standards-Version to 4.1.1 (no changes needed)
   * Drop lintian overrides for false positives
   * Set myself as maintainer (instead of linux-rdma)
   * Do not try to install disabled ibverbs providers on architectures that do
     not provide cache coherent DMA (Closes: #881731)
   * Explicitly list private libibverbs symbols
Checksums-Sha1:
 36eff0afe60382053018f7866b615b03d0a9b558 2782 rdma-core_15-2.dsc
 7e9699b32b6120e075b0d7397bc232f55ab98822 17336 rdma-core_15-2.debian.tar.xz
 99492dd9fad4c4821610aadaef086aec28af6628 8498 rdma-core_15-2_source.buildinfo
Checksums-Sha256:
 05bd4c6e600109fb0ca332af6396c09318c1bc8963fd61bcfec17ad6c9d656af 2782 rdma-core_15-2.dsc
 9962dbb5019b144fe1528e427a786caab8ffd53c75385a4832bf037dff3bbb21 17336 rdma-core_15-2.debian.tar.xz
 a0c83d1bb167c06bc7dd02c87263423d379d18cbb820a941b10771eb77765125 8498 rdma-core_15-2_source.buildinfo
Files:
 68528e3fc865833c7fa7fb3de4997d39 2782 net optional rdma-core_15-2.dsc
 802fd5e813c8a6003ac51e8baa5615b7 17336 net optional rdma-core_15-2.debian.tar.xz
 ed674b1d66cf68c6a0a22f91c27c8ea9 8498 net optional rdma-core_15-2_source.buildinfo

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJaDYBQAAoJEN2M1aXejH56IUsQAJ1pCykPrQhmMqpZFS55abWm
wufFH1ZR1ExSes1Vt/9qRwiAg8yVAY/19+ZEhSPbd5zSL51FJdp8dVhACRP1oLj3
n2JZPKCWGijok1A3xBY48+xK7/+U6Qgh8TdbXG2YEnQ6nuJE6snytMIltIOKjh8T
Qz5nfU8OT5MG+3CNC+U7lmM15srRyAeTi9Efl9O6rUFGs5fDkw+BQ0nlZA4GUvKW
FqiTk93UvfoYilqJRb/AykNRjDUxQbFabQXiQ/PMBi41p4LeVC1J2jWj3NhPrOJy
viTp0YOGe+BDRsqXOaksUqUmD/sqXe6GoxFftpUnRfJCFrXnny8jG1xQQQnRbPSe
Uqe1jEOU30ioaj9oXcIQcmDY8+HxcpJzep3qDrwgeQkuEzgJX1HBOwLpJmg81VSq
ra0HDZhBSeEiSSMKTkExxIlXHevwKS5185Ra1dhVnzsBEiPjvQ0VrGkQcBhOXtRA
8qRKGrOV+L7AFYSfQxwDzra6JFnzeirMw8QGiMgTPh4ma7lyEPzQWGYA5qeamOAs
u9JPGiAIZvgTjFI4upUS2xv70uwN7vlN9jIHBRH/2Gx19Ym9khJvnZ6HJ18OLu+0
XHGllGEkJKbF/ccSrHCTzDdQfglr4i5mPuCKVSb/fYzq4gWs0y/ynEZ/+dK5+R7K
LBICGAgJMMOKmjJ45qI1
=h96j
-----END PGP SIGNATURE-----
------------=_1510835943-22710-0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
