Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99A633E024B;
	Sat, 10 Oct 2026 06:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791615288; cv=none; b=mYBnKW9xXhblLQF/jH4TELsdwDJodqPJhUT/EYxH3MB3FA7Y7suIuqS/CxWuraPpNfNY8EwveERXSObcUrPmkd/TpN98ChtJE87Uo6YNmK4pBgp6m5XrkxSGaxltVmOCTPTM/p9xJeIQEQeNV1yPQUkmhirNxV4q+ud0d970FNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791615288; c=relaxed/simple;
	bh=vyXJvwzoAz8FYKnp9s8fZuQGswBWgSkSNKQF2zCUBNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GWX19xs1yD5BkUrtiBI+VsQFtS0muc0zmzKuopj3TrNpaum6QeRohorrPQwwhmeN1lTwR0anvXEn3HYgDcSGaFLw+cGG2+N0o92+wyyfy1m7f/xsTC3LBxXMdEPQja6xqXgQd5tR8grlT6u44jdxDOf3wu6sW8yANWhOtzWRA1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Qf0BuDmL; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Qf0BuDmL"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id E1A7620B716C; Fri,  9 Oct 2026 23:54:43 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E1A7620B716C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791615283;
	bh=aDS7CAIfTZrNCRXJ9oUiEXNnX7P09huEcRLiyUxqKLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qf0BuDmLPLVLhz/CoSZOPmYWZQC9NjZW4ibDjB56zmKirl/pj7aheTiCsmKMRF9z+
	 X3dtZQc6mh+OcyFVQCu1X1xdF3MXJZ4IHmSrzoPz7EmajDlqZzPEovspBsib4Yc3zX
	 GrgQ+8xuiEy8y5FnQoTGavyZae8A+HIX0v/w9KX8=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v4 05/10] RDMA/mana_ib: Post receive WRs on kernel RC QPs
Date: Fri,  9 Oct 2026 23:54:38 -0700
Message-ID: <20261010065443.3554193-6-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261010065443.3554193-1-kotaranov@linux.microsoft.com>
References: <20261010065443.3554193-1-kotaranov@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Konstantin Taranov <kotaranov@microsoft.com>

Implement receive request posting for RC QPs. When posting a batch of
WRs, ring the doorbell periodically to prevent the u8 counter from
overflowing.

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
---
 drivers/infiniband/hw/mana/wr.c | 37 +++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/infiniband/hw/mana/wr.c b/drivers/infiniband/hw/mana/wr.c
index 250d673f58f2..5d42af91fce4 100644
--- a/drivers/infiniband/hw/mana/wr.c
+++ b/drivers/infiniband/hw/mana/wr.c
@@ -70,6 +70,41 @@ static int mana_ib_post_recv_ud(struct mana_ib_qp *qp, const struct ib_recv_wr *
 	return err;
 }
 
+static int mana_ib_post_recv_rc(struct mana_ib_qp *qp, const struct ib_recv_wr *wr,
+				const struct ib_recv_wr **bad_wr)
+{
+	struct mana_ib_dev *mdev = container_of(qp->ibqp.device, struct mana_ib_dev, ib_dev);
+	struct mana_ib_queue *ib_rq = mana_qp_get_rq(qp);
+	unsigned long flags;
+	u8 wqe_cnt = 0;
+	int err = 0;
+
+	spin_lock_irqsave(&qp->rq_lock, flags);
+
+	for (; wr; wr = wr->next) {
+		err = mana_ib_post_rq(qp, wr);
+		if (unlikely(err)) {
+			*bad_wr = wr;
+			break;
+		}
+		wqe_cnt++;
+		if (wqe_cnt == 0xFF) {
+			mana_gd_wq_ring_doorbell_ext(mdev_to_gc(mdev), ib_rq->kmem,
+						     ib_rq->kmem->head * GDMA_WQE_BU_SIZE,
+						     wqe_cnt, 0);
+			wqe_cnt = 0;
+		}
+	}
+
+	if (wqe_cnt)
+		mana_gd_wq_ring_doorbell_ext(mdev_to_gc(mdev), ib_rq->kmem,
+					     ib_rq->kmem->head * GDMA_WQE_BU_SIZE,
+					     wqe_cnt, 0);
+
+	spin_unlock_irqrestore(&qp->rq_lock, flags);
+	return err;
+}
+
 int mana_ib_post_recv(struct ib_qp *ibqp, const struct ib_recv_wr *wr,
 		      const struct ib_recv_wr **bad_wr)
 {
@@ -79,6 +114,8 @@ int mana_ib_post_recv(struct ib_qp *ibqp, const struct ib_recv_wr *wr,
 	case IB_QPT_UD:
 	case IB_QPT_GSI:
 		return mana_ib_post_recv_ud(qp, wr, bad_wr);
+	case IB_QPT_RC:
+		return mana_ib_post_recv_rc(qp, wr, bad_wr);
 	default:
 		/* Unsupported QP type */
 		*bad_wr = wr;

-- 
2.43.0
