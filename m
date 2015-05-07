From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 09/14] xprtrdma: Remove unused LOCAL_INV recovery logic
Date: Thu, 07 May 2015 13:35:38 +0300
Message-ID: <554B3FFA.5020101@dev.mellanox.co.il>
References: <20150504174626.3483.97639.stgit@manet.1015granger.net> <20150504175808.3483.57643.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150504175808.3483.57643.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/4/2015 8:58 PM, Chuck Lever wrote:
> Clean up: Remove functions no longer used to recover broken FRMRs.
>
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>   net/sunrpc/xprtrdma/verbs.c |  109 -------------------------------------------
>   1 file changed, 109 deletions(-)
>
> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
> index 5226161..5120a8e 100644
> --- a/net/sunrpc/xprtrdma/verbs.c
> +++ b/net/sunrpc/xprtrdma/verbs.c
> @@ -1210,33 +1210,6 @@ rpcrdma_put_mw(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mw *mw)
>   	spin_unlock_irqrestore(&buf->rb_lock, flags);
>   }
>
> -/* "*mw" can be NULL when rpcrdma_buffer_get_mrs() fails, leaving
> - * some req segments uninitialized.
> - */
> -static void
> -rpcrdma_buffer_put_mr(struct rpcrdma_mw **mw, struct rpcrdma_buffer *buf)
> -{
> -	if (*mw) {
> -		list_add_tail(&(*mw)->mw_list, &buf->rb_mws);
> -		*mw = NULL;
> -	}
> -}
> -
> -/* Cycle mw's back in reverse order, and "spin" them.
> - * This delays and scrambles reuse as much as possible.
> - */
> -static void
> -rpcrdma_buffer_put_mrs(struct rpcrdma_req *req, struct rpcrdma_buffer *buf)
> -{
> -	struct rpcrdma_mr_seg *seg = req->rl_segments;
> -	struct rpcrdma_mr_seg *seg1 = seg;
> -	int i;
> -
> -	for (i = 1, seg++; i < RPCRDMA_MAX_SEGS; seg++, i++)
> -		rpcrdma_buffer_put_mr(&seg->rl_mw, buf);
> -	rpcrdma_buffer_put_mr(&seg1->rl_mw, buf);
> -}
> -
>   static void
>   rpcrdma_buffer_put_sendbuf(struct rpcrdma_req *req, struct rpcrdma_buffer *buf)
>   {
> @@ -1249,88 +1222,6 @@ rpcrdma_buffer_put_sendbuf(struct rpcrdma_req *req, struct rpcrdma_buffer *buf)
>   	}
>   }
>
> -/* rpcrdma_unmap_one() was already done during deregistration.
> - * Redo only the ib_post_send().
> - */
> -static void
> -rpcrdma_retry_local_inv(struct rpcrdma_mw *r, struct rpcrdma_ia *ia)
> -{
> -	struct rpcrdma_xprt *r_xprt =
> -				container_of(ia, struct rpcrdma_xprt, rx_ia);
> -	struct ib_send_wr invalidate_wr, *bad_wr;
> -	int rc;
> -
> -	dprintk("RPC:       %s: FRMR %p is stale\n", __func__, r);
> -
> -	/* When this FRMR is re-inserted into rb_mws, it is no longer stale */
> -	r->r.frmr.fr_state = FRMR_IS_INVALID;
> -
> -	memset(&invalidate_wr, 0, sizeof(invalidate_wr));
> -	invalidate_wr.wr_id = (unsigned long)(void *)r;
> -	invalidate_wr.opcode = IB_WR_LOCAL_INV;
> -	invalidate_wr.ex.invalidate_rkey = r->r.frmr.fr_mr->rkey;
> -	DECR_CQCOUNT(&r_xprt->rx_ep);
> -
> -	dprintk("RPC:       %s: frmr %p invalidating rkey %08x\n",
> -		__func__, r, r->r.frmr.fr_mr->rkey);
> -
> -	read_lock(&ia->ri_qplock);
> -	rc = ib_post_send(ia->ri_id->qp, &invalidate_wr, &bad_wr);
> -	read_unlock(&ia->ri_qplock);
> -	if (rc) {
> -		/* Force rpcrdma_buffer_get() to retry */
> -		r->r.frmr.fr_state = FRMR_IS_STALE;
> -		dprintk("RPC:       %s: ib_post_send failed, %i\n",
> -			__func__, rc);
> -	}
> -}
> -
> -static void
> -rpcrdma_retry_flushed_linv(struct list_head *stale,
> -			   struct rpcrdma_buffer *buf)
> -{
> -	struct rpcrdma_ia *ia = rdmab_to_ia(buf);
> -	struct list_head *pos;
> -	struct rpcrdma_mw *r;
> -	unsigned long flags;
> -
> -	list_for_each(pos, stale) {
> -		r = list_entry(pos, struct rpcrdma_mw, mw_list);
> -		rpcrdma_retry_local_inv(r, ia);
> -	}
> -
> -	spin_lock_irqsave(&buf->rb_lock, flags);
> -	list_splice_tail(stale, &buf->rb_mws);
> -	spin_unlock_irqrestore(&buf->rb_lock, flags);
> -}
> -
> -static struct rpcrdma_req *
> -rpcrdma_buffer_get_frmrs(struct rpcrdma_req *req, struct rpcrdma_buffer *buf,
> -			 struct list_head *stale)
> -{
> -	struct rpcrdma_mw *r;
> -	int i;
> -
> -	i = RPCRDMA_MAX_SEGS - 1;
> -	while (!list_empty(&buf->rb_mws)) {
> -		r = list_entry(buf->rb_mws.next,
> -			       struct rpcrdma_mw, mw_list);
> -		list_del(&r->mw_list);
> -		if (r->r.frmr.fr_state == FRMR_IS_STALE) {
> -			list_add(&r->mw_list, stale);
> -			continue;
> -		}
> -		req->rl_segments[i].rl_mw = r;
> -		if (unlikely(i-- == 0))
> -			return req;	/* Success */
> -	}
> -
> -	/* Not enough entries on rb_mws for this req */
> -	rpcrdma_buffer_put_sendbuf(req, buf);
> -	rpcrdma_buffer_put_mrs(req, buf);
> -	return NULL;
> -}
> -
>   /*
>    * Get a set of request/reply buffers.
>    *
>

Looks good,

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
