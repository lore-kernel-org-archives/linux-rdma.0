Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 125B2CE7A8C
	for <linux-rdma@archiver.kernel.org>; Sat, 23 Sep 2023 18:52:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjIWSwi (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 23 Sep 2023 14:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjIWSwh (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sat, 23 Sep 2023 14:52:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B79FA;
        Sat, 23 Sep 2023 11:52:31 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A206C433C7;
        Sat, 23 Sep 2023 18:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695495151;
        bh=F7de3crm3LCfSbjyukI9kxChF2B638DBUriCQ/rXhMg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jZaa9DjPkIh55AGwWY/u7y9dxlwEODQ/VwNNq+t59ssiX5bFfd73d/KhvcgWtgW++
         LSt+SgeKhEKdhL2Rp9sAZ3yXVyzdH0+GwQMwegKdLmq11BReWMz/3tgpBNGIYfwIn3
         dy1iJrCmhuv6ORNBvLMHUUuEYl59m+BfPHRLn7lv3FXGT19azkldsloRLd7RzyNJiH
         9/TsJEEdlBqhWr0fTEF/N4xe6pCRcAev1DLSN/1/RZgytn8aW5rMACY+9vesEKjd2l
         OItKMgeKq2rKw/J95FuLvi44lOvwWIlVYSwrgVJtZxbYykL0NLOuLnK+rkCdoYK3Xa
         cWt1DP1QiAOQg==
Date:   Sat, 23 Sep 2023 21:52:26 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Matan Barak <matanb@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH] RDMA/cma: Fix the size of a buffer in add_port_entries()
Message-ID: <20230923185226.GE1642130@unreal>
References: <91395b73a64c13dfe45c3fd3b088b216ba0c9332.1695449697.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <91395b73a64c13dfe45c3fd3b088b216ba0c9332.1695449697.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Sat, Sep 23, 2023 at 08:15:25AM +0200, Christophe JAILLET wrote:
> In order to be sure that 'buff' is never truncated, its size should be
> 11, not 10.
> 
> When building with W=1, this fixes the following warnings:
> 
>   drivers/infiniband/core/cma_configfs.c: In function ‘make_cma_ports’:
>   drivers/infiniband/core/cma_configfs.c:223:57: error: ‘snprintf’ output may be truncated before the last format character [-Werror=format-truncation=]
>     223 |                 snprintf(port_str, sizeof(port_str), "%u", i + 1);
>         |                                                         ^
>   drivers/infiniband/core/cma_configfs.c:223:17: note: ‘snprintf’ output between 2 and 11 bytes into a destination of size 10
>     223 |                 snprintf(port_str, sizeof(port_str), "%u", i + 1);
>         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Fixes: 045959db65c67 ("IB/cma: Add configfs for rdma_cm")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/infiniband/core/cma_configfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks, it was already fixed.
https://lore.kernel.org/all/a7e3b347ee134167fa6a3787c56ef231a04bc8c2.1694434639.git.leonro@nvidia.com/
