From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 15/16] xprtrdma: Make rpcrdma_{un}map_one() into inline
 functions
Date: Mon, 16 Mar 2015 14:45:34 +0200
Message-ID: <5506D06E.8020809@dev.mellanox.co.il>
References: <20150313212517.22783.18364.stgit@manet.1015granger.net> <20150313212853.22783.62285.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150313212853.22783.62285.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 3/13/2015 11:28 PM, Chuck Lever wrote:
> These functions are called in a loop for each page transferred via
> RDMA READ or WRITE. Extract loop invariants and inline them to
> reduce CPU overhead.
>
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>   net/sunrpc/xprtrdma/fmr_ops.c      |   10 ++++++--
>   net/sunrpc/xprtrdma/frwr_ops.c     |   10 ++++++--
>   net/sunrpc/xprtrdma/physical_ops.c |   11 ++++++---
>   net/sunrpc/xprtrdma/verbs.c        |   44 ++++++-----------------------------
>   net/sunrpc/xprtrdma/xprt_rdma.h    |   45 ++++++++++++++++++++++++++++++++++--
>   5 files changed, 73 insertions(+), 47 deletions(-)
>
> diff --git a/net/sunrpc/xprtrdma/fmr_ops.c b/net/sunrpc/xprtrdma/fmr_ops.c
> index 9c6c2e8..1404f20 100644
> --- a/net/sunrpc/xprtrdma/fmr_ops.c
> +++ b/net/sunrpc/xprtrdma/fmr_ops.c
> @@ -29,14 +29,16 @@ __fmr_unmap(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg)
>   	struct rpcrdma_ia *ia = &r_xprt->rx_ia;
>   	struct rpcrdma_mr_seg *seg1 = seg;
>   	struct rpcrdma_mw *mw = seg1->rl_mw;
> +	struct ib_device *device;
>   	int rc, nsegs = seg->mr_nsegs;
>   	LIST_HEAD(l);
>
>   	list_add(&mw->r.fmr->list, &l);
>   	rc = ib_unmap_fmr(&l);
>   	read_lock(&ia->ri_qplock);
> +	device = ia->ri_id->device;
>   	while (seg1->mr_nsegs--)
> -		rpcrdma_unmap_one(ia, seg++);
> +		rpcrdma_unmap_one(device, seg++);
>   	read_unlock(&ia->ri_qplock);
>   	if (rc)
>   		goto out_err;
> @@ -150,6 +152,8 @@ fmr_op_map(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg,
>   	   int nsegs, bool writing)
>   {
>   	struct rpcrdma_ia *ia = &r_xprt->rx_ia;
> +	struct ib_device *device = ia->ri_id->device;
> +	enum dma_data_direction direction = rpcrdma_data_dir(writing);
>   	struct rpcrdma_mr_seg *seg1 = seg;
>   	struct rpcrdma_mw *mw;
>   	u64 physaddrs[RPCRDMA_MAX_DATA_SEGS];
> @@ -170,7 +174,7 @@ fmr_op_map(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg,
>   	if (nsegs > RPCRDMA_MAX_FMR_SGES)
>   		nsegs = RPCRDMA_MAX_FMR_SGES;
>   	for (i = 0; i < nsegs;) {
> -		rpcrdma_map_one(ia, seg, writing);
> +		rpcrdma_map_one(device, seg, direction);
>   		physaddrs[i] = seg->mr_dma;
>   		len += seg->mr_len;
>   		++seg;
> @@ -197,7 +201,7 @@ out_maperr:
>   		__func__, len, (unsigned long long)seg1->mr_dma,
>   		pageoff, i, rc);
>   	while (i--)
> -		rpcrdma_unmap_one(ia, --seg);
> +		rpcrdma_unmap_one(device, --seg);
>   	rpcrdma_put_mw(r_xprt, mw);
>   	return rc;
>   }
> diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
> index d23e064..4494668 100644
> --- a/net/sunrpc/xprtrdma/frwr_ops.c
> +++ b/net/sunrpc/xprtrdma/frwr_ops.c
> @@ -55,6 +55,7 @@ __frwr_unmap(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg)
>   	struct rpcrdma_mr_seg *seg1 = seg;
>   	struct rpcrdma_ia *ia = &r_xprt->rx_ia;
>   	struct rpcrdma_mw *mw = seg1->rl_mw;
> +	struct ib_device *device;
>   	struct ib_send_wr invalidate_wr, *bad_wr;
>   	int rc, nsegs = seg->mr_nsegs;
>
> @@ -67,8 +68,9 @@ __frwr_unmap(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg)
>   	DECR_CQCOUNT(&r_xprt->rx_ep);
>
>   	read_lock(&ia->ri_qplock);
> +	device = ia->ri_id->device;
>   	while (seg1->mr_nsegs--)
> -		rpcrdma_unmap_one(ia, seg++);
> +		rpcrdma_unmap_one(device, seg++);
>   	rc = ib_post_send(ia->ri_id->qp, &invalidate_wr, &bad_wr);
>   	read_unlock(&ia->ri_qplock);
>   	if (rc)
> @@ -323,6 +325,8 @@ frwr_op_map(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg,
>   	    int nsegs, bool writing)
>   {
>   	struct rpcrdma_ia *ia = &r_xprt->rx_ia;
> +	struct ib_device *device = ia->ri_id->device;
> +	enum dma_data_direction direction = rpcrdma_data_dir(writing);
>   	struct rpcrdma_mr_seg *seg1 = seg;
>   	struct rpcrdma_frmr *frmr;
>   	struct rpcrdma_mw *mw;
> @@ -351,7 +355,7 @@ frwr_op_map(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg,
>   		nsegs = ia->ri_max_frmr_depth;
>   	frmr = &mw->r.frmr;
>   	for (page_no = i = 0; i < nsegs;) {
> -		rpcrdma_map_one(ia, seg, writing);
> +		rpcrdma_map_one(device, seg, direction);
>   		pa = seg->mr_dma;
>   		for (seg_len = seg->mr_len; seg_len > 0; seg_len -= PAGE_SIZE) {
>   			frmr->fr_pgl->page_list[page_no++] = pa;
> @@ -409,7 +413,7 @@ out_senderr:
>   out_err:
>   	frmr->fr_state = FRMR_IS_INVALID;
>   	while (i--)
> -		rpcrdma_unmap_one(ia, --seg);
> +		rpcrdma_unmap_one(device, --seg);
>   	rpcrdma_put_mw(r_xprt, mw);
>   	return rc;
>   }
> diff --git a/net/sunrpc/xprtrdma/physical_ops.c b/net/sunrpc/xprtrdma/physical_ops.c
> index 0998f4f..9ce7dfc 100644
> --- a/net/sunrpc/xprtrdma/physical_ops.c
> +++ b/net/sunrpc/xprtrdma/physical_ops.c
> @@ -64,7 +64,8 @@ physical_op_map(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg,
>   {
>   	struct rpcrdma_ia *ia = &r_xprt->rx_ia;
>
> -	rpcrdma_map_one(ia, seg, writing);
> +	rpcrdma_map_one(ia->ri_id->device, seg,
> +			rpcrdma_data_dir(writing));
>   	seg->mr_rkey = ia->ri_bind_mem->rkey;
>   	seg->mr_base = seg->mr_dma;
>   	seg->mr_nsegs = 1;
> @@ -77,10 +78,14 @@ static void
>   physical_op_unmap(struct rpcrdma_xprt *r_xprt, struct rpcrdma_req *req,
>   		  unsigned int count)
>   {
> +	struct rpcrdma_ia *ia = &r_xprt->rx_ia;
>   	unsigned int i;
>
> -	for (i = 0; i < count; i++)
> -		rpcrdma_unmap_one(&r_xprt->rx_ia, &req->rl_segments[i]);
> +	for (i = 0; i < count; i++) {
> +		read_lock(&ia->ri_qplock);
> +		rpcrdma_unmap_one(ia->ri_id->device, &req->rl_segments[i]);
> +		read_unlock(&ia->ri_qplock);
> +	}
>   }
>
>   static void
> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
> index 21b63fe..460c917 100644
> --- a/net/sunrpc/xprtrdma/verbs.c
> +++ b/net/sunrpc/xprtrdma/verbs.c
> @@ -1288,6 +1288,14 @@ rpcrdma_recv_buffer_put(struct rpcrdma_rep *rep)
>    * Wrappers for internal-use kmalloc memory registration, used by buffer code.
>    */
>
> +void
> +rpcrdma_mapping_error(struct rpcrdma_mr_seg *seg)
> +{
> +	dprintk("RPC:       map_one: offset %p iova %llx len %zu\n",
> +		seg->mr_offset,
> +		(unsigned long long)seg->mr_dma, seg->mr_dmalen);
> +}
> +
>   static int
>   rpcrdma_register_internal(struct rpcrdma_ia *ia, void *va, int len,
>   				struct ib_mr **mrp, struct ib_sge *iov)
> @@ -1413,42 +1421,6 @@ rpcrdma_free_regbuf(struct rpcrdma_ia *ia, struct rpcrdma_regbuf *rb)
>   }
>
>   /*
> - * Wrappers for chunk registration, shared by read/write chunk code.
> - */
> -
> -void
> -rpcrdma_map_one(struct rpcrdma_ia *ia, struct rpcrdma_mr_seg *seg, bool writing)
> -{
> -	seg->mr_dir = writing ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
> -	seg->mr_dmalen = seg->mr_len;
> -	if (seg->mr_page)
> -		seg->mr_dma = ib_dma_map_page(ia->ri_id->device,
> -				seg->mr_page, offset_in_page(seg->mr_offset),
> -				seg->mr_dmalen, seg->mr_dir);
> -	else
> -		seg->mr_dma = ib_dma_map_single(ia->ri_id->device,
> -				seg->mr_offset,
> -				seg->mr_dmalen, seg->mr_dir);
> -	if (ib_dma_mapping_error(ia->ri_id->device, seg->mr_dma)) {
> -		dprintk("RPC:       %s: mr_dma %llx mr_offset %p mr_dma_len %zu\n",
> -			__func__,
> -			(unsigned long long)seg->mr_dma,
> -			seg->mr_offset, seg->mr_dmalen);
> -	}
> -}
> -
> -void
> -rpcrdma_unmap_one(struct rpcrdma_ia *ia, struct rpcrdma_mr_seg *seg)
> -{
> -	if (seg->mr_page)
> -		ib_dma_unmap_page(ia->ri_id->device,
> -				seg->mr_dma, seg->mr_dmalen, seg->mr_dir);
> -	else
> -		ib_dma_unmap_single(ia->ri_id->device,
> -				seg->mr_dma, seg->mr_dmalen, seg->mr_dir);
> -}
> -
> -/*
>    * Prepost any receive buffer, then post send.
>    *
>    * Receive buffer is donated to hardware, reclaimed upon recv completion.
> diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
> index b167e44..10c4fa5 100644
> --- a/net/sunrpc/xprtrdma/xprt_rdma.h
> +++ b/net/sunrpc/xprtrdma/xprt_rdma.h
> @@ -423,11 +423,52 @@ void rpcrdma_free_regbuf(struct rpcrdma_ia *,
>   			 struct rpcrdma_regbuf *);
>
>   unsigned int rpcrdma_max_segments(struct rpcrdma_xprt *);
> -void rpcrdma_map_one(struct rpcrdma_ia *, struct rpcrdma_mr_seg *, bool);
> -void rpcrdma_unmap_one(struct rpcrdma_ia *, struct rpcrdma_mr_seg *);
>   void rpcrdma_put_mw(struct rpcrdma_xprt *, struct rpcrdma_mw *);
>
>   /*
> + * Wrappers for chunk registration, shared by read/write chunk code.
> + */
> +
> +void rpcrdma_mapping_error(struct rpcrdma_mr_seg *);
> +
> +static inline enum dma_data_direction
> +rpcrdma_data_dir(bool writing)
> +{
> +	return writing ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
> +}
> +
> +static inline void
> +rpcrdma_map_one(struct ib_device *device, struct rpcrdma_mr_seg *seg,
> +		enum dma_data_direction direction)
> +{
> +	seg->mr_dir = direction;
> +	seg->mr_dmalen = seg->mr_len;
> +
> +	if (seg->mr_page)
> +		seg->mr_dma = ib_dma_map_page(device,
> +				seg->mr_page, offset_in_page(seg->mr_offset),
> +				seg->mr_dmalen, seg->mr_dir);
> +	else
> +		seg->mr_dma = ib_dma_map_single(device,
> +				seg->mr_offset,
> +				seg->mr_dmalen, seg->mr_dir);
> +
> +	if (ib_dma_mapping_error(device, seg->mr_dma))
> +		rpcrdma_mapping_error(seg);
> +}
> +
> +static inline void
> +rpcrdma_unmap_one(struct ib_device *device, struct rpcrdma_mr_seg *seg)
> +{
> +	if (seg->mr_page)
> +		ib_dma_unmap_page(device,
> +				  seg->mr_dma, seg->mr_dmalen, seg->mr_dir);
> +	else
> +		ib_dma_unmap_single(device,
> +				    seg->mr_dma, seg->mr_dmalen, seg->mr_dir);
> +}
> +
> +/*
>    * RPC/RDMA connection management calls - xprtrdma/rpc_rdma.c
>    */
>   void rpcrdma_connect_worker(struct work_struct *);
>

Looks good,

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
