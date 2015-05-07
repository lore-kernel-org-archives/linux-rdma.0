From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 14/14] xprtrmda: Reduce per-transport MR allocation
Date: Thu, 07 May 2015 14:00:55 +0300
Message-ID: <554B45E7.4040902@dev.mellanox.co.il>
References: <20150504174626.3483.97639.stgit@manet.1015granger.net> <20150504175856.3483.57373.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150504175856.3483.57373.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/4/2015 8:58 PM, Chuck Lever wrote:
> Reduce resource consumption per-transport to make way for increasing
> the credit limit and maximum r/wsize. Pre-allocate fewer MRs.
>
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>   net/sunrpc/xprtrdma/fmr_ops.c  |    6 ++++--
>   net/sunrpc/xprtrdma/frwr_ops.c |    6 ++++--
>   2 files changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/net/sunrpc/xprtrdma/fmr_ops.c b/net/sunrpc/xprtrdma/fmr_ops.c
> index 4a53ad5..f1e8daf 100644
> --- a/net/sunrpc/xprtrdma/fmr_ops.c
> +++ b/net/sunrpc/xprtrdma/fmr_ops.c
> @@ -69,8 +69,10 @@ fmr_op_init(struct rpcrdma_xprt *r_xprt)
>   	INIT_LIST_HEAD(&buf->rb_mws);
>   	INIT_LIST_HEAD(&buf->rb_all);
>
> -	i = (buf->rb_max_requests + 1) * RPCRDMA_MAX_SEGS;
> -	dprintk("RPC:       %s: initializing %d FMRs\n", __func__, i);
> +	i = max_t(int, RPCRDMA_MAX_DATA_SEGS / RPCRDMA_MAX_FMR_SGES, 1);
> +	i += 2;				/* head + tail */
> +	i *= buf->rb_max_requests;	/* one set for each RPC slot */
> +	dprintk("RPC:       %s: initalizing %d FMRs\n", __func__, i);
>
>   	rc = -ENOMEM;
>   	while (i--) {
> diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
> index edc10ba..fc2d0c6 100644
> --- a/net/sunrpc/xprtrdma/frwr_ops.c
> +++ b/net/sunrpc/xprtrdma/frwr_ops.c
> @@ -270,8 +270,10 @@ frwr_op_init(struct rpcrdma_xprt *r_xprt)
>   	INIT_LIST_HEAD(&buf->rb_mws);
>   	INIT_LIST_HEAD(&buf->rb_all);
>
> -	i = (buf->rb_max_requests + 1) * RPCRDMA_MAX_SEGS;
> -	dprintk("RPC:       %s: initializing %d FRMRs\n", __func__, i);
> +	i = max_t(int, RPCRDMA_MAX_DATA_SEGS / depth, 1);
> +	i += 2;				/* head + tail */
> +	i *= buf->rb_max_requests;	/* one set for each RPC slot */
> +	dprintk("RPC:       %s: initalizing %d FRMRs\n", __func__, i);
>
>   	while (i--) {
>   		struct rpcrdma_mw *r;
>

Looks good.

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
