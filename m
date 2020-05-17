Return-Path: <SRS0=ZqxG=67=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EE3CC433E0
	for <linux-rdma@archiver.kernel.org>; Sun, 17 May 2020 19:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82D7A20657
	for <linux-rdma@archiver.kernel.org>; Sun, 17 May 2020 19:38:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbgEQTiH (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 17 May 2020 15:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgEQTiH (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 17 May 2020 15:38:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C8EC061A0C;
        Sun, 17 May 2020 12:38:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 14568128A2D8A;
        Sun, 17 May 2020 12:38:07 -0700 (PDT)
Date:   Sun, 17 May 2020 12:38:06 -0700 (PDT)
Message-Id: <20200517.123806.1659008654334663086.davem@davemloft.net>
To:     jhubbard@nvidia.com
Cc:     linux-kernel@vger.kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Subject: Re: [PATCH] rds: convert get_user_pages() --> pin_user_pages()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200517012336.382624-1-jhubbard@nvidia.com>
References: <20200517012336.382624-1-jhubbard@nvidia.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 17 May 2020 12:38:07 -0700 (PDT)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>
Date: Sat, 16 May 2020 18:23:36 -0700

> This code was using get_user_pages_fast(), in a "Case 2" scenario
> (DMA/RDMA), using the categorization from [1]. That means that it's
> time to convert the get_user_pages_fast() + put_page() calls to
> pin_user_pages_fast() + unpin_user_pages() calls.
> 
> There is some helpful background in [2]: basically, this is a small
> part of fixing a long-standing disconnect between pinning pages, and
> file systems' use of those pages.
> 
> [1] Documentation/core-api/pin_user_pages.rst
> 
> [2] "Explicit pinning of user-space pages":
>     https://lwn.net/Articles/807108/
> 
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Cc: linux-rdma@vger.kernel.org
> Cc: rds-devel@oss.oracle.com
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Applied to net-next, thanks.
