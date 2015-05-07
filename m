From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 04/14] xprtrdma: Use ib_device pointer safely
Date: Thu, 07 May 2015 13:00:47 +0300
Message-ID: <554B37CF.2070206@dev.mellanox.co.il>
References: <20150504174626.3483.97639.stgit@manet.1015granger.net> <20150504175720.3483.80356.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150504175720.3483.80356.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/4/2015 8:57 PM, Chuck Lever wrote:
> The connect worker can replace ri_id, but prevents ri_id->device
> from changing during the lifetime of a transport instance.
>
> Cache a copy of ri_id->device in rpcrdma_ia and in rpcrdma_rep.
> The cached copy can be used safely in code that does not serialize
> with the connect worker.
>
> Other code can use it to save an extra address generation (one
> pointer dereference instead of two).
>
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>   net/sunrpc/xprtrdma/fmr_ops.c      |    8 +----
>   net/sunrpc/xprtrdma/frwr_ops.c     |   12 +++----
>   net/sunrpc/xprtrdma/physical_ops.c |    8 +----
>   net/sunrpc/xprtrdma/verbs.c        |   61 +++++++++++++++++++-----------------
>   net/sunrpc/xprtrdma/xprt_rdma.h    |    2 +
>   5 files changed, 43 insertions(+), 48 deletions(-)
>
> diff --git a/net/sunrpc/xprtrdma/fmr_ops.c b/net/sunrpc/xprtrdma/fmr_ops.c
> index 302d4eb..0a96155 100644
> --- a/net/sunrpc/xprtrdma/fmr_ops.c
> +++ b/net/sunrpc/xprtrdma/fmr_ops.c
> @@ -85,7 +85,7 @@ fmr_op_map(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg,
>   	   int nsegs, bool writing)
>   {
>   	struct rpcrdma_ia *ia = &r_xprt->rx_ia;
> -	struct ib_device *device = ia->ri_id->device;
> +	struct ib_device *device = ia->ri_device;
>   	enum dma_data_direction direction = rpcrdma_data_dir(writing);
>   	struct rpcrdma_mr_seg *seg1 = seg;
>   	struct rpcrdma_mw *mw = seg1->rl_mw;
> @@ -137,17 +137,13 @@ fmr_op_unmap(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg)
>   {
>   	struct rpcrdma_ia *ia = &r_xprt->rx_ia;
>   	struct rpcrdma_mr_seg *seg1 = seg;
> -	struct ib_device *device;
>   	int rc, nsegs = seg->mr_nsegs;
>   	LIST_HEAD(l);
>
>   	list_add(&seg1->rl_mw->r.fmr->list, &l);
>   	rc = ib_unmap_fmr(&l);
> -	read_lock(&ia->ri_qplock);
> -	device = ia->ri_id->device;
>   	while (seg1->mr_nsegs--)
> -		rpcrdma_unmap_one(device, seg++);
> -	read_unlock(&ia->ri_qplock);
> +		rpcrdma_unmap_one(ia->ri_device, seg++);

Umm, I'm wandering if this is guaranteed to be the same device as
ri_id->device?

Imagine you are working on a bond device where each slave belongs to
a different adapter. When the active port toggles, you will see a
ADDR_CHANGED event (that the current code does not handle...), what
you'd want to do is just reconnect and rdma_cm will resolve the new
address for you (via the backup slave). I suspect that in case this
flow is concurrent with the reconnects you may end up with a stale
device handle.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
