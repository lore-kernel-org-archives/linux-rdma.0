From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 1/7] svcrdma: Another sendto chunk list parsing update
Date: Tue, 7 Feb 2017 11:42:52 -0800
Message-ID: <20170207194252.GA28088@infradead.org>
References: <20170207165131.14422.47088.stgit@klimt.1015granger.net>
 <20170207165815.14422.77348.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170207165815.14422.77348.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>  	/* Prepare the SGE for the RPCRDMA Header */
>  	ctxt->sge[0].lkey = rdma->sc_pd->local_dma_lkey;
> -	ctxt->sge[0].length = svc_rdma_xdr_get_reply_hdr_len(rdma_resp);
> +	ctxt->sge[0].length =
> +	    svc_rdma_xdr_get_reply_hdr_len((__be32 *)rdma_resp);

That case is pretty ugly, but given that it'll go away soon it's
probably fine for now.

Otherwise this look good:

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
