Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=44.245.243.92
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794212043;
	b=r96gzOOOQ+ol2JYR88vaKJMGrvMFgQY7tIzhrWw7zq7XHIPqWA8+7UPHl9t1x+hY4diw
	 XnRnb0W69b3csV2j0gay3qS/t4Ce+wGqgQ5X0GV9/KCKxOaBL/GyvNz6FQnKRQAuNFD+b
	 WPr7eahjolOR+954dmF9cooVsr9zsaBA0noTO8pjY6vBw8MliZACjby+O2R0w1+MQuQjl
	 PikX4OpEIR9Yft8vfbJHWlTzlr3OnAUisSONZNfqYG+gN9oQ+SVOH54fSvPsQUgwNtpKl
	 Wn5RwLuLhcK1AOy1SqXHNQl+Om5r+0Q1vEGv0TaI4NaI2lTB/xNXXX5xVxvDyc5cNVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794212043;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Received:X-Farcaster-Flow-ID:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=JLZlpBd1d3BDj3Wu1cwsGgCishghlLkO8yxS5u3nun8=;
	b=GSuZ59sLGBE60zZUZ+ZQPhLtOlOMz+RQMrDOG5ienQP3lzFWoVVOcp8ZCZAhbDVQvD8q
	 U9z7Y1GGtljyozhDziLMdHoTPOJPveQ2OyLoTKRDK3lgLX6U147khRIg/7LBvn3QTdG4L
	 XEMLXhpPLVeRDErGFofMy288x5uOL2vHsZ+tsB9DHNyrlP59VRy1vI9TgrG/EjfvhcEhV
	 JmL0LbTWiS2jhzaDC2uFGaYJXA6ZUgK/dpT3pies35mP2l7JsgwkZr4CbGVuDQLAygDbM
	 kGuPE27Yll18VNso71PBMpo6z5eYuZ4xUAHPtI6ev1qmVDW6fQ9beSGGQsioAHxh+PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amazon.com;
	spf=pass smtp.mailfrom=amazon.com;
	dkim=pass header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=ZFEtXTjy;
	arc=none smtp.remote-ip=44.245.243.92
Received: from pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.245.243.92])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A63A606A31C
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 08:14:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A63A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=ZFEtXTjy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794212043; x=1825748043;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JLZlpBd1d3BDj3Wu1cwsGgCishghlLkO8yxS5u3nun8=;
  b=ZFEtXTjyu9NU1IwRLYE9KWqPuAYnI3/QPfbHVdZvfA65d+VENTulPO+b
   hntju0ECQUdnrdTeltXh/CcXQcGkjBsEwDNyTBjtNowEkBf9E+9U6nTcJ
   MqHdmurhpUZWGUqjBtGKpHWBBTvLOwBmj31qu/WDWp6KfEJyx38/qLK5D
   t7sapmFZM5FWntzd7O2vn4ERGakDh61V1AeFJP2E6vAYSTHrT0o/uLgrQ
   H2YVefSTsiRS4td3j77QN42HiMbjfQHqRZBJfiLHrI7o9QxO2+XgEeHUH
   URHo9jqFM8wgUxrlO/UW9OQQy7KA9AhYvtYOeoA1HAEyPJrsOyGXyjkWy
   A==;
X-CSE-ConnectionGUID: bnaxZksHSySu5IG92nWQiQ==
X-CSE-MsgGUID: quNoooVTSnivVMlPzzu1Vw==
X-IronPort-AV: E=Sophos;i="6.27,203,1787011200"; 
   d="scan'208";a="33006276"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 08:14:00 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:8775]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.50.212:2525] with esmtp (Farcaster)
 id 5fb9e450-b2a7-4662-8ebb-f55c21ed2bee; Mon, 9 Nov 2026 08:14:00 +0000 (UTC)
X-Farcaster-Flow-ID: 5fb9e450-b2a7-4662-8ebb-f55c21ed2bee
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Mon, 9 Nov 2026 08:13:59 +0000
Received: from dev-dsk-ikolomin-1a-673563de.eu-west-1.amazon.com
 (172.19.125.167) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Mon, 9 Nov 2026
 08:13:58 +0000
From: Ilia Kolominsky <ikolomin@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <sleybo@amazon.com>, <matua@amazon.com>, <gal.pressman@linux.dev>,
	"Michael Margolin" <mrgolin@amazon.com>, Yonatan Nachum <ynachum@amazon.com>
Subject: [PATCH for-next 1/3] RDMA/efa: Update device interface
Date: Mon, 9 Nov 2026 08:13:47 +0000
Message-ID: <20261109081349.27316-2-ikolomin@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261109081349.27316-1-ikolomin@amazon.com>
References: <20261109081349.27316-1-ikolomin@amazon.com>
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
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Align device interface definitions.

Reviewed-by: Michael Margolin <mrgolin@amazon.com>
Reviewed-by: Yonatan Nachum <ynachum@amazon.com>
Signed-off-by: Ilia Kolominsky <ikolomin@amazon.com>
---
 .../infiniband/hw/efa/efa_admin_cmds_defs.h   | 111 +++++++++++++++++-
 drivers/infiniband/hw/efa/efa_io_defs.h       |  26 +++-
 2 files changed, 132 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h b/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h
index 30a38e633..b28ae294a 100644
--- a/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h
+++ b/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h
@@ -29,6 +29,8 @@ enum efa_admin_aq_opcode {
 	EFA_ADMIN_DESTROY_EQ                        = 19,
 	EFA_ADMIN_ALLOC_MR                          = 20,
 	EFA_ADMIN_SERVICE                           = 21,
+	EFA_ADMIN_CREATE_ACTION                     = 22,
+	EFA_ADMIN_DESTROY_ACTION                    = 23,
 	EFA_ADMIN_CREATE_EVENT_COUNTER              = 25,
 	EFA_ADMIN_DESTROY_EVENT_COUNTER             = 26,
 	EFA_ADMIN_ATTACH_EVENT_COUNTER              = 27,
@@ -162,8 +164,20 @@ struct efa_admin_create_qp_cmd {
 	/* MBZ */
 	u8 reserved;
 
+	/*
+	 * Enablement bitmap for WQE configurable feature blocks
+	 * 0 : action_with_data - If set, action with data
+	 *    block is used - offset in the WQE is provided by
+	 *    action_with_data_wqe_offset
+	 * 15:1 : reserved - MBZ
+	 */
+	u16 wqe_blocks_enablement;
+
+	/* Offset in SQ WQE to action w/ data descriptor */
+	u8 action_with_data_wqe_offset;
+
 	/* MBZ */
-	u32 reserved2;
+	u8 reserved2;
 } __packed;
 
 struct efa_admin_create_qp_resp {
@@ -701,7 +715,8 @@ struct efa_admin_feature_device_attr_desc {
 	 * 9:6 : reserved1 - MBZ
 	 * 10 : sq_64_bit_req_id - If set, SQ can use 64-bit
 	 *    work request ids
-	 * 31:11 : reserved2 - MBZ
+	 * 11 : actions - If set, actions are supported
+	 * 31:12 : reserved2 - MBZ
 	 */
 	u32 device_caps;
 
@@ -792,7 +807,10 @@ struct efa_admin_feature_queue_attr_desc_2 {
 	u16 inline_buf_size_ex;
 
 	/* MBZ */
-	u8 reserved[6];
+	u8 reserved[2];
+
+	/* Maximum number of actions supported per device */
+	u32 max_actions;
 
 	/*
 	 * Supported counter QP events
@@ -818,6 +836,27 @@ struct efa_admin_feature_queue_attr_desc_2 {
 	 * this value
 	 */
 	u64 event_counter_max_val;
+
+	/*
+	 * Bitmask indicating which completion events can trigger actions
+	 * 0 : action_send_comp - Send completion
+	 * 1 : action_recv_comp - Receive completion
+	 * 2 : action_read_comp - RDMA read initiator
+	 *    completion
+	 * 3 : action_remote_read_comp - RDMA read target
+	 *    (responder) completion
+	 * 4 : action_write_comp - RDMA write initiator
+	 *    completion (w/ or w/o immediate)
+	 * 5 : action_remote_write_comp - RDMA write target
+	 *    completion
+	 * 6 : action_remote_write_imm_comp - RDMA write with
+	 *    immediate target completion
+	 * 31:7 : reserved - MBZ
+	 */
+	u32 supported_action_events;
+
+	/* MBZ */
+	u32 reserved2;
 };
 
 struct efa_admin_event_queue_attr_desc {
@@ -1086,6 +1125,62 @@ struct efa_admin_service_resp {
 	u8 buffer[56];
 };
 
+enum efa_admin_action_type {
+	/* Memset action - write a value to a target memory location */
+	EFA_ADMIN_ACTION_TYPE_MEMSET                = 0,
+};
+
+/* Memset action attributes */
+struct efa_admin_action_memset_attr {
+	/* Target physical address. */
+	u64 paddr;
+
+	/* Size of the memory range in bytes. */
+	u32 length;
+
+	/* Size of memset in bytes. Only 1, 2 or 4 are accepted */
+	u8 write_size;
+
+	/* MBZ */
+	u8 flags;
+
+	/* MBZ */
+	u16 reserved;
+};
+
+/* Create Action command parameters. */
+struct efa_admin_create_action_cmd {
+	/* Action type, defined in enum efa_admin_action_type */
+	u16 type;
+
+	/* Protection Domain associated with this action */
+	u16 pd;
+
+	union {
+		struct efa_admin_action_memset_attr memset;
+	} action_data;
+} __packed;
+
+struct efa_admin_create_action_resp {
+	/* Common Admin Queue completion descriptor */
+	struct efa_admin_acq_common_desc acq_common_desc;
+
+	/* Opaque handle to be used for consequent admin operation */
+	u32 action_handle;
+
+	/* Action id to be used in work requests */
+	u32 action_id;
+};
+
+struct efa_admin_destroy_action_cmd {
+	u32 action_handle;
+} __packed;
+
+struct efa_admin_destroy_action_resp {
+	/* Common Admin Queue completion descriptor */
+	struct efa_admin_acq_common_desc acq_common_desc;
+};
+
 /* Create Counter command */
 struct efa_admin_create_event_counter_cmd {
 	/* UAR number */
@@ -1191,8 +1286,8 @@ struct efa_admin_modify_event_counter_resp {
 #define EFA_ADMIN_CREATE_QP_CMD_SQ_VIRT_MASK                BIT(0)
 #define EFA_ADMIN_CREATE_QP_CMD_RQ_VIRT_MASK                BIT(1)
 #define EFA_ADMIN_CREATE_QP_CMD_UNSOLICITED_WRITE_RECV_MASK BIT(2)
-#define EFA_ADMIN_CREATE_QP_CMD_SQ_64_BIT_REQ_ID_SHIFT      3
 #define EFA_ADMIN_CREATE_QP_CMD_SQ_64_BIT_REQ_ID_MASK       BIT(3)
+#define EFA_ADMIN_CREATE_QP_CMD_ACTION_WITH_DATA_MASK       BIT(0)
 
 /* modify_qp_cmd */
 #define EFA_ADMIN_MODIFY_QP_CMD_QP_STATE_MASK               BIT(0)
@@ -1234,6 +1329,7 @@ struct efa_admin_modify_event_counter_resp {
 #define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_UNSOLICITED_WRITE_RECV_MASK BIT(4)
 #define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_EVENT_COUNTERS_MASK BIT(5)
 #define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_SQ_64_BIT_REQ_ID_MASK BIT(10)
+#define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_ACTIONS_MASK     BIT(11)
 
 /* feature_queue_attr_desc_2 */
 #define EFA_ADMIN_FEATURE_QUEUE_ATTR_DESC_2_SEND_COMP_MASK  BIT(0)
@@ -1246,6 +1342,13 @@ struct efa_admin_modify_event_counter_resp {
 #define EFA_ADMIN_FEATURE_QUEUE_ATTR_DESC_2_WRITE_COMP_ERR_MASK BIT(7)
 #define EFA_ADMIN_FEATURE_QUEUE_ATTR_DESC_2_REMOTE_READ_COMP_MASK BIT(8)
 #define EFA_ADMIN_FEATURE_QUEUE_ATTR_DESC_2_REMOTE_WRITE_COMP_MASK BIT(9)
+#define EFA_ADMIN_FEATURE_QUEUE_ATTR_DESC_2_ACTION_SEND_COMP_MASK BIT(0)
+#define EFA_ADMIN_FEATURE_QUEUE_ATTR_DESC_2_ACTION_RECV_COMP_MASK BIT(1)
+#define EFA_ADMIN_FEATURE_QUEUE_ATTR_DESC_2_ACTION_READ_COMP_MASK BIT(2)
+#define EFA_ADMIN_FEATURE_QUEUE_ATTR_DESC_2_ACTION_REMOTE_READ_COMP_MASK BIT(3)
+#define EFA_ADMIN_FEATURE_QUEUE_ATTR_DESC_2_ACTION_WRITE_COMP_MASK BIT(4)
+#define EFA_ADMIN_FEATURE_QUEUE_ATTR_DESC_2_ACTION_REMOTE_WRITE_COMP_MASK BIT(5)
+#define EFA_ADMIN_FEATURE_QUEUE_ATTR_DESC_2_ACTION_REMOTE_WRITE_IMM_COMP_MASK BIT(6)
 
 /* create_eq_cmd */
 #define EFA_ADMIN_CREATE_EQ_CMD_ENTRY_SIZE_WORDS_MASK       GENMASK(4, 0)
diff --git a/drivers/infiniband/hw/efa/efa_io_defs.h b/drivers/infiniband/hw/efa/efa_io_defs.h
index 1444552de..fb2afe7aa 100644
--- a/drivers/infiniband/hw/efa/efa_io_defs.h
+++ b/drivers/infiniband/hw/efa/efa_io_defs.h
@@ -65,6 +65,10 @@ enum efa_io_comp_status {
 	EFA_IO_COMP_STATUS_REMOTE_ERROR_UNKNOWN_PEER = 14,
 	/* Unreachable remote - never received a response */
 	EFA_IO_COMP_STATUS_LOCAL_ERROR_UNREACH_REMOTE = 15,
+	/* Local action not valid */
+	EFA_IO_COMP_STATUS_LOCAL_ERROR_INVALID_ACTION = 16,
+	/* No valid action at remote side */
+	EFA_IO_COMP_STATUS_REMOTE_ERROR_INVALID_ACTION = 17,
 	/* Remote feature mismatch */
 	EFA_IO_COMP_STATUS_REMOTE_ERROR_FEATURE_MISMATCH = 18,
 };
@@ -83,6 +87,20 @@ struct efa_io_req_id_ex {
 	u16 w[3];
 };
 
+/*
+ * Action descriptor, placed in WQE inline space. Holds local and remote
+ * action handles and data. One entry per local and remote action.
+ */
+struct efa_io_action_with_data_block {
+	u32 local_action_handle;
+
+	u32 remote_action_handle;
+
+	u64 local_action_data;
+
+	u64 remote_action_data;
+};
+
 struct efa_io_tx_meta_desc {
 	/* Verbs-generated Request ID */
 	u16 req_id;
@@ -112,7 +130,11 @@ struct efa_io_tx_meta_desc {
 	 * 4 : comp_req - Indicates whether completion should
 	 *    be posted, after packet is transmitted. Valid only
 	 *    for the first descriptor
-	 * 7:5 : reserved29 - MBZ
+	 * 5 : reserved29 - MBZ
+	 * 6 : local_action_req - Indicates local action
+	 *    should be triggered post local WR completion.
+	 * 7 : remote_action_req - Indicates remote action
+	 *    should be triggered post remote completion.
 	 */
 	u8 ctrl2;
 
@@ -388,6 +410,8 @@ struct efa_io_rx_cdesc_ex {
 #define EFA_IO_TX_META_DESC_FIRST_MASK                      BIT(2)
 #define EFA_IO_TX_META_DESC_LAST_MASK                       BIT(3)
 #define EFA_IO_TX_META_DESC_COMP_REQ_MASK                   BIT(4)
+#define EFA_IO_TX_META_DESC_LOCAL_ACTION_REQ_MASK           BIT(6)
+#define EFA_IO_TX_META_DESC_REMOTE_ACTION_REQ_MASK          BIT(7)
 #define EFA_IO_TX_META_DESC_PROCESSING_HINTS_MASK           GENMASK(1, 0)
 
 /* tx_buf_desc */
-- 
2.47.3

