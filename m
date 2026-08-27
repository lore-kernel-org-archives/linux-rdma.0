Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 341E847D93A;
	Thu, 27 Aug 2026 14:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787841503; cv=none; b=vGl7S7E8TXwSWZuxvMdANdHBEw83B4K8J4j5192Yv+Mz9tVtOxLe1ptR8YBYyiTTWKbJ3FpZDgEkrlTuKpIVnf7EhtQGHAWLg6XOhXEKVCWE/ksduNlHbrsCuLJvTp6OsyTXuLxhRU1H5eJpZ4isIxx0Y1rDxUA670C3S2EqW2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787841503; c=relaxed/simple;
	bh=8tT8cocZEH4jipb2q0BI2cZkAU5cF2zvVWxAW9JS5+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BwT3B40WQMEBhDafRC40W+BrL48RLOhRWoefhrkV83URsLxAwh4jRADBcATKVA3iztonGFfe3lvm14duL9a4dBcRokFv8h4zof4+4e1H5ql/dq8pSVN2CNMq6yai/6CsKtTEGi6PNuxgGTqgAzBzPbSC064fQJO5K5FsMhCXjuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=JOrKMACK; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="JOrKMACK"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id ADABA20B710C; Thu, 27 Aug 2026 07:37:36 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com ADABA20B710C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1787841456;
	bh=Ak/gdFhRIeBvpQ1j2e2By2BfjknmQchfoWiwthddXwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JOrKMACKsP2/8JSIlAGC5K0Qf/5jShawUQncKJd9XLl1XOHNDbvjr227rCcwk8TGz
	 v9TSO8IIZR/SFtNF5cm9uBQQNnTxbjDkN9r9HnQvI6EJZZpRdOlVIaZK3C9qwVTnJj
	 EW+3HDS1CKYXoH2xb90pk6iZdVnV07nEdKUsFwuU=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v2 2/3] RDMA/mana_ib: MMQ creation for RC QPs
Date: Thu, 27 Aug 2026 07:37:35 -0700
Message-ID: <20260827143736.2013093-3-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260827143736.2013093-1-kotaranov@linux.microsoft.com>
References: <20260827143736.2013093-1-kotaranov@linux.microsoft.com>
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
index aa5f8c607..c6821ae5f 100644
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

