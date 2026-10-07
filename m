Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BF0E4BD371;
	Wed,  7 Oct 2026 15:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791387279; cv=none; b=KaUagKCj3+Wxx6fvNYt4HlsMO5P/uEdFuOmcIkINsjAfu+kJesMny6LtLWme0SL863GD2Wbldm4GdKXGJWQcMlcEbz6j8lQVY68TKf2pH70WEdwHo+XjZJU/QWpH6GuZ32pzNZjcOtbz8R73WvpdhblwWJkuEVLVM5xwkuCtXqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791387279; c=relaxed/simple;
	bh=sHxFHb/duJvwH48zg5TwF48rZ5LMvUfG+khn71M3JNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9nggMwH2fNBRYfNUUJolSHGYTRlQCInCtoglHmhoII07GmlQIWSJWo/OhWXHUDa0w9Q3O5ABx5y0fLzkZtN0FBG33Z46dYBs/9fyd2hlIhLIdP4hZ+YEqWGMQanuJkWqqyXeVHUc5gyUp+zzlPjPM79pv0peni1r6Eq8cPcDHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=cLakZswv; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="cLakZswv"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id 10E0220B716C; Wed,  7 Oct 2026 08:33:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 10E0220B716C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791387211;
	bh=rtAWr8aLJJGbLMkAW/QfAjNkIGwj00v3ffiqGlnvDJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cLakZswv/prvRiZgef2/zhxkt9212hlpT2WGw98infqfWak3yi5Z1jRY6nwvA0igi
	 iVF8SdiRbxsZM3TLkjE5Uo/iiab8kzo+E1vt9UiTAO7PzDLypvZh/SBzqdSFc2UUSm
	 Rt6DdCH1MRoVgChs98NoQR3NihUgNX0X9LvLoCR8=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v3 05/10] RDMA/mana_ib: Post receive WRs on kernel RC QPs
Date: Wed,  7 Oct 2026 08:33:25 -0700
Message-ID: <20261007153330.2979799-6-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261007153330.2979799-1-kotaranov@linux.microsoft.com>
References: <20261007153330.2979799-1-kotaranov@linux.microsoft.com>
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
