From: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: Fwd: Re: [PATCH 6/9] ocrdma: Driver for Emulex OneConnect RDMA adapter
Date: Wed, 21 Mar 2012 13:03:31 -0500
Message-ID: <4F6A17F3.8010008@systemfabricworks.com>
References: <4F6A114A.3070802@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F6A114A.3070802-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


(Resent becasue the first one got lost)

On 03/20/2012 05:39 PM, parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org wrote:
> +
> +int ocrdma_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
> +		     struct ib_send_wr **bad_wr)
> +{
> +	int status = 0;
> +	struct ocrdma_qp *qp = get_ocrdma_qp(ibqp);
> +	struct ocrdma_hdr_wqe *hdr;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&qp->q_lock, flags);
> +	if (qp->state != OCRDMA_QPS_RTS && qp->state != OCRDMA_QPS_SQD) {
> +		spin_unlock_irqrestore(&qp->q_lock, flags);
> +		return -EINVAL;
> +	}

There, and in several places in this function, you return an error
without setting bad_wr.

Frank.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
