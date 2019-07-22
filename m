Return-Path: <SRS0=nyJA=VT=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 430E5C7618F
	for <linux-rdma@archiver.kernel.org>; Mon, 22 Jul 2019 19:09:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17B7E21901
	for <linux-rdma@archiver.kernel.org>; Mon, 22 Jul 2019 19:09:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfGVTJC (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 22 Jul 2019 15:09:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47920 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbfGVTJC (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 22 Jul 2019 15:09:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AE38815258BA1;
        Mon, 22 Jul 2019 12:09:01 -0700 (PDT)
Date:   Mon, 22 Jul 2019 12:09:01 -0700 (PDT)
Message-Id: <20190722.120901.1770656295609872438.davem@davemloft.net>
To:     cai@lca.pw
Cc:     saeedm@mellanox.com, leonro@mellanox.com, yishaih@mellanox.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5: fix -Wtype-limits compilation warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1563820482-10302-1-git-send-email-cai@lca.pw>
References: <1563820482-10302-1-git-send-email-cai@lca.pw>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jul 2019 12:09:02 -0700 (PDT)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Qian Cai <cai@lca.pw>
Date: Mon, 22 Jul 2019 14:34:42 -0400

> The commit b9a7ba556207 ("net/mlx5: Use event mask based on device
> capabilities") introduced a few compilation warnings due to it bumps
> MLX5_EVENT_TYPE_MAX from 0x27 to 0x100 which is always greater than
> an "struct {mlx5_eqe|mlx5_nb}.type" that is an "u8".
> 
> drivers/net/ethernet/mellanox/mlx5/core/eq.c: In function
> 'mlx5_eq_notifier_register':
> drivers/net/ethernet/mellanox/mlx5/core/eq.c:948:21: warning: comparison
> is always false due to limited range of data type [-Wtype-limits]
>   if (nb->event_type >= MLX5_EVENT_TYPE_MAX)
>                      ^~
> drivers/net/ethernet/mellanox/mlx5/core/eq.c: In function
> 'mlx5_eq_notifier_unregister':
> drivers/net/ethernet/mellanox/mlx5/core/eq.c:959:21: warning: comparison
> is always false due to limited range of data type [-Wtype-limits]
>   if (nb->event_type >= MLX5_EVENT_TYPE_MAX)
> 
> Fix them by removing unnecessary checkings.
> 
> Fixes: b9a7ba556207 ("net/mlx5: Use event mask based on device capabilities")
> Signed-off-by: Qian Cai <cai@lca.pw>

Saeed, I am assuming that you will take this.
