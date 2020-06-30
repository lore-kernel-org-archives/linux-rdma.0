Return-Path: <SRS0=Yo+y=AL=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12DB4C433DF
	for <linux-rdma@archiver.kernel.org>; Tue, 30 Jun 2020 11:42:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D527620760
	for <linux-rdma@archiver.kernel.org>; Tue, 30 Jun 2020 11:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593517331;
	bh=SJity4bazAZ5Halj+68D9yTjgFxyN1yh71JMH5APd+U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=fvH9B8qqSb/ZyLp7sahdmkAoC87WTJ6/Wq4hj87qwCjyIbewylntuj/FXTJR3YlLk
	 gR0oT9SqFKHg165EcrDzVubXAT1jxJ/HZIROmxsp7A3Jm6AJ8IYa3Y9RxctmBo9sFE
	 dUo9lMJAChTc8osuAND2yjotaba8NT4z/9isnW9Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729294AbgF3LmL (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 30 Jun 2020 07:42:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730225AbgF3LmL (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 30 Jun 2020 07:42:11 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEBBE20759;
        Tue, 30 Jun 2020 11:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593517330;
        bh=SJity4bazAZ5Halj+68D9yTjgFxyN1yh71JMH5APd+U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=foR7l+qKiloAu4sViB5eJgQyKvzBuKrP5NCIIpOovhIDC0yqduHFLhA+8OMnfhy/R
         1UUVUR6ZXkuZRcZTjz10dIJZxSvWzJKrPjcXyEwBsov/DLYEItbkMO040W0+2kkMA1
         Xk1VBD1AALTD8AztD7RhHVg9P9gB5sWsyaUR6Cbo=
Date:   Tue, 30 Jun 2020 14:42:06 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Yishai Hadas <yishaih@dev.mellanox.co.il>
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        Yishai Hadas <yishaih@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>
Subject: Re: [PATCH rdma-next v1 4/4] RDMA/core: Convert RWQ table logic to
 ib_core allocation scheme
Message-ID: <20200630114206.GG17857@unreal>
References: <20200630101855.368895-1-leon@kernel.org>
 <20200630101855.368895-5-leon@kernel.org>
 <f3426e16-c427-65ac-6b1a-f3979062b85e@dev.mellanox.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3426e16-c427-65ac-6b1a-f3979062b85e@dev.mellanox.co.il>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Jun 30, 2020 at 02:31:16PM +0300, Yishai Hadas wrote:
> On 6/30/2020 1:18 PM, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Move struct ib_rwq_ind_table allocation to ib_core.
> >
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
> >   drivers/infiniband/core/device.c           |  1 +
> >   drivers/infiniband/core/uverbs_cmd.c       | 37 ++++++++++++-------
> >   drivers/infiniband/core/uverbs_std_types.c | 16 +++++---
> >   drivers/infiniband/core/verbs.c            | 23 ------------
> >   drivers/infiniband/hw/mlx4/main.c          |  4 +-
> >   drivers/infiniband/hw/mlx4/mlx4_ib.h       | 12 +++---
> >   drivers/infiniband/hw/mlx4/qp.c            | 40 ++++++--------------
> >   drivers/infiniband/hw/mlx5/main.c          |  3 ++
> >   drivers/infiniband/hw/mlx5/mlx5_ib.h       |  8 ++--
> >   drivers/infiniband/hw/mlx5/qp.c            | 43 +++++++++-------------
> >   include/rdma/ib_verbs.h                    | 11 +++---
> >   11 files changed, 85 insertions(+), 113 deletions(-)

<...>

> > +
> > +	if (rwq_ind_tbl->device->ops.destroy_rwq_ind_table)
> > +		rwq_ind_tbl->device->ops.destroy_rwq_ind_table(rwq_ind_tbl);
>
>
> We had here two notes from previous review that need to be settled, ref
> count decrement before object destruction (high priority) and considering
> the existance of both alloc/destroy functions from driver point of view from
> symetic reasons. (low priority).
>
> Let's get Jason's feedback here please.

I'm confident that Jason will give his feedback like he always does
while accepting/declining patches. It goes without saying.

From my point of view, there is nothing to change.

Thanks
