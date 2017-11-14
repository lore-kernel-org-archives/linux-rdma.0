From: owner-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org (Debian Bug Tracking System)
Subject: Bug#860498: marked as done (support autoloading of kernel modules)
Date: Tue, 14 Nov 2017 12:03:23 +0000
Message-ID: <handler.860498.D860498.151066078826312.ackdone@bugs.debian.org>
References: <1510660782.4026.29.camel@profitbricks.com>
 <149247030901.19532.4421317403592978228.reportbug@xps13.dannf>
Reply-To: 860498-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----------=_1510661003-28313-0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format...

------------=_1510661003-28313-0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Your message dated Tue, 14 Nov 2017 12:59:42 +0100
with message-id <1510660782.4026.29.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
and subject line Re: support autoloading of kernel modules
has caused the Debian Bug report #860498,
regarding support autoloading of kernel modules
to be marked as done.

This means that you claim that the problem has been dealt with.
If this is not the case it is now your responsibility to reopen the
Bug report if necessary, and/or fix the problem forthwith.

(NB: If you are a system administrator and have no idea what this
message is talking about, this may indicate a serious mail system
misconfiguration somewhere. Please contact owner-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org
immediately.)


--=20
860498: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D860498
Debian Bug Tracking System
Contact owner-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org with problems

------------=_1510661003-28313-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at submit) by bugs.debian.org; 17 Apr 2017 23:12:28 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.0-bugs.debian.org_2005_01_02
	(2014-02-07) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=4.0 tests=BAYES_00,FOURLA,
	FROMDEVELOPER,HAS_PACKAGE,RCVD_IN_DNSWL_NONE,XMAILER_REPORTBUG autolearn=ham
	autolearn_force=no version=3.4.0-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 18; hammy, 150; neutral, 73; spammy,
	0. spammytokens: hammytokens:0.000-+--H*M:reportbug, 0.000-+--H*MI:reportbug,
	0.000-+--systemd, 0.000-+--H*x:reportbug, 0.000-+--H*UA:reportbug
Return-path: <dannf-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Received: from complete.lackof.org ([198.49.126.79])
	by buxtehude.debian.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.84_2)
	(envelope-from <dannf-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>)
	id 1d0Fop-00068R-RB
	for submit-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org; Mon, 17 Apr 2017 23:12:27 +0000
Received: from localhost (c-107-2-141-92.hsd1.co.comcast.net [107.2.141.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client did not present a certificate)
	by complete.lackof.org (Postfix) with ESMTPSA id 7E09933E01C8;
	Mon, 17 Apr 2017 17:05:09 -0600 (MDT)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: dann frazier <dannf-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
To: Debian Bug Tracking System <submit-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org>
Subject: support autoloading of kernel modules
Message-ID: <149247030901.19532.4421317403592978228.reportbug-Nq5M5umRAOQi7DXBEVcY1Q@public.gmane.org>
X-Mailer: reportbug 7.1.5
Date: Mon, 17 Apr 2017 17:05:09 -0600
X-Greylist: delayed 436 seconds by postgrey-1.35 at buxtehude; Mon, 17 Apr 2017 23:12:27 UTC
Delivered-To: submit-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org

Package: ibverbs-utils
Version: 1.2.1-2
Severity: normal

Certain kernel modules need to be loaded to use this stack, for example:

dannf@xps13:~$ sudo ibv_devinfo
Failed to get IB devices list: Function not implemented
dannf@xps13:~$ sudo modprobe ib_uverbs
dannf@xps13:~$ sudo ibv_devinfo
libibverbs: Warning: couldn't open config directory '/etc/libibverbs.d'.
No IB devices found

It seems like we could be loading the necessary modules automatically.
Indeed, there seems to be code in the rdma-core repo for doing so:

redhat/rdma.udev-rules
redhat/rdma.kernel-init

Could we enable such a facility for Debian?

-- System Information:
Debian Release: 9.0
  APT prefers unstable
  APT policy: (500, 'unstable'), (500, 'testing'), (1, 'experimental')
Architecture: amd64 (x86_64)

Kernel: Linux 4.9.0-2-amd64 (SMP w/4 CPU cores)
Locale: LANG=en_US.UTF-8, LC_CTYPE=en_US.UTF-8 (charmap=UTF-8)
Shell: /bin/sh linked to /bin/dash
Init: systemd (via /run/systemd/system)

Versions of packages ibverbs-utils depends on:
ii  libc6              2.24-10
ii  libibverbs1        1.2.1-2
ii  libnl-3-200        3.2.27-2
ii  libnl-route-3-200  3.2.27-2

ibverbs-utils recommends no packages.

ibverbs-utils suggests no packages.

-- no debconf information

------------=_1510661003-28313-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at 860498-done) by bugs.debian.org; 14 Nov 2017 11:59:48 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.1-bugs.debian.org_2005_01_02
	(2015-04-28) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.2 required=4.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FOURLA,RCVD_IN_DNSWL_LOW,T_SPF_PERMERROR,URIBL_CNKR,VERSION
	autolearn=no autolearn_force=no version=3.4.1-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 29; hammy, 150; neutral, 58; spammy,
	0. spammytokens: hammytokens:0.000-+--Drung, 0.000-+--drung,
	0.000-+--Hx-spam-relays-external:sk:smtp.go, 0.000-+--kernel's,
	0.000-+--H*M:camel
Return-path: <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Received: from mail-lf0-x229.google.com ([2a00:1450:4010:c07::229])
	by buxtehude.debian.org with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.89)
	(envelope-from <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>)
	id 1eEZsa-0006q6-3r
	for 860498-done-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org; Tue, 14 Nov 2017 11:59:48 +0000
Received: by mail-lf0-x229.google.com with SMTP id s16so21733077lfs.1
        for <860498-done-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org>; Tue, 14 Nov 2017 03:59:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=profitbricks-com.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=ztFFweJdKQ6Mqt/LX/+3lvtPynVYCMrFDtUWDZ4GGiE=;
        b=lOiDlwpPkR5UQH1amOm/HRpNXxYb28CSTVQbho0Tdp7PWqElljo75+63qoZ26QFcu4
         /EFb6AWpi7DnT/plzB/fpMX+jPiRDB4kF1FieV98N55TBNI/OFj0yZ1cUfNBMXDdKTIJ
         +B6mh7zhPJPrM9Aze4A/lYx7iyEjMpDNfFwjBXHjOJG+J9qomHlm02L7NOzF6RiwsOji
         KOU7H6/2eGFG0+gN1Y7q6Y037PmCZR3Ozkb3yXy94aTmBWOPzO9Q9EidjEPxaAmvnW6V
         JbTzYzkChyFiGWNkHdGT1KO5B8nHfaQ4+y0ss+N//cTxaaWn/rvxAuueQInouk3roahF
         kzjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=ztFFweJdKQ6Mqt/LX/+3lvtPynVYCMrFDtUWDZ4GGiE=;
        b=JOkz5j1j/2z2dH85Sc4QEzLE3pJSj4G1TAYJ4Dd6ruJL0aGPlT2oPLNOd9oC8nhGns
         tMGwH0nFNgOASSDR6jlwACPcWDimHDrCGLlR1yQfZQAuZQ+5ew6kpoMZiRmgkGvMYVYC
         qnF+MxYZKXre6ffetR5Nm+shq2JH2c7jdL4vODtrRIiOe5yFIVrDJp/1zOBkZ69lsqEa
         kkGl9WHVIezwsYTyEA0m0K6bDjGjakRtBArFP8uDzU3st9gM/XEAEsvfLPKI5pcnzWKn
         B/Khy+bzXXueSqD6xjnCdh1BP3L0ywaNzJEpwZSEE+2D/4OP+n0V6PLNhzqoFAJU5eFx
         Ivew==
X-Gm-Message-State: AJaThX6QzgdKvPaq7neZrbwZ9FMlpexQw7pgwAMM5h8ktbVqdzfftx1L
	WjYhbXFGS8YjA9XhBySkTiM5Ism5y9M=
X-Google-Smtp-Source: AGs4zMaoHMBDJhZXTU309Xt0rSXtgClsMgEXnXMb9ZJ6nCVMllWqNBw8HF2A//+Oy7MLf6cN6tqfgA==
X-Received: by 10.25.163.196 with SMTP id m187mr4003825lfe.244.1510660783565;
        Tue, 14 Nov 2017 03:59:43 -0800 (PST)
Received: from konstrukt ([62.217.45.26])
        by smtp.googlemail.com with ESMTPSA id 8sm3708647ljs.34.2017.11.14.03.59.42
        for <860498-done-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Nov 2017 03:59:42 -0800 (PST)
Message-ID: <1510660782.4026.29.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: support autoloading of kernel modules
From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
To: 860498-done-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org
Date: Tue, 14 Nov 2017 12:59:42 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit

Version: 15-1

We have rdma-core in Debian unstable now. This source package provides
a binary package called 'rdma-core' which provides the basic boot time
support for systems that use the Linux kernel's remote direct memory
access (RDMA) subystem which includes InfiniBand, iWARP, and RDMA over
Converged Ethernet (RoCE).

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
------------=_1510661003-28313-0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
