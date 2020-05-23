Return-Path: <SRS0=Njt3=7F=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 861C4C433E3
	for <linux-rdma@archiver.kernel.org>; Sat, 23 May 2020 23:35:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 690E3207CB
	for <linux-rdma@archiver.kernel.org>; Sat, 23 May 2020 23:35:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388212AbgEWXfd (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 23 May 2020 19:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388140AbgEWXfd (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sat, 23 May 2020 19:35:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C0CC061A0E;
        Sat, 23 May 2020 16:35:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 976831286F3AF;
        Sat, 23 May 2020 16:35:32 -0700 (PDT)
Date:   Sat, 23 May 2020 16:35:32 -0700 (PDT)
Message-Id: <20200523.163532.187431052087652248.davem@davemloft.net>
To:     wu000273@umn.edu
Cc:     kuba@kernel.org, tariqt@mellanox.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kjlu@umn.edu
Subject: Re: [PATCH v2] net/mlx4_core: fix a memory leak bug.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200522190715.29022-1-wu000273@umn.edu>
References: <20200522190715.29022-1-wu000273@umn.edu>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 23 May 2020 16:35:32 -0700 (PDT)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: wu000273@umn.edu
Date: Fri, 22 May 2020 14:07:15 -0500

> From: Qiushi Wu <wu000273@umn.edu>
> 
> In function mlx4_opreq_action(), pointer "mailbox" is not released,
> when mlx4_cmd_box() return and error, causing a memory leak bug.
> Fix this issue by going to "out" label, mlx4_free_cmd_mailbox() can
> free this pointer.
> 
> Fixes: fe6f700d6cbb ("net/mlx4_core: Respond to operation request by firmware")
> Signed-off-by: Qiushi Wu <wu000273@umn.edu>

Applied.
