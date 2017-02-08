From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v3 1/7] svcrdma: Another sendto chunk list parsing update
Date: Wed, 8 Feb 2017 11:57:00 -0500
Message-ID: <20170208165700.GB16064@fieldses.org>
References: <20170207165131.14422.47088.stgit@klimt.1015granger.net>
 <20170207165815.14422.77348.stgit@klimt.1015granger.net>
 <20170207194252.GA28088@infradead.org>
 <C65F013C-84A2-456D-A0C0-04444D3C4D58@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <C65F013C-84A2-456D-A0C0-04444D3C4D58-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, List Linux RDMA Mailing <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 07, 2017 at 03:30:58PM -0500, Chuck Lever wrote:
> 
> > On Feb 7, 2017, at 2:42 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> > 
> >> 	/* Prepare the SGE for the RPCRDMA Header */
> >> 	ctxt->sge[0].lkey = rdma->sc_pd->local_dma_lkey;
> >> -	ctxt->sge[0].length = svc_rdma_xdr_get_reply_hdr_len(rdma_resp);
> >> +	ctxt->sge[0].length =
> >> +	    svc_rdma_xdr_get_reply_hdr_len((__be32 *)rdma_resp);
> > 
> > That case is pretty ugly, but given that it'll go away soon it's
> > probably fine for now.
> 
> Yes, the type cast will be replaced.
> 
> 
> > Otherwise this look good:
> > 
> > Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> 
> Bruce, I assume you will pick up the extra Reviewed-by tags
> if I don't have to send another version of this series.

Yep, will do.

Thanks to you and Christoph.

--b.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
