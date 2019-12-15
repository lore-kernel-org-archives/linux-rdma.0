Return-Path: <SRS0=v+Vh=2F=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07A61C43603
	for <linux-rdma@archiver.kernel.org>; Sun, 15 Dec 2019 18:55:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDACD2467A
	for <linux-rdma@archiver.kernel.org>; Sun, 15 Dec 2019 18:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576436113;
	bh=qxCq1Eg94Bm5MYZwDFLzvHbmo6W6Stbi9CbdFj0Q4jU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=rnFniM0rjaEmQifAfG/RSrBvqRPb4uURXueDeD/gB3kU99W0dH6dbaG1hoxYf2pqr
	 ZZEv6o8KIDDy9wVqsy42lQm9EPA4mSx/nl8m9b5TZY7gKoMUmc//XsEBe3ko5rSSqw
	 DNw4NmoyPk2lfzC7KLN0a06ZRy0MAs8mnNaZ9/zI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfLOSzN (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 15 Dec 2019 13:55:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:58476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726260AbfLOSzN (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 15 Dec 2019 13:55:13 -0500
Received: from localhost (unknown [5.29.147.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81F55206D8;
        Sun, 15 Dec 2019 18:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576436112;
        bh=qxCq1Eg94Bm5MYZwDFLzvHbmo6W6Stbi9CbdFj0Q4jU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wj09b1guP/gt7Byo70cXSasaHvLkF5hTReDDqJsPfA/4wRaouCOrqgmYhQRde/Cqc
         saXLnyJ/1jTtLbmgEjr1t57KJeT56+WAo052IH+M7Dor2ofLRtE9DjSNVlJuM3a02P
         bBypbr1vd0XFSJxeVbShKqmthLUyDdepkci5W3zg=
Date:   Sun, 15 Dec 2019 20:55:00 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Prabhath Sajeepa <psajeepa@purestorage.com>
Cc:     dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, roland@purestorage.com
Subject: Re: [PATCH] IB/mlx5: Fix outstanding_pi index for GSI qps
Message-ID: <20191215185500.GA6097@unreal>
References: <1576195889-23527-1-git-send-email-psajeepa@purestorage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1576195889-23527-1-git-send-email-psajeepa@purestorage.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Dec 12, 2019 at 05:11:29PM -0700, Prabhath Sajeepa wrote:
> b0ffeb537f3a changed the way how outstanding WRs are tracked for GSI QP. But the
> fix did not cover the case when a call to ib_post_send fails and index
> to track outstanding WRs need to be updated correctly.
>
> Fixes: b0ffeb537f3a ('IB/mlx5: Fix iteration overrun in GSI qps ')
> Signed-off-by: Prabhath Sajeepa <psajeepa@purestorage.com>
> ---
>  drivers/infiniband/hw/mlx5/gsi.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/hw/mlx5/gsi.c b/drivers/infiniband/hw/mlx5/gsi.c
> index ac4d8d1..1ae6fd9 100644
> --- a/drivers/infiniband/hw/mlx5/gsi.c
> +++ b/drivers/infiniband/hw/mlx5/gsi.c
> @@ -507,8 +507,7 @@ int mlx5_ib_gsi_post_send(struct ib_qp *qp, const struct ib_send_wr *wr,
>  		ret = ib_post_send(tx_qp, &cur_wr.wr, bad_wr);
>  		if (ret) {
>  			/* Undo the effect of adding the outstanding wr */
> -			gsi->outstanding_pi = (gsi->outstanding_pi - 1) %
> -					      gsi->cap.max_send_wr;
> +			gsi->outstanding_pi--;

I'm a little bit confused, what is the difference before and after
except dropping "gsi->cap.max_send_wr"?

Thanks

>  			goto err;
>  		}
>  		spin_unlock_irqrestore(&gsi->lock, flags);
> --
> 2.7.4
>
