Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985611E5B63;
	Sun,  6 Sep 2026 09:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788685581; cv=none; b=BrOhkQk5BFacgxnYh2yOuIG0s9Kcob7sYJNA0YdAEPJo7s5+Gm94xWshJZJ3yavVnH0UVQqu4U5aMxk2Tl6pJrmuY1/ml0QWmgjQUDjdLpe+Vb6uREqfR7Vdxt+izq+Wir/wsn5UUwpsM1GNxslCCtu6Ud+//r6QHGbVCLwtmoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788685581; c=relaxed/simple;
	bh=nOc4gweAkLcjATxHtLcE51nbbeLwr+3QyEi8gANk790=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CoNUEIZbPv2zdz/Q4Tpz4PCufQxYp8bcocYW/tg5DR8NkUcEpYk5tvUwy1hrNQDbcxOJmCnZanHAGUweWXKCfMco7gZ/Ts2zTrnW0lDtFoBrKz/aCkljWm6gSqLZJlWCukIDL8J0Qhb/fYdXgHDkeXZwoGcJCwk4rzZFo7P+XpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hg3MIcV7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hg3MIcV7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 678EC1F00A3A;
	Sun,  6 Sep 2026 09:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788685580;
	bh=YZsdB2ImJRms4VpCdTBgTdut2su3Ix6F1ucc9/RHA0c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Hg3MIcV7o2ImhjSqgiENn/Uu3PfJGQcYeQExHZ0QXSL/jAzSGroWCIusdMXQ5Gm9H
	 lxl+t3wZ5qqEkaAMIUqDv8o9EEN2G/cOvOJbkIQ3wTZ1lWh2f1Hr/ByjrNk2d2RqO6
	 USPahoYC1hqMG6GGg2ydKJVSmD87//4809FXDumNffd3soOO9U1MuHR3eebuDCw3hx
	 OPfS0lFRHfU3Si1RM2rZwj/vklewhVKn1zM1BE6q6vAIMRvWIHMgQCoYYsCyuUv56j
	 wcduU4dVMVx4FcDFJJBZASCEDUAOiZ8QvKXGw3cGSrt0oPvrM4QkC6sgeI7ZXjVvKQ
	 RoArDutR/j1hg==
Date: Sun, 6 Sep 2026 12:06:16 +0300
From: Leon Romanovsky <leon@kernel.org>
To: lirongqing <lirongqing@baidu.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Sean Hefty <sean.hefty@intel.com>,
	Christian Koenig <christian.koenig@amd.com>,
	"Michael J . Ruhl" <michael.j.ruhl@intel.com>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/uverbs: Set MR iova and length in ioctl reg paths
Message-ID: <20260906090616.GA56944@unreal>
References: <20260904022441.2200-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904022441.2200-1-lirongqing@baidu.com>

On Fri, Sep 04, 2026 at 10:24:41AM +0800, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> UVERBS_METHOD_REG_MR and UVERBS_METHOD_REG_DMABUF_MR do not
> initialize ib_mr->iova and ib_mr->length, unlike
> ib_uverbs_reg_mr() which assigns both from the command.
> 
> Drivers that do not set these fields themselves are therefore left
> with zero values. UVERBS_METHOD_QUERY_MR and RDMA netlink then report
> zero iova and length. Some drivers also use these fields in their data
> path; for example, rxe uses them for range validation in
> mr_check_range(), causing accesses to MRs registered through these
> ioctl paths to fail.
> 
> Drivers such as mlx5 that initialize the fields themselves are
> unaffected.
> 
> Set iova and length in both ioctl handlers, matching the legacy
> registration path.

They are affected because you overwrite the fields set by an earlier
driver callback.

Thanks

> 
> Fixes: 5b2e45049dc0 ("IB/core: Add UVERBS_METHOD_REG_MR on the MR object")
> Fixes: bfe0cc6eb249 ("RDMA/uverbs: Add uverbs command for dma-buf based MR registration")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  drivers/infiniband/core/uverbs_std_types_mr.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/infiniband/core/uverbs_std_types_mr.c b/drivers/infiniband/core/uverbs_std_types_mr.c
> index 0c72f80..df02488 100644
> --- a/drivers/infiniband/core/uverbs_std_types_mr.c
> +++ b/drivers/infiniband/core/uverbs_std_types_mr.c
> @@ -247,6 +247,8 @@ static int UVERBS_HANDLER(UVERBS_METHOD_REG_DMABUF_MR)(
>  	mr->pd = pd;
>  	mr->type = IB_MR_TYPE_USER;
>  	mr->uobject = uobj;
> +	mr->iova = iova;
> +	mr->length = length;
>  	atomic_inc(&pd->usecnt);
>  
>  	rdma_restrack_new(&mr->res, RDMA_RESTRACK_MR);
> @@ -374,6 +376,8 @@ static int UVERBS_HANDLER(UVERBS_METHOD_REG_MR)(
>  	mr->pd = pd;
>  	mr->type = IB_MR_TYPE_USER;
>  	mr->uobject = uobj;
> +	mr->iova = iova;
> +	mr->length = length;
>  	atomic_inc(&pd->usecnt);
>  	if (dmah) {
>  		mr->dmah = dmah;
> -- 
> 2.9.4
> 
