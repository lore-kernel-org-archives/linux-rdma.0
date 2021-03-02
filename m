Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16A19C4360C
	for <linux-rdma@archiver.kernel.org>; Tue,  2 Mar 2021 17:13:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE58364F2C
	for <linux-rdma@archiver.kernel.org>; Tue,  2 Mar 2021 17:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1579740AbhCBRIo (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 2 Mar 2021 12:08:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:35266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382804AbhCBK05 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 2 Mar 2021 05:26:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7800A64F0A;
        Tue,  2 Mar 2021 10:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614680777;
        bh=7d1J4SQ6sqC/em2kvX7lD57erUnbePcrTQRWhUILoHI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GB+uoJVfWtdTi5WPDzE30vJ4YO8SMOu7egFrhj3YOAV2mQKkWv3hC0Nw91ux/+c00
         4hv+P7nmGe5Rg3M765V2t3K1U6owpSSEwBSOLR5Rr9oV5WmHvomTM5APwrBK6xmonp
         DxOpyEUjMFoQji73JBX80ZkMoNHDeouyleC+uMnUztLWK00xxsx38otZndzRhNMTIw
         B4tipY+WlZol1WI914tFjcuTU4iMQ+ao2pUVIsEYhn1GFW/7J4TBUFb36uoUxiBcJG
         dpPudoqJ5gos9iuomXxeFhnt9ocEPMA1ZGoJ28JcrSjxpRyRhn4G3Hyu1nMvjLe/Z2
         Sr9E5ID8/uwjw==
Date:   Tue, 2 Mar 2021 12:26:13 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH rdma-rc 1/2] RDMA/mlx5: Set correct kernel-doc identifier
Message-ID: <YD4SxWLbPkEoH3GR@unreal>
References: <20210302074214.1054299-1-leon@kernel.org>
 <20210302074214.1054299-2-leon@kernel.org>
 <20210302093109.GA2690909@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302093109.GA2690909@dell>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Mar 02, 2021 at 09:31:09AM +0000, Lee Jones wrote:
> On Tue, 02 Mar 2021, Leon Romanovsky wrote:
>
> > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > The W=1 allmodconfig build produces the following warning:
> > drivers/infiniband/hw/mlx5/odp.c:1086: warning: wrong kernel-doc identifier on line:
> >   * Parse a series of data segments for page fault handling.
> >
> > Fix it by changing /** to be /* as it is written in kernel-doc documentation.
> >
> > Fixes: 5e769e444d26 ("RDMA/hw/mlx5/odp: Fix formatting and add missing descriptions in 'pagefault_data_segments()'")
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/infiniband/hw/mlx5/odp.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
> > index 374698186662..b103555b1f5d 100644
> > --- a/drivers/infiniband/hw/mlx5/odp.c
> > +++ b/drivers/infiniband/hw/mlx5/odp.c
> > @@ -1082,7 +1082,7 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
> >  	return ret ? ret : npages;
> >  }
> >
> > -/**
> > +/*
>
> This is not the correct fix.

I don't want kernel-doc comments on static function. It is local to this
file, so change from /** to /* was to mark that this is not kernel-doc.

>
> Kernel-doc is asking for the function name.

The thing is that I don't want it to be kernel-doc.

Thanks
