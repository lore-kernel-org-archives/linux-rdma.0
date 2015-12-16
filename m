From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v3 06/11] xprtrdma: Add ro_unmap_sync method for FRWR
Date: Wed, 16 Dec 2015 15:57:56 +0200
Message-ID: <56716DE4.8080403@dev.mellanox.co.il>
References: <20151214211317.16295.70115.stgit@manet.1015granger.net>
 <20151214211827.16295.76338.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151214211827.16295.76338.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> +static void
> +__frwr_dma_unmap(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg,
> +		 int rc)
> +{
> +	struct ib_device *device = r_xprt->rx_ia.ri_device;
> +	struct rpcrdma_mw *mw = seg->rl_mw;
> +	int nsegs = seg->mr_nsegs;
> +
> +	seg->rl_mw = NULL;
> +
> +	while (nsegs--)
> +		rpcrdma_unmap_one(device, seg++);

Chuck, shouldn't this be replaced with ib_dma_unmap_sg?

Sorry for the late comment (Didn't find enough time to properly
review this...)
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
