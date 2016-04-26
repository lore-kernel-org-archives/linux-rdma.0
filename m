From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v2 13/18] xprtrdma: Refactor the FRWR recovery worker
Date: Tue, 26 Apr 2016 23:16:12 +0300
Message-ID: <571FCC8C.5040503@grimberg.me>
References: <20160425185956.3566.64142.stgit@manet.1015granger.net>
 <20160425192234.3566.63698.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160425192234.3566.63698.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> +static void
> +__frwr_reset_and_unmap(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mw *mw)
> +{
> +	struct rpcrdma_ia *ia = &r_xprt->rx_ia;
> +	struct rpcrdma_frmr *f = &mw->frmr;
> +	int rc;
> +
> +	rc = __frwr_reset_mr(ia, mw);
> +	ib_dma_unmap_sg(ia->ri_device, f->fr_sg, f->fr_nents, f->fr_dir);
> +	if (rc)
> +		return;
> +
> +	rpcrdma_put_mw(r_xprt, mw);
> +}
> +

If this is not being called from other sites I'd say just
do it in __frwr_recovery_worker instead of having it just bouncing
the call...
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
