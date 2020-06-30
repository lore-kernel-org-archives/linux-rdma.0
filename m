Return-Path: <SRS0=Yo+y=AL=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5458BC433E1
	for <linux-rdma@archiver.kernel.org>; Tue, 30 Jun 2020 20:39:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D521206B6
	for <linux-rdma@archiver.kernel.org>; Tue, 30 Jun 2020 20:39:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729606AbgF3UjA (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 30 Jun 2020 16:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729341AbgF3Ui7 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 30 Jun 2020 16:38:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3957C061755;
        Tue, 30 Jun 2020 13:38:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 571841277F862;
        Tue, 30 Jun 2020 13:38:59 -0700 (PDT)
Date:   Tue, 30 Jun 2020 13:38:58 -0700 (PDT)
Message-Id: <20200630.133858.836154523537769936.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     borisp@mellanox.com, saeedm@mellanox.com, leon@kernel.org,
        kuba@kernel.org, tariqt@mellanox.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net/mlx5e: fix memory leak of tls
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200630151646.517757-1-colin.king@canonical.com>
References: <20200630151646.517757-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jun 2020 13:38:59 -0700 (PDT)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Tue, 30 Jun 2020 16:16:46 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> The error return path when create_singlethread_workqueue fails currently
> does not kfree tls and leads to a memory leak. Fix this by kfree'ing
> tls before returning -ENOMEM.
> 
> Addresses-Coverity: ("Resource leak")
> Fixes: 1182f3659357 ("net/mlx5e: kTLS, Add kTLS RX HW offload support")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied, thanks.
