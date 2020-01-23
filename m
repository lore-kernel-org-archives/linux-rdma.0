Return-Path: <SRS0=WZnQ=3M=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99920C2D0DB
	for <linux-rdma@archiver.kernel.org>; Thu, 23 Jan 2020 15:18:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4155621835
	for <linux-rdma@archiver.kernel.org>; Thu, 23 Jan 2020 15:18:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=wp.pl header.i=@wp.pl header.b="nZ9u77Zk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgAWPSN (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 23 Jan 2020 10:18:13 -0500
Received: from mx3.wp.pl ([212.77.101.9]:50015 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbgAWPSN (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 23 Jan 2020 10:18:13 -0500
Received: (wp-smtpd smtp.wp.pl 1361 invoked from network); 23 Jan 2020 16:18:10 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1579792690; bh=HVebdqs4jjVJLiwEy7GWNt82L4WsqWx3d6tHegSCug0=;
          h=Subject:To:CC:From;
          b=nZ9u77Zk0CgC8gYFwBOLt5WyALlx2Q0aTTDjGlVjEk6erf8aUgyX/KaO552nYpWTt
           /3JJj7/o9AlfQa46sk3QmN5qVacvyLjVDPTMHIDpAPPP1swYTTu9uu3C8MImWJQUM7
           AZzOKKDuPqQShfv355bUdrZ1ZbT9mBGKw9Y2t1D8=
Received: from unknown (HELO [IPv6:2607:fb90:4a9:9af8:7bb0:36a1:c5f0:bff9]) (kubakici@wp.pl@[172.58.38.244])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <leon@kernel.org>; 23 Jan 2020 16:18:10 +0100
Date:   Thu, 23 Jan 2020 07:17:54 -0800
User-Agent: K-9 Mail for Android
In-Reply-To: <20200123145442.GP7018@unreal>
References: <20200123130541.30473-1-leon@kernel.org> <20200123064006.2012fb0b@cakuba> <20200123145442.GP7018@unreal>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH net-next] net/core: Replace driver version to be kernel version
To:     Leon Romanovsky <leon@kernel.org>, Jakub Kicinski <kuba@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
From:   Jakub Kicinski <kubakici@wp.pl>
Message-ID: <035D6EB1-B1CB-4285-97F8-534B10D9C01E@wp.pl>
X-WP-MailID: f9657610267c0eccae14476658ee131e
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [AROy]                               
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org



On January 23, 2020 6:54:42 AM PST, Leon Romanovsky <leon@kernel=2Eorg> wr=
ote:
>> Anyway, you gotta rebase on net-next, the ethtool code got moved
>around
>> :)
>
>I tried it now and It applies cleanly on top of commit
>6d9f6e6790e7 Merge branch
>'net-sched-add-Flow-Queue-PIE-packet-scheduler'

Git is magic=2E
