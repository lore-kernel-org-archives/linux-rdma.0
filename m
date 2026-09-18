Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 798434F68D7;
	Fri, 18 Sep 2026 14:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789740296; cv=none; b=QwU1uqNWmGxieRpvVmqUegDDZilDpJZ0XyKWRFOXJJv8lmFJRNEx/j7IXkOyAxu6/f2vFkxapz+aGIXmu2qxDMBO4Ve4QJdhSjLlqh2PkB2KT4YGUBjLrlWiruXopcU6nX62OfAgmOWJzCn9wfY2zt8/5VxE047JdV7AXYGoXj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789740296; c=relaxed/simple;
	bh=0yFu+r//xYtB5GtrS0ehTPNay0LJs6+Z827X/K/aINo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GDITTqmwmEDeV7+Se73RXqRrIMC1jS9jbyNSQgrRhvU0nv8Xdbrlu7B2ynHQeJc71cQItZC6tU/i2LW6hb+sV3UgHN/K8cd0WuX+b8eIBoltmgd3ehSg5pY3WLnPtT1CNq1ODeIpC2F687SWWw3YjBzQguScQsmdtloJQBVtJsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=ltBbWdif; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="ltBbWdif"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id E53DF20B716C; Fri, 18 Sep 2026 07:04:07 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E53DF20B716C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1789740247;
	bh=iCXR3iksiRM1v8CRw4fAQCv/6uqZljXWFz84TjXXoVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ltBbWdifcmwlWen+Pco+2vEaNxKpENUBTBfPwkUu2wZfTAMb8ltqMZ6Vz2Pjo3mjh
	 4BORmudqoTxPiqTvwg/XfypmPBvyYoD5cxxIOYaWjNn7EDdX+PN9cImV9GAJS3x3JS
	 jfeHL9kBhSRWXWMtesKMQnaRwAw+kSSpsU4lo+6s=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v2 4/5] RDMA/mana_ib: Make kernel CQ arming robust
Date: Fri, 18 Sep 2026 07:04:06 -0700
Message-ID: <20260918140407.2922819-5-kotaranov@linux.microsoft.com>
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

Track CQ polling credits across owner-bit wraps and serialize arming
with polling under cq_lock. Check the relevant owner bits before
advancing an outstanding arm, and update the hardware consumer position
when polling exhausts its credits.

Expose the allocated CQ capacity to the core. Pull the explicit-index
GDMA doorbell helper and its declaration forward here because CQ arming
is its first consumer; ordinary GDMA doorbells retain their zero client
offset. RC-specific PSN doorbell use is introduced later.

Preserve the baseline's dynamic interrupt moderation doorbell with a
zero client offset. Read CQ owner bits through the scattered backing
pages when the queue allocation falls back to non-contiguous memory.

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
---
 drivers/infiniband/hw/mana/cq.c               | 55 ++++++++++++++++++-
 drivers/infiniband/hw/mana/mana_ib.h          |  1 +
 .../net/ethernet/microsoft/mana/gdma_main.c   | 20 +++++--
 include/net/mana/gdma.h                       |  2 +
 4 files changed, 72 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana/cq.c
index 14a48409e..6764e2de0 100644
--- a/drivers/infiniband/hw/mana/cq.c
+++ b/drivers/infiniband/hw/mana/cq.c
@@ -64,6 +64,9 @@ int mana_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		doorbell = mdev->gdma_dev->doorbell;
 	}
 
+	ibcq->cqe = cq->cqe;
+	cq->poll_credit = (cq->cqe << (GDMA_CQE_OWNER_BITS - 1)) - 1;
+
 	if (is_rnic_cq) {
 		err = mana_ib_gd_create_cq(mdev, cq, doorbell);
 		if (err) {
@@ -174,15 +177,62 @@ void mana_ib_remove_cq_cb(struct mana_ib_dev *mdev, struct mana_ib_cq *cq)
 	gc->cq_table[cq->queue.id] = NULL;
 }
 
+static inline bool gdma_cq_idx_produced(struct gdma_queue *gdma_cq, uint32_t idx)
+{
+	struct gdma_mem_info *gmi = &gdma_cq->mem_info;
+	u32 num_cqe = gdma_cq->queue_size / GDMA_CQE_SIZE;
+	u32 expected_bits = (idx / num_cqe) & GDMA_CQE_OWNER_MASK;
+	u32 offset = (idx % num_cqe) * GDMA_CQE_SIZE;
+	struct gdma_cqe *cqe;
+
+	if (gmi->nr_pages)
+		cqe = gmi->pages_va[offset / PAGE_SIZE] +
+		      (offset & (PAGE_SIZE - 1));
+	else
+		cqe = gdma_cq->queue_mem_ptr + offset;
+
+	return cqe->cqe_info.owner_bits == expected_bits;
+}
+
+static inline void mana_ib_cq_doorbell(struct mana_ib_cq *cq, uint8_t arm)
+{
+	struct mana_ib_dev *mdev = container_of(cq->ibcq.device, struct mana_ib_dev, ib_dev);
+	struct gdma_queue *gdma_cq = cq->queue.kmem;
+	u32 num_cqe, max_credit, idx;
+
+	num_cqe = gdma_cq->queue_size / GDMA_CQE_SIZE;
+	max_credit = num_cqe << (GDMA_CQE_OWNER_BITS - 1);
+	idx = gdma_cq->head;
+
+	if (cq->poll_credit >= max_credit) {
+		if (gdma_cq_idx_produced(gdma_cq, idx + cq->poll_credit - max_credit))
+			cq->poll_credit++;
+		else
+			return;
+	} else {
+		/* Set index of already polled CQE for unarm */
+		cq->poll_credit = max_credit - (arm ? 0 : 1);
+	}
+
+	idx += (cq->poll_credit - max_credit);
+	idx %= (num_cqe << GDMA_CQE_OWNER_BITS);
+
+	mana_gd_wq_ring_doorbell_ext(mdev_to_gc(mdev), gdma_cq, idx, arm, 0);
+}
+
 int mana_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
 {
 	struct mana_ib_cq *cq = container_of(ibcq, struct mana_ib_cq, ibcq);
 	struct gdma_queue *gdma_cq = cq->queue.kmem;
+	unsigned long irq_flags;
 
 	if (!gdma_cq)
 		return -EINVAL;
 
-	mana_gd_ring_cq(gdma_cq, SET_ARM_BIT);
+	spin_lock_irqsave(&cq->cq_lock, irq_flags);
+	mana_ib_cq_doorbell(cq, SET_ARM_BIT);
+	spin_unlock_irqrestore(&cq->cq_lock, irq_flags);
+
 	return 0;
 }
 
@@ -343,6 +393,9 @@ int mana_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 		comp_read = mana_gd_poll_cq(queue, &gdma_cqe, 1);
 		if (comp_read < 1)
 			break;
+		cq->poll_credit--;
+		if (!cq->poll_credit)
+			mana_ib_cq_doorbell(cq, 0);
 		mana_handle_cqe(mdev, &gdma_cqe);
 	}
 
diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw/mana/mana_ib.h
index 619578f16..0ad757990 100644
--- a/drivers/infiniband/hw/mana/mana_ib.h
+++ b/drivers/infiniband/hw/mana/mana_ib.h
@@ -170,6 +170,7 @@ struct mana_ib_cq {
 	struct list_head list_recv_qp;
 	int cqe;
 	u32 comp_vector;
+	u32 poll_credit;
 	mana_handle_t  cq_handle;
 };
 
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 542491a6c..cb51fcf57 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -559,11 +559,13 @@ static int mana_gd_disable_queue(struct gdma_queue *queue)
 
 static void mana_gd_ring_doorbell(struct gdma_context *gc, u32 db_index,
 				  enum gdma_queue_type q_type, u32 qid,
-				  u32 tail_ptr, u8 num_req)
+				  u32 tail_ptr, u8 num_req, u8 client_offset)
 {
 	void __iomem *addr = gc->db_page_base + gc->db_page_size * db_index;
 	union gdma_doorbell_entry e = {};
 
+	addr += client_offset;
+
 	switch (q_type) {
 	case GDMA_EQ:
 		e.eq.id = qid;
@@ -623,10 +625,18 @@ void mana_gd_wq_ring_doorbell(struct gdma_context *gc, struct gdma_queue *queue)
 	 * wqe_cnt for Receive Queues. This value is not used in Send Queues.
 	 */
 	mana_gd_ring_doorbell(gc, queue->gdma_dev->doorbell, queue->type,
-			      queue->id, queue->head * GDMA_WQE_BU_SIZE, 0);
+			      queue->id, queue->head * GDMA_WQE_BU_SIZE, 0, 0);
 }
 EXPORT_SYMBOL_NS(mana_gd_wq_ring_doorbell, "NET_MANA");
 
+void mana_gd_wq_ring_doorbell_ext(struct gdma_context *gc, struct gdma_queue *queue,
+				  u32 tail_ptr, u8 wqe_cnt, u8 client_offset)
+{
+	mana_gd_ring_doorbell(gc, queue->gdma_dev->doorbell, queue->type,
+			      queue->id, tail_ptr, wqe_cnt, client_offset);
+}
+EXPORT_SYMBOL_NS(mana_gd_wq_ring_doorbell_ext, "NET_MANA");
+
 void mana_gd_ring_cq(struct gdma_queue *cq, u8 arm_bit)
 {
 	struct gdma_context *gc = cq->gdma_dev->gdma_context;
@@ -636,7 +646,7 @@ void mana_gd_ring_cq(struct gdma_queue *cq, u8 arm_bit)
 	u32 head = cq->head % (num_cqe << GDMA_CQE_OWNER_BITS);
 
 	mana_gd_ring_doorbell(gc, cq->gdma_dev->doorbell, cq->type, cq->id,
-			      head, arm_bit);
+			      head, arm_bit, 0);
 }
 EXPORT_SYMBOL_NS(mana_gd_ring_cq, "NET_MANA");
 
@@ -653,7 +663,7 @@ void mana_gd_ring_dim(struct gdma_queue *cq, u32 mod_usec, bool mod_usec_vld,
 		dim_val |= MANA_INTR_MODR_USEC_VLD;
 
 	mana_gd_ring_doorbell(gc, cq->gdma_dev->doorbell, GDMA_DIM, cq->id,
-			      dim_val, mod_comps_vld);
+			      dim_val, mod_comps_vld, 0);
 }
 EXPORT_SYMBOL_NS(mana_gd_ring_dim, "NET_MANA");
 
@@ -1023,7 +1033,7 @@ static void mana_gd_process_eq_events(void *arg)
 	head = eq->head % (num_eqe << GDMA_EQE_OWNER_BITS);
 
 	mana_gd_ring_doorbell(gc, eq->gdma_dev->doorbell, eq->type, eq->id,
-			      head, SET_ARM_BIT);
+			      head, SET_ARM_BIT, 0);
 }
 
 static int mana_gd_register_irq(struct gdma_queue *queue,
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index 8ccbe2d57..02632acd7 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -1068,6 +1068,8 @@ void mana_gd_free_res_map(struct gdma_resource *r);
 
 void mana_gd_wq_ring_doorbell(struct gdma_context *gc,
 			      struct gdma_queue *queue);
+void mana_gd_wq_ring_doorbell_ext(struct gdma_context *gc, struct gdma_queue *queue,
+				  u32 tail_ptr, u8 wqe_cnt, u8 client_offset);
 
 int mana_gd_alloc_memory(struct gdma_context *gc, unsigned int length,
 			 struct gdma_mem_info *gmi, bool allow_scatter);
-- 
2.43.0

