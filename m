Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9997B1E1DE5
	for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 12:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.68.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785069576; cv=none; b=X/9hHrJjDogtaYZrNGm4P5PxQeOk2ELmmHtE8MWuDrCmi7NiXtK4f9EB3hB0/e+9SIE9mOXIimV/w4pII3uV9jurcRGrsgFU7LnAdExtQcWS5o2NgDy0jJ/JOHLS0mdPzLE0ga+ydjqXrGbmaDpHHbHjygaVao+nX/a1R4VtWQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785069576; c=relaxed/simple;
	bh=ITHNkTwELwavXUKrDk1/nVmhs8O7dGV30NVWtuG3PJU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uVzdn0etV6cLjTUUruWxFF8xmpSazT4xa8TOuMFPcSpJo9Ce4aJ5uRPmucqYstitOjOOCth+Dfn/fAp0EKxk12UG9VvaAIVyT0pzFfMxmXQNco5GvSBxr8A397eIOoDrPIiFh5XdwSYKekQSagiUaCVkDj24v+U+H07+S/fuF4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=PI0zCypA; arc=none smtp.client-ip=44.246.68.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="PI0zCypA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1785069574; x=1816605574;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sdX5Mup2xBNnKdRVj/ERjKiKw8gt/jdFvTJtq9aVEYs=;
  b=PI0zCypA5fbhOHC2BNK9h8ojTlKeq+r52GqCAAtheWXNPArEESFTyEyW
   qq2dEkwhuhCMxvFxWPc0udBLxnICzbgBkJVcUR4rSBwP+QtUtlVM8jSAG
   r+ghn0+glbv5c1mmypYi0U+Yj3r2YzCfFBOes/E8Z2QJfa2tKsEGXXzbh
   /9ARpMLCXlaq90jVeAiLCw8LQ49Y/x/Km97VyoPxkqjQ0BZaz/wc9cwO0
   ZUk12wGqWwunJrcG9RB0IA4OhGWdUYuPvgt68moQzGVF0rvJg4K/dBXBv
   jLmiYq1abuQOs3QJXnoBCTXixeoH54YCnc1bh5d/KSmmycE4gR2lobERH
   A==;
X-CSE-ConnectionGUID: xnepei5KSlqKKv9emt2Slw==
X-CSE-MsgGUID: WXAnIsx1STOwYU1PHv+IIQ==
X-IronPort-AV: E=Sophos;i="6.25,186,1779148800"; 
   d="scan'208";a="24391155"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2026 12:39:31 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:13125]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.38.8:2525] with esmtp (Farcaster)
 id fd459687-0684-41e1-bd3b-5658258da429; Sun, 26 Jul 2026 12:39:31 +0000 (UTC)
X-Farcaster-Flow-ID: fd459687-0684-41e1-bd3b-5658258da429
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Sun, 26 Jul 2026 12:39:30 +0000
Received: from dev-dsk-ynachum-1b-0ecf7b87.eu-west-1.amazon.com
 (10.13.226.176) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45; Sun, 26 Jul 2026
 12:39:29 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <mrgolin@amazon.com>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>, Yonatan Nachum <ynachum@amazon.com>, Tom Sela
	<tomsela@amazon.com>
Subject: [PATCH for-next 3/3] RDMA/efa: Add support for 128B admin v2 SQ entry
Date: Sun, 26 Jul 2026 12:38:54 +0000
Message-ID: <20260726123854.638687-4-ynachum@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260726123854.638687-1-ynachum@amazon.com>
References: <20260726123854.638687-1-ynachum@amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D042UWB002.ant.amazon.com (10.13.139.175) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Add the new admin v2 format which is 128B in size and its header extends
the v1 header with checksum and payload version.
On admin SQ init check if the API version reported by the device
supports the admin v2 SQ entry and if so use it. Store the payload
offset and max size in the SQ for quick access in admin command
execution flow.

Using the admin SQ v2 entry implicitly enable the checksum in its
header so set it for device to validate against.

Reviewed-by: Michael Margolin <mrgolin@amazon.com>
Reviewed-by: Tom Sela <tomsela@amazon.com>
Signed-off-by: Yonatan Nachum <ynachum@amazon.com>
---
 drivers/infiniband/hw/efa/efa_admin_defs.h |  29 +++++-
 drivers/infiniband/hw/efa/efa_com.c        | 113 +++++++++++++++------
 drivers/infiniband/hw/efa/efa_com.h        |   6 ++
 3 files changed, 116 insertions(+), 32 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_admin_defs.h b/drivers/infiniband/hw/efa/efa_admin_defs.h
index 0a14b3abe6f9..bf1721e31a70 100644
--- a/drivers/infiniband/hw/efa/efa_admin_defs.h
+++ b/drivers/infiniband/hw/efa/efa_admin_defs.h
@@ -7,7 +7,7 @@
 #define _EFA_ADMIN_H_
 
 #define EFA_ADMIN_API_VERSION_MAJOR          0
-#define EFA_ADMIN_API_VERSION_MINOR          2
+#define EFA_ADMIN_API_VERSION_MINOR          3
 
 enum efa_admin_aq_completion_status {
 	EFA_ADMIN_SUCCESS                           = 0,
@@ -41,6 +41,21 @@ struct efa_admin_aq_common_desc {
 	u8 flags;
 };
 
+struct efa_admin_aq_common_desc_v2 {
+	struct efa_admin_aq_common_desc common;
+
+	/*
+	 * Poly 0x8005 CRC16 with initial value 0xFFFF and final XOR of
+	 * 0xFFFF. The checksum covers the entire admin command entry
+	 * including the zeroed checksum field.
+	 */
+	u16 checksum;
+
+	u8 payload_ver;
+
+	u8 reserved[5];
+};
+
 /*
  * used in efa_admin_aq_entry. Can point directly to control data, or to a
  * page list chunk. Used also at the end of indirect mode page list chunks,
@@ -58,6 +73,12 @@ struct efa_admin_aq_entry {
 	u32 request_payload[15];
 };
 
+struct efa_admin_aq_entry_v2 {
+	struct efa_admin_aq_common_desc_v2 aq_common_descriptor;
+
+	u32 request_payload[29];
+};
+
 struct efa_admin_acq_common_desc {
 	/*
 	 * command identifier to associate it with the aq descriptor
@@ -74,7 +95,11 @@ struct efa_admin_acq_common_desc {
 	 */
 	u8 flags;
 
-	/* Poly 0x8005 CRC16 with initial value 0xFFFF and final XOR of 0xFFFF */
+	/*
+	 * Poly 0x8005 CRC16 with initial value 0xFFFF and final XOR of 0xFFFF.
+	 * The checksum covers the entire admin completion entry including the
+	 * zeroed checksum field.
+	 */
 	u16 checksum;
 
 	u16 reserved;
diff --git a/drivers/infiniband/hw/efa/efa_com.c b/drivers/infiniband/hw/efa/efa_com.c
index 72b87f8cd086..74ad1d640fa6 100644
--- a/drivers/infiniband/hw/efa/efa_com.c
+++ b/drivers/infiniband/hw/efa/efa_com.c
@@ -25,11 +25,16 @@
 
 #define EFA_CRC16_INIT_VAL 0xffff
 
-#define EFA_CRC_MIN_ADMIN_API_VERSION_MAJOR 0
-#define EFA_CRC_MIN_ADMIN_API_VERSION_MINOR 2
+#define EFA_ADMIN_SQ_MAX_ENT_SIZE sizeof(struct efa_admin_aq_entry_v2)
 
-#define EFA_MIN_ADMIN_API_VERSION_MAJOR 0
-#define EFA_MIN_ADMIN_API_VERSION_MINOR 1
+#define EFA_CRC_MIN_API_VERSION_MAJOR 0
+#define EFA_CRC_MIN_API_VERSION_MINOR 2
+
+#define EFA_ADMIN_V2_MIN_API_VERSION_MAJOR 0
+#define EFA_ADMIN_V2_MIN_API_VERSION_MINOR 3
+
+#define EFA_MIN_API_VERSION_MAJOR 0
+#define EFA_MIN_API_VERSION_MINOR 1
 
 enum efa_cmd_status {
 	EFA_CMD_UNUSED,
@@ -82,6 +87,16 @@ void efa_com_set_dma_addr(dma_addr_t addr, u32 *addr_high, u32 *addr_low)
 	*addr_high = upper_32_bits(addr);
 }
 
+static u32 efa_com_construct_ver(u32 major, u32 minor)
+{
+	u32 ver = 0;
+
+	EFA_SET(&ver, EFA_REGS_VERSION_MAJOR_VERSION, major);
+	EFA_SET(&ver, EFA_REGS_VERSION_MINOR_VERSION, minor);
+
+	return ver;
+}
+
 static u32 efa_com_reg_read32(struct efa_com_dev *edev, u16 offset)
 {
 	struct efa_com_mmio_read *mmio_read = &edev->mmio_read;
@@ -138,10 +153,23 @@ static int efa_com_admin_init_sq(struct efa_com_dev *edev)
 {
 	struct efa_com_admin_queue *aq = &edev->aq;
 	struct efa_com_admin_sq *sq = &aq->sq;
+	u32 aq_caps = 0, admin_v2_min_ver = 0;
 	u32 addr_high, addr_low;
-	u32 aq_caps = 0;
 
-	sq->entry_size = sizeof(struct efa_admin_aq_entry);
+	admin_v2_min_ver = efa_com_construct_ver(EFA_ADMIN_V2_MIN_API_VERSION_MAJOR,
+						 EFA_ADMIN_V2_MIN_API_VERSION_MINOR);
+	if (edev->dev_api_ver >= admin_v2_min_ver) {
+		sq->entry_size = sizeof(struct efa_admin_aq_entry_v2);
+		sq->payload_offset = offsetof(struct efa_admin_aq_entry_v2, request_payload);
+		sq->proto_ver = EFA_ADMIN_V2_PROTO_VER;
+	} else {
+		sq->entry_size = sizeof(struct efa_admin_aq_entry);
+		sq->payload_offset = offsetof(struct efa_admin_aq_entry, request_payload);
+		sq->proto_ver = EFA_ADMIN_V1_PROTO_VER;
+	}
+
+	sq->max_payload_size = sq->entry_size - sq->payload_offset;
+
 	sq->buffer = dma_alloc_coherent(aq->dmadev, aq->depth * sq->entry_size,
 					&sq->dma_addr, GFP_KERNEL);
 	if (!sq->buffer)
@@ -184,8 +212,8 @@ static int efa_com_admin_init_cq(struct efa_com_dev *edev)
 
 	spin_lock_init(&cq->lock);
 
-	EFA_SET(&crc_min_ver, EFA_REGS_VERSION_MAJOR_VERSION, EFA_CRC_MIN_ADMIN_API_VERSION_MAJOR);
-	EFA_SET(&crc_min_ver, EFA_REGS_VERSION_MINOR_VERSION, EFA_CRC_MIN_ADMIN_API_VERSION_MINOR);
+	crc_min_ver = efa_com_construct_ver(EFA_CRC_MIN_API_VERSION_MAJOR,
+					    EFA_CRC_MIN_API_VERSION_MINOR);
 	if (edev->dev_api_ver >= crc_min_ver)
 		cq->validate_checksum = true;
 
@@ -321,13 +349,45 @@ static inline struct efa_comp_ctx *efa_com_get_comp_ctx_by_cmd_id(struct efa_com
 	return &aq->comp_ctx[ctx_id];
 }
 
+static u16 efa_com_calc_crc16_checksum(u8 *buff, u32 buff_size)
+{
+	return crc16(EFA_CRC16_INIT_VAL, buff, buff_size) ^ EFA_CRC16_INIT_VAL;
+}
+
+static void efa_com_construct_aq_entry(struct efa_com_admin_queue *aq, u8 *aq_entry, u16 cmd_id,
+				       u8 opcode, u8 flags, void *payload, size_t payload_size)
+{
+	struct efa_admin_aq_common_desc_v2 *common_v2 = NULL;
+	struct efa_admin_aq_common_desc *common;
+	struct efa_com_admin_sq *sq = &aq->sq;
+
+	if (sq->proto_ver == EFA_ADMIN_V1_PROTO_VER) {
+		common = (struct efa_admin_aq_common_desc *)aq_entry;
+	} else {
+		common_v2 = (struct efa_admin_aq_common_desc_v2 *)aq_entry;
+		common = &common_v2->common;
+	}
+
+	common->command_id = cmd_id;
+	common->opcode = opcode;
+	common->flags = flags;
+	EFA_SET(&common->flags, EFA_ADMIN_AQ_COMMON_DESC_PHASE, sq->phase);
+
+	if (payload)
+		memcpy(aq_entry + sq->payload_offset, payload, payload_size);
+
+	if (common_v2)
+		common_v2->checksum = efa_com_calc_crc16_checksum(aq_entry, sq->entry_size);
+}
+
 static void __efa_com_submit_admin_cmd(struct efa_com_admin_queue *aq,
 				       struct efa_comp_ctx *comp_ctx,
-				       struct efa_admin_aq_entry *cmd,
-				       size_t cmd_size_in_bytes,
+				       u8 opcode, u8 flags,
+				       void *payload, size_t payload_size,
 				       struct efa_admin_acq_entry *comp,
 				       size_t comp_size_in_bytes)
 {
+	u8 aq_entry[EFA_ADMIN_SQ_MAX_ENT_SIZE] = {};
 	u16 queue_size_mask, cmd_id, ctx_id, pi;
 	struct efa_com_admin_sq *sq = &aq->sq;
 	u8 *aqe;
@@ -341,21 +401,19 @@ static void __efa_com_submit_admin_cmd(struct efa_com_admin_queue *aq,
 	cmd_id |= sq->pc << ilog2(aq->depth);
 	cmd_id &= EFA_ADMIN_AQ_COMMON_DESC_COMMAND_ID_MASK;
 
-	cmd->aq_common_descriptor.command_id = cmd_id;
-	EFA_SET(&cmd->aq_common_descriptor.flags,
-		EFA_ADMIN_AQ_COMMON_DESC_PHASE, sq->phase);
+	efa_com_construct_aq_entry(aq, aq_entry, cmd_id, opcode, flags, payload, payload_size);
 
 	comp_ctx->status = EFA_CMD_SUBMITTED;
 	comp_ctx->comp_size = comp_size_in_bytes;
 	comp_ctx->user_cqe = comp;
-	comp_ctx->cmd_opcode = cmd->aq_common_descriptor.opcode;
+	comp_ctx->cmd_opcode = opcode;
 	comp_ctx->cmd_id = cmd_id;
 
 	reinit_completion(&comp_ctx->wait_event);
 
 	aqe = sq->buffer + sq->entry_size * pi;
 	memset(aqe, 0, sq->entry_size);
-	memcpy(aqe, cmd, cmd_size_in_bytes);
+	memcpy(aqe, aq_entry, sq->entry_size);
 
 	sq->pc++;
 	atomic64_inc(&aq->stats.submitted_cmd);
@@ -399,8 +457,8 @@ static inline int efa_com_init_comp_ctxt(struct efa_com_admin_queue *aq)
 
 static int efa_com_submit_admin_cmd(struct efa_com_admin_queue *aq,
 				    struct efa_comp_ctx *comp_ctx,
-				    struct efa_admin_aq_entry *cmd,
-				    size_t cmd_size_in_bytes,
+				    u8 opcode, u8 flags,
+				    void *payload, size_t payload_size,
 				    struct efa_admin_acq_entry *comp,
 				    size_t comp_size_in_bytes)
 {
@@ -411,8 +469,8 @@ static int efa_com_submit_admin_cmd(struct efa_com_admin_queue *aq,
 		return -ENODEV;
 	}
 
-	__efa_com_submit_admin_cmd(aq, comp_ctx, cmd, cmd_size_in_bytes, comp,
-				   comp_size_in_bytes);
+	__efa_com_submit_admin_cmd(aq, comp_ctx, opcode, flags, payload,
+				   payload_size, comp, comp_size_in_bytes);
 	spin_unlock(&aq->sq.lock);
 
 	return 0;
@@ -426,7 +484,7 @@ static bool efa_com_cqe_checksum_valid(struct efa_com_admin_queue *aq,
 
 	cqe->acq_common_descriptor.checksum = 0;
 
-	calc_checksum = crc16(EFA_CRC16_INIT_VAL, (u8 *)cqe, sizeof(*cqe)) ^ EFA_CRC16_INIT_VAL;
+	calc_checksum = efa_com_calc_crc16_checksum((u8 *)cqe, sizeof(*cqe));
 	if (calc_checksum != cqe_checksum) {
 		ibdev_err(aq->efa_dev,
 			  "Received completion with invalid checksum, cqe[%u], calc[%u], sq producer[%d], sq consumer[%d], cq consumer[%d]\n",
@@ -647,11 +705,10 @@ int efa_com_cmd_exec(struct efa_com_admin_queue *aq,
 		     void *payload, size_t payload_size,
 		     struct efa_admin_acq_entry *comp, size_t comp_size)
 {
-	struct efa_admin_aq_entry aq_entry = {};
 	struct efa_comp_ctx *comp_ctx;
 	int err;
 
-	if (payload_size > sizeof(aq_entry.request_payload))
+	if (payload_size > aq->sq.max_payload_size)
 		return -EINVAL;
 
 	might_sleep();
@@ -669,12 +726,8 @@ int efa_com_cmd_exec(struct efa_com_admin_queue *aq,
 		return -EINVAL;
 	}
 
-	aq_entry.aq_common_descriptor.opcode = opcode;
-	aq_entry.aq_common_descriptor.flags = flags;
-	if (payload)
-		memcpy(aq_entry.request_payload, payload, payload_size);
-
-	err = efa_com_submit_admin_cmd(aq, comp_ctx, &aq_entry, sizeof(aq_entry), comp, comp_size);
+	err = efa_com_submit_admin_cmd(aq, comp_ctx, opcode, flags, payload, payload_size, comp,
+				       comp_size);
 	if (err) {
 		ibdev_err_ratelimited(
 			aq->efa_dev,
@@ -1003,8 +1056,8 @@ int efa_com_validate_version(struct efa_com_dev *edev)
 		  EFA_GET(&ver, EFA_REGS_VERSION_MAJOR_VERSION),
 		  EFA_GET(&ver, EFA_REGS_VERSION_MINOR_VERSION));
 
-	EFA_SET(&min_ver, EFA_REGS_VERSION_MAJOR_VERSION, EFA_MIN_ADMIN_API_VERSION_MAJOR);
-	EFA_SET(&min_ver, EFA_REGS_VERSION_MINOR_VERSION, EFA_MIN_ADMIN_API_VERSION_MINOR);
+	min_ver = efa_com_construct_ver(EFA_MIN_API_VERSION_MAJOR,
+					EFA_MIN_API_VERSION_MINOR);
 	if (ver < min_ver) {
 		ibdev_err(edev->efa_dev,
 			  "EFA version is lower than the minimal version the driver supports\n");
diff --git a/drivers/infiniband/hw/efa/efa_com.h b/drivers/infiniband/hw/efa/efa_com.h
index 069c9dd98328..0341704d0921 100644
--- a/drivers/infiniband/hw/efa/efa_com.h
+++ b/drivers/infiniband/hw/efa/efa_com.h
@@ -22,6 +22,9 @@
 
 #define EFA_MAX_HANDLERS 256
 
+#define EFA_ADMIN_V1_PROTO_VER 0
+#define EFA_ADMIN_V2_PROTO_VER 1
+
 struct efa_com_admin_cq {
 	struct efa_admin_acq_entry *entries;
 	dma_addr_t dma_addr;
@@ -35,8 +38,11 @@ struct efa_com_admin_cq {
 struct efa_com_admin_sq {
 	u8 *buffer;
 	u16 entry_size;
+	u16 payload_offset;
+	u16 max_payload_size;
 	dma_addr_t dma_addr;
 	spinlock_t lock; /* Protects ASQ */
+	u8 proto_ver;
 
 	u32 __iomem *db_addr;
 
-- 
2.50.1

