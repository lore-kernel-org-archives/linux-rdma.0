Received: from stargate.chelsio.com (unknown [12.32.117.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE48F3515F9;
	Fri, 24 Jul 2026 08:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=12.32.117.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784883126; cv=none; b=ClMJwEbrsqHTPrUJOhuGz6myapEm6sQ78SuVLTVOGfXA3j2N52g8Xr/+dMd1ot+Qmg3sZnmhvn4J84CXV7+3Uc6aYgFD4aR4w3+5P4tn8v+2qBOxPi8njdn2LXu6qB8iva3b0sBp0Q4OPD4yHE6zWzft8lKdbGDDf4/toZobqZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784883126; c=relaxed/simple;
	bh=5vUAbcoBwTLbU3P3yCeQxdbg4ylq9296SG3q8OeF9jU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dn5EhbRHUJ4rz5RdWD535HoA4E8Sy/EmLUtFIEBn9U2SKx2jJHk0trmqqJuvKSDsqzzctEWAfFJRE1XGfjjc/bGkwD0Jcv6Xn3TNl1TiRdTuVnwVnF0d/UroHqNI2jBEFlgGkfEKiveC8LlOWXzoq3zLQiyVJwjn9355HNOMnao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chelsio.com; spf=pass smtp.mailfrom=chelsio.com; arc=none smtp.client-ip=12.32.117.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chelsio.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chelsio.com
Received: from localhost (praveen-pc.asicdesigners.com [10.193.191.60] (may be forged))
	by stargate.chelsio.com (8.14.7/8.14.7) with ESMTP id 66O7YKls001771;
	Fri, 24 Jul 2026 00:34:20 -0700
Date: Fri, 24 Jul 2026 13:04:03 +0530
From: Potnuri Bharat Teja <bharat@chelsio.com>
To: Gou Hao <gouhao@uniontech.com>
Cc: maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com,
        chleroy@kernel.org, maarten.lankhorst@linux.intel.com,
        mripard@kernel.org, tzimmermann@suse.de, airlied@gmail.com,
        simona@ffwll.ch, jgg@ziepe.ca, leon@kernel.org,
        akpm@linux-foundation.org, namcao@linutronix.de, ynorov@nvidia.com,
        sshegde@linux.ibm.com, nilay@linux.ibm.com, clg@kaod.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org,
        linux-mm@kvack.org, gouhaojake@163.com, kernel@uniontech.com
Subject: Re: [PATCH v2 6/6] RDMA/cxgb4: remove dead NULL checks after
 GFP_NOFAIL allocations
Message-ID: <amMVa/hvQndWud1I@chelsio.com>
References: <20260724022851.466017-1-gouhao@uniontech.com>
 <20260724022851.466017-7-gouhao@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724022851.466017-7-gouhao@uniontech.com>

On Friday, July 07/24/26, 2026 at 10:28:51 +0800, Gou Hao wrote:
> alloc_skb() with the __GFP_NOFAIL flag will never return NULL,
> so the subsequent NULL checks and error handling are unreachable
> dead code. Remove them.
> 
> Signed-off-by: Gou Hao <gouhao@uniontech.com>
> ---
>  drivers/infiniband/hw/cxgb4/mem.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
> index cd1b010141984..08631de17c0a3 100644
> --- a/drivers/infiniband/hw/cxgb4/mem.c
> +++ b/drivers/infiniband/hw/cxgb4/mem.c
> @@ -74,11 +74,8 @@ static int _c4iw_write_mem_dma_aligned(struct c4iw_rdev *rdev, u32 addr,
>  		c4iw_init_wr_wait(wr_waitp);
>  	wr_len = roundup(sizeof(*req) + sizeof(*sgl), 16);
>  
> -	if (!skb) {
> +	if (!skb)
>  		skb = alloc_skb(wr_len, GFP_KERNEL | __GFP_NOFAIL);
> -		if (!skb)
> -			return -ENOMEM;
> -	}
>  	set_wr_txq(skb, CPL_PRIORITY_CONTROL, 0);
>  
>  	req = __skb_put_zero(skb, wr_len);
> @@ -134,11 +131,8 @@ static int _c4iw_write_mem_inline(struct c4iw_rdev *rdev, u32 addr, u32 len,
>  					 roundup(copy_len, T4_ULPTX_MIN_IO),
>  				 16);
>  
> -		if (!skb) {
> +		if (!skb)
>  			skb = alloc_skb(wr_len, GFP_KERNEL | __GFP_NOFAIL);
> -			if (!skb)
> -				return -ENOMEM;
> -		}

Reviewed-by: Potnuri Bharat Teja <bharat@chelsio.com>

>  		set_wr_txq(skb, CPL_PRIORITY_CONTROL, 0);
>  
>  		req = __skb_put_zero(skb, wr_len);
> -- 
> 2.20.1
> 
