Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F805C5519F
	for <linux-rdma@archiver.kernel.org>; Sun, 22 Nov 2020 12:49:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0FF72078D
	for <linux-rdma@archiver.kernel.org>; Sun, 22 Nov 2020 12:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgKVMtP (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 22 Nov 2020 07:49:15 -0500
Received: from gentwo.org ([3.19.106.255]:37398 "EHLO gentwo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727646AbgKVMtP (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 22 Nov 2020 07:49:15 -0500
Received: by gentwo.org (Postfix, from userid 1002)
        id 742A73F3FF; Sun, 22 Nov 2020 12:49:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
        by gentwo.org (Postfix) with ESMTP id 71EE83F0E1;
        Sun, 22 Nov 2020 12:49:14 +0000 (UTC)
Date:   Sun, 22 Nov 2020 12:49:14 +0000 (UTC)
From:   Christopher Lameter <cl@linux.com>
X-X-Sender: cl@www.lameter.com
To:     =?ISO-8859-15?Q?H=E5kon_Bugge?= <haakon.bugge@oracle.com>
cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Mark Haywood <mark.haywood@oracle.com>,
        OFED mailing list <linux-rdma@vger.kernel.org>
Subject: Re: Is there a working cache for path record and lids etc for
 librdmacm?
In-Reply-To: <6F632AE0-7921-4C5F-8455-F8E9390BD071@oracle.com>
Message-ID: <alpine.DEB.2.22.394.2011221246230.261606@www.lameter.com>
References: <alpine.DEB.2.22.394.2011170253150.206345@www.lameter.com> <20201117193329.GH244516@ziepe.ca> <alpine.DEB.2.22.394.2011201805000.248138@www.lameter.com> <6F632AE0-7921-4C5F-8455-F8E9390BD071@oracle.com>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="531401748-372401157-1606049354=:261606"
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531401748-372401157-1606049354=:261606
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Fri, 20 Nov 2020, Håkon Bugge wrote:
> > Oh great. I did not know. Will work with them to get things sorted out.
> Inside Oracle, we're only using it for resolving IB routes. A cache for
> address resolution already exists in the kernel. There is a config
> option to disable address resolution from user-space
> (acme_plus_kernel_only).

The app that we have runs in user space. Can it use the cache? Is the
cache only in Mellanox OFED? I heard that it was removed.

This is an an option while building ibacm?

And yes we need it to resolve IB routes.

Can you share a working config?

--531401748-372401157-1606049354=:261606--
