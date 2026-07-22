Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061B24C954E
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 11:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.83.148.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784720036; cv=none; b=CVp8yWkL6uCUVHYcsUCk27ApvQl+5YjsNoXSqYHYhEfQzt/wpZKZ0CWEu/l5TO0ljf5njGb7Lcb9G1PPxl8tJyBy3UsjTRkOtIIRc46aZbgFbobpoGxH0Y6892FgSRU2VaqIDXbChiDXdqqT+eMJ0ja+5tUGeiaJb5qGhB1rYJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784720036; c=relaxed/simple;
	bh=6EXgbEUKPY11gQ7ae+7+nnWKnPfLrW1Um10sfaDRzm4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VBImTNrFYzLUqxJ0llkLdJs0D3pFjoncUeaaz5I+vFY6o3jVLKnzL/Z8fWeOzy3PA0KXggDiPohzC8HdGfZErGsOzJ1t5zP5d9CyNCNCpim9olb1fwGS+NExncifZG84olCG3Eri/wDNpZ6JyZeRkA3/TbwXOlxjW1IkADjEkI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=Ng4PViK4; arc=none smtp.client-ip=35.83.148.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="Ng4PViK4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1784720035; x=1816256035;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q3NQM3OXvQZa+QobfwHyC0yo5EX3ol9TmqBXExj8o+U=;
  b=Ng4PViK4wkiZcp7mJutGychyfi+g/EmwkONmHq2LTwlOs5vo1do6R8J8
   9SpHe0sH0lkDbnqTpLwLEL0K6gzZci9XyJJ1MpyhnPWxkhp3AvVOXKT75
   pHTI/I9flpkqUiV7h9kQ4HvYTIxKwy/jAsMz6aHGc4VsM8A+iQkXn7JHu
   MdHB0X+ZmFjuLkOuNJIxGTJSCWLrsJmz4ZFd/zTobRH2Y/lRLqj7dRi7j
   LG3QU2AU6qgsDk3mu3BkZV/1WJC8wLByH80Q+KKFQGCoxOAtMRXNkz9Nn
   lhFoNwdOLtfm7kiZbY7RJmrx0yz6tXhJ8XKlFf01r94iuS4m7cSdGyHIr
   A==;
X-CSE-ConnectionGUID: Zr/BNeD2QfKZJ9Kixgh9Ow==
X-CSE-MsgGUID: GjmlJr6oRmSCcfxBKgkSdw==
X-IronPort-AV: E=Sophos;i="6.25,178,1779148800"; 
   d="scan'208";a="23937887"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 11:33:52 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:23245]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.12.152:2525] with esmtp (Farcaster)
 id 5814c151-0a0d-4162-9096-25b0d3e86c46; Wed, 22 Jul 2026 11:33:52 +0000 (UTC)
X-Farcaster-Flow-ID: 5814c151-0a0d-4162-9096-25b0d3e86c46
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Wed, 22 Jul 2026 11:33:51 +0000
Received: from dev-dsk-ynachum-1b-0ecf7b87.eu-west-1.amazon.com
 (10.13.226.176) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Wed, 22 Jul 2026
 11:33:50 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <mrgolin@amazon.com>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>, Yonatan Nachum <ynachum@amazon.com>, Tom Sela
	<tomsela@amazon.com>
Subject: [PATCH for-next v2 1/2] RDMA/efa: Add CQ/QP creation with 64-bit SQ req ID support
Date: Wed, 22 Jul 2026 11:33:30 +0000
Message-ID: <20260722113331.2515247-2-ynachum@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260722113331.2515247-1-ynachum@amazon.com>
References: <20260722113331.2515247-1-ynachum@amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D046UWA001.ant.amazon.com (10.13.139.112) To
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
index fc07213e26af..95d1493153cd 100644
--- a/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h
+++ b/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h
@@ -119,7 +119,10 @@ struct efa_admin_create_qp_cmd {
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
 
@@ -523,7 +526,9 @@ struct efa_admin_create_cq_cmd {
 	 * 5 : set_src_addr - If set, source address will be
 	 *    filled on RX completions from unknown senders.
 	 *    Requires 8 words CQ entry size.
-	 * 7:6 : reserved7 - MBZ
+	 * 6 : sq_comp_64_bit_req_id - If set, send
+	 *    completions will use 64-bit work request ids
+	 * 7 : reserved7 - MBZ
 	 */
 	u8 cq_caps_2;
 
@@ -730,7 +735,10 @@ struct efa_admin_feature_device_attr_desc {
 	 *    write with imm. receive is supported
 	 * 5 : event_counters - If set, event counters are
 	 *    supported
-	 * 31:6 : reserved - MBZ
+	 * 9:6 : reserved1 - MBZ
+	 * 10 : sq_64_bit_req_id - If set, SQ can use 64-bit
+	 *    work request ids
+	 * 31:11 : reserved2 - MBZ
 	 */
 	u32 device_caps;
 
@@ -1250,6 +1258,8 @@ struct efa_admin_modify_event_counter_resp {
 #define EFA_ADMIN_CREATE_QP_CMD_SQ_VIRT_MASK                BIT(0)
 #define EFA_ADMIN_CREATE_QP_CMD_RQ_VIRT_MASK                BIT(1)
 #define EFA_ADMIN_CREATE_QP_CMD_UNSOLICITED_WRITE_RECV_MASK BIT(2)
+#define EFA_ADMIN_CREATE_QP_CMD_SQ_64_BIT_REQ_ID_SHIFT      3
+#define EFA_ADMIN_CREATE_QP_CMD_SQ_64_BIT_REQ_ID_MASK       BIT(3)
 
 /* modify_qp_cmd */
 #define EFA_ADMIN_MODIFY_QP_CMD_QP_STATE_MASK               BIT(0)
@@ -1276,6 +1286,8 @@ struct efa_admin_modify_event_counter_resp {
 #define EFA_ADMIN_CREATE_CQ_CMD_VIRT_MASK                   BIT(6)
 #define EFA_ADMIN_CREATE_CQ_CMD_CQ_ENTRY_SIZE_WORDS_MASK    GENMASK(4, 0)
 #define EFA_ADMIN_CREATE_CQ_CMD_SET_SRC_ADDR_MASK           BIT(5)
+#define EFA_ADMIN_CREATE_CQ_CMD_SQ_COMP_64_BIT_REQ_ID_SHIFT 6
+#define EFA_ADMIN_CREATE_CQ_CMD_SQ_COMP_64_BIT_REQ_ID_MASK  BIT(6)
 
 /* create_cq_resp */
 #define EFA_ADMIN_CREATE_CQ_RESP_DB_VALID_MASK              BIT(0)
@@ -1287,6 +1299,8 @@ struct efa_admin_modify_event_counter_resp {
 #define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_RDMA_WRITE_MASK  BIT(3)
 #define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_UNSOLICITED_WRITE_RECV_MASK BIT(4)
 #define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_EVENT_COUNTERS_MASK BIT(5)
+#define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_SQ_64_BIT_REQ_ID_SHIFT 10
+#define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_SQ_64_BIT_REQ_ID_MASK BIT(10)
 
 /* feature_queue_attr_desc_2 */
 #define EFA_ADMIN_FEATURE_QUEUE_ATTR_DESC_2_SEND_COMP_MASK  BIT(0)
diff --git a/drivers/infiniband/hw/efa/efa_com_cmd.c b/drivers/infiniband/hw/efa/efa_com_cmd.c
index a9fd44b4debf..198a27d02b18 100644
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
index 3e7380fa0abb..bca722f021ea 100644
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
index a849d92a6eb6..1444552de2de 100644
--- a/drivers/infiniband/hw/efa/efa_io_defs.h
+++ b/drivers/infiniband/hw/efa/efa_io_defs.h
@@ -79,6 +79,10 @@ enum efa_io_processing_hint {
 	EFA_IO_PROCESSING_HINT_BURST_PPS_SENSITIVE  = 1 << 0,
 };
 
+struct efa_io_req_id_ex {
+	u16 w[3];
+};
+
 struct efa_io_tx_meta_desc {
 	/* Verbs-generated Request ID */
 	u16 req_id;
@@ -141,7 +145,9 @@ struct efa_io_tx_meta_desc {
 	/* Queue key */
 	u32 qkey;
 
-	u8 reserved2[12];
+	u8 reserved2[6];
+
+	struct efa_io_req_id_ex req_id_ex;
 };
 
 /*
@@ -327,8 +333,10 @@ struct efa_io_tx_cdesc {
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
index 9bc8199b60bf..73a80caca7e2 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -719,6 +719,9 @@ int efa_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *init_attr,
 	if (EFA_DEV_CAP(dev, UNSOLICITED_WRITE_RECV))
 		supported_efa_flags |= EFA_CREATE_QP_WITH_UNSOLICITED_WRITE_RECV;
 
+	if (EFA_DEV_CAP(dev, SQ_64_BIT_REQ_ID))
+		supported_efa_flags |= EFA_CREATE_QP_WITH_SQ_64_BIT_REQ_ID;
+
 	if (cmd.flags & ~supported_efa_flags) {
 		ibdev_dbg(&dev->ibdev, "Unsupported EFA QP create flags[%#x], supported[%#x]\n",
 			  cmd.flags, supported_efa_flags);
@@ -778,6 +781,9 @@ int efa_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *init_attr,
 	if (cmd.flags & EFA_CREATE_QP_WITH_UNSOLICITED_WRITE_RECV)
 		create_qp_params.unsolicited_write_recv = true;
 
+	if (cmd.flags & EFA_CREATE_QP_WITH_SQ_64_BIT_REQ_ID)
+		create_qp_params.sq_64_bit_req_id = true;
+
 	err = efa_com_create_qp(&dev->edev, &create_qp_params,
 				&create_qp_resp);
 	if (err)
@@ -1212,6 +1218,7 @@ int efa_create_user_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	params.entry_size_in_bytes = cmd.cq_entry_size;
 	params.num_sub_cqs = cmd.num_sub_cqs;
 	params.set_src_addr = set_src_addr;
+	params.sq_comp_64_bit_req_id = !!(cmd.flags & EFA_CREATE_CQ_WITH_SQ_COMP_64_BIT_REQ_ID);
 	if (cmd.flags & EFA_CREATE_CQ_WITH_COMPLETION_CHANNEL) {
 		cq->eq = efa_vec2eq(dev, attr->comp_vector);
 		params.eqn = cq->eq->eeq.eqn;
diff --git a/include/uapi/rdma/efa-abi.h b/include/uapi/rdma/efa-abi.h
index c79b54aade23..5d3d01b6333e 100644
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

