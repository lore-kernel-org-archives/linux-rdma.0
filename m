From: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: Re: [PATCH 05/14] SIWv3: User Interface: siw_ae.c, siw_verbs.c, siw_user.h,
 siw_verbs.h
Date: Fri, 22 Jul 2011 13:56:29 -0500
Message-ID: <4E29C7DD.4050409@systemfabricworks.com>
References: <1311360458-15187-1-git-send-email-bmt@zurich.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1311360458-15187-1-git-send-email-bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 07/22/2011 01:47 PM, Bernard Metzler wrote:
> +int siw_post_receive(struct ib_qp *ofa_qp, struct ib_recv_wr *wr,
> +		     struct ib_recv_wr **bad_wr)
> +{
> +	struct siw_wqe	*wqe = NULL;
> +	struct siw_qp	*qp = siw_qp_ofa2siw(ofa_qp);
> +	unsigned long	flags;
> +	int rv = 0;
> +
> +	dprint(DBG_WR|DBG_TX, "(QP%d): state=%d\n", QP_ID(qp),
> +		qp->attrs.state);
> +
> +	if (qp->srq)
> +		return -EOPNOTSUPP; /* what else from errno.h? */

bad_wr is not set.

> +	/*
> +	 * Try to acquire QP state lock. Must be non-blocking
> +	 * to accommodate kernel clients needs.
> +	 */
> +	if (!down_read_trylock(&qp->state_lock)) {
> +		*bad_wr = wr;
> +		return -ENOTCONN;
> +	}
> +
> +	if (qp->attrs.state > SIW_QP_STATE_RTS) {
> +		up_read(&qp->state_lock);
> +		dprint(DBG_ON, " (QP%d): state=%d\n", QP_ID(qp),
> +			qp->attrs.state);
> +		return -EINVAL;

ditto.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
