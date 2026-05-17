Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2FB332629
	for <linux-rdma@vger.kernel.org>; Sun, 17 May 2026 11:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779017768; cv=none; b=UgQlMM5SGPu8F9yr0st5BbiaYi5iEiu9o9BjDuOc2Ap8lgCTZXL9+Un/av5bnKImHwIKrybZ2GUo5B1VYZy/dPRzTsjWKlbvg9ZU92fB2jH5HWjOytdlNxmgILIYQ1WKRtRfHgarNB+6Plcjur95HLGTFzOCCK/YmCE9237Mm88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779017768; c=relaxed/simple;
	bh=Ge9EcOrJhlBJIZVwSvExPbJZAJtQoqmEZNPYD5r7xyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c+KYIulitH5VLeMGe115QGBF0WO2FLnVyG4/EW0nDvWp/MHHNVq9e3jyQ7wgSshXsy6Z2d845tO5SVOcDDL2WCoZxtrP6q/h4HxQBxInOaLyOQmweMwd/rXNuig6AV2guXSFCzp8k/H1NlE1TKXt5NkNEi6/+y4rWy9w+yuwQv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LmZ2IrEY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LmZ2IrEY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2958C2BCB0;
	Sun, 17 May 2026 11:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779017767;
	bh=Ge9EcOrJhlBJIZVwSvExPbJZAJtQoqmEZNPYD5r7xyE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LmZ2IrEYHZaugTxeKAZrUrdA+YBLpBbkUKJfWcHuKehTCIbQ3eUt/1CY6P3sZF+VF
	 86inkHC4THZo1DVx1yeXgCwm+7f6ZuAcjzGAr6Ubgf33EXobdBAdJvhCPMhHJn/kRL
	 C4/TSUQ75Hx7R0t22JEFxfAdu/ipZFZaFVh1ZCha2jipaKg26uV5zRigwi8iwZNyng
	 FDB14MhuVZLpOi5ZS8hWr8SDVVks7snUy6GSg9FCKGKlrTWZuyOg7Xo9SSbdaG/aso
	 J2J5Gd77DMNkiDow4pQwUNo6TNcI1LMcUJCRUCp84XsokbdgCxi8fP9sfox/CexnHD
	 hM/QHYKgVhfTA==
Date: Sun, 17 May 2026 14:36:03 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-rdma@vger.kernel.org, jgg@ziepe.ca, mrgolin@amazon.com,
	gal.pressman@linux.dev, sleybo@amazon.com, parav@nvidia.com,
	mbloch@nvidia.com, yanjun.zhu@linux.dev, marco.crivellari@suse.com,
	roman.gushchin@linux.dev, phaddad@nvidia.com, lirongqing@baidu.com,
	ynachum@amazon.com, huangjunxian6@hisilicon.com,
	kalesh-anakkur.purayil@broadcom.com, ohartoov@nvidia.com,
	michaelgur@nvidia.com, shayd@nvidia.com, edwards@nvidia.com,
	sriharsha.basavapatna@broadcom.com, andrew.gospodarek@broadcom.com,
	selvin.xavier@broadcom.com
Subject: Re: [PATCH rdma-next v4 08/16] RDMA/efa: Use ib_umem_get_cq_buf()
 for user CQ buffer
Message-ID: <20260517113603.GE33515@unreal>
References: <20260507125231.2950751-1-jiri@resnulli.us>
 <20260507125231.2950751-9-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260507125231.2950751-9-jiri@resnulli.us>

On Thu, May 07, 2026 at 02:52:23PM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Pin the user CQ buffer with ib_umem_get_cq_buf() and take
> ownership of the umem in the driver. Fall back to the
> existing kernel-DMA path on NULL.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---
> v2->v3:
> - used ib_umem_get_cq_buf() to get umem, stored in efa_cq->umem
> - replaced ib_umem_release_non_listed() with ib_umem_release()
> - added release to efa_destroy_cq() and new error path
> ---
>  drivers/infiniband/hw/efa/efa_verbs.c | 27 +++++++++++++++++----------
>  1 file changed, 17 insertions(+), 10 deletions(-)

<...>

> -	if (ibcq->umem) {
> -		if (ibcq->umem->length < cq->size) {
> -			ibdev_dbg(&dev->ibdev, "External memory too small\n");
> -			err = -EINVAL;
> -			goto err_out;
> -		}
> +	umem = ib_umem_get_cq_buf(ibcq->device, udata, cq->size,
> +				  IB_ACCESS_LOCAL_WRITE);
> +	if (IS_ERR(umem)) {
> +		err = PTR_ERR(umem);
> +		goto err_out;
> +	}
> +
> +	cq->umem = umem;
>  
> -		if (!ib_umem_is_contiguous(ibcq->umem)) {
> +	if (umem) {
> +		if (!ib_umem_is_contiguous(umem)) {
>  			ibdev_dbg(&dev->ibdev, "Non contiguous CQ unsupported\n");
>  			err = -EINVAL;
> -			goto err_out;
> +			goto err_release_umem;
>  		}
>  
> -		cq->dma_addr = ib_umem_start_dma_addr(ibcq->umem);
> +		cq->dma_addr = ib_umem_start_dma_addr(umem);

This patch is the one that confused me the most. Didn't we already set
`ibcq->umem` before calling ops.create_user_cq()? If so, we're now ignoring
that pointer.

Thanks
