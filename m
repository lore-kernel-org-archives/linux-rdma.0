Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243653955EB;
	Wed, 10 Jun 2026 08:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781078551; cv=none; b=eI1M1XPQf+owwhp8OXPD63h1yUr1V/KlVpMNd3qHG/u39XVvEBmf3sTmIrCV2U7BGp/4DUYzGv+EzCGCPQRtZGgR1KVt8G+w32k02cKZwPhHqAxe/Fp+w4yZgDRDYukCDljeQDMGnZVqOV6HFmRuydtYwVEg39HvWvs8ALM+igk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781078551; c=relaxed/simple;
	bh=fJY0nz7AyvAV2b2Cr6C2OC0hgWmMCNgjwIAEFhYwcqw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OEWnaIq8hVDWkAflwWAaY+/xaGHeEd0k/4fGAlTthVOjVcb9epjh4oJ24MD9oFNLKxfI/H8vjmTQs/Zi7b+yldzFAPFRl2aBoar2ZNMJWYwKS2sNjFDcnPeXVlwLCoqZspBrsXmkyJiGHxjdXn6cvhzgfDjZtb248Tb/q/S66y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hskcOfwb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hskcOfwb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 053C21F00893;
	Wed, 10 Jun 2026 08:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781078549;
	bh=v4yLloZ10f0E8LI0hBNXdGXhisrlfbbYsRrFL9HmlHw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hskcOfwb3AT1yqLXka3Fj78u4fIteDPkN2LaEP9k6YQsr7di/wZ7oHrlNNe5QM76Y
	 Me5JOUPtZtEFP6ASce0SJAaLA63H77DOPp7YnYslAvS7Ia7DmeHgcfqdlkMzhIPcfZ
	 epLsPoD2/mHj5tZdFoLNS6YdPzfTSaBBaUE7MIlZ9zyhtSMoYg6yPASJAkq7SialPw
	 WTHQghmP0Q26l3VIAVSqDwo990+EXl5SeBpvmisxNebhepXJbPNwbNOUcaNo/PtBGs
	 O+u2JOFJCuhA0wwr5EA+z6J0NvzCQR1zRsKkdSBcMgo6DpBh5gD/VqOfMrnInnI2FO
	 LTwQU7Qf3HjeA==
Date: Wed, 10 Jun 2026 11:02:23 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Tao Cui <cuitao@kylinos.cn>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH rdma-next v2] RDMA/nldev: add resource summary max values
 for usage display
Message-ID: <20260610080223.GE327369@unreal>
References: <20260515073307.428768-1-cuitao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515073307.428768-1-cuitao@kylinos.cn>

On Fri, May 15, 2026 at 03:33:07PM +0800, Tao Cui wrote:
> Add RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX netlink attribute to expose
> device resource limits (max_qp, max_cq, max_mr, max_pd, max_srq) in
> the resource summary alongside the existing current count. This allows
> userspace tools like iproute2's rdma to display resource usage in
> curr/max format.
> 
> Expected output from "rdma resource show":
>   Before: 0: mlx5_0: qp 123  cq 45  mr 200  pd 10
>   After:  0: mlx5_0: qp 123/131072  cq 45/65536  mr 200/1000000  pd 10/32768
> 
> In JSON output, both "curr" and "max" fields will be provided so that
> scripts can compute percentages if needed.
> 
> The new attribute is optional and backward compatible - old userspace
> tools will simply ignore it.
> 
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> ---
>  drivers/infiniband/core/nldev.c  | 29 ++++++++++++++++++++++++++---
>  include/uapi/rdma/rdma_netlink.h |  5 +++++
>  2 files changed, 31 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
> index 96c745d5bac4..879aaa7960fe 100644
> --- a/drivers/infiniband/core/nldev.c
> +++ b/drivers/infiniband/core/nldev.c
> @@ -187,6 +187,7 @@ static const struct nla_policy nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
>  	[RDMA_NLDEV_ATTR_FRMR_POOLS_AGING_PERIOD] = { .type = NLA_U32 },
>  	[RDMA_NLDEV_ATTR_FRMR_POOL_PINNED_HANDLES] = { .type = NLA_U32 },
>  	[RDMA_NLDEV_ATTR_FRMR_POOL_KEY_KERNEL_VENDOR_KEY] = { .type = NLA_U64 },
> +	[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX]	= { .type = NLA_U64 },
>  };

<...>

>  	if (fill_nldev_handle(msg, device))
>  		return -EMSGSIZE;
> @@ -462,7 +466,26 @@ static int fill_res_info(struct sk_buff *msg, struct ib_device *device,
>  		if (!names[i])
>  			continue;
>  		curr = rdma_restrack_count(device, i, show_details);
> -		ret = fill_res_info_entry(msg, names[i], curr);
> +		switch (i) {
> +		case RDMA_RESTRACK_QP:
> +			max = device->attrs.max_qp;
> +			break;
> +		case RDMA_RESTRACK_CQ:
> +			max = device->attrs.max_cq;
> +			break;
> +		case RDMA_RESTRACK_MR:
> +			max = device->attrs.max_mr;
> +			break;
> +		case RDMA_RESTRACK_PD:
> +			max = device->attrs.max_pd;
> +			break;
> +		case RDMA_RESTRACK_SRQ:
> +			max = device->attrs.max_srq;
> +			break;
> +		default:
> +			max = 0;

The more accurate approach is to avoid setting the  
RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX field for cases that have no  
limitations, and let iproute2 decide how to handle it.

Thanks
