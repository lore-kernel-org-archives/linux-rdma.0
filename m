From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH -next v3] IB/ipath: use GFP_NOWAIT under spin lock
Date: Fri, 22 Feb 2013 14:16:42 -0800
Message-ID: <20130222141642.247ee792.akpm@linux-foundation.org>
References: <CAPgLHd965-++Kj6HE-wjHqpZjortmmCAvApSSwiXaX6YwWncHQ@mail.gmail.com>
	<CAOS58YNcJ0gDmoR4M1tgJbqqzv0i=5EkoAr=OhoTSrozfw-ZtQ@mail.gmail.com>
	<CAOS58YOHt7OaBHRwwqjLF8xZtVaj=BeFUXFAxW0owb4_BxC3Rg@mail.gmail.com>
	<CAPgLHd8_WyQiDpJwRWwNVPbSvVcpMj1bMu7h2QmfJpscd0LOFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPgLHd8_WyQiDpJwRWwNVPbSvVcpMj1bMu7h2QmfJpscd0LOFQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 22 Feb 2013 10:48:12 +0800
Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> From: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
> 
> A spin lock is taken here so we should use GFP_NOWAIT like
> other case.
> 
> ..
>
> --- a/drivers/infiniband/hw/ipath/ipath_driver.c
> +++ b/drivers/infiniband/hw/ipath/ipath_driver.c
> @@ -204,7 +204,7 @@ static struct ipath_devdata *ipath_alloc_devdata(struct pci_dev *pdev)
>  	idr_preload(GFP_KERNEL);
>  	spin_lock_irqsave(&ipath_devs_lock, flags);
>  
> -	ret = idr_alloc(&unit_table, dd, 0, 0, GFP_KERNEL);
> +	ret = idr_alloc(&unit_table, dd, 0, 0, GFP_NOWAIT);
>  	if (ret < 0) {
>  		printk(KERN_ERR IPATH_DRV_NAME
>  		       ": Could not allocate unit ID: error %d\n", -ret);

I'd say we're entitled to use GFP_ATOMIC here: it will dip into page
reserves and is less likely to fail.

Given that this code is performing allocations under
spin_lock_irqsave(), it should be using idr_preload()/idr_preload_end()
(and perhaps even a repeat loop around those) to make the allocations
more reliable.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
