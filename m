Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 797964F3EA8;
	Fri, 18 Sep 2026 14:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789740295; cv=none; b=MOfhNwCvWow954nPqG8i/WOC3Mdw32vpNEXZgmVx/1B/kr7soaIAg3sEt8sVPoZQEJtRgODe8gRDOIhO3CWY+jdNji4cNda1irFx8riswFr++oxy0ooyjciwZ2ew1MDij/39rQLJyS1n/BmHF2FXixRuprsLiaSfCqj/x6TEeTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789740295; c=relaxed/simple;
	bh=/JdKAnKJSOA7apsoSpJ8DCJyHVXTr5+OLwiRfO1hMmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UYKyE762aRSpyRfzbmQ8KE/b8D50krt1PvGP7mRj6W+r750qVkozzbOtRjl+3Xy70oIX2iqSRinoGOUhq7xBlOD8h7jM+9AXPC5LIFhn9LMhUPOxvArRtkwTPCBtuIpQFwM3DvpQjbJOeHVJMm8AvAuHi2wTEWpOpY8BuSxJfBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=ASBQ6f7q; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="ASBQ6f7q"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id D85B420B716B; Fri, 18 Sep 2026 07:04:07 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D85B420B716B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1789740247;
	bh=nn57R9DHwmtSrtNHgZ04QEG4fqJKYtK3tyfDWD2sFNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ASBQ6f7q4uWrcaUYWCVeCl5fum/2zn10seHfZSGwsKlodGd7qwDVws0+3BdH/K9Rk
	 RA3rZ73nUUJS7dOlp0BBhoodTE85rRoF5wMsaXflKQaRI50c2AeRExElsog5U3C7MP
	 Kp1QnrsRFhcWG1zne7jx59jriKzZMwO5MUZdRSPo=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v2 3/5] RDMA/mana_ib: Revise UD receive posting with GDMA_WR_IB_SGL
Date: Fri, 18 Sep 2026 07:04:05 -0700
Message-ID: <20260918140407.2922819-4-kotaranov@linux.microsoft.com>
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

Pass receive verbs SGEs directly to GDMA instead of copying them into
a small stack array. Accept the receive SGE limit, supply a dummy SGE
for zero-length requests, and ring once after each successful batch.

Introduce GDMA_WR_IB_SGL, its request union, and the wrap-aware verbs
SGE writer together with their first consumer. These shared GDMA pieces
must precede the later extended-WQE patch so this receive path does not
depend on definitions or encoding support introduced after it.

Address verbs SGEs by ring offset so both scattered-page boundaries and
ring wrap preserve the local kernel baseline's non-contiguous buffers.

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
---
 drivers/infiniband/hw/mana/wr.c               | 70 +++++++++++--------
 .../net/ethernet/microsoft/mana/gdma_main.c   | 23 +++++-
 include/net/mana/gdma.h                       |  7 +-
 3 files changed, 70 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/hw/mana/wr.c b/drivers/infiniband/hw/mana/wr.c
index f25df2fad..eb671b45b 100644
--- a/drivers/infiniband/hw/mana/wr.c
+++ b/drivers/infiniband/hw/mana/wr.c
@@ -7,29 +7,30 @@
 
 #define MAX_WR_SGL_NUM (2)
 
-static int mana_ib_post_recv_ud(struct mana_ib_qp *qp, const struct ib_recv_wr *wr)
+static int mana_ib_post_rq(struct mana_ib_qp *qp, const struct ib_recv_wr *wr)
 {
-	struct mana_ib_dev *mdev = container_of(qp->ibqp.device, struct mana_ib_dev, ib_dev);
-	struct gdma_queue *queue = qp->ud_qp.queues[MANA_UD_RECV_QUEUE].kmem;
+	struct ib_sge mana_ib_dummy_sge = {.addr = 1, .length = 0, .lkey = 0};
+	struct mana_ib_queue *ib_rq = mana_qp_get_rq(qp);
 	struct gdma_posted_wqe_info wqe_info = {0};
-	struct gdma_sge gdma_sgl[MAX_WR_SGL_NUM];
+	struct gdma_queue *queue = ib_rq->kmem;
 	struct gdma_wqe_request wqe_req = {0};
 	struct shadow_wqe_header *shadow_wqe;
-	int err, i;
+	int err;
 
 	if (shadow_queue_full(&qp->shadow_rq))
 		return -EINVAL;
 
-	if (wr->num_sge > MAX_WR_SGL_NUM)
+	if (wr->num_sge > MAX_RX_WQE_SGL_ENTRIES)
 		return -EINVAL;
 
-	for (i = 0; i < wr->num_sge; ++i) {
-		gdma_sgl[i].address = wr->sg_list[i].addr;
-		gdma_sgl[i].mem_key = wr->sg_list[i].lkey;
-		gdma_sgl[i].size = wr->sg_list[i].length;
-	}
 	wqe_req.num_sge = wr->num_sge;
-	wqe_req.sgl = gdma_sgl;
+	wqe_req.ib_sgl = wr->sg_list;
+	wqe_req.flags = GDMA_WR_IB_SGL;
+
+	if (wr->num_sge == 0) {
+		wqe_req.ib_sgl = &mana_ib_dummy_sge;
+		wqe_req.num_sge = 1;
+	}
 
 	err = mana_gd_post_work_request(queue, &wqe_req, &wqe_info);
 	if (err)
@@ -41,36 +42,49 @@ static int mana_ib_post_recv_ud(struct mana_ib_qp *qp, const struct ib_recv_wr *
 	shadow_wqe->wqe_size_in_bu = wqe_info.wqe_size_in_bu;
 	shadow_queue_advance_producer(&qp->shadow_rq);
 
-	mana_gd_wq_ring_doorbell(mdev_to_gc(mdev), queue);
 	return 0;
 }
 
-int mana_ib_post_recv(struct ib_qp *ibqp, const struct ib_recv_wr *wr,
-		      const struct ib_recv_wr **bad_wr)
+static int mana_ib_post_recv_ud(struct mana_ib_qp *qp, const struct ib_recv_wr *wr,
+				const struct ib_recv_wr **bad_wr)
 {
-	struct mana_ib_qp *qp = container_of(ibqp, struct mana_ib_qp, ibqp);
+	struct mana_ib_dev *mdev = container_of(qp->ibqp.device, struct mana_ib_dev, ib_dev);
+	struct mana_ib_queue *ib_rq = mana_qp_get_rq(qp);
+	struct gdma_queue *rq = ib_rq->kmem;
+	bool ring_rq = false;
 	int err = 0;
 
 	for (; wr; wr = wr->next) {
-		switch (ibqp->qp_type) {
-		case IB_QPT_UD:
-		case IB_QPT_GSI:
-			err = mana_ib_post_recv_ud(qp, wr);
-			if (unlikely(err)) {
-				*bad_wr = wr;
-				return err;
-			}
+		err = mana_ib_post_rq(qp, wr);
+		if (unlikely(err)) {
+			*bad_wr = wr;
 			break;
-		default:
-			ibdev_dbg(ibqp->device, "Posting recv wr on qp type %u is not supported\n",
-				  ibqp->qp_type);
-			return -EINVAL;
 		}
+		ring_rq = true;
 	}
 
+	if (ring_rq)
+		mana_gd_wq_ring_doorbell(mdev_to_gc(mdev), rq);
+
 	return err;
 }
 
+int mana_ib_post_recv(struct ib_qp *ibqp, const struct ib_recv_wr *wr,
+		      const struct ib_recv_wr **bad_wr)
+{
+	struct mana_ib_qp *qp = container_of(ibqp, struct mana_ib_qp, ibqp);
+
+	switch (ibqp->qp_type) {
+	case IB_QPT_UD:
+	case IB_QPT_GSI:
+		return mana_ib_post_recv_ud(qp, wr, bad_wr);
+	default:
+		/* Unsupported QP type */
+		*bad_wr = wr;
+		return -EINVAL;
+	}
+}
+
 static int mana_ib_post_send_ud_one(struct mana_ib_qp *qp, const struct ib_ud_wr *wr)
 {
 	struct mana_ib_dev *mdev = container_of(qp->ibqp.device, struct mana_ib_dev, ib_dev);
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index f92b2d0bf..542491a6c 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1738,6 +1738,24 @@ static void mana_gd_write_sgl(struct gdma_queue *wq, u32 sgl_offset,
 	memcpy(mana_gd_ring_ptr(wq, sgl_offset), address, sgl_size);
 }
 
+static void mana_gd_write_ib_sgl(struct gdma_queue *wq, u32 sgl_offset,
+				 const struct gdma_wqe_request *wqe_req)
+{
+	const struct ib_sge *sge = wqe_req->ib_sgl;
+	struct gdma_sge *gdma_sgl;
+	u32 i;
+
+	for (i = 0; i < wqe_req->num_sge; ++i, ++sge) {
+		gdma_sgl = mana_gd_ring_ptr(wq, sgl_offset);
+		gdma_sgl->address = sge->addr;
+		gdma_sgl->size = sge->length;
+		gdma_sgl->mem_key = sge->lkey;
+		sgl_offset += sizeof(*gdma_sgl);
+		if (sgl_offset == wq->queue_size)
+			sgl_offset = 0;
+	}
+}
+
 int mana_gd_post_work_request(struct gdma_queue *wq,
 			      const struct gdma_wqe_request *wqe_req,
 			      struct gdma_posted_wqe_info *wqe_info)
@@ -1792,7 +1810,10 @@ int mana_gd_post_work_request(struct gdma_queue *wq,
 	if (sgl_offset >= wq->queue_size)
 		sgl_offset -= wq->queue_size;
 
-	mana_gd_write_sgl(wq, sgl_offset, wqe_req);
+	if (wqe_req->flags & GDMA_WR_IB_SGL)
+		mana_gd_write_ib_sgl(wq, sgl_offset, wqe_req);
+	else
+		mana_gd_write_sgl(wq, sgl_offset, wqe_req);
 
 	wq->head += wqe_size / GDMA_WQE_BU_SIZE;
 
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index 06af65d50..8ccbe2d57 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -6,6 +6,7 @@
 
 #include <linux/dma-mapping.h>
 #include <linux/netdevice.h>
+#include <rdma/ib_verbs.h>
 
 #include "shm_channel.h"
 
@@ -54,6 +55,7 @@ enum gdma_work_request_flags {
 	GDMA_WR_NONE			= 0,
 	GDMA_WR_OOB_IN_SGL		= BIT(0),
 	GDMA_WR_PAD_BY_SGE0		= BIT(1),
+	GDMA_WR_IB_SGL			= BIT(2),
 };
 
 enum gdma_eqe_type {
@@ -212,7 +214,10 @@ struct gdma_sge {
 }; /* HW DATA */
 
 struct gdma_wqe_request {
-	struct gdma_sge *sgl;
+	union {
+		struct gdma_sge *sgl;
+		struct ib_sge *ib_sgl;
+	};
 	u32 num_sge;
 
 	u32 inline_oob_size;
-- 
2.43.0

