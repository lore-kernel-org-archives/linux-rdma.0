From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v4 9/9] IB/srpt: convert to the generic RDMA READ/WRITE
 API
Date: Thu, 10 Mar 2016 14:40:08 -0800
Message-ID: <56E1F7C8.9000101@sandisk.com>
References: <1457461000-24088-1-git-send-email-hch@lst.de>
 <1457461000-24088-10-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457461000-24088-10-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 03/08/2016 10:16 AM, Christoph Hellwig wrote:
> -/**
>    * srpt_get_send_ioctx() - Obtain an I/O context for sending to the initiator.
>    */
>   static struct srpt_send_ioctx *srpt_get_send_ioctx(struct srpt_rdma_ch *ch)
> @@ -1284,12 +1096,8 @@ static struct srpt_send_ioctx *srpt_get_send_ioctx(struct srpt_rdma_ch *ch)
>   	BUG_ON(ioctx->ch != ch);
>   	spin_lock_init(&ioctx->spinlock);
>   	ioctx->state = SRPT_STATE_NEW;
> -	ioctx->n_rbuf = 0;
> -	ioctx->rbufs = NULL;
> +	ioctx->n_rw_ctx = 0;
>   	ioctx->n_rdma = 0;
> -	ioctx->n_rdma_wrs = 0;
> -	ioctx->rdma_wrs = NULL;
> -	ioctx->mapped_sg_count = 0;
>   	init_completion(&ioctx->tx_done);
>   	ioctx->queue_status_only = false;
>   	/*
> @@ -1359,7 +1167,6 @@ static int srpt_abort_cmd(struct srpt_send_ioctx *ioctx)
>   		 * SRP_RSP sending failed or the SRP_RSP send completion has
>   		 * not been received in time.
>   		 */
> -		srpt_unmap_sg_to_ib_sge(ioctx->ch, ioctx);
>   		transport_generic_free_cmd(&ioctx->cmd, 0);
>   		break;
>   	case SRPT_STATE_MGMT_RSP_SENT:
> @@ -1387,6 +1194,7 @@ static void srpt_rdma_read_done(struct ib_cq *cq, struct ib_wc *wc)
>
>   	WARN_ON(ioctx->n_rdma <= 0);
>   	atomic_add(ioctx->n_rdma, &ch->sq_wr_avail);
> +	ioctx->n_rdma = 0;
>
>   	if (unlikely(wc->status != IB_WC_SUCCESS)) {
>   		pr_info("RDMA_READ for ioctx 0x%p failed with status %d\n",

ioctx->n_rdma is reset by srpt_get_send_ioctx(). Do we really need to 
reset that member variable in srpt_rdma_read_done()?

> @@ -1832,8 +1626,11 @@ retry:
>   	qp_init->srq = sdev->srq;
>   	qp_init->sq_sig_type = IB_SIGNAL_REQ_WR;
>   	qp_init->qp_type = IB_QPT_RC;
> -	qp_init->cap.max_send_wr = srp_sq_size;
> -	qp_init->cap.max_send_sge = SRPT_DEF_SG_PER_WQE;
> +	qp_init->cap.max_send_wr = srp_sq_size / 2;
> +	qp_init->cap.max_rdma_ctxs = srp_sq_size / 2;
> +	qp_init->cap.max_send_sge = max(sdev->device->attrs.max_sge_rd,
> +					sdev->device->attrs.max_sge);
> +	qp_init->port_num = ch->sport->port;
>
>   	ch->qp = ib_create_qp(sdev->pd, qp_init);
>   	if (IS_ERR(ch->qp)) {

The QP max_send_wr parameter has been changed but not the ib_alloc_cq() 
argument. Is that perhaps an oversight?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
