From: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 02/20] xprtrdma: Refactor ->ro_init
Date: Wed, 8 Jun 2016 13:48:06 -0400
Message-ID: <e92ef6c5-8ceb-90f0-2d83-8b61ed37c3a9@Netapp.com>
References: <20160607194001.18401.88592.stgit@manet.1015granger.net>
 <20160607194635.18401.66399.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160607194635.18401.66399.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Chuck,

One nitpicky comment below:

On 06/07/2016 03:46 PM, Chuck Lever wrote:
> Clean up: Now that ALLPHYSICAL is gone, there is some buffer
> initialization code that is common to remaining memory registration
> modes. Move it into rpcrdma_buffer_create.
> 
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  net/sunrpc/xprtrdma/fmr_ops.c  |    4 ----
>  net/sunrpc/xprtrdma/frwr_ops.c |    4 ----
>  net/sunrpc/xprtrdma/verbs.c    |    3 +++
>  3 files changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/net/sunrpc/xprtrdma/fmr_ops.c b/net/sunrpc/xprtrdma/fmr_ops.c
> index 6326ebe..b8952c7 100644
> --- a/net/sunrpc/xprtrdma/fmr_ops.c
> +++ b/net/sunrpc/xprtrdma/fmr_ops.c
> @@ -126,10 +126,6 @@ fmr_op_init(struct rpcrdma_xprt *r_xprt)
>  	struct rpcrdma_mw *r;
>  	int i, rc;
>  
> -	spin_lock_init(&buf->rb_mwlock);
> -	INIT_LIST_HEAD(&buf->rb_mws);
> -	INIT_LIST_HEAD(&buf->rb_all);
> -
>  	i = max_t(int, RPCRDMA_MAX_DATA_SEGS / RPCRDMA_MAX_FMR_SGES, 1);
>  	i += 2;				/* head + tail */
>  	i *= buf->rb_max_requests;	/* one set for each RPC slot */
> diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
> index c094754..6e0e5e8 100644
> --- a/net/sunrpc/xprtrdma/frwr_ops.c
> +++ b/net/sunrpc/xprtrdma/frwr_ops.c
> @@ -355,10 +355,6 @@ frwr_op_init(struct rpcrdma_xprt *r_xprt)
>  	struct ib_pd *pd = r_xprt->rx_ia.ri_pd;
>  	int i;
>  
> -	spin_lock_init(&buf->rb_mwlock);
> -	INIT_LIST_HEAD(&buf->rb_mws);
> -	INIT_LIST_HEAD(&buf->rb_all);
> -
>  	i = max_t(int, RPCRDMA_MAX_DATA_SEGS / depth, 1);
>  	i += 2;				/* head + tail */
>  	i *= buf->rb_max_requests;	/* one set for each RPC slot */
> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
> index 7f09162..ecd494a 100644
> --- a/net/sunrpc/xprtrdma/verbs.c
> +++ b/net/sunrpc/xprtrdma/verbs.c
> @@ -822,6 +822,9 @@ rpcrdma_buffer_create(struct rpcrdma_xprt *r_xprt)
>  
>  	buf->rb_max_requests = r_xprt->rx_data.max_requests;
>  	buf->rb_bc_srv_max_requests = 0;
> +	spin_lock_init(&buf->rb_mwlock);
> +	INIT_LIST_HEAD(&buf->rb_mws);
> +	INIT_LIST_HEAD(&buf->rb_all);
>  	spin_lock_init(&buf->rb_lock);

Can you rearrange this so the two spin_lock_inits() are next to each other?

Thanks,
Anna

>  	atomic_set(&buf->rb_credits, 1);
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
