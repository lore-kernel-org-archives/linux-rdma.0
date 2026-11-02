Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793636721;
	b=rNP/fLlUGlWea86YrSYk2g4f0o2MYjWlNI9hHzSFO4kbdz5KsrI+dc1TpZn2PWrGlvah
	 Kv4113lvkEwS6SApTNUToDQ22M8PM/Fv+YvtE6uiKb1a9XDmmv379BsOc8AQYtJ/PQIEP
	 Zd0sLutLNspvZ630KhuDIpDwl0NVrSy8qMzNgFr6SKJF0obPeZiDMVrSzY0+1NiOS8PMp
	 hIb3DgTJZj++JM09cPkxc/qjAiIz/9CICaMt56SpwSvf5Ba0Tk6mMgfKfhDf0gDp2+bke
	 IuxN7aAVeKqqOcXktmUrrV3UHj8mH9RE+j+uCQwl/Yru3L3oV/rKXYY72CBbpr2BE2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793636721;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=rtAWr8aLJJGbLMkAW/QfAjNkIGwj00v3ffiqGlnvDJI=;
	b=UBVY2BQLEBRBSnBm/0yuBXVCA42GtDsSVr8aEp5o09rGKugmyFQBlDXa8jBPp6UJQYAG
	 0OBKWvVN6bzUaRm1XCaKqy299Z32kgrC+371r1G//OY3NlRrZGmtrLCKGpPS4qzrQbDTF
	 SsetGwi43seZA5tkQ66mmMtlfYGBFLOfaQXd0+p5CP1kTEcw0r6WZH5a4P4voqAThQN+q
	 7l2C1gRfje1UIbx7m07zu+9oW9BG7Dvr8TL4DRo8maqw0UX1AptHOkesK9dD4wxxwcyFX
	 4JsY3tFzodNeAFHrkjRnfXYEV/cdXLZTqnm5Hz835TaWur9OTvFctQQI9vQDAr+/BoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=m0+BW3m5;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B9A5606AB90;
	Mon,  2 Nov 2026 16:25:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B9A5606AB90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=m0+BW3m5
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id 7F96920B716B; Mon,  2 Nov 2026 08:25:05 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7F96920B716B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1793636705;
	bh=rtAWr8aLJJGbLMkAW/QfAjNkIGwj00v3ffiqGlnvDJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m0+BW3m5WiL7Hg0O7gdrEEJ5W715roswM6eNbR6YhMNmoCxo8ncoob4qsFihY8ytC
	 F7g5Mjy6Ng7PiruYSvb93aItgDZ9m5laWbGF8M9clggo5L2l8uQqQR0iuO08+FuSxE
	 zKA5fhCYFO1DohDjEdrARTf8NHHwZOR2f+4sLNmI=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v7 5/9] RDMA/mana_ib: Post receive WRs on kernel RC QPs
Date: Mon,  2 Nov 2026 08:25:01 -0800
Message-ID: <20261102162505.501853-6-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261102162505.501853-1-kotaranov@linux.microsoft.com>
References: <20261102162505.501853-1-kotaranov@linux.microsoft.com>
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
