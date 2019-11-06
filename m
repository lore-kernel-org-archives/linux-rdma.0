Return-Path: <SRS0=/r8L=Y6=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06C2AC5DF62
	for <linux-rdma@archiver.kernel.org>; Wed,  6 Nov 2019 07:44:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1EFE217F5
	for <linux-rdma@archiver.kernel.org>; Wed,  6 Nov 2019 07:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573026250;
	bh=7VjSL02R1RRn+F8bTT1W3vS2dZIXRH5Wd5CY5RolT/E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=cV6ieaGWY7vQ5yK2qFOfqMmfNXnhr1vFh3nkLx8E3m9tgEVL5Gdm//JsECqUbnrsv
	 27DMB4D2gIcH9LckFnfpUqk+h1Xnqs+4lupNOK7zE/JeCHzWsSO8WUespIhxTlwndx
	 WRGqDaTkuVrPNE9O4+rc/Bxb0PdYfszIaynpSuRA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731323AbfKFHoK (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 6 Nov 2019 02:44:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:32908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729986AbfKFHoK (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 6 Nov 2019 02:44:10 -0500
Received: from localhost (unknown [77.137.81.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D67AB2173E;
        Wed,  6 Nov 2019 07:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573026249;
        bh=7VjSL02R1RRn+F8bTT1W3vS2dZIXRH5Wd5CY5RolT/E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zDQffusXyKpjEy5C7f7uxjJ2PyFiqsyPa0/lXi4jZGpSPHvWURw34dF/Z88Lron6N
         GN63sT3LI6wAph7MFiaM4LvQqk5jk/Jpq+5qWojb2vQe37Q2kf3B8hIY3SE6hFD3w8
         BdXEUf3TLklCbI9AsQJrtgTEhozkFBNgQ2n2Jkgo=
Date:   Wed, 6 Nov 2019 09:44:04 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Pan Bian <bianpan2016@163.com>
Cc:     Faisal Latif <faisal.latif@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/i40iw: fix potential use after free
Message-ID: <20191106074404.GK6763@unreal>
References: <1573022651-37171-1-git-send-email-bianpan2016@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573022651-37171-1-git-send-email-bianpan2016@163.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Nov 06, 2019 at 02:44:11PM +0800, Pan Bian wrote:
> Release variable dst after logging dst->error to avoid possible use after
> free.
>
> Signed-off-by: Pan Bian <bianpan2016@163.com>
> ---
>  drivers/infiniband/hw/i40iw/i40iw_cm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
> index 2d6a378e8560..bb78d3280acc 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
> +++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
> @@ -2079,9 +2079,9 @@ static int i40iw_addr_resolve_neigh_ipv6(struct i40iw_device *iwdev,
>  	dst = i40iw_get_dst_ipv6(&src_addr, &dst_addr);
>  	if (!dst || dst->error) {
>  		if (dst) {
> -			dst_release(dst);
>  			i40iw_pr_err("ip6_route_output returned dst->error = %d\n",
>  				     dst->error);

I suggest to remove those prints together with "if (dst)" check because
dst_release() already has such check.

Thanks

> +			dst_release(dst);
>  		}
>  		return rc;
>  	}
> --
> 2.7.4
>
