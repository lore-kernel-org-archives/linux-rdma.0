Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793901585;
	b=1GEwZvGxF10yUWKyBvprFSty4fPvUC/U0CZ3iMlK4ak1wECxYqpEQDvuZ2Yak2dtLO4b
	 1NvjnMUvhBTj0OWqpjH4QCE6lZuHO3dxg0J+KVsMhrEaGlqBB3xWkyjxlGm0Uvt+/DvXl
	 b+B8XwZ98hKIG+jCKruEcPN0R8/pksDfQO+aE5r5FtA4/NxRKtt325sUUf0+9kR+h3u76
	 MNcf4IAPXSqaJb9tszsLMjIjpUnHxrZtPoojpMcNclfdH6Da/bkHtfHhe8JTkXS2usGCt
	 cVql4kJl7hUTm8kAHWCiY6+ELAlA4FYmfSoF3BI+SqgqLbVfyz+ziWShgkIqq+m3NUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793901585;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=rtAWr8aLJJGbLMkAW/QfAjNkIGwj00v3ffiqGlnvDJI=;
	b=BDRtdG17I0y2ifn4OIS+xS6s/Er3G2m5yrwFrKfVTyYNrr7Z1fGmy3La+qXEHYZKicYW
	 m3+1rwyI0dcHh34iaI7YGg4t6yUppEujKN37/TXpX75LtlkfDpBHELEzijrT/jGjQzSE8
	 XgG9Z5Sr9kPwqBHEVN4ZJL0V2PZvheiJzWOJdUVsVgYlaKlHCTbZ5pHRWRHgTPLGRuVCX
	 /pUgpbuGFO3NV+c9U6r9Ulp4OroxLExYC0vQ1Sas4mhKNQyhOQs/FJmSS3CpkudXtDNat
	 fgHtUhxt5gq8+BblUYmGwUHAAQTSitjz1XnfHMm3cROeb4vcuuLcc4J/DGOSJ/2PgOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=gc6sR0dY;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BE54606A335;
	Thu,  5 Nov 2026 17:59:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1BE54606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=gc6sR0dY
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id AF01A20B716B; Thu,  5 Nov 2026 09:59:28 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AF01A20B716B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1793901568;
	bh=rtAWr8aLJJGbLMkAW/QfAjNkIGwj00v3ffiqGlnvDJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gc6sR0dYIUOxK0AcmyhUsatr9N/dSN/xWHgZnofenCn89dSRoddwL0J9yPewmH483
	 slWN1TN6rsboLtrPf5PyopPZxbKhnh+b1zHEoVoVNZ/yc5x9lkpfGXEODsbd8xmDJD
	 bzKLKvjtyRPNc76jXdRMuU9K4CbFekzkxZ+U7Noc=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v9 5/9] RDMA/mana_ib: Post receive WRs on kernel RC QPs
Date: Thu,  5 Nov 2026 09:59:24 -0800
Message-ID: <20261105175928.1326682-6-kotaranov@linux.microsoft.com>
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

