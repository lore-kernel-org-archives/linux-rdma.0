From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 for-next 3/4] IB/core: Make sure that the PSN does not
 overflow
Date: Thu, 29 Jan 2015 10:54:37 -0700
Message-ID: <20150129175437.GF11842@obsidianresearch.com>
References: <1422522871-11216-1-git-send-email-ogerlitz@mellanox.com>
 <1422522871-11216-4-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1422522871-11216-4-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 29, 2015 at 11:14:30AM +0200, Or Gerlitz wrote:
> From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> The rq/sq->psn is 24 bits as defined in the IB spec, therefore ULPs and User
> space applications shouldn't use the 8 most significant bits in the 32 bits
> variables to avoid overflow in modify_qp.
> 
> Fixed the PSN usage for kernel ULPs and masked out the 8 most significant bits
> for User-space applications.
> 
> From now on, we check in ib_modify_qp_is_ok that the PSN doesn't overflow, and
> we fail if so.

So, I guess the actual problem here is this:

        get_random_bytes(&id_priv->seq_num, sizeof id_priv->seq_num);

?

So what we need is

        get_random_bytes(&id_priv->seq_num, sizeof id_priv->seq_num);
+       id_priv->seq_num &= 0xffffff;

>  		if (qp_attr->qp_state == IB_QPS_RTR)
> -			qp_attr->rq_psn = id_priv->seq_num;
> +			qp_attr->rq_psn = id_priv->seq_num & 0xffffff;

All this duplicitive masking should be centralized at the seq_num
assignment, not sprinkled

>  int ib_modify_qp_is_ok(enum ib_qp_state cur_state, enum ib_qp_state next_state,
> -		       enum ib_qp_type type, enum ib_qp_attr_mask mask,
> -		       enum rdma_link_layer ll)
> +		       enum ib_qp_type type, struct ib_qp_attr *attr,
> +		       enum ib_qp_attr_mask mask, enum rdma_link_layer ll)
>  {
>  	enum ib_qp_attr_mask req_param, opt_param;
>  
> @@ -860,6 +860,12 @@ int ib_modify_qp_is_ok(enum ib_qp_state cur_state, enum ib_qp_state next_state,
>  	if (mask & ~(req_param | opt_param | IB_QP_STATE))
>  		return 0;
>  
> +	if ((mask & IB_QP_SQ_PSN) && (attr->sq_psn & 0xff000000))
> +		return 0;
> +
> +	if ((mask & IB_QP_RQ_PSN) && (attr->rq_psn & 0xff000000))
> +		return 0;
> +

And since rdmacm has had this longstanding bug of generating > 24 bit
PSNs, this change seems really scary - very likely to break working
systems.

I think we'd be better off keeping the current behavior of masking
the PSN, not enforcing the limit.

> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> index 56959ad..bdf35b0 100644
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> @@ -294,7 +294,7 @@ static int ipoib_cm_modify_rx_qp(struct net_device *dev,
>  		ipoib_warn(priv, "failed to init QP attr for RTR: %d\n", ret);
>  		return ret;
>  	}
> -	qp_attr.rq_psn = psn;
> +	qp_attr.rq_psn = psn & 0xffffff;
>  	ret = ib_modify_qp(qp, &qp_attr, qp_attr_mask);

Please don't just sed/grep stuff without review. It was trivial for me
to find that this is unneeded:

        psn = prandom_u32() & 0xffffff;
        ret = ipoib_cm_modify_rx_qp(dev, cm_id, p->qp, psn);

> @@ -433,7 +433,7 @@ static int ipoib_cm_send_rep(struct net_device *dev, struct ib_cm_id *cm_id,
>  	rep.rnr_retry_count = req->rnr_retry_count;
>  	rep.srq = ipoib_cm_has_srq(dev);
>  	rep.qp_num = qp->qp_num;
> -	rep.starting_psn = psn;
> +	rep.starting_psn = psn & 0xffffff;

ditto:

        psn = prandom_u32() & 0xffffff;
[..]
        ret = ipoib_cm_send_rep(dev, cm_id, p->qp, &event->param.req_rcvd, psn);

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
