From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v3 2/2] libmlx4: Add support for XRC QPs
Date: Fri, 28 Sep 2012 22:57:50 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A98244@FMSMSX151.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A981DE@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A981DE-Q3cL8pyY+6ukrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "miked-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <miked-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Tzahi Oved (tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> diff --git a/src/cq.c b/src/cq.c
> index 8f7a8cc..20ce1f1 100644
> --- a/src/cq.c
> +++ b/src/cq.c
> @@ -220,33 +220,43 @@ static int mlx4_poll_one(struct mlx4_cq *cq,
>  	rmb();
> 
>  	qpn = ntohl(cqe->vlan_my_qpn) & MLX4_CQE_QPN_MASK;
> +	wc->qp_num = qpn;
> 
>  	is_send  = cqe->owner_sr_opcode & MLX4_CQE_IS_SEND_MASK;
>  	is_error = (cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) ==
>  		MLX4_CQE_OPCODE_ERROR;
> 
> -	if (!*cur_qp ||
> -	    (qpn != (*cur_qp)->ibv_qp.qp_num)) {
> +	if ((qpn & MLX4_XRC_QPN_BIT) && !is_send) {
>  		/*
> -		 * We do not have to take the QP table lock here,
> -		 * because CQs will be locked while QPs are removed
> +		 * We do not have to take the XSRQ table lock here,
> +		 * because CQs will be locked while SRQs are removed
>  		 * from the table.
>  		 */
> -		*cur_qp = mlx4_find_qp(to_mctx(cq->ibv_cq.context), qpn);
> -		if (!*cur_qp)
> +		srq = mlx4_find_xsrq(&to_mctx(cq->ibv_cq.context)->xsrq_table,
> +				     ntohl(cqe->g_mlpath_rqpn) & MLX4_CQE_QPN_MASK);
> +		if (!srq)
>  			return CQ_POLL_ERR;
> +	} else {
> +		if (!*cur_qp || (qpn != (*cur_qp)->verbs_qp.qp.qp_num)) {
> +			/*
> +		 	 * We do not have to take the QP table lock here,
> +			 * because CQs will be locked while QPs are removed
> +		 	 * from the table.
> +			 */
> +			*cur_qp = mlx4_find_qp(to_mctx(cq->ibv_cq.context), qpn);
> +			if (!*cur_qp)
> +				return CQ_POLL_ERR;
> +		}
> +		srq = ((*cur_qp)->verbs_qp.qp.srq) ? to_msrq((*cur_qp)-
> >verbs_qp.qp.srq) : NULL;
>  	}
> 
> -	wc->qp_num = (*cur_qp)->ibv_qp.qp_num;
> -
>  	if (is_send) {
>  		wq = &(*cur_qp)->sq;
>  		wqe_index = ntohs(cqe->wqe_index);
>  		wq->tail += (uint16_t) (wqe_index - (uint16_t) wq->tail);
>  		wc->wr_id = wq->wrid[wq->tail & (wq->wqe_cnt - 1)];
>  		++wq->tail;
> -	} else if ((*cur_qp)->ibv_qp.srq) {
> -		srq = to_msrq((*cur_qp)->ibv_qp.srq);
> +	} else if (srq) {
>  		wqe_index = htons(cqe->wqe_index);
>  		wc->wr_id = srq->wrid[wqe_index];
>  		mlx4_free_srq_wqe(srq, wqe_index);
> @@ -322,7 +332,8 @@ static int mlx4_poll_one(struct mlx4_cq *cq,
>  		wc->dlid_path_bits = (g_mlpath_rqpn >> 24) & 0x7f;
>  		wc->wc_flags	  |= g_mlpath_rqpn & 0x80000000 ? IBV_WC_GRH : 0;
>  		wc->pkey_index     = ntohl(cqe->immed_rss_invalid) & 0x7f;
> -		if ((*cur_qp)->link_layer == IBV_LINK_LAYER_ETHERNET)
> +		/* HACK */
> +		if ((*cur_qp) && (*cur_qp)->link_layer == IBV_LINK_LAYER_ETHERNET)
>  			wc->sl	   = ntohs(cqe->sl_vid) >> 13;
>  		else
>  			wc->sl	   = ntohs(cqe->sl_vid) >> 12;

Can someone from Mellanox see what this code should be?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
