Return-Path: <SRS0=/r8L=Y6=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A199C5DF60
	for <linux-rdma@archiver.kernel.org>; Wed,  6 Nov 2019 02:35:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E40682178F
	for <linux-rdma@archiver.kernel.org>; Wed,  6 Nov 2019 02:35:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730724AbfKFCfX (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 5 Nov 2019 21:35:23 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42364 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbfKFCfX (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 5 Nov 2019 21:35:23 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8AC661510CDF5;
        Tue,  5 Nov 2019 18:35:22 -0800 (PST)
Date:   Tue, 05 Nov 2019 18:35:22 -0800 (PST)
Message-Id: <20191105.183522.2155800632990290770.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net/mlx5: fix spelling mistake "metdata" ->
 "metadata"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191105145416.60451-1-colin.king@canonical.com>
References: <20191105145416.60451-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Nov 2019 18:35:22 -0800 (PST)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Tue,  5 Nov 2019 14:54:16 +0000

> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in a esw_warn warning message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Saeed, please pick this one up.

Thank you.
