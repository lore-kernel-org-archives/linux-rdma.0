Return-Path: <SRS0=0Liq=A6=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 170A6C433E0
	for <linux-rdma@archiver.kernel.org>; Sun, 19 Jul 2020 12:51:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E092822B48
	for <linux-rdma@archiver.kernel.org>; Sun, 19 Jul 2020 12:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595163096;
	bh=SJ4NWVZk5/wVvAa19846pBQA1rQAoZBQRt7ncBrO/Fk=;
	h=From:Date:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Pp10Aav754oXF+IDBYRTENXX1hO9xRp6i4FIPQWXEYjVl6/hFDyvElvGU88hzZc+o
	 NVLk+dlQy24uAT5yRVxePcDgLS6mgrp+u/qZA+KcvbkTZnduwSt2F8YbxySHn8c8NH
	 f9OTTGfbHfzAX3UC5cvMl8uGLWZhrE51Hwbj6lFo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbgGSMvg (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 19 Jul 2020 08:51:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:32942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgGSMvf (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 19 Jul 2020 08:51:35 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A38420809;
        Sun, 19 Jul 2020 12:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595163095;
        bh=SJ4NWVZk5/wVvAa19846pBQA1rQAoZBQRt7ncBrO/Fk=;
        h=From:Date:To:Cc:Subject:References:In-Reply-To:From;
        b=d4O5EdniwwgaKrPhBNznwVCRUh+e5kVDHqg5d6k4YaJtuW/vXkGmUNIRUWVsgYvyc
         ZWubS805FHxJlqC+H+ZT/dZEZKZqVc/i6lilqkLv90XtLpUShI+ZkKcfbh51lHhV1O
         PjZivKMtNmQmTpbRRe/bzyBX3WSsiDAwDp6d+Zs4=
From:   leon@kernel.org
Date:   Sun, 19 Jul 2020 15:51:31 +0300
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     kernel test robot <lkp@intel.com>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH rdma-next 1/2] RDMA/uverbs: Remove redundant assignments
Message-ID: <20200719125131.GD127306@unreal>
References: <20200719060319.77603-1-leon@kernel.org>
 <20200719060319.77603-2-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200719060319.77603-2-leon@kernel.org>
erom:   Leon Romanovsky <leonro@mellanox.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Sun, Jul 19, 2020 at 09:03:18AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>
> The kbuild reported the following warning, so clean whole uverbs_cmd.c file.
>
>    drivers/infiniband/core/uverbs_cmd.c:1066:6: warning: Variable 'ret'
> is reassigned a value before the old one has
> been used. [redundantAssignment]
>     ret = uverbs_request(attrs, &cmd, sizeof(cmd));
>         ^
>    drivers/infiniband/core/uverbs_cmd.c:1064:0: note: Variable 'ret' is
> reassigned a value before the old one has been
> used.
>     int    ret = -EINVAL;
>    ^
>
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/infiniband/core/uverbs_cmd.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> index a66fc3e37a74..7d2b4258f573 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -558,9 +558,9 @@ static int ib_uverbs_open_xrcd(struct uverbs_attr_bundle *attrs)
>  	struct ib_uverbs_open_xrcd	cmd;
>  	struct ib_uxrcd_object         *obj;
>  	struct ib_xrcd                 *xrcd = NULL;
> -	struct fd			f = {NULL, 0};
> +	struct fd f = {};
>  	struct inode                   *inode = NULL;
> -	int				ret = 0;
> +	int ret;
>  	int				new_xrcd = 0;
>  	struct ib_device *ib_dev;
>
> @@ -761,7 +761,7 @@ static int ib_uverbs_rereg_mr(struct uverbs_attr_bundle *attrs)
>  {
>  	struct ib_uverbs_rereg_mr      cmd;
>  	struct ib_uverbs_rereg_mr_resp resp;
> -	struct ib_pd                *pd = NULL;
> +	struct ib_pd *pd;

This line shouldn't be changed, PD is passed as an argument to ops.rereg_user_mr.

Thanks
