Received: from pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com [50.112.246.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C1033ADB9
	for <linux-rdma@vger.kernel.org>; Fri, 31 Jul 2026 07:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=50.112.246.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785484236; cv=none; b=nFNA//1lVA/x/nNqtt5HfhJ3dNGAiy9LtS/a9zeUIrqS0JcKEKFvNJSKGZgfrPqwvPV+4yVxDqvkelGoT4Vj7Jf1oFqyZkUc8umHQrkPKYFzJFWCfu9UO4AdRZAB5pbj2dDHkXtVwpKaJaEAPHbgJgrnV95SZktUIdfyzOpaAYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785484236; c=relaxed/simple;
	bh=nUHveraYmllAlqkNScrQTWwZ4g1k+KI42gI9og1Zst8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j4jNIqIEKPm1TMlG0CilSjoMW/6aaJKy+ZM2GbVFAP4qEqBmTq5mFKuQD+moVDApUvlbWSBfh3T86kF5f0Ufcz7U+/UQsuBY9VgGExIowdcJR6LmnkDSS1syAo+kcPlJo6FRJ0pqPGQgW6GGywV+WPJHzjk2/1CvEDd+VBMMLOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=ZiN+SJzz; arc=none smtp.client-ip=50.112.246.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="ZiN+SJzz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1785484235; x=1817020235;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sPBpQ7RLua8ix+G5cXrNPjHFpqNWrphR71dPVDe3Dvs=;
  b=ZiN+SJzzlV1fk+A5O+yheyhAEtuQCmr57c9vs4hPFQZbj8zXqk4SOcEr
   8ryRayNgv2wUo3rEfx8xHeRszzTFlsTp3muTShJ+zmCovOsQw0cI65f6k
   NYPn2gSRyfDUpLLdNo8Fmd56IGp9f5ctNaYtKFWTyaJ1HJSMoDZAwOye4
   V5Kg+zlFG6iE9XC21631zdYpnORXYDwPyrMgbau5LLQpukSsqT1RmFJob
   Pn3wUSImUX4QwIlCkWmBlvrPEBAob3HocnJVAcSWepeSvETC/PDkZnRIs
   ioLjczjJuUrse50JV+lrsTZNEwLohayEEiL2WkEV/36fE37OdNOL1Lgnp
   Q==;
X-CSE-ConnectionGUID: nLz267kSSBWRdKxsia9kYA==
X-CSE-MsgGUID: v3cXf6k1TWua+xOsqxTWgA==
X-IronPort-AV: E=Sophos;i="6.25,196,1779148800"; 
   d="scan'208";a="24539838"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2026 07:50:31 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:17044]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.28.136:2525] with esmtp (Farcaster)
 id 0d4cd6be-3f49-4a59-9939-6bcac1bfda03; Fri, 31 Jul 2026 07:50:31 +0000 (UTC)
X-Farcaster-Flow-ID: 0d4cd6be-3f49-4a59-9939-6bcac1bfda03
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Fri, 31 Jul 2026 07:50:31 +0000
Received: from dev-dsk-ynachum-1b-0ecf7b87.eu-west-1.amazon.com
 (10.13.226.176) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45; Fri, 31 Jul 2026
 07:50:29 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <mrgolin@amazon.com>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>, Yonatan Nachum <ynachum@amazon.com>
Subject: [PATCH for-next v2 2/3] RDMA/efa: Generalize the admin SQ
Date: Fri, 31 Jul 2026 07:50:06 +0000
Message-ID: <20260731075007.3878376-3-ynachum@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260731075007.3878376-1-ynachum@amazon.com>
References: <20260731075007.3878376-1-ynachum@amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D044UWB002.ant.amazon.com (10.13.139.188) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

As preparation for admin v2 entry size which is 128B, generalize the SQ
ring to use a generic buffer and use the right offset into it using the
configured entry size. This will allow us to choose different entry size
on SQ init with minimal changes.

Reviewed-by: Michael Margolin <mrgolin@amazon.com>
Signed-off-by: Yonatan Nachum <ynachum@amazon.com>
---
 drivers/infiniband/hw/efa/efa_com.c | 48 +++++++++++++----------------
 drivers/infiniband/hw/efa/efa_com.h |  3 +-
 2 files changed, 24 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_com.c b/drivers/infiniband/hw/efa/efa_com.c
index 8d8be22b76c8..72b87f8cd086 100644
--- a/drivers/infiniband/hw/efa/efa_com.c
+++ b/drivers/infiniband/hw/efa/efa_com.c
@@ -138,14 +138,13 @@ static int efa_com_admin_init_sq(struct efa_com_dev *edev)
 {
 	struct efa_com_admin_queue *aq = &edev->aq;
 	struct efa_com_admin_sq *sq = &aq->sq;
-	u16 size = aq->depth * sizeof(*sq->entries);
+	u32 addr_high, addr_low;
 	u32 aq_caps = 0;
-	u32 addr_high;
-	u32 addr_low;
 
-	sq->entries =
-		dma_alloc_coherent(aq->dmadev, size, &sq->dma_addr, GFP_KERNEL);
-	if (!sq->entries)
+	sq->entry_size = sizeof(struct efa_admin_aq_entry);
+	sq->buffer = dma_alloc_coherent(aq->dmadev, aq->depth * sq->entry_size,
+					&sq->dma_addr, GFP_KERNEL);
+	if (!sq->buffer)
 		return -ENOMEM;
 
 	spin_lock_init(&sq->lock);
@@ -163,8 +162,7 @@ static int efa_com_admin_init_sq(struct efa_com_dev *edev)
 	writel(addr_high, edev->reg_bar + EFA_REGS_AQ_BASE_HI_OFF);
 
 	EFA_SET(&aq_caps, EFA_REGS_AQ_CAPS_AQ_DEPTH, aq->depth);
-	EFA_SET(&aq_caps, EFA_REGS_AQ_CAPS_AQ_ENTRY_SIZE,
-		sizeof(struct efa_admin_aq_entry));
+	EFA_SET(&aq_caps, EFA_REGS_AQ_CAPS_AQ_ENTRY_SIZE, sq->entry_size);
 
 	writel(aq_caps, edev->reg_bar + EFA_REGS_AQ_CAPS_OFF);
 
@@ -330,24 +328,22 @@ static void __efa_com_submit_admin_cmd(struct efa_com_admin_queue *aq,
 				       struct efa_admin_acq_entry *comp,
 				       size_t comp_size_in_bytes)
 {
-	struct efa_admin_aq_entry *aqe;
-	u16 queue_size_mask;
-	u16 cmd_id;
-	u16 ctx_id;
-	u16 pi;
+	u16 queue_size_mask, cmd_id, ctx_id, pi;
+	struct efa_com_admin_sq *sq = &aq->sq;
+	u8 *aqe;
 
 	queue_size_mask = aq->depth - 1;
-	pi = aq->sq.pc & queue_size_mask;
+	pi = sq->pc & queue_size_mask;
 	ctx_id = efa_com_get_comp_ctx_id(aq, comp_ctx);
 
 	/* cmd_id LSBs are the ctx_id and MSBs are entropy bits from pc */
 	cmd_id = ctx_id & queue_size_mask;
-	cmd_id |= aq->sq.pc << ilog2(aq->depth);
+	cmd_id |= sq->pc << ilog2(aq->depth);
 	cmd_id &= EFA_ADMIN_AQ_COMMON_DESC_COMMAND_ID_MASK;
 
 	cmd->aq_common_descriptor.command_id = cmd_id;
 	EFA_SET(&cmd->aq_common_descriptor.flags,
-		EFA_ADMIN_AQ_COMMON_DESC_PHASE, aq->sq.phase);
+		EFA_ADMIN_AQ_COMMON_DESC_PHASE, sq->phase);
 
 	comp_ctx->status = EFA_CMD_SUBMITTED;
 	comp_ctx->comp_size = comp_size_in_bytes;
@@ -357,18 +353,18 @@ static void __efa_com_submit_admin_cmd(struct efa_com_admin_queue *aq,
 
 	reinit_completion(&comp_ctx->wait_event);
 
-	aqe = &aq->sq.entries[pi];
-	memset(aqe, 0, sizeof(*aqe));
+	aqe = sq->buffer + sq->entry_size * pi;
+	memset(aqe, 0, sq->entry_size);
 	memcpy(aqe, cmd, cmd_size_in_bytes);
 
-	aq->sq.pc++;
+	sq->pc++;
 	atomic64_inc(&aq->stats.submitted_cmd);
 
-	if ((aq->sq.pc & queue_size_mask) == 0)
-		aq->sq.phase = !aq->sq.phase;
+	if ((sq->pc & queue_size_mask) == 0)
+		sq->phase = !sq->phase;
 
 	/* barrier not needed in case of writel */
-	writel(aq->sq.pc, aq->sq.db_addr);
+	writel(sq->pc, sq->db_addr);
 }
 
 static inline int efa_com_init_comp_ctxt(struct efa_com_admin_queue *aq)
@@ -723,8 +719,8 @@ void efa_com_admin_destroy(struct efa_com_dev *edev)
 	devm_kfree(edev->dmadev, aq->comp_ctx_pool);
 	devm_kfree(edev->dmadev, aq->comp_ctx);
 
-	size = aq->depth * sizeof(*sq->entries);
-	dma_free_coherent(edev->dmadev, size, sq->entries, sq->dma_addr);
+	size = aq->depth * sq->entry_size;
+	dma_free_coherent(edev->dmadev, size, sq->buffer, sq->dma_addr);
 
 	size = aq->depth * sizeof(*cq->entries);
 	dma_free_coherent(edev->dmadev, size, cq->entries, cq->dma_addr);
@@ -843,8 +839,8 @@ int efa_com_admin_init(struct efa_com_dev *edev,
 	dma_free_coherent(edev->dmadev, aq->depth * sizeof(*aq->cq.entries),
 			  aq->cq.entries, aq->cq.dma_addr);
 err_destroy_sq:
-	dma_free_coherent(edev->dmadev, aq->depth * sizeof(*aq->sq.entries),
-			  aq->sq.entries, aq->sq.dma_addr);
+	dma_free_coherent(edev->dmadev, aq->depth * aq->sq.entry_size,
+			  aq->sq.buffer, aq->sq.dma_addr);
 err_destroy_comp_ctxt:
 	devm_kfree(edev->dmadev, aq->comp_ctx);
 err_destroy_ah_cache:
diff --git a/drivers/infiniband/hw/efa/efa_com.h b/drivers/infiniband/hw/efa/efa_com.h
index f979e36ec158..069c9dd98328 100644
--- a/drivers/infiniband/hw/efa/efa_com.h
+++ b/drivers/infiniband/hw/efa/efa_com.h
@@ -33,7 +33,8 @@ struct efa_com_admin_cq {
 };
 
 struct efa_com_admin_sq {
-	struct efa_admin_aq_entry *entries;
+	u8 *buffer;
+	u16 entry_size;
 	dma_addr_t dma_addr;
 	spinlock_t lock; /* Protects ASQ */
 
-- 
2.50.1

