Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C358C433DB
	for <linux-rdma@archiver.kernel.org>; Wed, 17 Mar 2021 17:05:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 217CE64E90
	for <linux-rdma@archiver.kernel.org>; Wed, 17 Mar 2021 17:05:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhCQREc (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 17 Mar 2021 13:04:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:40946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229545AbhCQRET (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 17 Mar 2021 13:04:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C73BA64E90;
        Wed, 17 Mar 2021 17:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616000658;
        bh=YecZ1+74PL0EiJdVgEbcbAb4OOfTrH7w3uHot9RGdq4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lu//GtLnTgjXYhm9esClHt8hR8sh/TVP6pNKtWo+MI7yVxrTMiA0sNuR7XVlOgdJc
         tz6Sd/GmVSnhirzXjrKY40U5Y2Z8zE/homaXsGzUDnRZlbZK3Ui0I9r6VxXlFL6fFC
         cgK3YsNXD+C5lw9byeBxwJBSG79kJQ4txCw34WEHi5q3eQK8571ufwpH61HNVpz4L7
         n9gj1PaVUuebEKDk0JV5MisibcOpL+dDmgsjhlfu2Tw8uUr4hDmFNy+2v9Nh7JC25y
         /cr3F1ah42VAX7J1ZOb5cfbT6eJqLDUsUpnf59PzVxL649yi1MaJKFIkcqC0p+3jbZ
         V1fkgNvRm/v2A==
Date:   Wed, 17 Mar 2021 19:04:14 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Colin King <colin.king@canonical.com>
Cc:     Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] RDMA/mlx5: Fix missing assignment of rc when
 calling mlx5_ib_dereg_mr
Message-ID: <YFI2jt/nTpn//Zc0@unreal>
References: <20210316095117.17089-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316095117.17089-1-colin.king@canonical.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Mar 16, 2021 at 09:51:17AM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> The assignment of the return code to rc when calling mlx5_ib_dereg_mr is
> missing and there is an error check on an uninitialized rc. Fix this by
> adding in the assignment.
>
> Addresses-Coverity: ("Uninitialized scalar variable")
> Fixes: e6fb246ccafb ("RDMA/mlx5: Consolidate MR destruction to mlx5_ib_dereg_mr()")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/infiniband/hw/mlx5/mr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

It was already sent, thanks.
https://lore.kernel.org/linux-rdma/20210314082250.10143-1-leon@kernel.org/

>
> diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
> index 86ffc7e5ef96..9dcb9fb4eeaa 100644
> --- a/drivers/infiniband/hw/mlx5/mr.c
> +++ b/drivers/infiniband/hw/mlx5/mr.c
> @@ -1946,7 +1946,7 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
>  			mr->mtt_mr = NULL;
>  		}
>  		if (mr->klm_mr) {
> -			mlx5_ib_dereg_mr(&mr->klm_mr->ibmr, NULL);
> +			rc = mlx5_ib_dereg_mr(&mr->klm_mr->ibmr, NULL);
>  			if (rc)
>  				return rc;
>  			mr->klm_mr = NULL;
> --
> 2.30.2
>
