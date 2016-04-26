From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v2 15/18] xprtrdma: Refactor __fmr_dma_unmap()
Date: Tue, 26 Apr 2016 23:21:03 +0300
Message-ID: <571FCDAF.8090606@grimberg.me>
References: <20160425185956.3566.64142.stgit@manet.1015granger.net>
 <20160425192251.3566.35007.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160425192251.3566.35007.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> diff --git a/net/sunrpc/xprtrdma/fmr_ops.c b/net/sunrpc/xprtrdma/fmr_ops.c
> index 009694b..9d50f3a 100644
> --- a/net/sunrpc/xprtrdma/fmr_ops.c
> +++ b/net/sunrpc/xprtrdma/fmr_ops.c
> @@ -186,15 +186,10 @@ static void
>   __fmr_dma_unmap(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg)
>   {
>   	struct ib_device *device = r_xprt->rx_ia.ri_device;
> -	struct rpcrdma_mw *mw = seg->rl_mw;
>   	int nsegs = seg->mr_nsegs;
>
> -	seg->rl_mw = NULL;
> -
>   	while (nsegs--)
>   		rpcrdma_unmap_one(device, seg++);

When will we get to see this in the form of dma_unmap_sg()? ;)

Looks fine anyways...

Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
