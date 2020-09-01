Return-Path: <SRS0=lY8S=CK=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B2B4C433E6
	for <linux-rdma@archiver.kernel.org>; Tue,  1 Sep 2020 20:14:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC3992078B
	for <linux-rdma@archiver.kernel.org>; Tue,  1 Sep 2020 20:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbgIAUNz (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 1 Sep 2020 16:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbgIAUNz (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 1 Sep 2020 16:13:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C080FC061244;
        Tue,  1 Sep 2020 13:13:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5EA0E1364C88D;
        Tue,  1 Sep 2020 12:57:07 -0700 (PDT)
Date:   Tue, 01 Sep 2020 13:13:53 -0700 (PDT)
Message-Id: <20200901.131353.1215898622774184669.davem@davemloft.net>
To:     shung-hsi.yu@suse.com
Cc:     tariqt@nvidia.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: ethernet: mlx4: Fix memory allocation in
 mlx4_buddy_init()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200831143709.GA12996@syu-laptop>
References: <20200831143709.GA12996@syu-laptop>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 01 Sep 2020 12:57:07 -0700 (PDT)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Date: Mon, 31 Aug 2020 22:37:09 +0800

> On machines with much memory (> 2 TByte) and log_mtts_per_seg == 0, a
> max_order of 31 will be passed to mlx_buddy_init(), which results in
> s = BITS_TO_LONGS(1 << 31) becoming a negative value, leading to
> kvmalloc_array() failure when it is converted to size_t.
> 
>   mlx4_core 0000:b1:00.0: Failed to initialize memory region table, aborting
>   mlx4_core: probe of 0000:b1:00.0 failed with error -12
> 
> Fix this issue by changing the left shifting operand from a signed literal to
> an unsigned one.
> 
> Fixes: 225c7b1feef1 ("IB/mlx4: Add a driver Mellanox ConnectX InfiniBand adapters")
> Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

Applied and queued up for -stable, thanks.
