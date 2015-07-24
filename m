From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH V6 4/9] svcrdma: Use max_sge_rd for destination read depths
Date: Fri, 24 Jul 2015 13:51:34 -0500
Message-ID: <00d301d0c641$c2fcb6a0$48f623e0$@opengridcomputing.com>
References: <20150724161331.25617.8475.stgit@build2.ogc.int> <20150724161837.25617.48584.stgit@build2.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150724161837.25617.48584.stgit-PBeJgSbIpn97NCTnQtmixQ@public.gmane.org>
Content-Language: en-us
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Steve Wise
> Sent: Friday, July 24, 2015 11:19 AM
> To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Cc: infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
> Subject: [PATCH V6 4/9] svcrdma: Use max_sge_rd for destination read depths
> 
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
> 
>  include/linux/sunrpc/svc_rdma.h          |    1 +
>  net/sunrpc/xprtrdma/svc_rdma_recvfrom.c  |   12 +-----------
>  net/sunrpc/xprtrdma/svc_rdma_transport.c |    4 ++++
>  3 files changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/svc_rdma.h
> index cb94ee4..83211bc 100644
> --- a/include/linux/sunrpc/svc_rdma.h
> +++ b/include/linux/sunrpc/svc_rdma.h
> @@ -132,6 +132,7 @@ struct svcxprt_rdma {
>  	struct list_head     sc_accept_q;	/* Conn. waiting accept */
>  	int		     sc_ord;		/* RDMA read limit */
>  	int                  sc_max_sge;
> +	int                  sc_max_sge_rd;	/* max sge for read target */
> 
>  	int                  sc_sq_depth;	/* Depth of SQ */
>  	atomic_t             sc_sq_count;	/* Number of SQ WR on queue */
> diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
> index 2e1348b..cb51742 100644
> --- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
> +++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
> @@ -115,15 +115,6 @@ static void rdma_build_arg_xdr(struct svc_rqst *rqstp,
>  	rqstp->rq_arg.tail[0].iov_len = 0;
>  }
> 
> -static int rdma_read_max_sge(struct svcxprt_rdma *xprt, int sge_count)
> -{
> -	if (!rdma_cap_read_multi_sge(xprt->sc_cm_id->device,
> -				     xprt->sc_cm_id->port_num))
> -		return 1;
> -	else
> -		return min_t(int, sge_count, xprt->sc_max_sge);
> -}
> -
>  /* Issue an RDMA_READ using the local lkey to map the data sink */
>  int rdma_read_chunk_lcl(struct svcxprt_rdma *xprt,
>  			struct svc_rqst *rqstp,
> @@ -144,8 +135,7 @@ int rdma_read_chunk_lcl(struct svcxprt_rdma *xprt,
> 
>  	ctxt->direction = DMA_FROM_DEVICE;
>  	ctxt->read_hdr = head;
> -	pages_needed =
> -		min_t(int, pages_needed, rdma_read_max_sge(xprt, pages_needed));
> +	pages_needed = min_t(int, pages_needed, xprt->sc_max_sge_rd);
>  	read = min_t(int, pages_needed << PAGE_SHIFT, rs_length);
> 
>  	for (pno = 0; pno < pages_needed; pno++) {
> diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
> index 6b36279..fdc850f 100644
> --- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
> +++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
> @@ -872,6 +872,8 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
>  	 * capabilities of this particular device */
>  	newxprt->sc_max_sge = min((size_t)devattr.max_sge,
>  				  (size_t)RPCSVC_MAXPAGES);
> +	newxprt->sc_max_sge_rd = min_t(size_t, devattr.max_sge_rd,
> +				       RPCSVC_MAXPAGES);
>  	newxprt->sc_max_requests = min((size_t)devattr.max_qp_wr,
>  				   (size_t)svcrdma_max_requests);
>  	newxprt->sc_sq_depth = RPCRDMA_SQ_DEPTH_MULT * newxprt->sc_max_requests;
> @@ -1046,6 +1048,7 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
>  		"    remote_ip       : %pI4\n"
>  		"    remote_port     : %d\n"
>  		"    max_sge         : %d\n"
> +		"    max_sge_rd      : %d\n"
>  		"    sq_depth        : %d\n"
>  		"    max_requests    : %d\n"
>  		"    ord             : %d\n",
> @@ -1059,6 +1062,7 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
>  		ntohs(((struct sockaddr_in *)&newxprt->sc_cm_id->
>  		       route.addr.dst_addr)->sin_port),
>  		newxprt->sc_max_sge,
> +		newxprt->sc_max_sge_rd,
>  		newxprt->sc_sq_depth,
>  		newxprt->sc_max_requests,
>  		newxprt->sc_ord);
> 

With the above patch change, we have no more users of the recently created rdma_cap_read_multi_sge().  Should I add a patch to remove it?

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
