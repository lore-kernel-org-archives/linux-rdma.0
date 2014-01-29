From: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] RDMA/ocrdma: Eq full catastrophe avoidance
 Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Date: Wed, 29 Jan 2014 11:47:03 +0000
Message-ID: <95363a40-6909-40cf-a8b4-806f534c0d9f@CMEXHTCAS2.ad.emulex.com>
References: <9b651e91-9df3-45de-8a68-5501274e2ace@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9b651e91-9df3-45de-8a68-5501274e2ace-3RiH6ntJJkP8BX6JNMqfyFjyZtpTMMwT@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Please discard this patch. 
Due to IP based GID changes, this won't apply clean, We are planning to send you a new series of patches on for-next tree please use that instead.

-Regards
 Devesh

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
Sent: Saturday, December 14, 2013 12:07 PM
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; Devesh Sharma
Subject: [PATCH] RDMA/ocrdma: Eq full catastrophe avoidance Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Stale entries in the CQ being destroyed causes hardware to generate EQEs indefinetly for a given CQ.
Thus causing uncontrolled execution of irq_handler. This patch fixes this using following sementics:

    * irq_handler will ring EQ doorbell atleast once and implement budgeting scheme.
    * cq_destroy will count number of valid entires during destroy and ring
      cq-db so that hadrware does not generate uncontrolled EQE.
    * cq_destroy will synchronize with last running irq_handler instance.
---
 drivers/infiniband/hw/ocrdma/ocrdma.h       |   15 ++++-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |   58 ++++++++++---------
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |   80 +++++++++++++++++++++++----
 3 files changed, 111 insertions(+), 42 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index adc11d1..5747fde 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -183,8 +183,7 @@ struct ocrdma_cq {
 			 */
 	u32 max_hw_cqe;
 	bool phase_change;
-	bool armed, solicited;
-	bool arm_needed;
+	bool deferred_arm, deferred_sol;
 
 	spinlock_t cq_lock ____cacheline_aligned; /* provide synchronization
 						   * to cq polling
@@ -197,6 +196,7 @@ struct ocrdma_cq {
 	struct ocrdma_ucontext *ucontext;
 	dma_addr_t pa;
 	u32 len;
+	u32 cqe_cnt;
 
 	/* head of all qp's sq and rq for which cqes need to be flushed
 	 * by the software.
@@ -422,5 +422,16 @@ static inline int is_cqe_wr_imm(struct ocrdma_cqe *cqe)
 		OCRDMA_CQE_WRITE_IMM) ? 1 : 0;
 }
 
+static inline int ocrdma_get_eq_table_index(struct ocrdma_dev *dev, int 
+eqid) {
+	int indx;
+
+	for (indx = 0; indx < dev->eq_cnt; indx++) {
+		if (dev->eq_tbl[indx].q.id == eqid)
+			return indx;
+	}
+	return -EINVAL;
+}
 
+int ocrdma_get_irq(struct ocrdma_dev *dev, struct ocrdma_eq *eq);
 #endif
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 50219ab..9490b41 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -444,7 +444,7 @@ mbx_err:
 	return status;
 }
 
-static int ocrdma_get_irq(struct ocrdma_dev *dev, struct ocrdma_eq *eq)
+int ocrdma_get_irq(struct ocrdma_dev *dev, struct ocrdma_eq *eq)
 {
 	int irq;
 
@@ -526,6 +526,7 @@ static u32 ocrdma_encoded_q_len(int q_len)
 	return len_encoded;
 }
 
+
 static int ocrdma_mbx_create_mq(struct ocrdma_dev *dev,
 				struct ocrdma_queue_info *mq,
 				struct ocrdma_queue_info *cq)
@@ -574,6 +575,7 @@ static int ocrdma_create_mq(struct ocrdma_dev *dev)
 	if (status)
 		goto alloc_err;
 
+	dev->eq_tbl[0].cq_cnt++;
 	status = ocrdma_mbx_mq_cq_create(dev, &dev->mq.cq, &dev->eq_tbl[0].q);
 	if (status)
 		goto mbx_cq_free;
@@ -858,16 +860,8 @@ static void ocrdma_qp_cq_handler(struct ocrdma_dev *dev, u16 cq_idx)
 		BUG();
 
 	cq = dev->cq_tbl[cq_idx];
-	if (cq == NULL) {
-		pr_err("%s%d invalid id=0x%x\n", __func__, dev->id, cq_idx);
+	if (cq == NULL)
 		return;
-	}
-	spin_lock_irqsave(&cq->cq_lock, flags);
-	cq->armed = false;
-	cq->solicited = false;
-	spin_unlock_irqrestore(&cq->cq_lock, flags);
-
-	ocrdma_ring_cq_db(dev, cq->id, false, false, 0);
 
 	if (cq->ibcq.comp_handler) {
 		spin_lock_irqsave(&cq->comp_handler_lock, flags); @@ -892,27 +886,35 @@ static irqreturn_t ocrdma_irq_handler(int irq, void *handle)
 	struct ocrdma_dev *dev = eq->dev;
 	struct ocrdma_eqe eqe;
 	struct ocrdma_eqe *ptr;
-	u16 eqe_popped = 0;
 	u16 cq_id;
-	while (1) {
+	int budget = eq->cq_cnt;
+
+	do {
 		ptr = ocrdma_get_eqe(eq);
 		eqe = *ptr;
 		ocrdma_le32_to_cpu(&eqe, sizeof(eqe));
 		if ((eqe.id_valid & OCRDMA_EQE_VALID_MASK) == 0)
 			break;
-		eqe_popped += 1;
+
 		ptr->id_valid = 0;
+		/* ring eq doorbell as soon as its consumed. */
+		ocrdma_ring_eq_db(dev, eq->q.id, false, true, 1);
 		/* check whether its CQE or not. */
 		if ((eqe.id_valid & OCRDMA_EQE_FOR_CQE_MASK) == 0) {
 			cq_id = eqe.id_valid >> OCRDMA_EQE_RESOURCE_ID_SHIFT;
 			ocrdma_cq_handler(dev, cq_id);
 		}
 		ocrdma_eq_inc_tail(eq);
-	}
-	ocrdma_ring_eq_db(dev, eq->q.id, true, true, eqe_popped);
-	/* Ring EQ doorbell with num_popped to 0 to enable interrupts again. */
-	if (dev->nic_info.intr_mode == BE_INTERRUPT_MODE_INTX)
-		ocrdma_ring_eq_db(dev, eq->q.id, true, true, 0);
+
+		/* There can be a stale EQE after the last bound CQ is
+		 * destroyed. EQE valid and budget == 0 implies this.
+		 */
+		if (budget)
+			budget--;
+
+	} while (budget);
+
+	ocrdma_ring_eq_db(dev, eq->q.id, true, true, 0);
 	return IRQ_HANDLED;
 }
 
@@ -1357,12 +1359,12 @@ static void ocrdma_unbind_eq(struct ocrdma_dev *dev, u16 eq_id)
 	int i;
 
 	mutex_lock(&dev->dev_lock);
-	for (i = 0; i < dev->eq_cnt; i++) {
-		if (dev->eq_tbl[i].q.id != eq_id)
-			continue;
-		dev->eq_tbl[i].cq_cnt -= 1;
-		break;
-	}
+
+	i = ocrdma_get_eq_table_index(dev, eq_id);
+	if (i == -EINVAL)
+		BUG();
+	dev->eq_tbl[i].cq_cnt -= 1;
+
 	mutex_unlock(&dev->dev_lock);
 }
 
@@ -1417,6 +1419,8 @@ int ocrdma_mbx_create_cq(struct ocrdma_dev *dev, struct ocrdma_cq *cq,
 	cq->eqn = ocrdma_bind_eq(dev);
 	cmd->cmd.req.rsvd_version = OCRDMA_CREATE_CQ_VER3;
 	cqe_count = cq->len / cqe_size;
+	cq->cqe_cnt = cqe_count;
+
 	if (cqe_count > 1024) {
 		/* Set cnt to 3 to indicate more than 1024 cq entries */
 		cmd->cmd.ev_cnt_flags |= (0x3 << OCRDMA_CREATE_CQ_CNT_SHIFT); @@ -1484,12 +1488,10 @@ int ocrdma_mbx_destroy_cq(struct ocrdma_dev *dev, struct ocrdma_cq *cq)
 	    (cq->id << OCRDMA_DESTROY_CQ_QID_SHIFT) &
 	    OCRDMA_DESTROY_CQ_QID_MASK;
 
-	ocrdma_unbind_eq(dev, cq->eqn);
 	status = ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
-	if (status)
-		goto mbx_err;
+	ocrdma_unbind_eq(dev, cq->eqn);
 	dma_free_coherent(&dev->nic_info.pdev->dev, cq->len, cq->va, cq->pa);
-mbx_err:
+
 	kfree(cmd);
 	return status;
 }
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 69f1d12..e07b8c5 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -927,9 +927,7 @@ struct ib_cq *ocrdma_create_cq(struct ib_device *ibdev, int entries, int vector,
 			goto ctx_err;
 	}
 	cq->phase = OCRDMA_CQE_VALID;
-	cq->arm_needed = true;
 	dev->cq_tbl[cq->id] = cq;
-
 	return &cq->ibcq;
 
 ctx_err:
@@ -952,13 +950,53 @@ int ocrdma_resize_cq(struct ib_cq *ibcq, int new_cnt,
 	return status;
 }
 
+void ocrdma_flush_cq(struct ocrdma_cq *cq) {
+	int cqe_cnt;
+	int valid_count = 0;
+	unsigned long flags;
+
+	struct ocrdma_dev *dev = get_ocrdma_dev(cq->ibcq.device);
+	struct ocrdma_cqe *cqe = NULL;
+
+	cqe = cq->va;
+	cqe_cnt = cq->cqe_cnt;
+
+	/* Last irq might have scheduled a polling thread
+	 * sync-up with it before hard flushing.
+	 */
+	spin_lock_irqsave(&cq->cq_lock, flags);
+	while (cqe_cnt) {
+		if (is_cqe_valid(cq, cqe))
+			valid_count++;
+		cqe++;
+		cqe_cnt--;
+	}
+	ocrdma_ring_cq_db(dev, cq->id, false, false, valid_count);
+	spin_unlock_irqrestore(&cq->cq_lock, flags); }
+
 int ocrdma_destroy_cq(struct ib_cq *ibcq)  {
 	int status;
 	struct ocrdma_cq *cq = get_ocrdma_cq(ibcq);
+	struct ocrdma_eq *eq = NULL;
 	struct ocrdma_dev *dev = get_ocrdma_dev(ibcq->device);
 	int pdid = 0;
+	u32 irq, indx;
 
+	dev->cq_tbl[cq->id] = NULL;
+
+	indx = ocrdma_get_eq_table_index(dev, cq->eqn);
+
+	if (indx == -EINVAL)
+		BUG();
+	eq = &dev->eq_tbl[indx];
+
+	irq = ocrdma_get_irq(dev, eq);
+	synchronize_irq(irq);
+
+	ocrdma_flush_cq(cq);
 	status = ocrdma_mbx_destroy_cq(dev, cq);
 
 	if (cq->ucontext) {
@@ -969,7 +1007,6 @@ int ocrdma_destroy_cq(struct ib_cq *ibcq)
 				ocrdma_get_db_addr(dev, pdid),
 				dev->nic_info.db_page_size);
 	}
-	dev->cq_tbl[cq->id] = NULL;
 
 	kfree(cq);
 	return status;
@@ -2706,10 +2743,17 @@ expand_cqe:
 	}
 stop_cqe:
 	cq->getp = cur_getp;
-	if (polled_hw_cqes || expand || stop) {
-		ocrdma_ring_cq_db(dev, cq->id, cq->armed, cq->solicited,
+	if (polled_hw_cqes && cq->deferred_arm) {
+		ocrdma_ring_cq_db(dev, cq->id, true, cq->deferred_sol,
+				  polled_hw_cqes);
+		cq->deferred_arm = false;
+		cq->deferred_sol = false;
+	} else if (polled_hw_cqes) {
+		/* We need to pop the CQE. No need to arm */
+		ocrdma_ring_cq_db(dev, cq->id, false, false,
 				  polled_hw_cqes);
 	}
+
 	return i;
 }
 
@@ -2784,25 +2828,37 @@ int ocrdma_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags cq_flags)
 	u16 cur_getp;
 	struct ocrdma_cqe *cqe;
 	unsigned long flags;
+	bool arm_needed = false, sol_needed = false;
 
 	cq_id = cq->id;
 
 	spin_lock_irqsave(&cq->cq_lock, flags);
 	if (cq_flags & IB_CQ_NEXT_COMP || cq_flags & IB_CQ_SOLICITED)
-		cq->armed = true;
+		arm_needed = true;
 	if (cq_flags & IB_CQ_SOLICITED)
-		cq->solicited = true;
+		sol_needed = true;
 
 	cur_getp = cq->getp;
 	cqe = cq->va + cur_getp;
 
 	/* check whether any valid cqe exist or not, if not then safe to
-	 * arm. If cqe is not yet consumed, then let it get consumed and then
-	 * we arm it to avoid false interrupts.
+	 * arm. If cqe is not yet consumed, then we defer arming until first
+	 * CQE is polled from CQ.
 	 */
-	if (!is_cqe_valid(cq, cqe) || cq->arm_needed) {
-		cq->arm_needed = false;
-		ocrdma_ring_cq_db(dev, cq_id, cq->armed, cq->solicited, 0);
+	if (!is_cqe_valid(cq, cqe)) {
+		ocrdma_ring_cq_db(dev, cq_id, arm_needed, sol_needed, 0);
+	} else {
+		if (!arm_needed) {
+			/* Arming not required. Just notify the CQ
+			 * for solicit requested.
+			 */
+			ocrdma_ring_cq_db(dev, cq_id, false, sol_needed, 0);
+			cq->deferred_sol = false;
+			cq->deferred_arm = false;
+		} else {
+			cq->deferred_arm = arm_needed;
+			cq->deferred_sol = sol_needed;
+		}
 	}
 	spin_unlock_irqrestore(&cq->cq_lock, flags);
 	return 0;
--
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
