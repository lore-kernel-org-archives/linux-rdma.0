Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AA840DB4B
	for <linux-rdma@vger.kernel.org>; Wed, 12 Aug 2026 12:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.42.203.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786537064; cv=none; b=TZCvM65Ed7cy1NtZ3nI8If56XXjkAN+h3WwXefOmRU7KetS6H9+v6nF9+mippSe0basI5Je1ucS8O+2TuEAKBOXN/EzZOd0fOGpDQxPLgr+0iRDICyEjOmSk9atZloydKsEOAtfVsIwNbDHCV/Df1ipDbq2jvWW3unCvCrlInAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786537064; c=relaxed/simple;
	bh=nUHveraYmllAlqkNScrQTWwZ4g1k+KI42gI9og1Zst8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NALyRYQpNa3wFe1MmosqLlfL60Tr6W0Hr7PH1DUceYQ28bN4WG49mkvsguCaIW+e/+POWWYA2mkiDHv7Bc4d9JLmN8xdNQXoE7mSXR3jXGL35KXE3axwLiMi4EUdXcPKE0EwC16zJ24lr5OsxaEjPoEeNB6DO31jCcmHg102UkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=E0IRhwRe; arc=none smtp.client-ip=52.42.203.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="E0IRhwRe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1786537063; x=1818073063;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sPBpQ7RLua8ix+G5cXrNPjHFpqNWrphR71dPVDe3Dvs=;
  b=E0IRhwReZc2q7eIMln5eBlpSKsVAXfPmja5NCWvPDlBOLcIZ5AHlLEIw
   PSjt8k0aKQNRH3Kbu7LWba9tPh40qPMu4pesrL2NUaLaVQw+wKZ/bLBou
   hVUbHj4RdDcCUGrfLw2kXHorEx5wcFyO+Qjb+PYZPn2U5HHa0MbznmtUI
   1ykcESqH5YsLFljlURYMs6nQo74CVpU93TGS8vLI1iMPtrE0ZHvEVBpMq
   D3lqTSMxZuE3UtPRF+PAEGoE6zp24a3f5GpdOUqd6R6AenOZrrR7sKWWt
   IMoyKc5Wa+DMbx0TbNDsQ34GYbcVYjCGfhUogeI6LPhvHfggEMVrgQS0O
   g==;
X-CSE-ConnectionGUID: 9l/u/Oc3TJGnRBiv8IGjig==
X-CSE-MsgGUID: 9/RDmxWvRFyMQNQ9XtxQvw==
X-IronPort-AV: E=Sophos;i="6.25,219,1779148800"; 
   d="scan'208";a="25790854"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2026 12:17:43 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:23776]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.2.175:2525] with esmtp (Farcaster)
 id 681462dc-cef3-4ca2-b188-465f14bc2d98; Wed, 12 Aug 2026 12:17:43 +0000 (UTC)
X-Farcaster-Flow-ID: 681462dc-cef3-4ca2-b188-465f14bc2d98
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Wed, 12 Aug 2026 12:17:42 +0000
Received: from dev-dsk-ynachum-1b-0ecf7b87.eu-west-1.amazon.com
 (10.13.226.176) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45; Wed, 12 Aug 2026
 12:17:41 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <mrgolin@amazon.com>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>, Yonatan Nachum <ynachum@amazon.com>
Subject: [PATCH for-next v3 2/3] RDMA/efa: Generalize the admin SQ
Date: Wed, 12 Aug 2026 12:17:17 +0000
Message-ID: <20260812121718.2904349-3-ynachum@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260812121718.2904349-1-ynachum@amazon.com>
References: <20260812121718.2904349-1-ynachum@amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D043UWC002.ant.amazon.com (10.13.139.222) To
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

