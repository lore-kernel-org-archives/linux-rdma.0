From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH V2] svcrdma: Fence LOCAL_INV work requests
Date: Thu, 5 Jun 2014 12:13:53 -0400
Message-ID: <20140605161353.GH8362@fieldses.org>
References: <20140605145429.14347.22150.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140605145429.14347.22150.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 05, 2014 at 09:54:31AM -0500, Steve Wise wrote:
> This applies on top of:
> 
> 	commit e5a070216356dbcb03607cb264cc3104e17339b3
> 	Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> 	Date:   Wed May 28 15:12:01 2014 -0500
> 
> 	    svcrdma: refactor marshalling logic

Sorry, I lost track--was there another revision of that patch coming
too?

--b.

> 
> Fencing forces the invalidate to only happen after all prior send
> work requests have been completed.
> 
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
> 
>  net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
> index 52d9f2c..8f92a61 100644
> --- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
> +++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
> @@ -338,7 +338,7 @@ static int rdma_read_chunk_frmr(struct svcxprt_rdma *xprt,
>  		memset(&inv_wr, 0, sizeof(inv_wr));
>  		inv_wr.wr_id = (unsigned long)ctxt;
>  		inv_wr.opcode = IB_WR_LOCAL_INV;
> -		inv_wr.send_flags = IB_SEND_SIGNALED;
> +		inv_wr.send_flags = IB_SEND_SIGNALED | IB_SEND_FENCE;
>  		inv_wr.ex.invalidate_rkey = frmr->mr->lkey;
>  	}
>  	ctxt->wr_op = read_wr.opcode;
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
