Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A563FDBF7
	for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 07:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.162.73.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784617251; cv=none; b=Wc/saUNYCRp1FvnixHfztkhbVAoEhR8y6qwTzO/x2cW4ZmX08E38l1EwlffhugVLo2a8CUHkdHvaJnNF1jeOQtp1lBqvoGmCxf4ClKCkmPVso7VShIdIEXtUNzISPxUoVUAPKC1wCFqbMYY7PEx0Tt82/Yh0jTWmk1qbbYaji4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784617251; c=relaxed/simple;
	bh=ipGVfN+6jFz4FGfUjOhY5edXRGq1ZZiGyW5XXPK0yLQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M74hcFS4XKrroYbYZawi1DyPwG6Q5/SbYEPbS3qwtTqlp1pE6nlubJnzIg2W87bTvddvwtG1E7Az0SRWNF6LbG75IR0sr0r9O1AhXbT5XM/HcRHRyPvHjp5m8g8tszvMlsDjl7plPxO1wIQLkHpUbNY20uS2mmx4kJXrlYnH6pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=eNkc0x5k; arc=none smtp.client-ip=35.162.73.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="eNkc0x5k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1784617250; x=1816153250;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PMJGxP7/fy2MknJnivh/3rjW5VxwIR0qTMP0Rh4c+Tc=;
  b=eNkc0x5kK+gOmvYFl/S9A5rpxJ5mmJDSaSEALzA+U6JOcdd2k6YNjrSk
   yEMNImbtMo6wSuCkjsTHU3jtokfR1gcyQWZleGg1IiJLb6fe6Wv5F6gX/
   uPByyA5lm2qUcB9rqNjlECi7ggV8zS3QE47ccmRq23nskvwwanoUEUjEu
   YuqLjqhgyEt1/zGg6wrv5y1h46L998wbGz7fxXCJWQGfBffDhi3kMW7xZ
   c8Sq5HLx6JrE+yV2GwC5bEELvoczfC34M4T5JWGGn7POESOSA2FWtBP7G
   qyvM99+FN0HWs1Q0FmvM+ldRfr1dESs8VuCi9BmMf2Fv7coY9k+FxZyEo
   w==;
X-CSE-ConnectionGUID: Lr68uRJQSiG6baOmJyaH3g==
X-CSE-MsgGUID: /Nau+6DQRsS0JilV0Mi1aA==
X-IronPort-AV: E=Sophos;i="6.25,176,1779148800"; 
   d="scan'208";a="23849912"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 07:00:46 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:12856]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.0.115:2525] with esmtp (Farcaster)
 id 8fed0d5a-d262-49a4-8923-6ade820c28dc; Tue, 21 Jul 2026 07:00:46 +0000 (UTC)
X-Farcaster-Flow-ID: 8fed0d5a-d262-49a4-8923-6ade820c28dc
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Tue, 21 Jul 2026 07:00:46 +0000
Received: from dev-dsk-ynachum-1b-0ecf7b87.eu-west-1.amazon.com
 (10.13.226.176) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Tue, 21 Jul 2026
 07:00:44 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <mrgolin@amazon.com>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>, Yonatan Nachum <ynachum@amazon.com>, Tom Sela
	<tomsela@amazon.com>
Subject: [PATCH for-next 1/2] RDMA/efa: Add CQ/QP creation with 64-bit SQ req ID support
Date: Tue, 21 Jul 2026 07:00:25 +0000
Message-ID: <20260721070026.1635441-2-ynachum@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260721070026.1635441-1-ynachum@amazon.com>
References: <20260721070026.1635441-1-ynachum@amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D035UWA004.ant.amazon.com (10.13.139.109) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Add the support needed to propagate the user requested flags to config
the CQ/QP to support 64-bit SQ request ID to the device.

Reviewed-by: Michael Margolin <mrgolin@amazon.com>
Reviewed-by: Tom Sela <tomsela@amazon.com>
Signed-off-by: Yonatan Nachum <ynachum@amazon.com>
---
 .../infiniband/hw/efa/efa_admin_cmds_defs.h   | 20 ++++++++++++++++---
 drivers/infiniband/hw/efa/efa_com_cmd.c       |  8 ++++++++
 drivers/infiniband/hw/efa/efa_com_cmd.h       |  2 ++
 drivers/infiniband/hw/efa/efa_io_defs.h       | 12 +++++++++--
 drivers/infiniband/hw/efa/efa_verbs.c         |  7 +++++++
 include/uapi/rdma/efa-abi.h                   |  4 +++-
 6 files changed, 47 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h b/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h
index 3eb3a4de8912..28076f122164 100644
--- a/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h
+++ b/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h
@@ -113,7 +113,10 @@ struct efa_admin_create_qp_cmd {
 	 * 2 : unsolicited_write_recv - If set, work requests
 	 *    will not be consumed for incoming RDMA write with
 	 *    immediate
-	 * 7:3 : reserved - MBZ
+	 * 3 : sq_64_bit_req_id - If set, requests posted on
+	 *    SQ will use 64-bit ids. The corresponding CQ must
+	 *    also have 64-bit ids enabled.
+	 * 7:4 : reserved - MBZ
 	 */
 	u8 flags;
 
@@ -517,7 +520,9 @@ struct efa_admin_create_cq_cmd {
 	 * 5 : set_src_addr - If set, source address will be
 	 *    filled on RX completions from unknown senders.
 	 *    Requires 8 words CQ entry size.
-	 * 7:6 : reserved7 - MBZ
+	 * 6 : sq_comp_64_bit_req_id - If set, send
+	 *    completions will use 64-bit work request ids
+	 * 7 : reserved7 - MBZ
 	 */
 	u8 cq_caps_2;
 
@@ -722,7 +727,10 @@ struct efa_admin_feature_device_attr_desc {
 	 *    on TX queues
 	 * 4 : unsolicited_write_recv - If set, unsolicited
 	 *    write with imm. receive is supported
-	 * 31:5 : reserved - MBZ
+	 * 9:5 : reserved1 - MBZ
+	 * 10 : sq_64_bit_req_id - If set, SQ can use 64-bit
+	 *    work request ids
+	 * 31:11 : reserved2 - MBZ
 	 */
 	u32 device_caps;
 
@@ -1093,6 +1101,8 @@ struct efa_admin_host_info {
 #define EFA_ADMIN_CREATE_QP_CMD_SQ_VIRT_MASK                BIT(0)
 #define EFA_ADMIN_CREATE_QP_CMD_RQ_VIRT_MASK                BIT(1)
 #define EFA_ADMIN_CREATE_QP_CMD_UNSOLICITED_WRITE_RECV_MASK BIT(2)
+#define EFA_ADMIN_CREATE_QP_CMD_SQ_64_BIT_REQ_ID_SHIFT      3
+#define EFA_ADMIN_CREATE_QP_CMD_SQ_64_BIT_REQ_ID_MASK       BIT(3)
 
 /* modify_qp_cmd */
 #define EFA_ADMIN_MODIFY_QP_CMD_QP_STATE_MASK               BIT(0)
@@ -1119,6 +1129,8 @@ struct efa_admin_host_info {
 #define EFA_ADMIN_CREATE_CQ_CMD_VIRT_MASK                   BIT(6)
 #define EFA_ADMIN_CREATE_CQ_CMD_CQ_ENTRY_SIZE_WORDS_MASK    GENMASK(4, 0)
 #define EFA_ADMIN_CREATE_CQ_CMD_SET_SRC_ADDR_MASK           BIT(5)
+#define EFA_ADMIN_CREATE_CQ_CMD_SQ_COMP_64_BIT_REQ_ID_SHIFT 6
+#define EFA_ADMIN_CREATE_CQ_CMD_SQ_COMP_64_BIT_REQ_ID_MASK  BIT(6)
 
 /* create_cq_resp */
 #define EFA_ADMIN_CREATE_CQ_RESP_DB_VALID_MASK              BIT(0)
@@ -1129,6 +1141,8 @@ struct efa_admin_host_info {
 #define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_DATA_POLLING_128_MASK BIT(2)
 #define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_RDMA_WRITE_MASK  BIT(3)
 #define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_UNSOLICITED_WRITE_RECV_MASK BIT(4)
+#define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_SQ_64_BIT_REQ_ID_SHIFT 10
+#define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_SQ_64_BIT_REQ_ID_MASK BIT(10)
 
 /* create_eq_cmd */
 #define EFA_ADMIN_CREATE_EQ_CMD_ENTRY_SIZE_WORDS_MASK       GENMASK(4, 0)
diff --git a/drivers/infiniband/hw/efa/efa_com_cmd.c b/drivers/infiniband/hw/efa/efa_com_cmd.c
index 0b96862c2787..169f834630bb 100644
--- a/drivers/infiniband/hw/efa/efa_com_cmd.c
+++ b/drivers/infiniband/hw/efa/efa_com_cmd.c
@@ -38,6 +38,9 @@ int efa_com_create_qp(struct efa_com_dev *edev,
 	if (params->unsolicited_write_recv)
 		EFA_SET(&create_qp_cmd.flags, EFA_ADMIN_CREATE_QP_CMD_UNSOLICITED_WRITE_RECV, 1);
 
+	if (params->sq_64_bit_req_id)
+		EFA_SET(&create_qp_cmd.flags, EFA_ADMIN_CREATE_QP_CMD_SQ_64_BIT_REQ_ID, 1);
+
 	err = efa_com_cmd_exec(aq,
 			       (struct efa_admin_aq_entry *)&create_qp_cmd,
 			       sizeof(create_qp_cmd),
@@ -178,6 +181,11 @@ int efa_com_create_cq(struct efa_com_dev *edev,
 		EFA_SET(&create_cmd.cq_caps_2,
 			EFA_ADMIN_CREATE_CQ_CMD_SET_SRC_ADDR, 1);
 	}
+	if (params->sq_comp_64_bit_req_id) {
+		EFA_SET(&create_cmd.cq_caps_2,
+			EFA_ADMIN_CREATE_CQ_CMD_SQ_COMP_64_BIT_REQ_ID, 1);
+	}
+
 	efa_com_set_dma_addr(params->dma_addr,
 			     &create_cmd.cq_ba.mem_addr_high,
 			     &create_cmd.cq_ba.mem_addr_low);
diff --git a/drivers/infiniband/hw/efa/efa_com_cmd.h b/drivers/infiniband/hw/efa/efa_com_cmd.h
index 39bd4e06684a..bd8f12ba3e62 100644
--- a/drivers/infiniband/hw/efa/efa_com_cmd.h
+++ b/drivers/infiniband/hw/efa/efa_com_cmd.h
@@ -29,6 +29,7 @@ struct efa_com_create_qp_params {
 	u8 qp_type;
 	u8 sl;
 	u8 unsolicited_write_recv : 1;
+	u8 sq_64_bit_req_id : 1;
 };
 
 struct efa_com_create_qp_result {
@@ -79,6 +80,7 @@ struct efa_com_create_cq_params {
 	u8 entry_size_in_bytes;
 	u8 interrupt_mode_enabled : 1;
 	u8 set_src_addr : 1;
+	u8 sq_comp_64_bit_req_id : 1;
 };
 
 struct efa_com_create_cq_result {
diff --git a/drivers/infiniband/hw/efa/efa_io_defs.h b/drivers/infiniband/hw/efa/efa_io_defs.h
index a4c9fd33da38..9858bab8ba8d 100644
--- a/drivers/infiniband/hw/efa/efa_io_defs.h
+++ b/drivers/infiniband/hw/efa/efa_io_defs.h
@@ -72,6 +72,10 @@ enum efa_io_frwr_pbl_mode {
 	EFA_IO_FRWR_DIRECT_PBL                      = 1,
 };
 
+struct efa_io_req_id_ex {
+	u16 w[3];
+};
+
 struct efa_io_tx_meta_desc {
 	/* Verbs-generated Request ID */
 	u16 req_id;
@@ -126,7 +130,9 @@ struct efa_io_tx_meta_desc {
 	/* Queue key */
 	u32 qkey;
 
-	u8 reserved2[12];
+	u8 reserved2[6];
+
+	struct efa_io_req_id_ex req_id_ex;
 };
 
 /*
@@ -312,8 +318,10 @@ struct efa_io_tx_cdesc {
 	/* Common completion info */
 	struct efa_io_cdesc_common common;
 
+	struct efa_io_req_id_ex req_id_ex;
+
 	/* MBZ */
-	u16 reserved16;
+	u8 reserved[4];
 };
 
 /* Rx Completion Descriptor */
diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
index 6be8ec53dcb3..001bd8cb4f66 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -711,6 +711,9 @@ int efa_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *init_attr,
 	if (EFA_DEV_CAP(dev, UNSOLICITED_WRITE_RECV))
 		supported_efa_flags |= EFA_CREATE_QP_WITH_UNSOLICITED_WRITE_RECV;
 
+	if (EFA_DEV_CAP(dev, SQ_64_BIT_REQ_ID))
+		supported_efa_flags |= EFA_CREATE_QP_WITH_SQ_64_BIT_REQ_ID;
+
 	if (cmd.flags & ~supported_efa_flags) {
 		ibdev_dbg(&dev->ibdev, "Unsupported EFA QP create flags[%#x], supported[%#x]\n",
 			  cmd.flags, supported_efa_flags);
@@ -770,6 +773,9 @@ int efa_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *init_attr,
 	if (cmd.flags & EFA_CREATE_QP_WITH_UNSOLICITED_WRITE_RECV)
 		create_qp_params.unsolicited_write_recv = true;
 
+	if (cmd.flags & EFA_CREATE_QP_WITH_SQ_64_BIT_REQ_ID)
+		create_qp_params.sq_64_bit_req_id = true;
+
 	err = efa_com_create_qp(&dev->edev, &create_qp_params,
 				&create_qp_resp);
 	if (err)
@@ -1204,6 +1210,7 @@ int efa_create_user_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	params.entry_size_in_bytes = cmd.cq_entry_size;
 	params.num_sub_cqs = cmd.num_sub_cqs;
 	params.set_src_addr = set_src_addr;
+	params.sq_comp_64_bit_req_id = !!(cmd.flags & EFA_CREATE_CQ_WITH_SQ_COMP_64_BIT_REQ_ID);
 	if (cmd.flags & EFA_CREATE_CQ_WITH_COMPLETION_CHANNEL) {
 		cq->eq = efa_vec2eq(dev, attr->comp_vector);
 		params.eqn = cq->eq->eeq.eqn;
diff --git a/include/uapi/rdma/efa-abi.h b/include/uapi/rdma/efa-abi.h
index d5c18f8de182..fc4b2eb903c9 100644
--- a/include/uapi/rdma/efa-abi.h
+++ b/include/uapi/rdma/efa-abi.h
@@ -56,7 +56,8 @@ struct efa_ibv_alloc_pd_resp {
 
 enum {
 	EFA_CREATE_CQ_WITH_COMPLETION_CHANNEL = 1 << 0,
-	EFA_CREATE_CQ_WITH_SGID               = 1 << 1,
+	EFA_CREATE_CQ_WITH_SGID = 1 << 1,
+	EFA_CREATE_CQ_WITH_SQ_COMP_64_BIT_REQ_ID = 1 << 2,
 };
 
 struct efa_ibv_create_cq {
@@ -88,6 +89,7 @@ enum {
 
 enum {
 	EFA_CREATE_QP_WITH_UNSOLICITED_WRITE_RECV = 1 << 0,
+	EFA_CREATE_QP_WITH_SQ_64_BIT_REQ_ID = 1 << 1,
 };
 
 struct efa_ibv_create_qp {
-- 
2.50.1

