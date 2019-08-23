Return-Path: <SRS0=sfWj=WT=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D0EEC3A5A2
	for <linux-rdma@archiver.kernel.org>; Fri, 23 Aug 2019 21:56:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C576721019
	for <linux-rdma@archiver.kernel.org>; Fri, 23 Aug 2019 21:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392824AbfHWV4L (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 23 Aug 2019 17:56:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38358 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392652AbfHWV4L (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 23 Aug 2019 17:56:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2FE801543BD21;
        Fri, 23 Aug 2019 14:56:10 -0700 (PDT)
Date:   Fri, 23 Aug 2019 14:56:09 -0700 (PDT)
Message-Id: <20190823.145609.1166235000657587390.davem@davemloft.net>
To:     dag.moxnes@oracle.com
Cc:     santosh.shilimkar@oracle.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Subject: Re: [PATCH net-next] net/rds: Whitelist rdma_cookie and rx_tstamp
 for usercopy
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566568998-26222-1-git-send-email-dag.moxnes@oracle.com>
References: <1566568998-26222-1-git-send-email-dag.moxnes@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 23 Aug 2019 14:56:10 -0700 (PDT)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Dag Moxnes <dag.moxnes@oracle.com>
Date: Fri, 23 Aug 2019 16:03:18 +0200

> Add the RDMA cookie and RX timestamp to the usercopy whitelist.
> 
> After the introduction of hardened usercopy whitelisting
> (https://lwn.net/Articles/727322/), a warning is displayed when the
> RDMA cookie or RX timestamp is copied to userspace:
> 
> kernel: WARNING: CPU: 3 PID: 5750 at
> mm/usercopy.c:81 usercopy_warn+0x8e/0xa6
> [...]
> kernel: Call Trace:
> kernel: __check_heap_object+0xb8/0x11b
> kernel: __check_object_size+0xe3/0x1bc
> kernel: put_cmsg+0x95/0x115
> kernel: rds_recvmsg+0x43d/0x620 [rds]
> kernel: sock_recvmsg+0x43/0x4a
> kernel: ___sys_recvmsg+0xda/0x1e6
> kernel: ? __handle_mm_fault+0xcae/0xf79
> kernel: __sys_recvmsg+0x51/0x8a
> kernel: SyS_recvmsg+0x12/0x1c
> kernel: do_syscall_64+0x79/0x1ae
> 
> When the whitelisting feature was introduced, the memory for the RDMA
> cookie and RX timestamp in RDS was not added to the whitelist, causing
> the warning above.
> 
> Signed-off-by: Dag Moxnes <dag.moxnes@oracle.com>
> Tested-by: jenny.x.xu@oracle.com

Applied, with tested-by tag fixed.

Thanks.
