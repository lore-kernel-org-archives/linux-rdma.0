Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794399262;
	b=j/L+l6v41dkAcdaF5QN3RjvIMjoUBgz+y0egWh7xo8gAh9GU49hQQ/5YDMreNY+AdtCa
	 1wPrYJGMjzum5Oix2I5rk0ieyOb2PZugPj5lTGLIXwurIQ3vRkQhCVuFRFOiEzu8pJ+Ps
	 e4lISPyHODlT+KRiWAIPK+HOp/8oZL7NvIVtCTrARBRc2fE4xkP1o5R6Q3bAQXM+pXaG3
	 bexNp/VvWcaO/m7Sl267sVTrSP8WAUKsgeVQg+l7El98VDzjJgg+5epLSKaSWxQJiRpju
	 GmJjJHyQjc8i9ulM1pxkYWgYfkKnGszjO+4c6foeeBHqVP6DyGbagFBe+fIwFCPR1bQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794399262;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6Wjm4i+LoGEXrdAtLJZAjS2UgNmy7pNMekJuhjC4aWM=;
	b=srtve2zbSL+6OKx6as5cCKP9MhY5nSEvndCRey6VsGTdLL/M3rG7yFlG+6VmGO2T04QN
	 mB/DsOGgk3EpmagUBJl4oOKezoOVPuPLVnimMIBYMhUOAaDPIEJvx4L4/aI2LmwcNkqPp
	 PTbul8CFdwWuslHxUEKtdBurCfvdfUdapYQnkErNWcqC6Fjb344IPzovjGvfFsqs9pAJY
	 mdH/Xx6v3V74kLLT17Qhu73NDDbh467/PwlR1/Cb+5/4k3kj1o8PWWiiBtowbiXFEf+Vl
	 6Hb+/4mWfC98LJVm6dFnCG7OKtjBFQxjnMy7KAIVG9+CJ2hC7w4ESxvCFo8s5G5/T1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=r3fR0BKv;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5063606A334;
	Wed, 11 Nov 2026 12:14:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C5063606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=r3fR0BKv
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id 2824520B716E; Wed, 11 Nov 2026 04:14:18 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2824520B716E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1794399258;
	bh=6Wjm4i+LoGEXrdAtLJZAjS2UgNmy7pNMekJuhjC4aWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r3fR0BKvnAnyMBqO0ZDz+l/8WoM9X1t4odwBXMV7LP7p1DebVkd4RKEWsrbG5oebi
	 Jm4idi6Qf65aOQPfsnVHeDm/ul8aG3CHiOEh9fR2ZbKnOMscLh6DJCr/tppolR++rb
	 +6ccVRuITRMajX6QIKhQRHI6QOhkUFwNlG2+SCBs=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v10 5/9] RDMA/mana_ib: Post receive WRs on kernel RC QPs
Date: Wed, 11 Nov 2026 04:14:13 -0800
Message-ID: <20261111121417.1265896-6-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261111121417.1265896-1-kotaranov@linux.microsoft.com>
References: <20261111121417.1265896-1-kotaranov@linux.microsoft.com>
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
 drivers/infiniband/hw/mana/wr.c | 37 +++++++++++++++++++++++++++++++++++++
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

