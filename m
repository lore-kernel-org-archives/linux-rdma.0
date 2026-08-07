Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B50D33793A5;
	Fri,  7 Aug 2026 13:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786110724; cv=none; b=XuXITYY5DVElZ1BFrQgMCoXaMx61vxB9SQ9XdykNqMkc/RPRf3Xq2ice9ucQGO8Pa6+MKFOUXr1K1xGxIqM5LEfYmeNI1a6NabE8ZCJmSZzwMH10C73QqiIN6wroSKHN+F24kKZFqr+68lL75Cz1RK/RdcvDdfQ6xtEG7ms2Ul4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786110724; c=relaxed/simple;
	bh=lNKt0jIfny1rB8D5DEtAdA/Ryt/qL/EUftcjRmCDrxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPnVwkFrRtAS8DXAaIiWuDOOUFR8zJr3q09NafZQYapMf1d5c1GSTRzB2JIk7/LSKLfGBcXWcCoS+wgzLIuGfOwXwvTHVz77m0TYHCnQ0qSs8ROMyw+KcSuu8UYD75SJy8Q3GnhKLo+/RLRyn8MASYB5duTrx3KJL40s4drgp9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=ktHeNuUf; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="ktHeNuUf"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id 7562F20B7135; Fri,  7 Aug 2026 06:51:32 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7562F20B7135
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1786110692;
	bh=3cdxBUJ7oo0JxrlJPOHc+7OdBzM0SPPOBNKbIvn7TzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ktHeNuUf+Epev05gVpTRwFrvn/kaGMcconqi6ZyyTn3oaIl2Vnkl74Z+DVRRgEV+E
	 dJ885QIYI/bs6OUJ9cyJ4afHbu5KDSWvy6OeqWbshNoo6lvaeLl3Ai8X0W+8nADBKn
	 +u5F5DxHOa+V1oCjEkWaDYDgjXpfm1FbJYp2A2CU=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next 2/3] RDMA/mana_ib: MMQ creation for RC QPs
Date: Fri,  7 Aug 2026 06:51:31 -0700
Message-ID: <20260807135132.1618382-3-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260807135132.1618382-1-kotaranov@linux.microsoft.com>
References: <20260807135132.1618382-1-kotaranov@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Konstantin Taranov <kotaranov@microsoft.com>

Create an MMQ for an RC QP when userspace sets the corresponding
compatibility-mask flag. Register the userspace MMQ buffer and pass the
queue to hardware instead of setting the NO_MMQ creation flag.

Keep the MMQ disabled for applications that do not request it, preserving
the existing behavior. Return the created MMQ ID to userspace in the
extended RC QP response.

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
---
 drivers/infiniband/hw/mana/qp.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
index aa5f8c6077bb0..c6821ae5fac1c 100644
--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -557,16 +557,22 @@ static int mana_ib_create_rc_qp(struct ib_qp *ibqp, struct ib_pd *ibpd,
 
 	for (i = 0, j = 0; i < MANA_RC_QUEUE_TYPE_MAX; ++i) {
 		if (i == MANA_RC_SEND_QUEUE_MMQ) {
-			qp->rc_qp.queues[i].id = INVALID_QUEUE_ID;
-			qp->rc_qp.queues[i].gdma_region = GDMA_INVALID_DMA_REGION;
+			if (ucmd.comp_mask & MANA_IB_RC_MMQ_CREATE) {
+				flags &= ~MANA_RC_FLAG_NO_MMQ;
+				err = mana_ib_create_queue(mdev, ucmd.mmq_buf, ucmd.mmq_size,
+							   &qp->rc_qp.queues[i]);
+				if (err)
+					goto destroy_queues;
+			} else {
+				qp->rc_qp.queues[i].id = INVALID_QUEUE_ID;
+				qp->rc_qp.queues[i].gdma_region = GDMA_INVALID_DMA_REGION;
+			}
 			continue;
 		}
 		err = mana_ib_create_queue(mdev, ucmd.queue_buf[j], ucmd.queue_size[j],
 					   &qp->rc_qp.queues[i]);
-		if (err) {
-			ibdev_err(&mdev->ib_dev, "Failed to create queue %d, err %d\n", i, err);
+		if (err)
 			goto destroy_queues;
-		}
 		j++;
 	}
 
@@ -580,8 +586,10 @@ static int mana_ib_create_rc_qp(struct ib_qp *ibqp, struct ib_pd *ibpd,
 
 	if (udata) {
 		for (i = 0, j = 0; i < MANA_RC_QUEUE_TYPE_MAX; ++i) {
-			if (i == MANA_RC_SEND_QUEUE_MMQ)
+			if (i == MANA_RC_SEND_QUEUE_MMQ) {
+				resp.mmq_id = qp->rc_qp.queues[i].id;
 				continue;
+			}
 			resp.queue_id[j] = qp->rc_qp.queues[i].id;
 			j++;
 		}
-- 
2.43.0

