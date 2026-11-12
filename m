Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794473241;
	b=Akdt+DzCVWCl3VNxCWp8w3PfrH9tw2NNT1BqhC2ndoe/UeWE7py3cwT1Yat4vOtNZ2iB
	 dGW2S0n1crr3q1Nr9jpZdqWUHL0YHKnqzgqbfNqIb2+bz1BKlnJybVsKZY23lfC9z4Duw
	 hAQnyHhi7MIm5mnj0Qadh7QWqnGv9ohBohqZocZExAozP42dLlVzCuoDoJAoMUv6AjwmN
	 NqYaGaSi8XJowkiBuxopfk8yZiA2anZtEOgWOR34TPjYsrcAEOVikE5gBAl7LE9oKtdgt
	 OoO4eOyU/hM0WDCk8qomKWdT5OyJl/2dAF+a52E/3JnBE7UrcipbjGxJkjTqFcxdHiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794473241;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6Wjm4i+LoGEXrdAtLJZAjS2UgNmy7pNMekJuhjC4aWM=;
	b=Qwo98fcJiXVJHgzQ2guYrtRHwyKd1ubteilCteOQy7v2kAez3m7nWkplnuRIDGxhjYrG
	 o4lDvFV6YhMdmgc2Ln8X2688SXaTdE5PzlcshCBOrwcJq1oyJJVWJpcDWXvKRacjKqHfh
	 Mqy4SUlDavSRSk12HMg0xd6Vy4vkoMkjllDi9KwrDpLIBIIjvFz70j032TT/zB9SOoI/4
	 E0ML+ok2qZqHnuDBtFedLzvsjk8MwEt+95dMFJj+e/6HuU6C+Ah0akcvOqU3nbyjING1j
	 JR/cuJs/R1+2dZpMakcAQhItJyMZEN1dRgvzwsFI9d8DyDdmGa2xShE5q+K5xZWODIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=UWjtfgu5;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA99D606A8AA;
	Thu, 12 Nov 2026 08:47:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BA99D606A8AA
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=UWjtfgu5
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id C083120B716D; Thu, 12 Nov 2026 00:47:16 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C083120B716D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1794473236;
	bh=6Wjm4i+LoGEXrdAtLJZAjS2UgNmy7pNMekJuhjC4aWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UWjtfgu5570wiqGeH6xErxv9cNWs8pyG0/BXUuR5GobSr8DtMxpQC/KfL1r+sJsEC
	 USv5ssb8A0ij0dNlwVlYqyEvPqQveaPkPvqvQ9rEanqC24AOQYdS6fZfTHNTBtA3x6
	 Pu1WTgI6urnRAykfPXR9Z7euDUMbGFiURAqtvmnM=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v11 5/9] RDMA/mana_ib: Post receive WRs on kernel RC QPs
Date: Thu, 12 Nov 2026 00:47:12 -0800
Message-ID: <20261112084716.1483342-6-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261112084716.1483342-1-kotaranov@linux.microsoft.com>
References: <20261112084716.1483342-1-kotaranov@linux.microsoft.com>
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

