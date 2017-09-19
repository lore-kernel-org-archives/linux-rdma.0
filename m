From: Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc] IB/bnxt_re: Fix frame stack compilation warning
Date: Tue, 19 Sep 2017 14:24:19 -0400
Message-ID: <b73b905c-baa2-0cb6-bccc-5f259ccedc48@redhat.com>
References: <20170919102213.30911-1-leon@kernel.org>
Reply-To: jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170919102213.30911-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/19/2017 06:22 AM, Leon Romanovsky wrote:
> Reduce stack size by dynamically allocating memory instead
> of declaring large struct on the stack:
> 
> drivers/infiniband/hw/bnxt_re/ib_verbs.c: In function ‘bnxt_re_query_qp’:
> drivers/infiniband/hw/bnxt_re/ib_verbs.c:1600:1: warning: the frame size of 1216 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>  }
>  ^
> 
> Cc: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 67 +++++++++++++++++---------------
>  1 file changed, 36 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> index 01eee15bbd65..03caf48af8e2 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> @@ -1551,43 +1551,46 @@ int bnxt_re_query_qp(struct ib_qp *ib_qp, struct ib_qp_attr *qp_attr,
>  {
>  	struct bnxt_re_qp *qp = container_of(ib_qp, struct bnxt_re_qp, ib_qp);
>  	struct bnxt_re_dev *rdev = qp->rdev;
> -	struct bnxt_qplib_qp qplib_qp;
> +	struct bnxt_qplib_qp *qplib_qp;
>  	int rc;
> 
> -	memset(&qplib_qp, 0, sizeof(struct bnxt_qplib_qp));
> -	qplib_qp.id = qp->qplib_qp.id;
> -	qplib_qp.ah.host_sgid_index = qp->qplib_qp.ah.host_sgid_index;
> +	qplib_qp = kzalloc(sizeof(*qplib_qp), GFP_KERNEL);
                                                ^^^^
Can this process block? Further down in the code I see a call to kzalloc
and they specifically use GFP_ATOMIC.

    bnxt_qplib_query_qp() ->
        bnxt_qplib_rcfw_alloc_sbuf()

Looking through the rest of the function and what it calls I am thinking
this function is assumed to not block so I think GFP_ATOMIC should be
used here.

> +	if (!qplib_qp)
> +		return -ENOMEM;
> +
> +	qplib_qp->id = qp->qplib_qp.id;
> +	qplib_qp->ah.host_sgid_index = qp->qplib_qp.ah.host_sgid_index;
> 
> -	rc = bnxt_qplib_query_qp(&rdev->qplib_res, &qplib_qp);
> +	rc = bnxt_qplib_query_qp(&rdev->qplib_res, qplib_qp);
>  	if (rc) {
>  		dev_err(rdev_to_dev(rdev), "Failed to query HW QP");
> -		return rc;
> +		goto out;
>  	}
> -	qp_attr->qp_state = __to_ib_qp_state(qplib_qp.state);
> -	qp_attr->en_sqd_async_notify = qplib_qp.en_sqd_async_notify ? 1 : 0;
> -	qp_attr->qp_access_flags = __to_ib_access_flags(qplib_qp.access);
> -	qp_attr->pkey_index = qplib_qp.pkey_index;
> -	qp_attr->qkey = qplib_qp.qkey;
> +	qp_attr->qp_state = __to_ib_qp_state(qplib_qp->state);
> +	qp_attr->en_sqd_async_notify = qplib_qp->en_sqd_async_notify ? 1 : 0;
> +	qp_attr->qp_access_flags = __to_ib_access_flags(qplib_qp->access);
> +	qp_attr->pkey_index = qplib_qp->pkey_index;
> +	qp_attr->qkey = qplib_qp->qkey;
>  	qp_attr->ah_attr.type = RDMA_AH_ATTR_TYPE_ROCE;
> -	rdma_ah_set_grh(&qp_attr->ah_attr, NULL, qplib_qp.ah.flow_label,
> -			qplib_qp.ah.host_sgid_index,
> -			qplib_qp.ah.hop_limit,
> -			qplib_qp.ah.traffic_class);
> -	rdma_ah_set_dgid_raw(&qp_attr->ah_attr, qplib_qp.ah.dgid.data);
> -	rdma_ah_set_sl(&qp_attr->ah_attr, qplib_qp.ah.sl);
> -	ether_addr_copy(qp_attr->ah_attr.roce.dmac, qplib_qp.ah.dmac);
> -	qp_attr->path_mtu = __to_ib_mtu(qplib_qp.path_mtu);
> -	qp_attr->timeout = qplib_qp.timeout;
> -	qp_attr->retry_cnt = qplib_qp.retry_cnt;
> -	qp_attr->rnr_retry = qplib_qp.rnr_retry;
> -	qp_attr->min_rnr_timer = qplib_qp.min_rnr_timer;
> -	qp_attr->rq_psn = qplib_qp.rq.psn;
> -	qp_attr->max_rd_atomic = qplib_qp.max_rd_atomic;
> -	qp_attr->sq_psn = qplib_qp.sq.psn;
> -	qp_attr->max_dest_rd_atomic = qplib_qp.max_dest_rd_atomic;
> -	qp_init_attr->sq_sig_type = qplib_qp.sig_type ? IB_SIGNAL_ALL_WR :
> -							IB_SIGNAL_REQ_WR;
> -	qp_attr->dest_qp_num = qplib_qp.dest_qpn;
> +	rdma_ah_set_grh(&qp_attr->ah_attr, NULL, qplib_qp->ah.flow_label,
> +			qplib_qp->ah.host_sgid_index,
> +			qplib_qp->ah.hop_limit,
> +			qplib_qp->ah.traffic_class);
> +	rdma_ah_set_dgid_raw(&qp_attr->ah_attr, qplib_qp->ah.dgid.data);
> +	rdma_ah_set_sl(&qp_attr->ah_attr, qplib_qp->ah.sl);
> +	ether_addr_copy(qp_attr->ah_attr.roce.dmac, qplib_qp->ah.dmac);
> +	qp_attr->path_mtu = __to_ib_mtu(qplib_qp->path_mtu);
> +	qp_attr->timeout = qplib_qp->timeout;
> +	qp_attr->retry_cnt = qplib_qp->retry_cnt;
> +	qp_attr->rnr_retry = qplib_qp->rnr_retry;
> +	qp_attr->min_rnr_timer = qplib_qp->min_rnr_timer;
> +	qp_attr->rq_psn = qplib_qp->rq.psn;
> +	qp_attr->max_rd_atomic = qplib_qp->max_rd_atomic;
> +	qp_attr->sq_psn = qplib_qp->sq.psn;
> +	qp_attr->max_dest_rd_atomic = qplib_qp->max_dest_rd_atomic;
> +	qp_init_attr->sq_sig_type = qplib_qp->sig_type ? IB_SIGNAL_ALL_WR :
> +							 IB_SIGNAL_REQ_WR;
> +	qp_attr->dest_qp_num = qplib_qp->dest_qpn;
> 
>  	qp_attr->cap.max_send_wr = qp->qplib_qp.sq.max_wqe;
>  	qp_attr->cap.max_send_sge = qp->qplib_qp.sq.max_sge;
> @@ -1596,7 +1599,9 @@ int bnxt_re_query_qp(struct ib_qp *ib_qp, struct ib_qp_attr *qp_attr,
>  	qp_attr->cap.max_inline_data = qp->qplib_qp.max_inline_data;
>  	qp_init_attr->cap = qp_attr->cap;
> 
> -	return 0;
> +out:
> +	kfree(qplib_qp);
> +	return rc;
>  }
> 
>  /* Routine for sending QP1 packets for RoCE V1 an V2
> --
> 2.14.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
