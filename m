From: owner-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org (Debian Bug Tracking System)
Subject: Bug#854217: marked as done (mark libibverbs1 Multi-Arch: same)
Date: Tue, 14 Nov 2017 10:48:03 +0000
Message-ID: <handler.854217.D854217.151065635726026.ackdone@bugs.debian.org>
References: <1510656350.4026.19.camel@profitbricks.com>
 <20170205073306.43smjtamm3cah7co@alf.mars>
Reply-To: 854217-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----------=_1510656483-26600-0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format...

------------=_1510656483-26600-0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Your message dated Tue, 14 Nov 2017 11:45:50 +0100
with message-id <1510656350.4026.19.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
and subject line Re: mark libibverbs1 Multi-Arch: same
has caused the Debian Bug report #854217,
regarding mark libibverbs1 Multi-Arch: same
to be marked as done.

This means that you claim that the problem has been dealt with.
If this is not the case it is now your responsibility to reopen the
Bug report if necessary, and/or fix the problem forthwith.

(NB: If you are a system administrator and have no idea what this
message is talking about, this may indicate a serious mail system
misconfiguration somewhere. Please contact owner-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org
immediately.)


--=20
854217: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D854217
Debian Bug Tracking System
Contact owner-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org with problems

------------=_1510656483-26600-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at submit) by bugs.debian.org; 5 Feb 2017 07:33:21 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.0-bugs.debian.org_2005_01_02
	(2014-02-07) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=4.0 tests=BAYES_00,FOURLA,HAS_PACKAGE,
	MURPHY_DRUGS_REL8,RCVD_IN_DNSWL_NONE,URIBL_CNKR autolearn=ham
	autolearn_force=no version=3.4.0-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 17; hammy, 150; neutral, 133; spammy,
	0. spammytokens: hammytokens:0.000-+--H*UA:NeoMutt, 0.000-+--H*u:NeoMutt,
	0.000-+--libdevel, 0.000-+--H*UA:1.7.1, 0.000-+--H*u:1.7.1
Return-path: <helmut-MfS4ITiXE9OELgA04lAiVw@public.gmane.org>
Received: from isilmar-3.linta.de ([188.40.101.200] helo=linta.de)
	by buxtehude.debian.org with esmtps (TLS1.2:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.84_2)
	(envelope-from <helmut-MfS4ITiXE9OELgA04lAiVw@public.gmane.org>)
	id 1caHK5-0001n2-3z
	for submit-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org; Sun, 05 Feb 2017 07:33:21 +0000
Received: (qmail 29649 invoked from network); 5 Feb 2017 07:33:18 -0000
Received: from localhost (HELO isilmar-3.linta.de) (127.0.0.1)
  by localhost with SMTP; 5 Feb 2017 07:33:18 -0000
Date: Sun, 5 Feb 2017 08:33:08 +0100
From: Helmut Grohne <helmut-MfS4ITiXE9OELgA04lAiVw@public.gmane.org>
To: Debian Bug Tracking System <submit-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org>
Subject: mark libibverbs1 Multi-Arch: same
Message-ID: <20170205073306.43smjtamm3cah7co-16Bhb28lvWY@public.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xm5n3jlqioszeykm"
Content-Disposition: inline
X-Reportbug-Version: 7.1.1
User-Agent: NeoMutt/20161014 (1.7.1)
Delivered-To: submit-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org


--xm5n3jlqioszeykm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Package: libibverbs1
Version: 1.2.1-2
Tags: patch
User: helmutg-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org
Usertags: rebootstrap
Control: affects -1 + src:armci-mpi src:ffindex src:gfsview src:lammps src:mpi-defaults src:otf src:scotch

The affected packages cannot satisfy their cross build dependencies,
because their transitive dependencies on libibverbs1 cannot be
satisfied. The bootstrap.d.n metadata processing indicates[1] more
affected packages. All of the packages need libibverbs1 for both the
build architecture and the host architecture. Such dependencies can only
be satisfied when the dependee, libibverbs1, is marked as Multi-Arch:
foreign or Multi-Arch: same. The former doesn't make any sense for
shared libraries, so we need to consider whether the latter is correct.
libibverbs1 already uses multiarch paths and its postinst keeps working
when executed repeatedly. Thus the marking is correct. libibverbs-dev
and libibverbs-dbg also use multiarch paths and none of the latter has
maintainer scripts, so marking them Multi-Arch: same is correct as well.
The attached patch adds all of those markings. Please consider applying
it after stretch is released.

Helmut

[1] https://bootstrap.debian.net/cross_all/libibverbs.html

--xm5n3jlqioszeykm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="libibverbs_1.2.1-2.1.debdiff"

diff --minimal -Nru libibverbs-1.2.1/debian/changelog libibverbs-1.2.1/debian/changelog
--- libibverbs-1.2.1/debian/changelog	2016-09-13 22:17:54.000000000 +0200
+++ libibverbs-1.2.1/debian/changelog	2017-02-05 08:04:11.000000000 +0100
@@ -1,3 +1,10 @@
+libibverbs (1.2.1-2.1) UNRELEASED; urgency=medium
+
+  * Non-maintainer upload.
+  * Mark lib* packages Multi-Arch: same (Closes: #-1)
+
+ -- Helmut Grohne <helmut-MfS4ITiXE9OELgA04lAiVw@public.gmane.org>  Sun, 05 Feb 2017 08:04:11 +0100
+
 libibverbs (1.2.1-2) unstable; urgency=medium
 
   * Add patch update_barriers: add barriers for MIPS and
diff --minimal -Nru libibverbs-1.2.1/debian/control libibverbs-1.2.1/debian/control
--- libibverbs-1.2.1/debian/control	2016-09-12 00:29:26.000000000 +0200
+++ libibverbs-1.2.1/debian/control	2017-02-05 08:04:04.000000000 +0100
@@ -16,6 +16,7 @@
 
 Package: libibverbs1
 Architecture: any
+Multi-Arch: same
 Depends: ${shlibs:Depends}, ${misc:Depends}, adduser
 Description: Library for direct userspace use of RDMA (InfiniBand/iWARP)
  libibverbs is a library that allows userspace processes to use RDMA
@@ -35,6 +36,7 @@
 Package: libibverbs-dev
 Section: libdevel
 Architecture: any
+Multi-Arch: same
 Depends: ${misc:Depends}, libibverbs1 (= ${binary:Version})
 Description: Development files for the libibverbs library
  libibverbs is a library that allows userspace processes to use RDMA
@@ -53,6 +55,7 @@
 Package: libibverbs1-dbg
 Section: debug
 Architecture: any
+Multi-Arch: same
 Depends: ${misc:Depends}, libibverbs1 (= ${binary:Version})
 Description: Debugging symbols for the libibverbs library
  libibverbs is a library that allows userspace processes to use RDMA

--xm5n3jlqioszeykm--

------------=_1510656483-26600-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at 854217-done) by bugs.debian.org; 14 Nov 2017 10:45:57 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.1-bugs.debian.org_2005_01_02
	(2015-04-28) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.3 required=4.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,T_SPF_PERMERROR,URIBL_CNKR,VERSION autolearn=no
	autolearn_force=no version=3.4.1-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 31; hammy, 150; neutral, 32; spammy,
	0. spammytokens: hammytokens:0.000-+--Hx-spam-relays-external:22c,
	0.000-+--H*RU:22c, 0.000-+--drung, 0.000-+--Drung,
	0.000-+--Hx-spam-relays-external:sk:smtp.go
Return-path: <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Received: from mail-lf0-x22c.google.com ([2a00:1450:4010:c07::22c])
	by buxtehude.debian.org with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.89)
	(envelope-from <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>)
	id 1eEYj7-0006lM-CB
	for 854217-done-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org; Tue, 14 Nov 2017 10:45:57 +0000
Received: by mail-lf0-x22c.google.com with SMTP id o66so13499611lfg.0
        for <854217-done-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org>; Tue, 14 Nov 2017 02:45:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=profitbricks-com.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=4p5sqm5CEvtMfFt/bSLP2d7E2YzLmHq4mtxS1ElMYuQ=;
        b=GAtb+KGJH02EleCQ9Eu1eph0HoPQkgS57akKdlmIs2KvKfN4yP3r8MdZlyxH7K1xxi
         eSS9JT6MLf7yuX+tATe+BjR7UK6iLcC49toXGlhXRBiA3NDXQJ7fnAG8O6E8q/iBG5wO
         TCa9nMxlHg1VqUpP7Q6kDAuOt03sbgqgjg3meBcmds5fKeTBvxNO6Cbyo11EuMRKx4rA
         wmrPYP9fDiC8pZeSgVmnWTALqU2Mrm/8DR/DARdoFEMVvDYgIzqxDp5o59D+ytLsKxw6
         HnX8DT9HibIuMiuKepFN+tz/lrzN+RtIdHw2TZ9/jqatLprTRxGzGhZRDGNVkj8jZkQ6
         IDvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=4p5sqm5CEvtMfFt/bSLP2d7E2YzLmHq4mtxS1ElMYuQ=;
        b=htjrxxrjjnI/oBhX8Na74TqJzRrcD6XspVI5DSihM7ImJZX7uEyLOowJpUKDtrvQHV
         AYGcJgh+dxjGapMNleGkl1W4l9GLALNtMzfNgJYvnj6AaGJ/dhefUKtmH4oL1dmIsayV
         hPTFwr2TEvrxqMC/QnHMLreMOKvWhssZE+AdHrl5NDj5OpnHDAt4SA2NcMfGT2dD13Oe
         5Lc1Bl3cEoMhfh5jk8bK4I9yngUlOfYCWWunIP7Rj86eMyCpz2YnvJTrAJfN1ZC56sqM
         KpLXj/gIQrWWiNGpij8mTnzm3TsBsgypI8dicLp+DMm96mMOIeHY8wo18hb+HXwvwg5D
         hz8A==
X-Gm-Message-State: AJaThX7mSatyGuCa3flIqfqLJyNIlxtQAjTnav5mp/atRcIGlNWgEQV4
	2GupKyYMXsNMG9QsrPEJV6vLizwBHXE=
X-Google-Smtp-Source: AGs4zMbX1RKMHraZfNjP8o94DUyVH9HPetdUjCvvuvghtZWeDi3Hk/jOQK+5UE18UngUVdFwt7h0sA==
X-Received: by 10.46.42.196 with SMTP id q187mr4349500ljq.59.1510656352151;
        Tue, 14 Nov 2017 02:45:52 -0800 (PST)
Received: from konstrukt ([62.217.45.26])
        by smtp.googlemail.com with ESMTPSA id o86sm1515940lja.2.2017.11.14.02.45.51
        for <854217-done-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Nov 2017 02:45:51 -0800 (PST)
Message-ID: <1510656350.4026.19.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: mark libibverbs1 Multi-Arch: same
From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
To: 854217-done-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org
Date: Tue, 14 Nov 2017 11:45:50 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit

Version: 15-1

libibverbs1 15-1 (from rdma-core source package) is marked as Multi-
Arch: same.

-- 
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL: https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Geschäftsführer: Achim Weiss, Matthias Steinberg
------------=_1510656483-26600-0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
