From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 15/18] svcrdma: Add svc_rdma_get_context() API that is
 allowed to fail
Date: Sun, 20 Sep 2015 15:40:49 +0300
Message-ID: <55FEA951.8000106@dev.mellanox.co.il>
References: <20150917202829.19671.90044.stgit@manet.1015granger.net>
 <20150917204614.19671.61606.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150917204614.19671.61606.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 9/17/2015 11:46 PM, Chuck Lever wrote:
> To support backward direction calls, I'm going to add an
> svc_rdma_get_context() call in the client RDMA transport.
>
> Called from ->buf_alloc(), we can't sleep waiting for memory.
> So add an API that can get a server op_ctxt but won't sleep.
>
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>   include/linux/sunrpc/svc_rdma.h          |    2 ++
>   net/sunrpc/xprtrdma/svc_rdma_transport.c |   28 +++++++++++++++++++++++-----
>   2 files changed, 25 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/svc_rdma.h
> index 6ce7495..2500dd1 100644
> --- a/include/linux/sunrpc/svc_rdma.h
> +++ b/include/linux/sunrpc/svc_rdma.h
> @@ -224,6 +224,8 @@ extern void svc_rdma_send_error(struct svcxprt_rdma *, struct rpcrdma_msg *,
>   extern int svc_rdma_post_recv(struct svcxprt_rdma *);
>   extern int svc_rdma_create_listen(struct svc_serv *, int, struct sockaddr *);
>   extern struct svc_rdma_op_ctxt *svc_rdma_get_context(struct svcxprt_rdma *);
> +extern struct svc_rdma_op_ctxt *svc_rdma_get_context_gfp(struct svcxprt_rdma *,
> +							 gfp_t);
>   extern void svc_rdma_put_context(struct svc_rdma_op_ctxt *, int);
>   extern void svc_rdma_unmap_dma(struct svc_rdma_op_ctxt *ctxt);
>   extern struct svc_rdma_req_map *svc_rdma_get_req_map(void);
> diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
> index 23aba30..c4083a3 100644
> --- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
> +++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
> @@ -153,17 +153,35 @@ static void svc_rdma_bc_free(struct svc_xprt *xprt)
>   }
>   #endif	/* CONFIG_SUNRPC_BACKCHANNEL */
>
> -struct svc_rdma_op_ctxt *svc_rdma_get_context(struct svcxprt_rdma *xprt)
> +static void svc_rdma_init_context(struct svcxprt_rdma *xprt,
> +				  struct svc_rdma_op_ctxt *ctxt)
>   {
> -	struct svc_rdma_op_ctxt *ctxt;
> -
> -	ctxt = kmem_cache_alloc(svc_rdma_ctxt_cachep,
> -				GFP_KERNEL | __GFP_NOFAIL);
>   	ctxt->xprt = xprt;
>   	INIT_LIST_HEAD(&ctxt->dto_q);
>   	ctxt->count = 0;
>   	ctxt->frmr = NULL;
>   	atomic_inc(&xprt->sc_ctxt_used);
> +}
> +
> +struct svc_rdma_op_ctxt *svc_rdma_get_context_gfp(struct svcxprt_rdma *xprt,
> +						  gfp_t flags)
> +{
> +	struct svc_rdma_op_ctxt *ctxt;
> +
> +	ctxt = kmem_cache_alloc(svc_rdma_ctxt_cachep, flags);
> +	if (!ctxt)
> +		return NULL;
> +	svc_rdma_init_context(xprt, ctxt);
> +	return ctxt;
> +}
> +
> +struct svc_rdma_op_ctxt *svc_rdma_get_context(struct svcxprt_rdma *xprt)
> +{

Why not:
        return svc_rdma_get_context_gfp(xprt, GFP_KERNEL | __GFP_NOFAIL);
?

> +	struct svc_rdma_op_ctxt *ctxt;
> +
> +	ctxt = kmem_cache_alloc(svc_rdma_ctxt_cachep,
> +				GFP_KERNEL | __GFP_NOFAIL);
> +	svc_rdma_init_context(xprt, ctxt);
>   	return ctxt;
>   }
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
