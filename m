From: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 08/21] xprtrdma: Back off rkey when FAST_REG_MR fails
Date: Tue, 22 Jul 2014 16:03:01 -0400
Message-ID: <53CEC375.3010408@netapp.com>
References: <20140722144459.6010.99389.stgit@manet.1015granger.net> <20140722145208.6010.76678.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140722145208.6010.76678.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 07/22/2014 10:52 AM, Chuck Lever wrote:
> If posting a FAST_REG_MR Work Reqeust fails, revert the rkey update
> to avoid subsequent IB_WC_MW_BIND_ERR completions.
> 
> Suggested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Tested-by: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Tested-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
> ---
>  include/rdma/ib_verbs.h     |   11 +++++++++++
>  net/sunrpc/xprtrdma/verbs.c |   12 +++++-------
>  2 files changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 7ccef34..c5c7ec6 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -2479,6 +2479,17 @@ static inline u32 ib_inc_rkey(u32 rkey)
>  }
>  
>  /**
> + * ib_dec_rkey - decrements the key portion of the given rkey. Can be used
> + * when recovering from a local immediate error.
> + * @rkey - the rkey to decrement.
> + */
> +static inline u32 ib_dec_rkey(u32 rkey)
> +{
> +	const u32 mask = 0x000000ff;
> +	return ((rkey - 1) & mask) | (rkey & ~mask);

ib_inc_rkey() uses the same mask, and ib_update_fast_reg_key() uses !mask.  I think this should be a #define constant, rather than hardcoded in four places.

Anna


> +}
> +
> +/**
>   * ib_alloc_mw - Allocates a memory window.
>   * @pd: The protection domain associated with the memory window.
>   * @type: The type of the memory window (1 or 2).
> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
> index 8bb7945..394b13f 100644
> --- a/net/sunrpc/xprtrdma/verbs.c
> +++ b/net/sunrpc/xprtrdma/verbs.c
> @@ -1497,13 +1497,12 @@ rpcrdma_register_frmr_external(struct rpcrdma_mr_seg *seg,
>  	struct rpcrdma_frmr *frmr = &mw->r.frmr;
>  	struct ib_mr *mr = frmr->fr_mr;
>  	struct ib_send_wr invalidate_wr, frmr_wr, *bad_wr, *post_wr;
> -
> -	u8 key;
>  	int len, pageoff;
>  	int i, rc;
>  	int seg_len;
>  	u64 pa;
>  	int page_no;
> +	u32 rkey;
>  
>  	pageoff = offset_in_page(seg1->mr_offset);
>  	seg1->mr_offset -= pageoff;	/* start of page */
> @@ -1558,14 +1557,11 @@ rpcrdma_register_frmr_external(struct rpcrdma_mr_seg *seg,
>  		rc = -EIO;
>  		goto out_err;
>  	}
> -
> -	/* Bump the key */
> -	key = (u8)(mr->rkey & 0x000000FF);
> -	ib_update_fast_reg_key(mr, ++key);
> -
>  	frmr_wr.wr.fast_reg.access_flags = (writing ?
>  				IB_ACCESS_REMOTE_WRITE | IB_ACCESS_LOCAL_WRITE :
>  				IB_ACCESS_REMOTE_READ);
> +	rkey = ib_inc_rkey(mr->rkey);
> +	ib_update_fast_reg_key(mr, rkey);
>  	frmr_wr.wr.fast_reg.rkey = mr->rkey;
>  	DECR_CQCOUNT(&r_xprt->rx_ep);
>  
> @@ -1574,6 +1570,8 @@ rpcrdma_register_frmr_external(struct rpcrdma_mr_seg *seg,
>  	if (rc) {
>  		dprintk("RPC:       %s: failed ib_post_send for register,"
>  			" status %i\n", __func__, rc);
> +		rkey = ib_dec_rkey(mr->rkey);
> +		ib_update_fast_reg_key(mr, rkey);
>  		goto out_err;
>  	} else {
>  		seg1->mr_rkey = mr->rkey;
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
