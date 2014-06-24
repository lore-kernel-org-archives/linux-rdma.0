From: Anna Schumaker <schumaker.anna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 08/13] xprtrdma: Back off rkey when FAST_REG_MR fails
Date: Tue, 24 Jun 2014 11:47:50 -0400
Message-ID: <53A99DA6.90808@gmail.com>
References: <20140623223201.1634.83888.stgit@manet.1015granger.net> <20140623224007.1634.55636.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140623224007.1634.55636.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 06/23/2014 06:40 PM, Chuck Lever wrote:
> If posting a FAST_REG_MR Work Reqeust fails, or the FAST_REG WR
> flushes, revert the rkey update to avoid subsequent
> IB_WC_MW_BIND_ERR completions.
>
> Suggested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  net/sunrpc/xprtrdma/verbs.c |   39 +++++++++++++++++++++++++++++----------
>  1 file changed, 29 insertions(+), 10 deletions(-)
>
> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
> index cef67fd..3efc007 100644
> --- a/net/sunrpc/xprtrdma/verbs.c
> +++ b/net/sunrpc/xprtrdma/verbs.c
> @@ -61,6 +61,8 @@
>  # define RPCDBG_FACILITY	RPCDBG_TRANS
>  #endif
>  
> +static void rpcrdma_decrement_frmr_rkey(struct rpcrdma_mw *);
> +
>  /*
>   * internal functions
>   */
> @@ -154,13 +156,17 @@ rpcrdma_sendcq_process_wc(struct ib_wc *wc)
>  
>  	if (wrid == 0)
>  		return;
> -	if (wc->status != IB_WC_SUCCESS)
> -		return;
>  
>  	fastreg = test_and_clear_bit(RPCRDMA_BIT_FASTREG, &wrid);
>  	mw = (struct rpcrdma_mw *)wrid;
>  
> -	mw->r.frmr.fr_state = fastreg ? FRMR_IS_VALID : FRMR_IS_INVALID;
> +	if (wc->status == IB_WC_SUCCESS) {
> +		mw->r.frmr.fr_state = fastreg ?
> +				FRMR_IS_VALID : FRMR_IS_INVALID;
> +	} else {
> +		if (fastreg)
> +			rpcrdma_decrement_frmr_rkey(mw);

Isn't this the same as "else if (fastreg)"?

Anna

> +	}
>  }
>  
>  static int
> @@ -1480,6 +1486,24 @@ rpcrdma_unmap_one(struct rpcrdma_ia *ia, struct rpcrdma_mr_seg *seg)
>  				seg->mr_dma, seg->mr_dmalen, seg->mr_dir);
>  }
>  
> +static void
> +rpcrdma_increment_frmr_rkey(struct rpcrdma_mw *mw)
> +{
> +	struct ib_mr *frmr = mw->r.frmr.fr_mr;
> +	u8 key = frmr->rkey & 0x000000FF;
> +
> +	ib_update_fast_reg_key(frmr, ++key);
> +}
> +
> +static void
> +rpcrdma_decrement_frmr_rkey(struct rpcrdma_mw *mw)
> +{
> +	struct ib_mr *frmr = mw->r.frmr.fr_mr;
> +	u8 key = frmr->rkey & 0x000000FF;
> +
> +	ib_update_fast_reg_key(frmr, --key);
> +}
> +
>  static int
>  rpcrdma_register_frmr_external(struct rpcrdma_mr_seg *seg,
>  			int *nsegs, int writing, struct rpcrdma_ia *ia,
> @@ -1487,8 +1511,6 @@ rpcrdma_register_frmr_external(struct rpcrdma_mr_seg *seg,
>  {
>  	struct rpcrdma_mr_seg *seg1 = seg;
>  	struct ib_send_wr invalidate_wr, frmr_wr, *bad_wr, *post_wr;
> -
> -	u8 key;
>  	int len, pageoff;
>  	int i, rc;
>  	int seg_len;
> @@ -1552,14 +1574,10 @@ rpcrdma_register_frmr_external(struct rpcrdma_mr_seg *seg,
>  		rc = -EIO;
>  		goto out_err;
>  	}
> -
> -	/* Bump the key */
> -	key = (u8)(seg1->mr_chunk.rl_mw->r.frmr.fr_mr->rkey & 0x000000FF);
> -	ib_update_fast_reg_key(seg1->mr_chunk.rl_mw->r.frmr.fr_mr, ++key);
> -
>  	frmr_wr.wr.fast_reg.access_flags = (writing ?
>  				IB_ACCESS_REMOTE_WRITE | IB_ACCESS_LOCAL_WRITE :
>  				IB_ACCESS_REMOTE_READ);
> +	rpcrdma_increment_frmr_rkey(seg1->mr_chunk.rl_mw);
>  	frmr_wr.wr.fast_reg.rkey = seg1->mr_chunk.rl_mw->r.frmr.fr_mr->rkey;
>  	DECR_CQCOUNT(&r_xprt->rx_ep);
>  
> @@ -1568,6 +1586,7 @@ rpcrdma_register_frmr_external(struct rpcrdma_mr_seg *seg,
>  	if (rc) {
>  		dprintk("RPC:       %s: failed ib_post_send for register,"
>  			" status %i\n", __func__, rc);
> +		rpcrdma_decrement_frmr_rkey(seg1->mr_chunk.rl_mw);
>  		goto out_err;
>  	} else {
>  		seg1->mr_rkey = seg1->mr_chunk.rl_mw->r.frmr.fr_mr->rkey;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
