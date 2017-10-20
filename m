From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 05/13] SoftiWarp application interface
Date: Fri, 20 Oct 2017 08:30:13 -0500
Message-ID: <20171020133013.GC11604@ssaleem-MOBL4.amr.corp.intel.com>
References: <20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171006122853.16310-6-bmt@zurich.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171006122853.16310-6-bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 06, 2017 at 08:28:45AM -0400, Bernard Metzler wrote:
> Signed-off-by: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
> ---
>  drivers/infiniband/sw/siw/siw_ae.c    |  113 ++
>  drivers/infiniband/sw/siw/siw_verbs.c | 1929 +++++++++++++++++++++++++++++++++
>  drivers/infiniband/sw/siw/siw_verbs.h |  119 ++
>  include/uapi/rdma/siw_user.h          |  220 ++++
>  4 files changed, 2381 insertions(+)
>  create mode 100644 drivers/infiniband/sw/siw/siw_ae.c
>  create mode 100644 drivers/infiniband/sw/siw/siw_verbs.c
>  create mode 100644 drivers/infiniband/sw/siw/siw_verbs.h
>  create mode 100644 include/uapi/rdma/siw_user.h
> 

> + *
> + * Post a list of S-WR's to a SQ.
> + *
> + * @ofa_qp:	OFA QP contained in siw QP
> + * @wr:		Null terminated list of user WR's
> + * @bad_wr:	Points to failing WR in case of synchronous failure.
> + */
> +int siw_post_send(struct ib_qp *ofa_qp, struct ib_send_wr *wr,
> +		  struct ib_send_wr **bad_wr)
> +{
> +	struct siw_qp	*qp = siw_qp_ofa2siw(ofa_qp);
> +	struct siw_wqe	*wqe = tx_wqe(qp);
> +
> +	unsigned long flags;
> +	int rv = 0;
> +
> +	dprint(DBG_WR|DBG_TX, "(QP%d): state=%d\n",
> +		QP_ID(qp), qp->attrs.state);
> +
> +	/*
> +	 * Try to acquire QP state lock. Must be non-blocking
> +	 * to accommodate kernel clients needs.
> +	 */
> +	if (!down_read_trylock(&qp->state_lock)) {
> +		*bad_wr = wr;
> +		return -ENOTCONN;
> +	}
> +
> +	if (unlikely(qp->attrs.state != SIW_QP_STATE_RTS)) {
> +		dprint(DBG_WR, "(QP%d): state=%d\n",
> +			QP_ID(qp), qp->attrs.state);
> +		up_read(&qp->state_lock);
> +		*bad_wr = wr;
> +		return -ENOTCONN;
> +	}
> +	if (wr && qp->kernel_verbs == 0) {
Can qp->kernel_verbs ever be 0? Isnt this post_send for kernel QPs only?

> +		dprint(DBG_WR|DBG_ON, "(QP%d): user mapped SQ with OFA WR\n",
> +			QP_ID(qp));
> +		up_read(&qp->state_lock);
> +		*bad_wr = wr;
> +		return -EINVAL;
> +	}
> +
> +	spin_lock_irqsave(&qp->sq_lock, flags);
> +
> +	while (wr) {
> +		u32 idx = qp->sq_put % qp->attrs.sq_size;
> +		struct siw_sqe *sqe = &qp->sendq[idx];
> +
> +		if (sqe->flags) {
> +			dprint(DBG_WR, "(QP%d): SQ full\n", QP_ID(qp));
> +			rv = -ENOMEM;
> +			break;
> +		}
> +		if (wr->num_sge > qp->attrs.sq_max_sges) {
> +			/*
> +			 * NOTE: we allow for zero length wr's here.
> +			 */
> +			dprint(DBG_WR, "(QP%d): Num SGE: %d\n",
> +				QP_ID(qp), wr->num_sge);
> +			rv = -EINVAL;
> +			break;
> +		}
> +		sqe->id = wr->wr_id;
> +		sqe->flags = 0;
sqe->flags will always be 0 if we reached to this point in code no? Since we break out of the loop if sqe->flags != 0.




> +
> +	if (qp->kernel_verbs)
> +		siw_sq_start(qp);
ditto. Is this check neccessary?


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
