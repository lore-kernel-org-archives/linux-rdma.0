From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 09/16] xprtrdma: Add "destroy MRs" memreg op
Date: Mon, 16 Mar 2015 12:46:39 +0200
Message-ID: <5506B48F.6050902@dev.mellanox.co.il>
References: <20150313212517.22783.18364.stgit@manet.1015granger.net> <20150313212758.22783.67493.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150313212758.22783.67493.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 3/13/2015 11:27 PM, Chuck Lever wrote:
> Memory Region objects associated with a transport instance are
> destroyed before the instance is shutdown and destroyed.
>
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>   net/sunrpc/xprtrdma/fmr_ops.c      |   21 +++++++++++++++
>   net/sunrpc/xprtrdma/frwr_ops.c     |   17 ++++++++++++
>   net/sunrpc/xprtrdma/physical_ops.c |    6 ++++
>   net/sunrpc/xprtrdma/verbs.c        |   52 +-----------------------------------
>   net/sunrpc/xprtrdma/xprt_rdma.h    |    1 +
>   5 files changed, 46 insertions(+), 51 deletions(-)
>
> diff --git a/net/sunrpc/xprtrdma/fmr_ops.c b/net/sunrpc/xprtrdma/fmr_ops.c
> index 1ccb3de..3115e4b 100644
> --- a/net/sunrpc/xprtrdma/fmr_ops.c
> +++ b/net/sunrpc/xprtrdma/fmr_ops.c
> @@ -178,11 +178,32 @@ fmr_op_reset(struct rpcrdma_xprt *r_xprt)
>   			__func__, rc);
>   }
>
> +static void
> +fmr_op_destroy(struct rpcrdma_buffer *buf)
> +{
> +	struct rpcrdma_mw *r;
> +	int rc;
> +
> +	while (!list_empty(&buf->rb_all)) {
> +		r = list_entry(buf->rb_all.next, struct rpcrdma_mw, mw_all);
> +		list_del(&r->mw_all);
> +		list_del(&r->mw_list);

Again, I understand this patch is just moving code, but is it
guaranteed that mr_list is in rb_mws at this point?

> +
> +		rc = ib_dealloc_fmr(r->r.fmr);
> +		if (rc)
> +			dprintk("RPC:       %s: ib_dealloc_fmr failed %i\n",
> +				__func__, rc);
> +
> +		kfree(r);
> +	}
> +}
> +
>   const struct rpcrdma_memreg_ops rpcrdma_fmr_memreg_ops = {
>   	.ro_map				= fmr_op_map,
>   	.ro_unmap			= fmr_op_unmap,
>   	.ro_maxpages			= fmr_op_maxpages,
>   	.ro_init			= fmr_op_init,
>   	.ro_reset			= fmr_op_reset,
> +	.ro_destroy			= fmr_op_destroy,
>   	.ro_displayname			= "fmr",
>   };
> diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
> index b4ce0e5..fc3a228 100644
> --- a/net/sunrpc/xprtrdma/frwr_ops.c
> +++ b/net/sunrpc/xprtrdma/frwr_ops.c
> @@ -271,11 +271,28 @@ frwr_op_reset(struct rpcrdma_xprt *r_xprt)
>   	}
>   }
>
> +static void
> +frwr_op_destroy(struct rpcrdma_buffer *buf)
> +{
> +	struct rpcrdma_mw *r;
> +
> +	while (!list_empty(&buf->rb_all)) {
> +		r = list_entry(buf->rb_all.next, struct rpcrdma_mw, mw_all);
> +		list_del(&r->mw_all);
> +		list_del(&r->mw_list);
> +
> +		__frwr_release(r);
> +
> +		kfree(r);
> +	}
> +}
> +
>   const struct rpcrdma_memreg_ops rpcrdma_frwr_memreg_ops = {
>   	.ro_map				= frwr_op_map,
>   	.ro_unmap			= frwr_op_unmap,
>   	.ro_maxpages			= frwr_op_maxpages,
>   	.ro_init			= frwr_op_init,
>   	.ro_reset			= frwr_op_reset,
> +	.ro_destroy			= frwr_op_destroy,
>   	.ro_displayname			= "frwr",
>   };
> diff --git a/net/sunrpc/xprtrdma/physical_ops.c b/net/sunrpc/xprtrdma/physical_ops.c
> index 0afc691..f8da8c4 100644
> --- a/net/sunrpc/xprtrdma/physical_ops.c
> +++ b/net/sunrpc/xprtrdma/physical_ops.c
> @@ -67,11 +67,17 @@ physical_op_reset(struct rpcrdma_xprt *r_xprt)
>   {
>   }
>
> +static void
> +physical_op_destroy(struct rpcrdma_buffer *buf)
> +{
> +}
> +
>   const struct rpcrdma_memreg_ops rpcrdma_physical_memreg_ops = {
>   	.ro_map				= physical_op_map,
>   	.ro_unmap			= physical_op_unmap,
>   	.ro_maxpages			= physical_op_maxpages,
>   	.ro_init			= physical_op_init,
>   	.ro_reset			= physical_op_reset,
> +	.ro_destroy			= physical_op_destroy,
>   	.ro_displayname			= "physical",
>   };
> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
> index e17d91a..dcbc736 100644
> --- a/net/sunrpc/xprtrdma/verbs.c
> +++ b/net/sunrpc/xprtrdma/verbs.c
> @@ -1198,47 +1198,6 @@ rpcrdma_destroy_req(struct rpcrdma_ia *ia, struct rpcrdma_req *req)
>   	kfree(req);
>   }
>
> -static void
> -rpcrdma_destroy_fmrs(struct rpcrdma_buffer *buf)
> -{
> -	struct rpcrdma_mw *r;
> -	int rc;
> -
> -	while (!list_empty(&buf->rb_all)) {
> -		r = list_entry(buf->rb_all.next, struct rpcrdma_mw, mw_all);
> -		list_del(&r->mw_all);
> -		list_del(&r->mw_list);
> -
> -		rc = ib_dealloc_fmr(r->r.fmr);
> -		if (rc)
> -			dprintk("RPC:       %s: ib_dealloc_fmr failed %i\n",
> -				__func__, rc);
> -
> -		kfree(r);
> -	}
> -}
> -
> -static void
> -rpcrdma_destroy_frmrs(struct rpcrdma_buffer *buf)
> -{
> -	struct rpcrdma_mw *r;
> -	int rc;
> -
> -	while (!list_empty(&buf->rb_all)) {
> -		r = list_entry(buf->rb_all.next, struct rpcrdma_mw, mw_all);
> -		list_del(&r->mw_all);
> -		list_del(&r->mw_list);
> -
> -		rc = ib_dereg_mr(r->r.frmr.fr_mr);
> -		if (rc)
> -			dprintk("RPC:       %s: ib_dereg_mr failed %i\n",
> -				__func__, rc);
> -		ib_free_fast_reg_page_list(r->r.frmr.fr_pgl);
> -
> -		kfree(r);
> -	}
> -}
> -
>   void
>   rpcrdma_buffer_destroy(struct rpcrdma_buffer *buf)
>   {
> @@ -1259,16 +1218,7 @@ rpcrdma_buffer_destroy(struct rpcrdma_buffer *buf)
>   			rpcrdma_destroy_req(ia, buf->rb_send_bufs[i]);
>   	}
>
> -	switch (ia->ri_memreg_strategy) {
> -	case RPCRDMA_FRMR:
> -		rpcrdma_destroy_frmrs(buf);
> -		break;
> -	case RPCRDMA_MTHCAFMR:
> -		rpcrdma_destroy_fmrs(buf);
> -		break;
> -	default:
> -		break;
> -	}
> +	ia->ri_ops->ro_destroy(buf);
>
>   	kfree(buf->rb_pool);
>   }
> diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
> index cdf6763..a0e3c3e 100644
> --- a/net/sunrpc/xprtrdma/xprt_rdma.h
> +++ b/net/sunrpc/xprtrdma/xprt_rdma.h
> @@ -343,6 +343,7 @@ struct rpcrdma_memreg_ops {
>   	size_t		(*ro_maxpages)(struct rpcrdma_xprt *);
>   	int		(*ro_init)(struct rpcrdma_xprt *);
>   	void		(*ro_reset)(struct rpcrdma_xprt *);
> +	void		(*ro_destroy)(struct rpcrdma_buffer *);
>   	const char	*ro_displayname;
>   };
>
>

Other than that,

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
