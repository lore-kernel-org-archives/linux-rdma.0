Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90E474570E4;
	Thu,  1 Oct 2026 18:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790878875; cv=none; b=QoLd+oVNQqeQga3vOFdS0ZGMKpVngilhzjGL2BacEGaZInnMs6rNAn0x/0T2VYkysbSlscLYcderDc34mL76fWD/rlclzchOyeBPTLqI6vubYNVynAfs7xQ9hI5aAv/TkcXCazkN4dDzQ4zPU/T05IK/h5mP6c8kewA680ujmI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790878875; c=relaxed/simple;
	bh=UgrpUH5sycxhlxh+mpHdPaRap4dO64bg5pHV0pB8oEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjyaiRDT+85YRjFUZccpe+TCqBoO28b1W48TE5bZsFXdlbUrJOEm1q/+3NVMSrxlXSy5g1xwBk3nu4K9C09FG+CJ7p39G8GSvu+//9vsoKG7oiv6nw26X5INGVYN5/EXKCj4q7I61qJYqqzKDFnt4YSBcMJxfPq5bDr65R9QR34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=jUEpLVX8; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="jUEpLVX8"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id 3862220B716A; Thu,  1 Oct 2026 11:20:16 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3862220B716A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1790878816;
	bh=sBvGlDcSPyScHTc6Pc0xCfSDN0jlOwtOHTkHxOmkNqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jUEpLVX8DYnDgaldCuh3N9IPjUWOzuB1wgJG9iapZp2shE1RMfX++J+1yQa5F1hrP
	 ELTrvUY61FmWciFBqhZq74oA0JQSpGwTgC/CE6Xo92kb/R9ODFPXaUpNqu4TVYVABI
	 vfv6tzXo8naUdGzxjw4XLaNDVH2P6oE1OLJ6XDak=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next 04/10] RDMA/mana_ib: Maintain kernel RC QP state
Date: Thu,  1 Oct 2026 11:20:09 -0700
Message-ID: <20261001182015.1757203-5-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261001182015.1757203-1-kotaranov@linux.microsoft.com>
References: <20261001182015.1757203-1-kotaranov@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Konstantin Taranov <kotaranov@microsoft.com>

Update mana_ib_modify_qp_state() to support RC QPs. Initialize the
packet, message, and frame counters for use by work requests.

Arm the requester receive queue at the initial PSN so that a CQE is
generated when the specified PSN is acknowledged, indicating send
completions.

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
---
 drivers/infiniband/hw/mana/mana_ib.h |  5 +++++
 drivers/infiniband/hw/mana/qp.c      | 23 ++++++++++++++++++++---
 include/net/mana/gdma.h              |  2 ++
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw/mana/mana_ib.h
index 61af35bf0e40..f8d9feee0abe 100644
--- a/drivers/infiniband/hw/mana/mana_ib.h
+++ b/drivers/infiniband/hw/mana/mana_ib.h
@@ -263,7 +263,12 @@ struct mana_ib_qp {
 	/* The port on the IB device, starting with 1 */
 	u32 port;
 	u32 sq_psn;
+	u32 sq_ssn;
+	u32 sq_fsn;
+	u16 sq_rsn;
+	bool pending_mmq_fence;
 	bool sq_sig_all;
+	enum ib_mtu mtu;
 
 	/* Serializes receive WR posting. */
 	spinlock_t rq_lock;
diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
index 1dc5b078b4ff..f5611fd30efe 100644
--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -744,8 +744,10 @@ static void mana_remove_qp_from_cqs(struct mana_ib_qp *qp, bool reset)
 	spin_lock_irqsave(&send_cq->cq_lock, flags);
 	list_del_init(&qp->send_err_node);
 	/* Keep shadow reset serialized with hardware polling and SW flushing. */
-	if (reset)
+	if (reset) {
 		reset_shadow_queue(&qp->shadow_sq);
+		reset_shadow_queue(&qp->shadow_mmq);
+	}
 	spin_unlock_irqrestore(&send_cq->cq_lock, flags);
 
 	spin_lock_irqsave(&recv_cq->cq_lock, flags);
@@ -1028,11 +1030,16 @@ static int mana_ib_gd_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 static void mana_ib_modify_qp_state(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 				    int attr_mask, struct ib_udata *udata)
 {
+	struct mana_ib_dev *mdev = container_of(ibqp->device, struct mana_ib_dev, ib_dev);
 	struct mana_ib_qp *qp = container_of(ibqp, struct mana_ib_qp, ibqp);
+	struct gdma_queue *rq;
 
 	if (udata)
 		return;
 
+	if (attr_mask & IB_QP_PATH_MTU)
+		qp->mtu = attr->path_mtu;
+
 	if (attr_mask & IB_QP_STATE) {
 		switch (attr->qp_state) {
 		case IB_QPS_RESET:
@@ -1043,8 +1050,19 @@ static void mana_ib_modify_qp_state(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		}
 	}
 
-	if (attr_mask & IB_QP_SQ_PSN)
+	if (attr_mask & IB_QP_SQ_PSN) {
+		qp->sq_ssn = 1;
+		qp->sq_rsn = 1;
+		qp->sq_fsn = 1;
 		qp->sq_psn = attr->sq_psn;
+		qp->pending_mmq_fence = false;
+
+		if (qp->ibqp.qp_type == IB_QPT_RC) {
+			rq = qp->rc_qp.queues[MANA_RC_RECV_QUEUE_REQUESTER].kmem;
+			mana_gd_wq_ring_doorbell_ext(mdev_to_gc(mdev), rq, attr->sq_psn,
+						     SET_ARM_BIT, MANA_PSN_CLIENT_OFFSET);
+		}
+	}
 }
 
 int mana_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
@@ -1057,7 +1075,6 @@ int mana_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 
 	switch (ibqp->qp_type) {
 	case IB_QPT_RC:
-	case IB_QPT_UC:
 	case IB_QPT_UD:
 	case IB_QPT_GSI:
 		ret = mana_ib_gd_modify_qp(ibqp, attr, attr_mask, udata);
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index 508da28591ae..fd0ec8fc44d5 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -605,6 +605,8 @@ struct gdma_cqe {
 
 #define GDMA_EQE_OWNER_BITS 3
 
+#define MANA_PSN_CLIENT_OFFSET 0x8
+
 union gdma_eqe_info {
 	u32 as_uint32;
 
-- 
2.43.0

