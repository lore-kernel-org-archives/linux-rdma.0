Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2228C3E7BA4;
	Wed, 15 Jul 2026 09:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784106365; cv=none; b=u2KBteluQEOs8d5ZJPgWIe8QGeBqlk875R4/PvpnXO87VMT96gP0ZuYt0XLyFIyeGuzO3kq2iMO60suZFqsvx+2jZpEfbBgSzSAsp129qqJlJm+e7nR06yLqdwwaCscQ9zVuaH1RbOJykBxch3x/8rpSS/lbgAu+mIfIUYz/T8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784106365; c=relaxed/simple;
	bh=3BI5Z4OqUuRtYp7BClG+SHiYvpqE3H+/n/Rx4Jg1ivQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uUGRb3Ts7p4witJqCmrZ4XeaZTUbFXwhnZBUvD0HMIjbCeSGZysdz0AmXF9036QQkc0hL36zHmpqnRUOg7N3RNMp50UFtzCUr+NJsnNefVB3GVPf7ZQWnB9EJIlo5KXobWhKYEoybpgh8UzxVYSsPt/tRhd0JmrnWNI2CdUPaT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NA6iqLfi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NA6iqLfi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62031F000E9;
	Wed, 15 Jul 2026 09:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784106362;
	bh=Y88tzC1/LJ6aLdthsFjO8w+Vf1/wl511Iaf+O9aceZ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NA6iqLfiTDjHV10czvzfbX+T/3yibb2uvqjCZh4lOIrlyViE77SGOlCfLAn4b6mxy
	 7XHfZcBucN6pAWXdVAkV8pa+aWpo0vkNIuV+kpZ+XKgELT1PWy5mhQWjI9GWlSiS0J
	 bB5KZfOtuEVuckco1Mu4wmPUxhTQMm4sojvzMbQwlrJbuXqG4mnCoKiIKSOCoWkb1m
	 rmeDEdcI5JI993RtjdFhs2NyKrW532YbDrBVWTYqL5YjjfAFIeyIVbS33Hxhrdiyt9
	 PY5P6QFqvcjy9sS7yekx0j2B4atzmHuX3v8kacZaY9SYTK3yyjWUkUVj+yXunJnvrD
	 L/1W0wvS8BuKQ==
Date: Wed, 15 Jul 2026 12:05:57 +0300
From: Leon Romanovsky <leon@kernel.org>
To: kensanya@163.com
Cc: bvanassche@acm.org, jgg@ziepe.ca, linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	TanZheng <tanzheng@kylinos.cn>
Subject: Re: [PATCH] RDMA/srpt: Fix srpt_alloc_rw_ctxs() unwind counters
Message-ID: <20260715090557.GE21348@unreal>
References: <20260715023016.56767-1-kensanya@163.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715023016.56767-1-kensanya@163.com>

On Wed, Jul 15, 2026 at 10:30:16AM +0800, kensanya@163.com wrote:
> From: TanZheng <tanzheng@kylinos.cn>
> 
> When srpt_alloc_rw_ctxs() fails partway through a multi-buffer indirect
> descriptor, the unwind path destroys RDMA contexts but leaves stale
> n_rw_ctx and n_rdma values (and a dangling rw_ctxs pointer). Later
> sq_wr_avail accounting in srpt_queue_response() or srpt_write_pending()
> can then subtract the wrong number of send queue credits.
> 
> Reset the counters and rw_ctxs pointer before returning an error.
> 
> Fixes: b99f8e4d7bcd ("IB/srpt: convert to the generic RDMA READ/WRITE API")
> Signed-off-by: TanZheng <tanzheng@kylinos.cn>
> ---
>  drivers/infiniband/ulp/srpt/ib_srpt.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index f66cfd70c263..4644429fae14 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -1016,6 +1016,9 @@ static int srpt_alloc_rw_ctxs(struct srpt_send_ioctx *ioctx,
>  	}
>  	if (ioctx->rw_ctxs != &ioctx->s_rw_ctx)
>  		kfree(ioctx->rw_ctxs);
> +	ioctx->rw_ctxs = &ioctx->s_rw_ctx;

This line seems questionable to me.
You probably need to write:
if (ioctx->rw_ctxs != &ioctx->s_rw_ctx) {
  kfree(ioctx->rw_ctxs);
  ioctx->rw_ctxs = NULL;
}

> +	ioctx->n_rw_ctx = 0;
> +	ioctx->n_rdma = 0;

These lines seem correct to me.

>  	return ret;
>  }
>  
> -- 
> 2.25.1
> 
