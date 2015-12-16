From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] svc_rdma: use local_dma_lkey
Date: Wed, 16 Dec 2015 11:49:33 -0700
Message-ID: <20151216184933.GA11846@obsidianresearch.com>
References: <1450278664-2133-1-git-send-email-hch@lst.de>
 <1450278664-2133-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1450278664-2133-2-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 16, 2015 at 04:11:04PM +0100, Christoph Hellwig wrote:
> We now alwasy have a per-PD local_dma_lkey available.  Make use of that
> fact in svc_rdma and stop registering our own MR.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

> +++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
> @@ -144,6 +144,7 @@ int rdma_read_chunk_lcl(struct svcxprt_rdma *xprt,
>  
>  		head->arg.pages[pg_no] = rqstp->rq_arg.pages[pg_no];
>  		head->arg.page_len += len;
> +
>  		head->arg.len += len;
>  		if (!pg_off)
>  			head->count++;

Was this hunk deliberate?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
