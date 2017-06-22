From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 09/13] RDMA/bnxt_re: Allow posting when QPs are
 in error
Date: Thu, 22 Jun 2017 08:40:10 +0300
Message-ID: <20170622054010.GL1248@mtr-leonro.local>
References: <1498065504-27902-1-git-send-email-selvin.xavier@broadcom.com>
 <1498065504-27902-10-git-send-email-selvin.xavier@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sCNd3Ivk/oijKKf1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1498065504-27902-10-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--sCNd3Ivk/oijKKf1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 21, 2017 at 10:18:20AM -0700, Selvin Xavier wrote:
> This  patch allows driver to post send and receive
> requests on QPs which are in  error state.
>
> Instead of flushing the QP in the context of polling
> error CQEs, the QPs will be added to a flush list
> maintained per CQ. QP state is moved to error.
> QP is added to flush list if the user moves it
> to error state using modify_qp also. After polling the HW
> CQ in poll_cq routine, this flush list is traversed
> and driver completes work requests each QP in the flush
> list, till the budget expires. The QP is moved out of
> flush list during QP destroy or during modify_QP to RESET.
>
> When ULPs post Work Requests while QP is in error state,
> driver will store the ULP data and then increments the
> QP producer s/w index, without ringing doorbell. It then
> schedules a worker to invoke the CQ handler since the
> interrupts wont be generated from the HW for this request.
>
> Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c   |  22 ++
>  drivers/infiniband/hw/bnxt_re/main.c       |   3 +-
>  drivers/infiniband/hw/bnxt_re/qplib_fp.c   | 411 ++++++++++++++++++++++-------
>  drivers/infiniband/hw/bnxt_re/qplib_fp.h   |  22 +-
>  drivers/infiniband/hw/bnxt_re/qplib_rcfw.c |  10 +-
>  drivers/infiniband/hw/bnxt_re/qplib_rcfw.h |  10 +-
>  6 files changed, 383 insertions(+), 95 deletions(-)
>
> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> index 6629727..e7d667f 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> @@ -829,6 +829,7 @@ int bnxt_re_destroy_qp(struct ib_qp *ib_qp)
>  	struct bnxt_re_dev *rdev = qp->rdev;
>  	int rc;
>
> +	bnxt_qplib_del_flush_qp(&qp->qplib_qp);
>  	rc = bnxt_qplib_destroy_qp(&rdev->qplib_res, &qp->qplib_qp);
>  	if (rc) {
>  		dev_err(rdev_to_dev(rdev), "Failed to destroy HW QP");
> @@ -843,6 +844,7 @@ int bnxt_re_destroy_qp(struct ib_qp *ib_qp)
>  			return rc;
>  		}
>
> +		bnxt_qplib_del_flush_qp(&qp->qplib_qp);
>  		rc = bnxt_qplib_destroy_qp(&rdev->qplib_res,
>  					   &rdev->qp1_sqp->qplib_qp);
>  		if (rc) {
> @@ -1387,6 +1389,21 @@ int bnxt_re_modify_qp(struct ib_qp *ib_qp, struct ib_qp_attr *qp_attr,
>  		}
>  		qp->qplib_qp.modify_flags |= CMDQ_MODIFY_QP_MODIFY_MASK_STATE;
>  		qp->qplib_qp.state = __from_ib_qp_state(qp_attr->qp_state);
> +
> +		if (!qp->sumem &&
> +		    qp->qplib_qp.state == CMDQ_MODIFY_QP_NEW_STATE_ERR) {
> +			dev_dbg(rdev_to_dev(rdev),
> +				"Move QP = %p to flush list\n",
> +				qp);
> +			bnxt_qplib_add_flush_qp(&qp->qplib_qp);
> +		}
> +		if (!qp->sumem &&
> +		    qp->qplib_qp.state == CMDQ_MODIFY_QP_NEW_STATE_RESET) {
> +			dev_dbg(rdev_to_dev(rdev),
> +				"Move QP = %p out of flush list\n",
> +				qp);
> +			bnxt_qplib_del_flush_qp(&qp->qplib_qp);
> +		}
>  	}
>  	if (qp_attr_mask & IB_QP_EN_SQD_ASYNC_NOTIFY) {
>  		qp->qplib_qp.modify_flags |=
> @@ -2397,6 +2414,7 @@ struct ib_cq *bnxt_re_create_cq(struct ib_device *ibdev,
>  	}
>  	cq->qplib_cq.max_wqe = entries;
>  	cq->qplib_cq.cnq_hw_ring_id = rdev->nq.ring_id;
> +	cq->qplib_cq.nq	= &rdev->nq;
>
>  	rc = bnxt_qplib_create_cq(&rdev->qplib_res, &cq->qplib_cq);
>  	if (rc) {
> @@ -2903,6 +2921,10 @@ int bnxt_re_poll_cq(struct ib_cq *ib_cq, int num_entries, struct ib_wc *wc)
>  					sq->send_phantom = false;
>  			}
>  		}
> +		if (ncqe < budget)
> +			ncqe += bnxt_qplib_process_flush_list(&cq->qplib_cq,
> +							      cqe + ncqe,
> +							      budget - ncqe);
>
>  		if (!ncqe)
>  			break;
> diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
> index c067b9c..ec9fc0b 100644
> --- a/drivers/infiniband/hw/bnxt_re/main.c
> +++ b/drivers/infiniband/hw/bnxt_re/main.c
> @@ -1045,7 +1045,8 @@ static int bnxt_re_ib_reg(struct bnxt_re_dev *rdev)
>  	/* Establish RCFW Communication Channel to initialize the context
>  	 * memory for the function and all child VFs
>  	 */
> -	rc = bnxt_qplib_alloc_rcfw_channel(rdev->en_dev->pdev, &rdev->rcfw);
> +	rc = bnxt_qplib_alloc_rcfw_channel(rdev->en_dev->pdev, &rdev->rcfw,
> +					   BNXT_RE_MAX_QPC_COUNT);
>  	if (rc)
>  		goto fail;
>
> diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
> index 8ef39df..5c144ce 100644
> --- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
> +++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
> @@ -52,6 +52,114 @@
>
>  static void bnxt_qplib_arm_cq_enable(struct bnxt_qplib_cq *cq);
>
> +/* Flush list */
> +
> +/* To avoid processing completions if QP is already in flush list */
> +static bool bnxt_qplib_is_qp_in_rq_flushlist(struct bnxt_qplib_qp *qp)
> +{
> +	bool flushed = false;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&qp->rcq->flush_lock, flags);
> +	flushed = qp->rq.flushed;
> +	spin_unlock_irqrestore(&qp->rcq->flush_lock, flags);
> +	return flushed;
> +}
> +
> +static bool bnxt_qplib_is_qp_in_sq_flushlist(struct bnxt_qplib_qp *qp)
> +{
> +	bool flushed = false;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&qp->scq->flush_lock, flags);
> +	flushed = qp->sq.flushed;
> +	spin_unlock_irqrestore(&qp->scq->flush_lock, flags);
> +	return flushed;

I don't really understand the lock/unlock here. What exactly do you
protect? Is it the change of "flushed"? It can be and will be worthless
immediately after your unlock.

You should protect the whole flow which depends on your "flushed".

> +}
> +
> +static void bnxt_qplib_cancel_phantom_processing(struct bnxt_qplib_qp *qp)
> +{
> +	qp->sq.condition = false;
> +	qp->sq.send_phantom = false;
> +	qp->sq.single = false;
> +}
> +
> +void bnxt_qplib_add_flush_qp(struct bnxt_qplib_qp *qp)
> +{
> +	struct bnxt_qplib_cq *scq, *rcq;
> +	unsigned long flags;
> +
> +	scq = qp->scq;
> +	rcq = qp->rcq;
> +
> +	spin_lock_irqsave(&scq->flush_lock, flags);
> +	if (!qp->sq.flushed) {
> +		dev_dbg(&scq->hwq.pdev->dev,
> +			"QPLIB: FP: Adding to SQ Flush list = %p",
> +			qp);
> +		bnxt_qplib_cancel_phantom_processing(qp);
> +		list_add_tail(&qp->sq_flush, &scq->sqf_head);
> +		qp->sq.flushed = true;
> +	}
> +	spin_unlock_irqrestore(&scq->flush_lock, flags);
> +	if (!qp->srq) {
> +		spin_lock_irqsave(&rcq->flush_lock, flags);
> +		if (!qp->rq.flushed) {
> +			dev_dbg(&rcq->hwq.pdev->dev,
> +				"QPLIB: FP: Adding to RQ Flush list = %p",
> +				qp);
> +			list_add_tail(&qp->rq_flush, &rcq->rqf_head);
> +			qp->rq.flushed = true;
> +		}
> +		spin_unlock_irqrestore(&rcq->flush_lock, flags);
> +	}
> +}
> +
> +void bnxt_qplib_del_flush_qp(struct bnxt_qplib_qp *qp)
> +{
> +	struct bnxt_qplib_cq *scq, *rcq;
> +	unsigned long flags;
> +
> +	scq = qp->scq;
> +	rcq = qp->rcq;
> +
> +	spin_lock_irqsave(&scq->flush_lock, flags);
> +	if (qp->sq.flushed) {
> +		qp->sq.flushed = false;
> +		list_del(&qp->sq_flush);
> +	}
> +	spin_unlock_irqrestore(&scq->flush_lock, flags);
> +	if (!qp->srq) {
> +		spin_lock_irqsave(&rcq->flush_lock, flags);
> +		if (qp->rq.flushed) {
> +			qp->rq.flushed = false;
> +			list_del(&qp->rq_flush);
> +		}
> +		spin_unlock_irqrestore(&rcq->flush_lock, flags);
> +	}
> +}
> +
> +static void bnxt_qpn_cqn_sched_task(struct work_struct *work)
> +{
> +	struct bnxt_qplib_nq_work *nq_work =
> +			container_of(work, struct bnxt_qplib_nq_work, work);
> +
> +	struct bnxt_qplib_cq *cq = nq_work->cq;
> +	struct bnxt_qplib_nq *nq = nq_work->nq;
> +
> +	if (cq && nq) {
> +		spin_lock_bh(&cq->compl_lock);
> +		if (atomic_read(&cq->arm_state) && nq->cqn_handler) {
> +			dev_dbg(&nq->pdev->dev,
> +				"%s:Trigger cq  = %p event nq = %p\n",
> +				__func__, cq, nq);
> +			nq->cqn_handler(nq, cq);
> +		}
> +		spin_unlock_bh(&cq->compl_lock);
> +	}
> +	kfree(nq_work);
> +}
> +
>  static void bnxt_qplib_free_qp_hdr_buf(struct bnxt_qplib_res *res,
>  				       struct bnxt_qplib_qp *qp)
>  {
> @@ -119,6 +227,7 @@ static void bnxt_qplib_service_nq(unsigned long data)
>  	struct bnxt_qplib_nq *nq = (struct bnxt_qplib_nq *)data;
>  	struct bnxt_qplib_hwq *hwq = &nq->hwq;
>  	struct nq_base *nqe, **nq_ptr;
> +	struct bnxt_qplib_cq *cq;
>  	int num_cqne_processed = 0;
>  	u32 sw_cons, raw_cons;
>  	u16 type;
> @@ -143,15 +252,17 @@ static void bnxt_qplib_service_nq(unsigned long data)
>  			q_handle = le32_to_cpu(nqcne->cq_handle_low);
>  			q_handle |= (u64)le32_to_cpu(nqcne->cq_handle_high)
>  						     << 32;
> -			bnxt_qplib_arm_cq_enable((struct bnxt_qplib_cq *)
> -						 ((unsigned long)q_handle));
> -			if (!nq->cqn_handler(nq, (struct bnxt_qplib_cq *)
> -						 ((unsigned long)q_handle)))
> +			cq = (struct bnxt_qplib_cq *)(unsigned long)q_handle;
> +			bnxt_qplib_arm_cq_enable(cq);
> +			spin_lock_bh(&cq->compl_lock);
> +			atomic_set(&cq->arm_state, 0);
> +			if (!nq->cqn_handler(nq, (cq)))
>  				num_cqne_processed++;
>  			else
>  				dev_warn(&nq->pdev->dev,
>  					 "QPLIB: cqn - type 0x%x not handled",
>  					 type);
> +			spin_unlock_bh(&cq->compl_lock);
>  			break;
>  		}
>  		case NQ_BASE_TYPE_DBQ_EVENT:
> @@ -190,6 +301,10 @@ static irqreturn_t bnxt_qplib_nq_irq(int irq, void *dev_instance)
>
>  void bnxt_qplib_disable_nq(struct bnxt_qplib_nq *nq)
>  {
> +	if (nq->cqn_wq) {
> +		destroy_workqueue(nq->cqn_wq);
> +		nq->cqn_wq = NULL;
> +	}
>  	/* Make sure the HW is stopped! */
>  	synchronize_irq(nq->vector);
>  	tasklet_disable(&nq->worker);
> @@ -216,7 +331,7 @@ int bnxt_qplib_enable_nq(struct pci_dev *pdev, struct bnxt_qplib_nq *nq,
>  					     void *, u8 event))
>  {
>  	resource_size_t nq_base;
> -	int rc;
> +	int rc = -1;
>
>  	nq->pdev = pdev;
>  	nq->vector = msix_vector;
> @@ -227,6 +342,11 @@ int bnxt_qplib_enable_nq(struct pci_dev *pdev, struct bnxt_qplib_nq *nq,
>
>  	tasklet_init(&nq->worker, bnxt_qplib_service_nq, (unsigned long)nq);
>
> +	/* Have a task to schedule CQ notifiers in post send case */
> +	nq->cqn_wq  = create_singlethread_workqueue("bnxt_qplib_nq");
> +	if (!nq->cqn_wq)
> +		goto fail;
> +
>  	nq->requested = false;
>  	rc = request_irq(nq->vector, bnxt_qplib_nq_irq, 0, "bnxt_qplib_nq", nq);
>  	if (rc) {
> @@ -401,8 +521,8 @@ int bnxt_qplib_create_qp1(struct bnxt_qplib_res *res, struct bnxt_qplib_qp *qp)
>
>  	qp->id = le32_to_cpu(resp.xid);
>  	qp->cur_qp_state = CMDQ_MODIFY_QP_NEW_STATE_RESET;
> -	sq->flush_in_progress = false;
> -	rq->flush_in_progress = false;
> +	rcfw->qp_tbl[qp->id].qp_id = qp->id;
> +	rcfw->qp_tbl[qp->id].qp_handle = (void *)qp;
>
>  	return 0;
>
> @@ -615,8 +735,10 @@ int bnxt_qplib_create_qp(struct bnxt_qplib_res *res, struct bnxt_qplib_qp *qp)
>
>  	qp->id = le32_to_cpu(resp.xid);
>  	qp->cur_qp_state = CMDQ_MODIFY_QP_NEW_STATE_RESET;
> -	sq->flush_in_progress = false;
> -	rq->flush_in_progress = false;
> +	INIT_LIST_HEAD(&qp->sq_flush);
> +	INIT_LIST_HEAD(&qp->rq_flush);
> +	rcfw->qp_tbl[qp->id].qp_id = qp->id;
> +	rcfw->qp_tbl[qp->id].qp_handle = (void *)qp;
>
>  	return 0;
>
> @@ -963,13 +1085,19 @@ int bnxt_qplib_destroy_qp(struct bnxt_qplib_res *res,
>  	u16 cmd_flags = 0;
>  	int rc;
>
> +	rcfw->qp_tbl[qp->id].qp_id = BNXT_QPLIB_QP_ID_INVALID;
> +	rcfw->qp_tbl[qp->id].qp_handle = NULL;
> +
>  	RCFW_CMD_PREP(req, DESTROY_QP, cmd_flags);
>
>  	req.qp_cid = cpu_to_le32(qp->id);
>  	rc = bnxt_qplib_rcfw_send_message(rcfw, (void *)&req,
>  					  (void *)&resp, NULL, 0);
> -	if (rc)
> +	if (rc) {
> +		rcfw->qp_tbl[qp->id].qp_id = qp->id;
> +		rcfw->qp_tbl[qp->id].qp_handle = qp;
>  		return rc;
> +	}
>
>  	/* Must walk the associated CQs to nullified the QP ptr */
>  	spin_lock_irqsave(&qp->scq->hwq.lock, flags);
> @@ -1074,14 +1202,21 @@ int bnxt_qplib_post_send(struct bnxt_qplib_qp *qp,
>  	struct bnxt_qplib_swq *swq;
>  	struct sq_send *hw_sq_send_hdr, **hw_sq_send_ptr;
>  	struct sq_sge *hw_sge;
> +	struct bnxt_qplib_nq_work *nq_work = NULL;
> +	bool sch_handler = false;
>  	u32 sw_prod;
>  	u8 wqe_size16;
>  	int i, rc = 0, data_len = 0, pkt_num = 0;
>  	__le32 temp32;
>
>  	if (qp->state != CMDQ_MODIFY_QP_NEW_STATE_RTS) {
> -		rc = -EINVAL;
> -		goto done;
> +		if (qp->state == CMDQ_MODIFY_QP_NEW_STATE_ERR) {
> +			sch_handler = true;
> +			dev_dbg(&sq->hwq.pdev->dev,
> +				"%s Error QP. Scheduling for poll_cq\n",
> +				__func__);
> +			goto queue_err;
> +		}
>  	}
>
>  	if (bnxt_qplib_queue_full(sq)) {
> @@ -1301,12 +1436,35 @@ int bnxt_qplib_post_send(struct bnxt_qplib_qp *qp,
>  			((swq->next_psn << SQ_PSN_SEARCH_NEXT_PSN_SFT) &
>  			 SQ_PSN_SEARCH_NEXT_PSN_MASK));
>  	}
> -
> +queue_err:
> +	if (sch_handler) {
> +		/* Store the ULP info in the software structures */
> +		sw_prod = HWQ_CMP(sq->hwq.prod, &sq->hwq);
> +		swq = &sq->swq[sw_prod];
> +		swq->wr_id = wqe->wr_id;
> +		swq->type = wqe->type;
> +		swq->flags = wqe->flags;
> +		if (qp->sig_type)
> +			swq->flags |= SQ_SEND_FLAGS_SIGNAL_COMP;
> +		swq->start_psn = sq->psn & BTH_PSN_MASK;
> +	}
>  	sq->hwq.prod++;
> -
>  	qp->wqe_cnt++;
>
>  done:
> +	if (sch_handler) {
> +		nq_work = kzalloc(sizeof(*nq_work), GFP_ATOMIC);
> +		if (nq_work) {
> +			nq_work->cq = qp->scq;
> +			nq_work->nq = qp->scq->nq;
> +			INIT_WORK(&nq_work->work, bnxt_qpn_cqn_sched_task);
> +			queue_work(qp->scq->nq->cqn_wq, &nq_work->work);
> +		} else {
> +			dev_err(&sq->hwq.pdev->dev,
> +				"QPLIB: FP: Failed to allocate SQ nq_work!");
> +			rc = -ENOMEM;
> +		}
> +	}
>  	return rc;
>  }
>
> @@ -1334,15 +1492,17 @@ int bnxt_qplib_post_recv(struct bnxt_qplib_qp *qp,
>  	struct bnxt_qplib_q *rq = &qp->rq;
>  	struct rq_wqe *rqe, **rqe_ptr;
>  	struct sq_sge *hw_sge;
> +	struct bnxt_qplib_nq_work *nq_work = NULL;
> +	bool sch_handler = false;
>  	u32 sw_prod;
>  	int i, rc = 0;
>
>  	if (qp->state == CMDQ_MODIFY_QP_NEW_STATE_ERR) {
> -		dev_err(&rq->hwq.pdev->dev,
> -			"QPLIB: FP: QP (0x%x) is in the 0x%x state",
> -			qp->id, qp->state);
> -		rc = -EINVAL;
> -		goto done;
> +		sch_handler = true;
> +		dev_dbg(&rq->hwq.pdev->dev,
> +			"%s Error QP. Scheduling for poll_cq\n",
> +			__func__);
> +		goto queue_err;
>  	}
>  	if (bnxt_qplib_queue_full(rq)) {
>  		dev_err(&rq->hwq.pdev->dev,
> @@ -1378,7 +1538,27 @@ int bnxt_qplib_post_recv(struct bnxt_qplib_qp *qp,
>  	/* Supply the rqe->wr_id index to the wr_id_tbl for now */
>  	rqe->wr_id[0] = cpu_to_le32(sw_prod);
>
> +queue_err:
> +	if (sch_handler) {
> +		/* Store the ULP info in the software structures */
> +		sw_prod = HWQ_CMP(rq->hwq.prod, &rq->hwq);
> +		rq->swq[sw_prod].wr_id = wqe->wr_id;
> +	}
> +
>  	rq->hwq.prod++;
> +	if (sch_handler) {
> +		nq_work = kzalloc(sizeof(*nq_work), GFP_ATOMIC);
> +		if (nq_work) {
> +			nq_work->cq = qp->rcq;
> +			nq_work->nq = qp->rcq->nq;
> +			INIT_WORK(&nq_work->work, bnxt_qpn_cqn_sched_task);
> +			queue_work(qp->rcq->nq->cqn_wq, &nq_work->work);
> +		} else {
> +			dev_err(&rq->hwq.pdev->dev,
> +				"QPLIB: FP: Failed to allocate RQ nq_work!");
> +			rc = -ENOMEM;
> +		}
> +	}
>  done:
>  	return rc;
>  }
> @@ -1471,6 +1651,10 @@ int bnxt_qplib_create_cq(struct bnxt_qplib_res *res, struct bnxt_qplib_cq *cq)
>  	cq->dbr_base = res->dpi_tbl.dbr_bar_reg_iomem;
>  	cq->period = BNXT_QPLIB_QUEUE_START_PERIOD;
>  	init_waitqueue_head(&cq->waitq);
> +	INIT_LIST_HEAD(&cq->sqf_head);
> +	INIT_LIST_HEAD(&cq->rqf_head);
> +	spin_lock_init(&cq->flush_lock);
> +	spin_lock_init(&cq->compl_lock);
>
>  	bnxt_qplib_arm_cq_enable(cq);
>  	return 0;
> @@ -1513,9 +1697,13 @@ static int __flush_sq(struct bnxt_qplib_q *sq, struct bnxt_qplib_qp *qp,
>  	while (*budget) {
>  		sw_cons = HWQ_CMP(sq->hwq.cons, &sq->hwq);
>  		if (sw_cons == sw_prod) {
> -			sq->flush_in_progress = false;
>  			break;
>  		}
> +		/* Skip the FENCE WQE completions */
> +		if (sq->swq[sw_cons].wr_id == BNXT_QPLIB_FENCE_WRID) {
> +			bnxt_qplib_cancel_phantom_processing(qp);
> +			goto skip_compl;
> +		}
>  		memset(cqe, 0, sizeof(*cqe));
>  		cqe->status = CQ_REQ_STATUS_WORK_REQUEST_FLUSHED_ERR;
>  		cqe->opcode = CQ_BASE_CQE_TYPE_REQ;
> @@ -1525,6 +1713,7 @@ static int __flush_sq(struct bnxt_qplib_q *sq, struct bnxt_qplib_qp *qp,
>  		cqe->type = sq->swq[sw_cons].type;
>  		cqe++;
>  		(*budget)--;
> +skip_compl:
>  		sq->hwq.cons++;
>  	}
>  	*pcqe = cqe;
> @@ -1536,11 +1725,24 @@ static int __flush_sq(struct bnxt_qplib_q *sq, struct bnxt_qplib_qp *qp,
>  }
>
>  static int __flush_rq(struct bnxt_qplib_q *rq, struct bnxt_qplib_qp *qp,
> -		      int opcode, struct bnxt_qplib_cqe **pcqe, int *budget)
> +		      struct bnxt_qplib_cqe **pcqe, int *budget)
>  {
>  	struct bnxt_qplib_cqe *cqe;
>  	u32 sw_prod, sw_cons;
>  	int rc = 0;
> +	int opcode = 0;
> +
> +	switch (qp->type) {
> +	case CMDQ_CREATE_QP1_TYPE_GSI:
> +		opcode = CQ_BASE_CQE_TYPE_RES_RAWETH_QP1;
> +		break;
> +	case CMDQ_CREATE_QP_TYPE_RC:
> +		opcode = CQ_BASE_CQE_TYPE_RES_RC;
> +		break;
> +	case CMDQ_CREATE_QP_TYPE_UD:
> +		opcode = CQ_BASE_CQE_TYPE_RES_UD;
> +		break;
> +	}
>
>  	/* Flush the rest of the RQ */
>  	sw_prod = HWQ_CMP(rq->hwq.prod, &rq->hwq);
> @@ -1567,6 +1769,21 @@ static int __flush_rq(struct bnxt_qplib_q *rq, struct bnxt_qplib_qp *qp,
>  	return rc;
>  }
>
> +void bnxt_qplib_mark_qp_error(void *qp_handle)
> +{
> +	struct bnxt_qplib_qp *qp = qp_handle;
> +
> +	if (!qp)
> +		return;
> +
> +	/* Must block new posting of SQ and RQ */
> +	qp->state = CMDQ_MODIFY_QP_NEW_STATE_ERR;
> +	bnxt_qplib_cancel_phantom_processing(qp);
> +
> +	/* Add qp to flush list of the CQ */
> +	bnxt_qplib_add_flush_qp(qp);
> +}
> +
>  /* Note: SQE is valid from sw_sq_cons up to cqe_sq_cons (exclusive)
>   *       CQE is track from sw_cq_cons to max_element but valid only if VALID=1
>   */
> @@ -1694,10 +1911,12 @@ static int bnxt_qplib_cq_process_req(struct bnxt_qplib_cq *cq,
>  			cqe_sq_cons, sq->hwq.max_elements);
>  		return -EINVAL;
>  	}
> -	/* If we were in the middle of flushing the SQ, continue */
> -	if (sq->flush_in_progress)
> -		goto flush;
>
> +	if (bnxt_qplib_is_qp_in_sq_flushlist(qp)) {
> +		dev_dbg(&cq->hwq.pdev->dev,
> +			"%s: QPLIB: QP in Flush QP = %p\n", __func__, qp);
> +		goto done;
> +	}
>  	/* Require to walk the sq's swq to fabricate CQEs for all previously
>  	 * signaled SWQEs due to CQE aggregation from the current sq cons
>  	 * to the cqe_sq_cons
> @@ -1733,11 +1952,7 @@ static int bnxt_qplib_cq_process_req(struct bnxt_qplib_cq *cq,
>  				sw_sq_cons, cqe->wr_id, cqe->status);
>  			cqe++;
>  			(*budget)--;
> -			sq->flush_in_progress = true;
> -			/* Must block new posting of SQ and RQ */
> -			qp->state = CMDQ_MODIFY_QP_NEW_STATE_ERR;
> -			sq->condition = false;
> -			sq->single = false;
> +			bnxt_qplib_mark_qp_error(qp);
>  		} else {
>  			if (swq->flags & SQ_SEND_FLAGS_SIGNAL_COMP) {
>  				/* Before we complete, do WA 9060 */
> @@ -1768,15 +1983,6 @@ static int bnxt_qplib_cq_process_req(struct bnxt_qplib_cq *cq,
>  	 * the WC for this CQE
>  	 */
>  	sq->single = false;
> -	if (!sq->flush_in_progress)
> -		goto done;
> -flush:
> -	/* Require to walk the sq's swq to fabricate CQEs for all
> -	 * previously posted SWQEs due to the error CQE received
> -	 */
> -	rc = __flush_sq(sq, qp, pcqe, budget);
> -	if (!rc)
> -		sq->flush_in_progress = false;
>  done:
>  	return rc;
>  }
> @@ -1798,6 +2004,12 @@ static int bnxt_qplib_cq_process_res_rc(struct bnxt_qplib_cq *cq,
>  		dev_err(&cq->hwq.pdev->dev, "QPLIB: process_cq RC qp is NULL");
>  		return -EINVAL;
>  	}
> +	if (bnxt_qplib_is_qp_in_rq_flushlist(qp)) {
> +		dev_dbg(&cq->hwq.pdev->dev,
> +			"%s: QPLIB: QP in Flush QP = %p\n", __func__, qp);
> +		goto done;
> +	}
> +
>  	cqe = *pcqe;
>  	cqe->opcode = hwcqe->cqe_type_toggle & CQ_BASE_CQE_TYPE_MASK;
>  	cqe->length = le32_to_cpu(hwcqe->length);
> @@ -1817,8 +2029,6 @@ static int bnxt_qplib_cq_process_res_rc(struct bnxt_qplib_cq *cq,
>  			wr_id_idx, rq->hwq.max_elements);
>  		return -EINVAL;
>  	}
> -	if (rq->flush_in_progress)
> -		goto flush_rq;
>
>  	cqe->wr_id = rq->swq[wr_id_idx].wr_id;
>  	cqe++;
> @@ -1826,13 +2036,11 @@ static int bnxt_qplib_cq_process_res_rc(struct bnxt_qplib_cq *cq,
>  	rq->hwq.cons++;
>  	*pcqe = cqe;
>
> -	if (hwcqe->status != CQ_RES_RC_STATUS_OK) {
> -		rq->flush_in_progress = true;
> -flush_rq:
> -		rc = __flush_rq(rq, qp, CQ_BASE_CQE_TYPE_RES_RC, pcqe, budget);
> -		if (!rc)
> -			rq->flush_in_progress = false;
> -	}
> +	if (hwcqe->status != CQ_RES_RC_STATUS_OK)
> +		 /* Add qp to flush list of the CQ */
> +		bnxt_qplib_add_flush_qp(qp);
> +
> +done:
>  	return rc;
>  }
>
> @@ -1853,6 +2061,11 @@ static int bnxt_qplib_cq_process_res_ud(struct bnxt_qplib_cq *cq,
>  		dev_err(&cq->hwq.pdev->dev, "QPLIB: process_cq UD qp is NULL");
>  		return -EINVAL;
>  	}
> +	if (bnxt_qplib_is_qp_in_rq_flushlist(qp)) {
> +		dev_dbg(&cq->hwq.pdev->dev,
> +			"%s: QPLIB: QP in Flush QP = %p\n", __func__, qp);
> +		goto done;
> +	}
>  	cqe = *pcqe;
>  	cqe->opcode = hwcqe->cqe_type_toggle & CQ_BASE_CQE_TYPE_MASK;
>  	cqe->length = le32_to_cpu(hwcqe->length);
> @@ -1876,8 +2089,6 @@ static int bnxt_qplib_cq_process_res_ud(struct bnxt_qplib_cq *cq,
>  			wr_id_idx, rq->hwq.max_elements);
>  		return -EINVAL;
>  	}
> -	if (rq->flush_in_progress)
> -		goto flush_rq;
>
>  	cqe->wr_id = rq->swq[wr_id_idx].wr_id;
>  	cqe++;
> @@ -1885,13 +2096,11 @@ static int bnxt_qplib_cq_process_res_ud(struct bnxt_qplib_cq *cq,
>  	rq->hwq.cons++;
>  	*pcqe = cqe;
>
> -	if (hwcqe->status != CQ_RES_RC_STATUS_OK) {
> -		rq->flush_in_progress = true;
> -flush_rq:
> -		rc = __flush_rq(rq, qp, CQ_BASE_CQE_TYPE_RES_UD, pcqe, budget);
> -		if (!rc)
> -			rq->flush_in_progress = false;
> -	}
> +	if (hwcqe->status != CQ_RES_RC_STATUS_OK)
> +		/* Add qp to flush list of the CQ */
> +		bnxt_qplib_add_flush_qp(qp);
> +
> +done:
>  	return rc;
>  }
>
> @@ -1913,6 +2122,11 @@ static int bnxt_qplib_cq_process_res_raweth_qp1(struct bnxt_qplib_cq *cq,
>  			"QPLIB: process_cq Raw/QP1 qp is NULL");
>  		return -EINVAL;
>  	}
> +	if (bnxt_qplib_is_qp_in_rq_flushlist(qp)) {
> +		dev_dbg(&cq->hwq.pdev->dev,
> +			"%s: QPLIB: QP in Flush QP = %p\n", __func__, qp);
> +		goto done;
> +	}
>  	cqe = *pcqe;
>  	cqe->opcode = hwcqe->cqe_type_toggle & CQ_BASE_CQE_TYPE_MASK;
>  	cqe->flags = le16_to_cpu(hwcqe->flags);
> @@ -1941,8 +2155,6 @@ static int bnxt_qplib_cq_process_res_raweth_qp1(struct bnxt_qplib_cq *cq,
>  			wr_id_idx, rq->hwq.max_elements);
>  		return -EINVAL;
>  	}
> -	if (rq->flush_in_progress)
> -		goto flush_rq;
>
>  	cqe->wr_id = rq->swq[wr_id_idx].wr_id;
>  	cqe++;
> @@ -1950,14 +2162,11 @@ static int bnxt_qplib_cq_process_res_raweth_qp1(struct bnxt_qplib_cq *cq,
>  	rq->hwq.cons++;
>  	*pcqe = cqe;
>
> -	if (hwcqe->status != CQ_RES_RC_STATUS_OK) {
> -		rq->flush_in_progress = true;
> -flush_rq:
> -		rc = __flush_rq(rq, qp, CQ_BASE_CQE_TYPE_RES_RAWETH_QP1, pcqe,
> -				budget);
> -		if (!rc)
> -			rq->flush_in_progress = false;
> -	}
> +	if (hwcqe->status != CQ_RES_RC_STATUS_OK)
> +	/* Add qp to flush list of the CQ */
> +		bnxt_qplib_add_flush_qp(qp);
> +
> +done:
>  	return rc;
>  }
>
> @@ -1971,7 +2180,6 @@ static int bnxt_qplib_cq_process_terminal(struct bnxt_qplib_cq *cq,
>  	struct bnxt_qplib_cqe *cqe;
>  	u32 sw_cons = 0, cqe_cons;
>  	int rc = 0;
> -	u8 opcode = 0;
>
>  	/* Check the Status */
>  	if (hwcqe->status != CQ_TERMINAL_STATUS_OK)
> @@ -2004,9 +2212,12 @@ static int bnxt_qplib_cq_process_terminal(struct bnxt_qplib_cq *cq,
>  			cqe_cons, sq->hwq.max_elements);
>  		goto do_rq;
>  	}
> -	/* If we were in the middle of flushing, continue */
> -	if (sq->flush_in_progress)
> -		goto flush_sq;
> +
> +	if (bnxt_qplib_is_qp_in_sq_flushlist(qp)) {
> +		dev_dbg(&cq->hwq.pdev->dev,
> +			"%s: QPLIB: QP in Flush QP = %p\n", __func__, qp);
> +		goto sq_done;
> +	}
>
>  	/* Terminal CQE can also include aggregated successful CQEs prior.
>  	 * So we must complete all CQEs from the current sq's cons to the
> @@ -2036,11 +2247,6 @@ static int bnxt_qplib_cq_process_terminal(struct bnxt_qplib_cq *cq,
>  		rc = -EAGAIN;
>  		goto sq_done;
>  	}
> -	sq->flush_in_progress = true;
> -flush_sq:
> -	rc = __flush_sq(sq, qp, pcqe, budget);
> -	if (!rc)
> -		sq->flush_in_progress = false;
>  sq_done:
>  	if (rc)
>  		return rc;
> @@ -2056,26 +2262,21 @@ static int bnxt_qplib_cq_process_terminal(struct bnxt_qplib_cq *cq,
>  			cqe_cons, rq->hwq.max_elements);
>  		goto done;
>  	}
> +
> +	if (bnxt_qplib_is_qp_in_rq_flushlist(qp)) {
> +		dev_dbg(&cq->hwq.pdev->dev,
> +			"%s: QPLIB: QP in Flush QP = %p\n", __func__, qp);
> +		rc = 0;
> +		goto done;
> +	}
> +
>  	/* Terminal CQE requires all posted RQEs to complete with FLUSHED_ERR
>  	 * from the current rq->cons to the rq->prod regardless what the
>  	 * rq->cons the terminal CQE indicates
>  	 */
> -	rq->flush_in_progress = true;
> -	switch (qp->type) {
> -	case CMDQ_CREATE_QP1_TYPE_GSI:
> -		opcode = CQ_BASE_CQE_TYPE_RES_RAWETH_QP1;
> -		break;
> -	case CMDQ_CREATE_QP_TYPE_RC:
> -		opcode = CQ_BASE_CQE_TYPE_RES_RC;
> -		break;
> -	case CMDQ_CREATE_QP_TYPE_UD:
> -		opcode = CQ_BASE_CQE_TYPE_RES_UD;
> -		break;
> -	}
>
> -	rc = __flush_rq(rq, qp, opcode, pcqe, budget);
> -	if (!rc)
> -		rq->flush_in_progress = false;
> +	/* Add qp to flush list of the CQ */
> +	bnxt_qplib_add_flush_qp(qp);
>  done:
>  	return rc;
>  }
> @@ -2096,6 +2297,33 @@ static int bnxt_qplib_cq_process_cutoff(struct bnxt_qplib_cq *cq,
>  	return 0;
>  }
>
> +int bnxt_qplib_process_flush_list(struct bnxt_qplib_cq *cq,
> +				  struct bnxt_qplib_cqe *cqe,
> +				  int num_cqes)
> +{
> +	struct bnxt_qplib_qp *qp = NULL;
> +	u32 budget = num_cqes;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&cq->flush_lock, flags);
> +	list_for_each_entry(qp, &cq->sqf_head, sq_flush) {
> +		dev_dbg(&cq->hwq.pdev->dev,
> +			"QPLIB: FP: Flushing SQ QP= %p",
> +			qp);
> +		__flush_sq(&qp->sq, qp, &cqe, &budget);
> +	}
> +
> +	list_for_each_entry(qp, &cq->rqf_head, rq_flush) {
> +		dev_dbg(&cq->hwq.pdev->dev,
> +			"QPLIB: FP: Flushing RQ QP= %p",
> +			qp);
> +		__flush_rq(&qp->rq, qp, &cqe, &budget);
> +	}
> +	spin_unlock_irqrestore(&cq->flush_lock, flags);
> +
> +	return num_cqes - budget;
> +}
> +
>  int bnxt_qplib_poll_cq(struct bnxt_qplib_cq *cq, struct bnxt_qplib_cqe *cqe,
>  		       int num_cqes, struct bnxt_qplib_qp **lib_qp)
>  {
> @@ -2186,6 +2414,7 @@ void bnxt_qplib_req_notify_cq(struct bnxt_qplib_cq *cq, u32 arm_type)
>  	spin_lock_irqsave(&cq->hwq.lock, flags);
>  	if (arm_type)
>  		bnxt_qplib_arm_cq(cq, arm_type);
> -
> +	/* Using cq->arm_state variable to track whether to issue cq handler */
> +	atomic_set(&cq->arm_state, 1);
>  	spin_unlock_irqrestore(&cq->hwq.lock, flags);
>  }
> diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.h b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
> index 36b7b7d..18abe40 100644
> --- a/drivers/infiniband/hw/bnxt_re/qplib_fp.h
> +++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
> @@ -220,19 +220,20 @@ struct bnxt_qplib_q {
>  	u16				q_full_delta;
>  	u16				max_sge;
>  	u32				psn;
> -	bool				flush_in_progress;
>  	bool				condition;
>  	bool				single;
>  	bool				send_phantom;
>  	u32				phantom_wqe_cnt;
>  	u32				phantom_cqe_cnt;
>  	u32				next_cq_cons;
> +	bool				flushed;
>  };
>
>  struct bnxt_qplib_qp {
>  	struct bnxt_qplib_pd		*pd;
>  	struct bnxt_qplib_dpi		*dpi;
>  	u64				qp_handle;
> +#define        BNXT_QPLIB_QP_ID_INVALID        0xFFFFFFFF
>  	u32				id;
>  	u8				type;
>  	u8				sig_type;
> @@ -296,6 +297,8 @@ struct bnxt_qplib_qp {
>  	dma_addr_t			sq_hdr_buf_map;
>  	void				*rq_hdr_buf;
>  	dma_addr_t			rq_hdr_buf_map;
> +	struct list_head		sq_flush;
> +	struct list_head		rq_flush;
>  };
>
>  #define BNXT_QPLIB_MAX_CQE_ENTRY_SIZE	sizeof(struct cq_base)
> @@ -351,6 +354,7 @@ struct bnxt_qplib_cq {
>  	u16				period;
>  	struct bnxt_qplib_hwq		hwq;
>  	u32				cnq_hw_ring_id;
> +	struct bnxt_qplib_nq		*nq;
>  	bool				resize_in_progress;
>  	struct scatterlist		*sghead;
>  	u32				nmap;
> @@ -360,6 +364,10 @@ struct bnxt_qplib_cq {
>  	unsigned long			flags;
>  #define CQ_FLAGS_RESIZE_IN_PROG		1
>  	wait_queue_head_t		waitq;
> +	spinlock_t			flush_lock; /* lock flush queue list */
> +	struct list_head		sqf_head, rqf_head;
> +	atomic_t			arm_state;
> +	spinlock_t			compl_lock; /* synch CQ handlers */
>  };
>
>  #define BNXT_QPLIB_MAX_IRRQE_ENTRY_SIZE	sizeof(struct xrrq_irrq)
> @@ -417,6 +425,13 @@ struct bnxt_qplib_nq {
>  						(struct bnxt_qplib_nq *nq,
>  						 void *srq,
>  						 u8 event);
> +	struct workqueue_struct         *cqn_wq;
> +};
> +
> +struct bnxt_qplib_nq_work {
> +	struct work_struct      work;
> +	struct bnxt_qplib_nq    *nq;
> +	struct bnxt_qplib_cq    *cq;
>  };
>
>  void bnxt_qplib_disable_nq(struct bnxt_qplib_nq *nq);
> @@ -452,4 +467,9 @@ int bnxt_qplib_poll_cq(struct bnxt_qplib_cq *cq, struct bnxt_qplib_cqe *cqe,
>  void bnxt_qplib_req_notify_cq(struct bnxt_qplib_cq *cq, u32 arm_type);
>  void bnxt_qplib_free_nq(struct bnxt_qplib_nq *nq);
>  int bnxt_qplib_alloc_nq(struct pci_dev *pdev, struct bnxt_qplib_nq *nq);
> +void bnxt_qplib_add_flush_qp(struct bnxt_qplib_qp *qp);
> +void bnxt_qplib_del_flush_qp(struct bnxt_qplib_qp *qp);
> +int bnxt_qplib_process_flush_list(struct bnxt_qplib_cq *cq,
> +				  struct bnxt_qplib_cqe *cqe,
> +				  int num_cqes);
>  #endif /* __BNXT_QPLIB_FP_H__ */
> diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
> index 16e4275..d88b5de 100644
> --- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
> +++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
> @@ -507,6 +507,7 @@ int bnxt_qplib_init_rcfw(struct bnxt_qplib_rcfw *rcfw,
>
>  void bnxt_qplib_free_rcfw_channel(struct bnxt_qplib_rcfw *rcfw)
>  {
> +	kfree(rcfw->qp_tbl);
>  	kfree(rcfw->crsqe_tbl);
>  	bnxt_qplib_free_hwq(rcfw->pdev, &rcfw->cmdq);
>  	bnxt_qplib_free_hwq(rcfw->pdev, &rcfw->creq);
> @@ -514,7 +515,8 @@ void bnxt_qplib_free_rcfw_channel(struct bnxt_qplib_rcfw *rcfw)
>  }
>
>  int bnxt_qplib_alloc_rcfw_channel(struct pci_dev *pdev,
> -				  struct bnxt_qplib_rcfw *rcfw)
> +				  struct bnxt_qplib_rcfw *rcfw,
> +				  int qp_tbl_sz)
>  {
>  	rcfw->pdev = pdev;
>  	rcfw->creq.max_elements = BNXT_QPLIB_CREQE_MAX_CNT;
> @@ -541,6 +543,12 @@ int bnxt_qplib_alloc_rcfw_channel(struct pci_dev *pdev,
>  	if (!rcfw->crsqe_tbl)
>  		goto fail;
>
> +	rcfw->qp_tbl_size = qp_tbl_sz;
> +	rcfw->qp_tbl = kcalloc(qp_tbl_sz, sizeof(struct bnxt_qplib_qp_node),
> +			       GFP_KERNEL);
> +	if (!rcfw->qp_tbl)
> +		goto fail;
> +
>  	return 0;
>
>  fail:
> diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
> index 09ce121..0ed312f 100644
> --- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
> +++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
> @@ -148,6 +148,11 @@ struct bnxt_qplib_rcfw_sbuf {
>  	u32 size;
>  };
>
> +struct bnxt_qplib_qp_node {
> +	u32 qp_id;              /* QP id */
> +	void *qp_handle;        /* ptr to qplib_qp */
> +};
> +
>  /* RCFW Communication Channels */
>  struct bnxt_qplib_rcfw {
>  	struct pci_dev		*pdev;
> @@ -181,11 +186,13 @@ struct bnxt_qplib_rcfw {
>  	/* Actual Cmd and Resp Queues */
>  	struct bnxt_qplib_hwq	cmdq;
>  	struct bnxt_qplib_crsq	*crsqe_tbl;
> +	int qp_tbl_size;
> +	struct bnxt_qplib_qp_node *qp_tbl;
>  };
>
>  void bnxt_qplib_free_rcfw_channel(struct bnxt_qplib_rcfw *rcfw);
>  int bnxt_qplib_alloc_rcfw_channel(struct pci_dev *pdev,
> -				  struct bnxt_qplib_rcfw *rcfw);
> +				  struct bnxt_qplib_rcfw *rcfw, int qp_tbl_sz);
>  void bnxt_qplib_disable_rcfw_channel(struct bnxt_qplib_rcfw *rcfw);
>  int bnxt_qplib_enable_rcfw_channel(struct pci_dev *pdev,
>  				   struct bnxt_qplib_rcfw *rcfw,
> @@ -207,4 +214,5 @@ int bnxt_qplib_rcfw_send_message(struct bnxt_qplib_rcfw *rcfw,
>  int bnxt_qplib_deinit_rcfw(struct bnxt_qplib_rcfw *rcfw);
>  int bnxt_qplib_init_rcfw(struct bnxt_qplib_rcfw *rcfw,
>  			 struct bnxt_qplib_ctx *ctx, int is_virtfn);
> +void bnxt_qplib_mark_qp_error(void *qp_handle);
>  #endif /* __BNXT_QPLIB_RCFW_H__ */
> --
> 2.5.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--sCNd3Ivk/oijKKf1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllLWDoACgkQ5GN7iDZy
WKfJaQ/9HiHM3AWBBKeWAW+q4HH5yEdBkyee2wlEJa0N+fH0I/TWJkJQK2LB0NON
SkWKv1lbZc/X2bl7qZOSmOiymVGN+ZxXYIw9c6tsWva1udhibkDf9LbnXOiF9c1F
n12ycWWnbuid9CKmeKdZUPGldmzPt3B6D2yAV0Cx4nSO1N5JwiKLUMbE9kSiFfxZ
698aamRYUE2jsgNW1+IuW86NF5mxRsXZYE+hwu3u4SqHMx4+LTAqfnClAL1h7eIS
W5fZTI/965NbAAhbUDdEszxtAQBkThe9guaxw3JLU46hWS3V09ZV3hsOlHnKAstl
/YSuNgSa2l8wSedX3sOZx5t43/IzD32V16FN2qSav/eCm2ZaSDBs3nGK9uzOtRFi
e2LQijpNWGAc5p/P3acLAgxKrG9FIHnyoINZZQ3KiUvbMDrDL1cfqhC34AZ8u54N
Sz/6d4TxVhSCaETzneiBl+V9D7/sgd2WltcrqQtki+TUi4y1vpS6f0Gl5CtQAFzj
grpwHhyW9Nx8Vyzc3kBkXA1a4o0JGFilqzMROy60Vy7EYb8o2UHQdzILyQ+SpHFR
lPOBKuJ0RkH0tfioaBXdvZ5UifQ3smwf4LZBV2PWAa8YX6wrcM981spZlUrRuEOA
1Cf7qydJNfaMEzvIdQtm6bYUZC3NaVTnUJnUW84VcDEA9n00VQE=
=bE8r
-----END PGP SIGNATURE-----

--sCNd3Ivk/oijKKf1--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
