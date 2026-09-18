Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79B404F7CD8;
	Fri, 18 Sep 2026 14:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789740296; cv=none; b=X3YD74HZaZbM0kRbKzhq2YluF1UiZF9e1b0jOFXvwKzJJkYVz7DxFh4aoLmP3p7Xad7/iljGPLH/uwOkT2yWJ7Z6ZY5FtJG7s3uJ+63kaSgghB6WpqoyU0Q8iGDj37GqOtzVKXJeXuOprFGO3iYtOhpehclkK/IFvA42GIcG8us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789740296; c=relaxed/simple;
	bh=jVFQhip/vlw8TJw/t9/1X4W3NVCUqLzpQWcjRqP1jqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oR5YSPu+NShf+vKIpKMndMBvpogki8dCmLFsCWfjBSZ1SlgYRnMkPVg45+HiKAo1007/mB5xC+y1fx9QOUVaO9ArszNoDUFLzcdziHzRGmz4GhEEpfBIfyYjrNtwwE0oIf9APoGsUalNyeUDg23TvwBe8FArai/EAYzzc+nDK/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Q19yaMVS; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Q19yaMVS"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id BEE1A20B7167; Fri, 18 Sep 2026 07:04:07 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BEE1A20B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1789740247;
	bh=pRq1CODKPIP7+gzmFoT9WbJ4eZOBgp1PAQeF0Ypg6qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q19yaMVSh+X0HGZw6IBzyk+/PWYiWHXFmHOkGTCnUrUgp4MgANf8OYw/NWzdecinm
	 umncwDp+M7xMhvex04hzrXUy34lBilvuWI4mQH24FCyBBbAe6/dY4g7u0XdvWUNWGf
	 0II5p1jlCpW3/+71UXzNt9KJ1s6RGprLgoPvduWo=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v2 1/5] RDMA/mana_ib: Optimize shadow queue bookkeeping
Date: Fri, 18 Sep 2026 07:04:03 -0700
Message-ID: <20260918140407.2922819-2-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260918140407.2922819-1-kotaranov@linux.microsoft.com>
References: <20260918140407.2922819-1-kotaranov@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Konstantin Taranov <kotaranov@microsoft.com>

Use compact bitfields for the posted WQE size and send opcode. Flatten
the UD receive shadow entry into the common shadow_wqe_header, retaining
byte_len, src_qpn and the cached status until direct-CQE polling replaces
their readers. Use this common entry for both send and receive queues,
including allocation, posting, CQE handling and WC generation. Derive
the receive WC opcode from the queue rather than storing it per WQE.

Publish initialized entries and release consumed entries with matching
release/acquire operations so posting and polling can run on different
CPUs. Retain the legacy completion cursor until direct-CQE polling and
software flush lists replace it.

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
---
 drivers/infiniband/hw/mana/cq.c           | 35 ++++++++++++-----------
 drivers/infiniband/hw/mana/qp.c           |  4 +--
 drivers/infiniband/hw/mana/shadow_queue.h | 29 +++++++++----------
 drivers/infiniband/hw/mana/wr.c           | 15 +++++-----
 4 files changed, 40 insertions(+), 43 deletions(-)

diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana/cq.c
index 6f9ac8b4a..14a48409e 100644
--- a/drivers/infiniband/hw/mana/cq.c
+++ b/drivers/infiniband/hw/mana/cq.c
@@ -190,15 +190,15 @@ static inline void handle_ud_sq_cqe(struct mana_ib_qp *qp, struct gdma_comp *cqe
 {
 	struct mana_rdma_cqe *rdma_cqe = (struct mana_rdma_cqe *)cqe->cqe_data;
 	struct gdma_queue *wq = qp->ud_qp.queues[MANA_UD_SEND_QUEUE].kmem;
-	struct ud_sq_shadow_wqe *shadow_wqe;
+	struct shadow_wqe_header *shadow_wqe;
 
 	shadow_wqe = shadow_queue_get_next_to_complete(&qp->shadow_sq);
 	if (!shadow_wqe)
 		return;
 
-	shadow_wqe->header.error_code = rdma_cqe->ud_send.vendor_error;
+	shadow_wqe->error_code = rdma_cqe->ud_send.vendor_error;
 
-	wq->tail += shadow_wqe->header.posted_wqe_size;
+	wq->tail += shadow_wqe->wqe_size_in_bu;
 	shadow_queue_advance_next_to_complete(&qp->shadow_sq);
 }
 
@@ -206,7 +206,7 @@ static inline void handle_ud_rq_cqe(struct mana_ib_qp *qp, struct gdma_comp *cqe
 {
 	struct mana_rdma_cqe *rdma_cqe = (struct mana_rdma_cqe *)cqe->cqe_data;
 	struct gdma_queue *wq = qp->ud_qp.queues[MANA_UD_RECV_QUEUE].kmem;
-	struct ud_rq_shadow_wqe *shadow_wqe;
+	struct shadow_wqe_header *shadow_wqe;
 
 	shadow_wqe = shadow_queue_get_next_to_complete(&qp->shadow_rq);
 	if (!shadow_wqe)
@@ -214,9 +214,9 @@ static inline void handle_ud_rq_cqe(struct mana_ib_qp *qp, struct gdma_comp *cqe
 
 	shadow_wqe->byte_len = rdma_cqe->ud_recv.msg_len;
 	shadow_wqe->src_qpn = rdma_cqe->ud_recv.src_qpn;
-	shadow_wqe->header.error_code = IB_WC_SUCCESS;
+	shadow_wqe->error_code = IB_WC_SUCCESS;
 
-	wq->tail += shadow_wqe->header.posted_wqe_size;
+	wq->tail += shadow_wqe->wqe_size_in_bu;
 	shadow_queue_advance_next_to_complete(&qp->shadow_rq);
 }
 
@@ -238,21 +238,20 @@ static void mana_handle_cqe(struct mana_ib_dev *mdev, struct gdma_comp *cqe)
 }
 
 static void fill_verbs_from_shadow_wqe(struct mana_ib_qp *qp, struct ib_wc *wc,
-				       const struct shadow_wqe_header *shadow_wqe)
+				       const struct shadow_wqe_header *shadow_wqe,
+				       enum ib_wc_opcode opcode)
 {
-	const struct ud_rq_shadow_wqe *ud_wqe = (const struct ud_rq_shadow_wqe *)shadow_wqe;
-
 	wc->wr_id = shadow_wqe->wr_id;
 	wc->status = shadow_wqe->error_code;
-	wc->opcode = shadow_wqe->opcode;
+	wc->opcode = opcode;
 	wc->vendor_err = shadow_wqe->error_code;
 	wc->wc_flags = 0;
 	wc->qp = &qp->ibqp;
 	wc->pkey_index = 0;
 
-	if (shadow_wqe->opcode == IB_WC_RECV) {
-		wc->byte_len = ud_wqe->byte_len;
-		wc->src_qp = ud_wqe->src_qpn;
+	if (opcode == IB_WC_RECV) {
+		wc->byte_len = shadow_wqe->byte_len;
+		wc->src_qp = shadow_wqe->src_qpn;
 		wc->wc_flags |= IB_WC_GRH;
 	}
 }
@@ -270,7 +269,8 @@ static int mana_process_completions(struct mana_ib_cq *cq, int nwc, struct ib_wc
 			if (wc_index >= nwc)
 				goto out;
 
-			fill_verbs_from_shadow_wqe(qp, &wc[wc_index], shadow_wqe);
+			fill_verbs_from_shadow_wqe(qp, &wc[wc_index], shadow_wqe,
+						   shadow_wqe->send_opcode);
 			shadow_queue_advance_consumer(&qp->shadow_sq);
 			wc_index++;
 		}
@@ -283,7 +283,8 @@ static int mana_process_completions(struct mana_ib_cq *cq, int nwc, struct ib_wc
 			if (wc_index >= nwc)
 				goto out;
 
-			fill_verbs_from_shadow_wqe(qp, &wc[wc_index], shadow_wqe);
+			fill_verbs_from_shadow_wqe(qp, &wc[wc_index], shadow_wqe,
+						   IB_WC_RECV);
 			shadow_queue_advance_consumer(&qp->shadow_rq);
 			wc_index++;
 		}
@@ -296,13 +297,13 @@ static int mana_process_completions(struct mana_ib_cq *cq, int nwc, struct ib_wc
 static void mana_drain_gsi_sq(struct mana_ib_qp *qp)
 {
 	struct mana_ib_cq *cq = container_of(qp->ibqp.send_cq, struct mana_ib_cq, ibcq);
-	struct ud_sq_shadow_wqe *shadow_wqe;
+	struct shadow_wqe_header *shadow_wqe;
 	unsigned long flags;
 
 	spin_lock_irqsave(&cq->cq_lock, flags);
 	while ((shadow_wqe = shadow_queue_get_next_to_complete(&qp->shadow_sq))
 			!= NULL) {
-		shadow_wqe->header.error_code = IB_WC_GENERAL_ERR;
+		shadow_wqe->error_code = IB_WC_GENERAL_ERR;
 		shadow_queue_advance_next_to_complete(&qp->shadow_sq);
 	}
 	spin_unlock_irqrestore(&cq->cq_lock, flags);
diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
index fac43b3a5..79c9cc944 100644
--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -748,13 +748,13 @@ static int mana_ib_create_ud_qp(struct ib_qp *ibqp, struct ib_pd *ibpd,
 	doorbell = mdev->gdma_dev->doorbell;
 
 	err = create_shadow_queue(&qp->shadow_rq, attr->cap.max_recv_wr,
-				  sizeof(struct ud_rq_shadow_wqe));
+				  sizeof(struct shadow_wqe_header));
 	if (err) {
 		ibdev_err(&mdev->ib_dev, "Failed to create shadow rq err %d\n", err);
 		goto destroy_queues;
 	}
 	err = create_shadow_queue(&qp->shadow_sq, attr->cap.max_send_wr,
-				  sizeof(struct ud_sq_shadow_wqe));
+				  sizeof(struct shadow_wqe_header));
 	if (err) {
 		ibdev_err(&mdev->ib_dev, "Failed to create shadow sq err %d\n", err);
 		goto destroy_shadow_queues;
diff --git a/drivers/infiniband/hw/mana/shadow_queue.h b/drivers/infiniband/hw/mana/shadow_queue.h
index a4b3818f9..a127edf7a 100644
--- a/drivers/infiniband/hw/mana/shadow_queue.h
+++ b/drivers/infiniband/hw/mana/shadow_queue.h
@@ -7,22 +7,14 @@
 #define _MANA_SHADOW_QUEUE_H_
 
 struct shadow_wqe_header {
-	u16 opcode;
-	u16 error_code;
-	u32 posted_wqe_size;
 	u64 wr_id;
-};
-
-struct ud_rq_shadow_wqe {
-	struct shadow_wqe_header header;
+	u64 wqe_size_in_bu : 8;
+	u64 send_opcode : 4;
+	u64 error_code : 16;
 	u32 byte_len;
 	u32 src_qpn;
 };
 
-struct ud_sq_shadow_wqe {
-	struct shadow_wqe_header header;
-};
-
 struct shadow_queue {
 	/* Unmasked producer index, Incremented on wqe posting */
 	u64 prod_idx;
@@ -57,12 +49,14 @@ static inline void destroy_shadow_queue(struct shadow_queue *queue)
 
 static inline bool shadow_queue_full(struct shadow_queue *queue)
 {
-	return (queue->prod_idx - queue->cons_idx) >= queue->length;
+	/* Do not reuse an entry until the poller has finished reading it. */
+	return (queue->prod_idx - smp_load_acquire(&queue->cons_idx)) >= queue->length;
 }
 
 static inline bool shadow_queue_empty(struct shadow_queue *queue)
 {
-	return queue->prod_idx == queue->cons_idx;
+	/* Pair with posting's release of the initialized shadow WQE. */
+	return smp_load_acquire(&queue->prod_idx) == queue->cons_idx;
 }
 
 static inline void *
@@ -91,7 +85,8 @@ shadow_queue_get_next_to_consume(const struct shadow_queue *queue)
 static inline void *
 shadow_queue_get_next_to_complete(struct shadow_queue *queue)
 {
-	if (queue->next_to_complete_idx == queue->prod_idx)
+	/* Observe initialized WQE fields published by the posting CPU. */
+	if (queue->next_to_complete_idx == smp_load_acquire(&queue->prod_idx))
 		return NULL;
 
 	return shadow_queue_get_element(queue, queue->next_to_complete_idx);
@@ -99,12 +94,14 @@ shadow_queue_get_next_to_complete(struct shadow_queue *queue)
 
 static inline void shadow_queue_advance_producer(struct shadow_queue *queue)
 {
-	queue->prod_idx++;
+	/* Publish all WQE fields to CQ polling on another CPU. */
+	smp_store_release(&queue->prod_idx, queue->prod_idx + 1);
 }
 
 static inline void shadow_queue_advance_consumer(struct shadow_queue *queue)
 {
-	queue->cons_idx++;
+	/* Finish WC generation and queue-tail updates before allowing reuse. */
+	smp_store_release(&queue->cons_idx, queue->cons_idx + 1);
 }
 
 static inline void shadow_queue_advance_next_to_complete(struct shadow_queue *queue)
diff --git a/drivers/infiniband/hw/mana/wr.c b/drivers/infiniband/hw/mana/wr.c
index 36a1d506f..8cd2980d4 100644
--- a/drivers/infiniband/hw/mana/wr.c
+++ b/drivers/infiniband/hw/mana/wr.c
@@ -14,7 +14,7 @@ static int mana_ib_post_recv_ud(struct mana_ib_qp *qp, const struct ib_recv_wr *
 	struct gdma_posted_wqe_info wqe_info = {0};
 	struct gdma_sge gdma_sgl[MAX_WR_SGL_NUM];
 	struct gdma_wqe_request wqe_req = {0};
-	struct ud_rq_shadow_wqe *shadow_wqe;
+	struct shadow_wqe_header *shadow_wqe;
 	int err, i;
 
 	if (shadow_queue_full(&qp->shadow_rq))
@@ -37,9 +37,8 @@ static int mana_ib_post_recv_ud(struct mana_ib_qp *qp, const struct ib_recv_wr *
 
 	shadow_wqe = shadow_queue_producer_entry(&qp->shadow_rq);
 	memset(shadow_wqe, 0, sizeof(*shadow_wqe));
-	shadow_wqe->header.opcode = IB_WC_RECV;
-	shadow_wqe->header.wr_id = wr->wr_id;
-	shadow_wqe->header.posted_wqe_size = wqe_info.wqe_size_in_bu;
+	shadow_wqe->wr_id = wr->wr_id;
+	shadow_wqe->wqe_size_in_bu = wqe_info.wqe_size_in_bu;
 	shadow_queue_advance_producer(&qp->shadow_rq);
 
 	mana_gd_wq_ring_doorbell(mdev_to_gc(mdev), queue);
@@ -82,7 +81,7 @@ static int mana_ib_post_send_ud(struct mana_ib_qp *qp, const struct ib_ud_wr *wr
 	struct gdma_posted_wqe_info wqe_info = {0};
 	struct gdma_wqe_request wqe_req = {0};
 	struct rdma_send_oob send_oob = {0};
-	struct ud_sq_shadow_wqe *shadow_wqe;
+	struct shadow_wqe_header *shadow_wqe;
 	int err, i;
 
 	if (!ndev) {
@@ -132,9 +131,9 @@ static int mana_ib_post_send_ud(struct mana_ib_qp *qp, const struct ib_ud_wr *wr
 	qp->ud_qp.sq_psn++;
 	shadow_wqe = shadow_queue_producer_entry(&qp->shadow_sq);
 	memset(shadow_wqe, 0, sizeof(*shadow_wqe));
-	shadow_wqe->header.opcode = IB_WC_SEND;
-	shadow_wqe->header.wr_id = wr->wr.wr_id;
-	shadow_wqe->header.posted_wqe_size = wqe_info.wqe_size_in_bu;
+	shadow_wqe->send_opcode = IB_WC_SEND;
+	shadow_wqe->wr_id = wr->wr.wr_id;
+	shadow_wqe->wqe_size_in_bu = wqe_info.wqe_size_in_bu;
 	shadow_queue_advance_producer(&qp->shadow_sq);
 
 	mana_gd_wq_ring_doorbell(mdev_to_gc(mdev), queue);
-- 
2.43.0

