Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30931624D5;
	Mon, 21 Sep 2026 16:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790009848; cv=none; b=ImNc2xwT9HRL/e29B/jXXDfCPBFN/6S3GSBf5GPCM115aD+bwAKuALZEbH61RK2scxtrhfKj2pJDvnQbjgs1k6Y1dsilDIe6k22tKK4wfdooHcfPtKYRoNWGjbHd5b+a5keUoDGxZkyi9Q7iRDzmOsDqt5MNwiiPIAw/sGZ3YSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790009848; c=relaxed/simple;
	bh=5nFCKZRfcuvn/YXGZADAf4Z8vVuASbwW+MW92OBSrV0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hvG0QIRdumAItuVKeDQZLzSO0K1TKBUfKfT1pGhhSldOZ5V7MfFmNMcjGniEXEj6tbwxTqyFyW35HslgRcLalZRhZ+NOVcZVIWOMXqxRhKvYKfPeXS+KwDbUj4vXGCK+neFmyHtrXK8rORlsprTwk43Emuszr2aoCNSbOLtAFsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nM7gV2Kk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nM7gV2Kk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB7B1F000FF;
	Mon, 21 Sep 2026 16:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790009846;
	bh=904noNjHPafrnstEIgkJLCwelDb9DPxtN8XoE/tkNIQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nM7gV2KkpVd0pB5qcjf+/dITkY5klukICr9KHFD5WIvdepw5sq4wP7wdZZ6zM+NTj
	 z0Pi2oShQaUp0uZ4CPnFViPzPjj6AwveV46SQDNmloUfWy/IhbI1tG0i8iio+C8a1w
	 stNT+Jn33V9dmsU7s4+eRMiiAlMuPUOZtvD12Yo3+9kFo6hASmx3qyhr9aCGHexcwY
	 QtweaTbjMwPxvWuUPu0xlgKFExzgRgB5b7+O6csqM4hCZzgZApoooHJ1N+9+Z4zGvL
	 JNFdNKYWYntCOGtoTvqMJf/draPy9ySj9nCKPG3zq3yvG1IFtTtlcOj0hJx4qaCpig
	 gR+WNppE0yd8A==
Date: Mon, 21 Sep 2026 17:57:22 +0100
From: Simon Horman <horms@kernel.org>
To: Dongliang Qin <cccccccccccc777777@gmail.com>
Cc: netdev@vger.kernel.org, achender@kernel.org,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net] rds: ib: Clear the sg list when mapping an MR fails
Message-ID: <20260921165722.GY13925@horms.kernel.org>
References: <20260920063449.1594203-1-cccccccccccc777777@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260920063449.1594203-1-cccccccccccc777777@gmail.com>

On Sun, Sep 20, 2026 at 02:34:49PM +0800, Dongliang Qin wrote:
> rds_ib_map_frmr() stores the caller's scatterlist in the MR before DMA
> mapping and registration can fail. On failure, __rds_rdma_map() unpins
> the pages and frees the scatterlist, but rds_ib_free_frmr() can still
> return the MR to the pool with the stale pointer set.
> 
> This leaves the pool with a dangling scatterlist and can lead to local
> privilege escalation. KASAN detects the resulting use-after-free when the
> MR is later torn down:
> 
> BUG: KASAN: slab-use-after-free in __rds_ib_teardown_mr
> Read of size 8
> 
> Call Trace:
>  __rds_ib_teardown_mr
>  rds_ib_unreg_frmr
>  rds_ib_flush_mr_pool
>  rds_ib_flush_mrs
>  rds_free_mr
>  rds_setsockopt
> 
> Clear the scatterlist fields before returning an error so the caller
> retains sole ownership of the scatterlist and its pinned pages. Route a
> zero-length DMA mapping through the same cleanup path, and skip unmap
> when no mapping was created.
> 
> Fixes: 1659185fb4d0 ("RDS: IB: Support Fastreg MR (FRMR) memory registration mode")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dongliang Qin <cccccccccccc777777@gmail.com>
> ---
>  net/rds/ib_frmr.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/net/rds/ib_frmr.c b/net/rds/ib_frmr.c
> index bd8611911..fea387952 100644
> --- a/net/rds/ib_frmr.c
> +++ b/net/rds/ib_frmr.c
> @@ -213,7 +213,8 @@ static int rds_ib_map_frmr(struct rds_ib_device *rds_ibdev,
>  					 DMA_BIDIRECTIONAL);
>  	if (unlikely(!ibmr->sg_dma_len)) {
>  		pr_warn("RDS/IB: %s failed!\n", __func__);
> -		return -EBUSY;
> +		ret = -EBUSY;
> +		goto out_unmap;
>  	}

Hi Dongliang,

This approach leads to the complexity of a condition in the out_unmap
label.  I wonder if a cleaner approach would be to, instead, only store the
scatterlist in the MR once mapping has succeeded.

With such an approach I think that ibmr->sg and ibmr->sg_len would still
need to be cleared in the error path. But neither the condition in the
out_unmap label nor the hunk above would not be necessary. And I wonder
if that would be a cleaner approach.

>  
>  	frmr->sg_byte_len = 0;
> @@ -261,9 +262,13 @@ static int rds_ib_map_frmr(struct rds_ib_device *rds_ibdev,
>  	return ret;
>  
>  out_unmap:
> -	ib_dma_unmap_sg(rds_ibdev->dev, ibmr->sg, ibmr->sg_len,
> -			DMA_BIDIRECTIONAL);
> -	ibmr->sg_dma_len = 0;
> +	if (ibmr->sg_dma_len) {
> +		ib_dma_unmap_sg(rds_ibdev->dev, ibmr->sg, ibmr->sg_len,
> +				DMA_BIDIRECTIONAL);
> +		ibmr->sg_dma_len = 0;
> +	}
> +	ibmr->sg = NULL;
> +	ibmr->sg_len = 0;
>  	return ret;
>  }
>  
> -- 
> 2.43.0
> 
