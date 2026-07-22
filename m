Received: from pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.245.243.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D02388860
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 08:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.245.243.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784709498; cv=none; b=hbrcKbYRWWwnHlTpP3EIuAhvl4HdmS9JTDTmb2py1TK7yRvH0UAoHHlVOam/lvySVI5WWn6aTauNw2dRb6Dx63wwk8kz0P1yMh9N2if+mfDiXAxFQXrlgzA/VipcQCHlY3iPe+LM/kpN25IkSbmQ7I1iKZUoqNqyAoX4BzUW5ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784709498; c=relaxed/simple;
	bh=KoPy4wtQTsoYRRr2NU/Og++e8AWt8VawhuDVmmf3MAc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u6VjIEe4fI5oUMgnYygqBLnqhG8dk+foSuFLPzIOBPuh6elOfFtTqDfpZ228eL/3sWtXUggnU3DySst0lBztJsTnqJK8Oy4r8Dc7FL4qTyorWnHP7L4M4NSiN1htEyk+Yy7BMT09boe4GR3DpWnz/6Ss6h4MbSEZxtkiOfQjl4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=f0pm/WpC; arc=none smtp.client-ip=44.245.243.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="f0pm/WpC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1784709496; x=1816245496;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DE4lSs2n7eN1m9pxN88327OSA0YlhyGwbN0h6F1B3nM=;
  b=f0pm/WpCFUwbcqy8yE5OaFTM0XOVVjZIn2fReuzBNGg7QPKphGjmkOEA
   3WFbniRUfwqaRt+QvEKU1Y429fJBu6T6dSMq8SAklSvxOL10io4WHv1Ku
   Bf6l6IY3T8xuacaorMKcuTlziKR7fbov8GrrIIDpYtLw3In4aYmkuUnR2
   woBoMP9eWnvRH0EEqjJwr7hSafPajZeE4dmbYBvENZIiHbW3QQWx2Igls
   qYWy3hbVbIFJigqU3fQ2F85qCE0hOZgeop8ScfGw0sjZj/cLkwrq9YoPS
   detQnUioK3lRVntHrQpXrHr39DgbDBgnZPuemGpRa+0Fx8z2ZfE8nZBOa
   g==;
X-CSE-ConnectionGUID: 2UW1gN++SEeETEUo9k4tjA==
X-CSE-MsgGUID: ihE6sSJeREWeGJ89lsWJcA==
X-Ironport-Invalid-End-Of-Message: True
X-IronPort-AV: E=Sophos;i="6.25,178,1779148800"; 
   d="scan'208";a="23640137"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 08:38:16 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:25255]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.40.177:2525] with esmtp (Farcaster)
 id 96435d6b-5c82-4d73-afe0-f8931e405fa3; Wed, 22 Jul 2026 08:38:16 +0000 (UTC)
X-Farcaster-Flow-ID: 96435d6b-5c82-4d73-afe0-f8931e405fa3
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Wed, 22 Jul 2026 08:38:15 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Wed, 22 Jul 2026
 08:38:14 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <sleybo@amazon.com>, <matua@amazon.com>, <gal.pressman@linux.dev>, "Daniel
 Kinsbursky" <dkinsb@amazon.com>, Yonatan Nachum <ynachum@amazon.com>
Subject: [PATCH for-next v11 5/6] RDMA/efa: Update device interface
Date: Wed, 22 Jul 2026 08:36:02 +0000
Message-ID: <20260722083603.30334-6-mrgolin@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722083603.30334-1-mrgolin@amazon.com>
References: <20260722083603.30334-1-mrgolin@amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D046UWB001.ant.amazon.com (10.13.139.187) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Align device interface definitions.

Reviewed-by: Daniel Kinsbursky <dkinsb@amazon.com>
Reviewed-by: Yonatan Nachum <ynachum@amazon.com>
Signed-off-by: Michael Margolin <mrgolin@amazon.com>
---
 .../infiniband/hw/efa/efa_admin_cmds_defs.h   | 186 +++++++++++++++++-
 drivers/infiniband/hw/efa/efa_io_defs.h       |  20 +-
 2 files changed, 202 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h b/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h
index 3eb3a4de8912..fc07213e26af 100644
--- a/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h
+++ b/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h
@@ -28,7 +28,13 @@ enum efa_admin_aq_opcode {
 	EFA_ADMIN_CREATE_EQ                         = 18,
 	EFA_ADMIN_DESTROY_EQ                        = 19,
 	EFA_ADMIN_ALLOC_MR                          = 20,
-	EFA_ADMIN_MAX_OPCODE                        = 20,
+	EFA_ADMIN_SERVICE                           = 21,
+	EFA_ADMIN_CREATE_EVENT_COUNTER              = 25,
+	EFA_ADMIN_DESTROY_EVENT_COUNTER             = 26,
+	EFA_ADMIN_ATTACH_EVENT_COUNTER              = 27,
+	EFA_ADMIN_MODIFY_EVENT_COUNTER              = 28,
+	EFA_ADMIN_DETACH_EVENT_COUNTER              = 29,
+	EFA_ADMIN_MAX_OPCODE                        = 29,
 };
 
 enum efa_admin_aq_feature_id {
@@ -722,7 +728,9 @@ struct efa_admin_feature_device_attr_desc {
 	 *    on TX queues
 	 * 4 : unsolicited_write_recv - If set, unsolicited
 	 *    write with imm. receive is supported
-	 * 31:5 : reserved - MBZ
+	 * 5 : event_counters - If set, event counters are
+	 *    supported
+	 * 31:6 : reserved - MBZ
 	 */
 	u32 device_caps;
 
@@ -811,6 +819,34 @@ struct efa_admin_feature_queue_attr_desc_1 {
 struct efa_admin_feature_queue_attr_desc_2 {
 	/* Maximum size of data that can be sent inline in a Send WQE */
 	u16 inline_buf_size_ex;
+
+	/* MBZ */
+	u8 reserved[6];
+
+	/*
+	 * Supported counter QP events
+	 * 0 : send_comp
+	 * 1 : send_comp_err
+	 * 2 : recv_comp
+	 * 3 : recv_comp_err
+	 * 4 : read_comp
+	 * 5 : read_comp_err
+	 * 6 : write_comp
+	 * 7 : write_comp_err
+	 * 8 : remote_read_comp
+	 * 9 : remote_write_comp
+	 * 31:10 : reserved - MBZ
+	 */
+	u32 supported_event_counter_qp_events;
+
+	/* Maximum number of counters */
+	u32 max_event_counters;
+
+	/*
+	 * Maximum counter value, counter wraps around to 0 after reaching
+	 * this value
+	 */
+	u64 event_counter_max_val;
 };
 
 struct efa_admin_event_queue_attr_desc {
@@ -1089,6 +1125,127 @@ struct efa_admin_host_info {
 	u32 flags;
 };
 
+struct efa_admin_service_cmd {
+	struct efa_admin_aq_common_desc aq_common_descriptor;
+
+	u8 buffer[60];
+};
+
+struct efa_admin_service_resp {
+	struct efa_admin_acq_common_desc acq_common_desc;
+
+	u8 buffer[56];
+};
+
+/* Create Counter command */
+struct efa_admin_create_event_counter_cmd {
+	struct efa_admin_aq_common_desc aq_common_descriptor;
+
+	/* UAR number */
+	u16 uar;
+
+	/* MBZ */
+	u16 reserved;
+
+	/* Counter physical address */
+	u64 paddr;
+};
+
+struct efa_admin_create_event_counter_resp {
+	struct efa_admin_acq_common_desc acq_common_desc;
+
+	/* Counter handle */
+	u32 cntr_handle;
+
+	/* MBZ */
+	u32 reserved;
+};
+
+struct efa_admin_destroy_event_counter_cmd {
+	struct efa_admin_aq_common_desc aq_common_descriptor;
+
+	/* Counter handle */
+	u32 cntr_handle;
+};
+
+struct efa_admin_destroy_event_counter_resp {
+	struct efa_admin_acq_common_desc acq_common_desc;
+};
+
+enum efa_admin_event_counter_attach_type {
+	EFA_ADMIN_EVENT_COUNTER_ATTACH_QP_EVENTS    = 0,
+};
+
+struct efa_admin_event_counter_attach_qp_events {
+	/* QP handle */
+	u32 qp_handle;
+
+	/*
+	 * Bitmask of counter QP events
+	 * 0 : send_comp
+	 * 1 : send_comp_err
+	 * 2 : recv_comp
+	 * 3 : recv_comp_err
+	 * 4 : read_comp
+	 * 5 : read_comp_err
+	 * 6 : write_comp
+	 * 7 : write_comp_err
+	 * 8 : remote_read_comp
+	 * 9 : remote_write_comp
+	 * 31:10 : reserved - MBZ
+	 */
+	u32 events;
+};
+
+struct efa_admin_attach_detach_event_counter_cmd {
+	struct efa_admin_aq_common_desc aq_common_descriptor;
+
+	/* Counter handle */
+	u32 cntr_handle;
+
+	/* efa_admin_event_counter_attach_type */
+	u8 attach_type;
+
+	/* MBZ */
+	u8 reserved[3];
+
+	union {
+		struct efa_admin_event_counter_attach_qp_events qp_events;
+	} u;
+};
+
+struct efa_admin_attach_detach_event_counter_resp {
+	struct efa_admin_acq_common_desc acq_common_desc;
+};
+
+/* Counter modify operations */
+enum efa_admin_event_counter_modify_ops {
+	/* Set counter value */
+	EFA_ADMIN_EVENT_COUNTER_MODIFY_SET          = 0,
+	/* Add to counter value */
+	EFA_ADMIN_EVENT_COUNTER_MODIFY_ADD          = 1,
+};
+
+struct efa_admin_modify_event_counter_cmd {
+	struct efa_admin_aq_common_desc aq_common_descriptor;
+
+	/* Counter handle */
+	u32 cntr_handle;
+
+	/* Counter operation type (efa_admin_event_counter_modify_ops) */
+	u8 operation;
+
+	/* MBZ */
+	u8 reserved[7];
+
+	/* Value for SET or ADD */
+	u64 value;
+};
+
+struct efa_admin_modify_event_counter_resp {
+	struct efa_admin_acq_common_desc acq_common_desc;
+};
+
 /* create_qp_cmd */
 #define EFA_ADMIN_CREATE_QP_CMD_SQ_VIRT_MASK                BIT(0)
 #define EFA_ADMIN_CREATE_QP_CMD_RQ_VIRT_MASK                BIT(1)
@@ -1129,6 +1286,19 @@ struct efa_admin_host_info {
 #define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_DATA_POLLING_128_MASK BIT(2)
 #define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_RDMA_WRITE_MASK  BIT(3)
 #define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_UNSOLICITED_WRITE_RECV_MASK BIT(4)
+#define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_EVENT_COUNTERS_MASK BIT(5)
+
+/* feature_queue_attr_desc_2 */
+#define EFA_ADMIN_FEATURE_QUEUE_ATTR_DESC_2_SEND_COMP_MASK  BIT(0)
+#define EFA_ADMIN_FEATURE_QUEUE_ATTR_DESC_2_SEND_COMP_ERR_MASK BIT(1)
+#define EFA_ADMIN_FEATURE_QUEUE_ATTR_DESC_2_RECV_COMP_MASK  BIT(2)
+#define EFA_ADMIN_FEATURE_QUEUE_ATTR_DESC_2_RECV_COMP_ERR_MASK BIT(3)
+#define EFA_ADMIN_FEATURE_QUEUE_ATTR_DESC_2_READ_COMP_MASK  BIT(4)
+#define EFA_ADMIN_FEATURE_QUEUE_ATTR_DESC_2_READ_COMP_ERR_MASK BIT(5)
+#define EFA_ADMIN_FEATURE_QUEUE_ATTR_DESC_2_WRITE_COMP_MASK BIT(6)
+#define EFA_ADMIN_FEATURE_QUEUE_ATTR_DESC_2_WRITE_COMP_ERR_MASK BIT(7)
+#define EFA_ADMIN_FEATURE_QUEUE_ATTR_DESC_2_REMOTE_READ_COMP_MASK BIT(8)
+#define EFA_ADMIN_FEATURE_QUEUE_ATTR_DESC_2_REMOTE_WRITE_COMP_MASK BIT(9)
 
 /* create_eq_cmd */
 #define EFA_ADMIN_CREATE_EQ_CMD_ENTRY_SIZE_WORDS_MASK       GENMASK(4, 0)
@@ -1147,4 +1317,16 @@ struct efa_admin_host_info {
 #define EFA_ADMIN_HOST_INFO_INTREE_MASK                     BIT(0)
 #define EFA_ADMIN_HOST_INFO_GDR_MASK                        BIT(1)
 
+/* counter_attach_qp_events */
+#define EFA_ADMIN_EVENT_COUNTER_ATTACH_QP_EVENTS_SEND_COMP_MASK   BIT(0)
+#define EFA_ADMIN_EVENT_COUNTER_ATTACH_QP_EVENTS_SEND_COMP_ERR_MASK BIT(1)
+#define EFA_ADMIN_EVENT_COUNTER_ATTACH_QP_EVENTS_RECV_COMP_MASK   BIT(2)
+#define EFA_ADMIN_EVENT_COUNTER_ATTACH_QP_EVENTS_RECV_COMP_ERR_MASK BIT(3)
+#define EFA_ADMIN_EVENT_COUNTER_ATTACH_QP_EVENTS_READ_COMP_MASK   BIT(4)
+#define EFA_ADMIN_EVENT_COUNTER_ATTACH_QP_EVENTS_READ_COMP_ERR_MASK BIT(5)
+#define EFA_ADMIN_EVENT_COUNTER_ATTACH_QP_EVENTS_WRITE_COMP_MASK  BIT(6)
+#define EFA_ADMIN_EVENT_COUNTER_ATTACH_QP_EVENTS_WRITE_COMP_ERR_MASK BIT(7)
+#define EFA_ADMIN_EVENT_COUNTER_ATTACH_QP_EVENTS_REMOTE_READ_COMP_MASK BIT(8)
+#define EFA_ADMIN_EVENT_COUNTER_ATTACH_QP_EVENTS_REMOTE_WRITE_COMP_MASK BIT(9)
+
 #endif /* _EFA_ADMIN_CMDS_H_ */
diff --git a/drivers/infiniband/hw/efa/efa_io_defs.h b/drivers/infiniband/hw/efa/efa_io_defs.h
index a4c9fd33da38..a849d92a6eb6 100644
--- a/drivers/infiniband/hw/efa/efa_io_defs.h
+++ b/drivers/infiniband/hw/efa/efa_io_defs.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
 /*
- * Copyright 2018-2024 Amazon.com, Inc. or its affiliates. All rights reserved.
+ * Copyright 2018-2026 Amazon.com, Inc. or its affiliates. All rights reserved.
  */
 
 #ifndef _EFA_IO_H_
@@ -65,6 +65,8 @@ enum efa_io_comp_status {
 	EFA_IO_COMP_STATUS_REMOTE_ERROR_UNKNOWN_PEER = 14,
 	/* Unreachable remote - never received a response */
 	EFA_IO_COMP_STATUS_LOCAL_ERROR_UNREACH_REMOTE = 15,
+	/* Remote feature mismatch */
+	EFA_IO_COMP_STATUS_REMOTE_ERROR_FEATURE_MISMATCH = 18,
 };
 
 enum efa_io_frwr_pbl_mode {
@@ -72,6 +74,11 @@ enum efa_io_frwr_pbl_mode {
 	EFA_IO_FRWR_DIRECT_PBL                      = 1,
 };
 
+enum efa_io_processing_hint {
+	/* Optimize for throughput */
+	EFA_IO_PROCESSING_HINT_BURST_PPS_SENSITIVE  = 1 << 0,
+};
+
 struct efa_io_tx_meta_desc {
 	/* Verbs-generated Request ID */
 	u16 req_id;
@@ -121,7 +128,15 @@ struct efa_io_tx_meta_desc {
 
 	u16 ah;
 
-	u16 reserved;
+	/*
+	 * control flags
+	 * 1:0 : processing_hints - Bitmask of enum
+	 *    efa_io_processing_hint
+	 * 7:2 : reserved - MBZ
+	 */
+	u8 ctrl3;
+
+	u8 reserved;
 
 	/* Queue key */
 	u32 qkey;
@@ -365,6 +380,7 @@ struct efa_io_rx_cdesc_ex {
 #define EFA_IO_TX_META_DESC_FIRST_MASK                      BIT(2)
 #define EFA_IO_TX_META_DESC_LAST_MASK                       BIT(3)
 #define EFA_IO_TX_META_DESC_COMP_REQ_MASK                   BIT(4)
+#define EFA_IO_TX_META_DESC_PROCESSING_HINTS_MASK           GENMASK(1, 0)
 
 /* tx_buf_desc */
 #define EFA_IO_TX_BUF_DESC_LKEY_MASK                        GENMASK(23, 0)
-- 
2.47.3

