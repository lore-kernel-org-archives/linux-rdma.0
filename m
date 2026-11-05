Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793901584;
	b=t448BbH/RAxKkxnV5R/Y7fkSmgBXd2F3B392VSqFmsOKqKBlw57CX+y9DClEUUtwH5yN
	 f+UafEzTVhEgJDbNHP7Z0Avt+V126CLDTcnjq8I52WrMqD0JSb524oOyH0pQ3rxBYmRjj
	 aNwtRXuZQfyRSUENxXL6XWOYLdppTF3Qm+DUaV6sDJMOJrWHKH9DdSI3XKy70FlSieQFE
	 QILqsK2TXGQkjbiptyc+Ks2hJ1fdW6iau5sqqniMi7cb1ilQw0L/mqLWAff0WB+bc0o6K
	 bHrdOTw3JSDdIlHWNrHPGyfzRijFyw2WpJhuTSagFvVELlYBFuwZO5HmNqJqK92v9fQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793901584;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=HwW40vo2o/uGDLbu7g1/rFGvFLAyIo2hkK9JwAuJaX4=;
	b=cALlR3zCIV0h3kD4CfWj0tfxbTx8qKbwwTvdGCV3moWXOTm8yorBecGB2oD7rZXWMFSS
	 MUI6Tc9fX0SH4FKi3xAh7PIsCRZ+opIQGcMk1wGJGJZftZZRU2eE3vqXI8ITt3G5Zf++l
	 DeEatxv3O7M2qqyO9LaCp+N6ZkpBcX9Qinz4SGiUmNPHWoOJQknYNXWTNuT68YGvgOa9m
	 /DHLM7vcm+Rokruhl9YDJ3po7TWfRuBuZRgbaoo35HhXnzxvnbXKHWhtJTo111nzanKzN
	 ojqNTDQqv094yALYBeUQv8P++2zDM9VD/ZdmzkQlgeUaN6bHEMy1oa2xL5oZXubsMvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=Cg1qdS4h;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BBFF606A32E;
	Thu,  5 Nov 2026 17:59:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8BBFF606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=Cg1qdS4h
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id A2C0C20B716A; Thu,  5 Nov 2026 09:59:28 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A2C0C20B716A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1793901568;
	bh=HwW40vo2o/uGDLbu7g1/rFGvFLAyIo2hkK9JwAuJaX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cg1qdS4hiiXaRq8orcEo7B+hlHRIxshVapBS5AnJQJN0GKlRJLixu6OUrofNyG82C
	 VIuZh3IwkuH3GyFF1c9v6dorUVM61834/TpNzVa8cBJ7zaeRPHvxzEsNZsVR1Qo0TT
	 e3MISGgaBfndNNK/0CPXDH23ZCziDu/pk5btKm00=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v9 4/9] RDMA/mana_ib: Maintain kernel RC QP state
Date: Thu,  5 Nov 2026 09:59:23 -0800
Message-ID: <20261105175928.1326682-5-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261105175928.1326682-1-kotaranov@linux.microsoft.com>
References: <20261105175928.1326682-1-kotaranov@linux.microsoft.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
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
v2:
- Preserve IB_QPT_UC handling in mana_ib_modify_qp().

 drivers/infiniband/hw/mana/mana_ib.h |  5 +++++
 drivers/infiniband/hw/mana/qp.c      | 22 ++++++++++++++++++++--
 include/net/mana/gdma.h              |  2 ++
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw/mana/mana_ib.h
index 6f5df64e838a..1094429af801 100644
--- a/drivers/infiniband/hw/mana/mana_ib.h
+++ b/drivers/infiniband/hw/mana/mana_ib.h
@@ -265,7 +265,12 @@ struct mana_ib_qp {
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
index 387586c45aa0..5d6f45b9f53d 100644
--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -779,8 +779,10 @@ static void mana_remove_qp_from_cqs(struct mana_ib_qp *qp, bool reset)
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
@@ -1071,11 +1073,16 @@ static int mana_ib_gd_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
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
@@ -1086,8 +1093,19 @@ static void mana_ib_modify_qp_state(struct ib_qp *ibqp, struct ib_qp_attr *attr,
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

