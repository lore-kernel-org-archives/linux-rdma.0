Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153EB36C0C8
	for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 12:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.42.203.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785069568; cv=none; b=KnzAbHezbfGDgrW0tRVeJSVyrOamTLLxW+FhhB8xeVhjzfgyE2YfRUqe6g4yEP4pmOj5KD/eQNlQ6D8fDMm3waOVJYr8GeDO1RKVrvfozv3T/9byohXX/4vQ1MYdeH+5yqBJQTictC7YM02KOdvDpa9H+enNxAunR0Yddy0TcoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785069568; c=relaxed/simple;
	bh=Zsvs27WYWKZ+rBPbVcw2rS/1s+NyCvZ/MftlgD+NNZk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tS4Inw8hgHHBIyWL124o4kXp859pPqSicHftZkHWiwIU6dtkwyPtB6WUUHNWZmfop5KCJ/1stYO0MDlZT+toZlv/uQrkDgCgudhIYcQh3gPAo4DeTYQCkH+zk1I0TY3J+ir7TV8GXUhB9SM3lMmRwTsOKSlGLiDRyaQzGxjgBcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=jKzig6OS; arc=none smtp.client-ip=52.42.203.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="jKzig6OS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1785069566; x=1816605566;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f2vrlwDYBrcr3IvBQf7BjzKdNroKIK7dA2PcAxB+NTw=;
  b=jKzig6OStGc68p0khBljWSFgBqW5pHI6BjWQgqp/+XrGkY2vpUZT9Mgl
   w1b6VmA0HXAxaeg9tdqwm7G/NQlFRth5WnzyRl+GjmXD+BRskXZwrHh00
   qAyv6l1+zH3HdomuLdABhGCEM8wSy6LlsNsxWHIz70Ejoz4q1bfhTxevW
   8ykVYViG/XZ3bvFL1RWZq1sh0eI46W7x8MXDkm35KF1I49cR64Suxxf1M
   CQ6tQtSHwgwjbstSds+WfhnWXUCZsE7Aznu8HukWL/wCvTye4PwZ2/GA0
   NZcH/wn8tI5KyLnizO4Mmupct9JXhwlXz2TygyjLIRZ8G5AwY9fqPfB7k
   w==;
X-CSE-ConnectionGUID: qLhW1bISRyuvLTuGT/5w0Q==
X-CSE-MsgGUID: /IwprA9GRwaeglTQxay6aw==
X-IronPort-AV: E=Sophos;i="6.25,186,1779148800"; 
   d="scan'208";a="24392702"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2026 12:39:22 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:1858]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.55.20:2525] with esmtp (Farcaster)
 id d6642c9f-a7c9-40cc-aa4f-ad92c6ed4a8f; Sun, 26 Jul 2026 12:39:22 +0000 (UTC)
X-Farcaster-Flow-ID: d6642c9f-a7c9-40cc-aa4f-ad92c6ed4a8f
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Sun, 26 Jul 2026 12:39:22 +0000
Received: from dev-dsk-ynachum-1b-0ecf7b87.eu-west-1.amazon.com
 (10.13.226.176) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45; Sun, 26 Jul 2026
 12:39:20 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <mrgolin@amazon.com>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>, Yonatan Nachum <ynachum@amazon.com>, "Daniel
 Kranzdorf" <dkkranzd@amazon.com>
Subject: [PATCH for-next 1/3] RDMA/efa: Decouple admin command payload from admin header
Date: Sun, 26 Jul 2026 12:38:52 +0000
Message-ID: <20260726123854.638687-2-ynachum@amazon.com>
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

Remove aq_common_desc from all EFA admin command descriptors so that
command structs represent pure payloads. This allows attaching different
headers to the same command by copying the payload into the generic
header payload field. The admin header is now constructed in a single
place which improves separability.

Reviewed-by: Daniel Kranzdorf <dkkranzd@amazon.com>
Reviewed-by: Michael Margolin <mrgolin@amazon.com>
Signed-off-by: Yonatan Nachum <ynachum@amazon.com>
---
 .../infiniband/hw/efa/efa_admin_cmds_defs.h   | 116 +++---------
 drivers/infiniband/hw/efa/efa_admin_defs.h    |   8 +-
 drivers/infiniband/hw/efa/efa_com.c           |  53 +++---
 drivers/infiniband/hw/efa/efa_com.h           |   7 +-
 drivers/infiniband/hw/efa/efa_com_cmd.c       | 170 ++++++------------
 5 files changed, 112 insertions(+), 242 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h b/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h
index 95d1493153cd..ab830764e3b4 100644
--- a/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h
+++ b/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h
@@ -102,9 +102,6 @@ struct efa_admin_qp_alloc_size {
 };
 
 struct efa_admin_create_qp_cmd {
-	/* Common Admin Queue descriptor */
-	struct efa_admin_aq_common_desc aq_common_desc;
-
 	/* Protection Domain associated with this QP */
 	u16 pd;
 
@@ -167,7 +164,7 @@ struct efa_admin_create_qp_cmd {
 
 	/* MBZ */
 	u32 reserved2;
-};
+} __packed;
 
 struct efa_admin_create_qp_resp {
 	/* Common Admin Queue completion descriptor */
@@ -208,9 +205,6 @@ struct efa_admin_create_qp_resp {
 };
 
 struct efa_admin_modify_qp_cmd {
-	/* Common Admin Queue descriptor */
-	struct efa_admin_aq_common_desc aq_common_desc;
-
 	/*
 	 * Mask indicating which fields should be updated
 	 * 0 : qp_state
@@ -246,7 +240,7 @@ struct efa_admin_modify_qp_cmd {
 
 	/* MBZ */
 	u16 reserved2;
-};
+} __packed;
 
 struct efa_admin_modify_qp_resp {
 	/* Common Admin Queue completion descriptor */
@@ -254,12 +248,9 @@ struct efa_admin_modify_qp_resp {
 };
 
 struct efa_admin_query_qp_cmd {
-	/* Common Admin Queue descriptor */
-	struct efa_admin_aq_common_desc aq_common_desc;
-
 	/* QP handle returned by create_qp command */
 	u32 qp_handle;
-};
+} __packed;
 
 struct efa_admin_query_qp_resp {
 	/* Common Admin Queue completion descriptor */
@@ -285,12 +276,9 @@ struct efa_admin_query_qp_resp {
 };
 
 struct efa_admin_destroy_qp_cmd {
-	/* Common Admin Queue descriptor */
-	struct efa_admin_aq_common_desc aq_common_desc;
-
 	/* QP handle returned by create_qp command */
 	u32 qp_handle;
-};
+} __packed;
 
 struct efa_admin_destroy_qp_resp {
 	/* Common Admin Queue completion descriptor */
@@ -302,9 +290,6 @@ struct efa_admin_destroy_qp_resp {
  * once for the same destination
  */
 struct efa_admin_create_ah_cmd {
-	/* Common Admin Queue descriptor */
-	struct efa_admin_aq_common_desc aq_common_desc;
-
 	/* Destination address in network byte order */
 	u8 dest_addr[16];
 
@@ -313,7 +298,7 @@ struct efa_admin_create_ah_cmd {
 
 	/* MBZ */
 	u16 reserved;
-};
+} __packed;
 
 struct efa_admin_create_ah_resp {
 	/* Common Admin Queue completion descriptor */
@@ -327,15 +312,12 @@ struct efa_admin_create_ah_resp {
 };
 
 struct efa_admin_destroy_ah_cmd {
-	/* Common Admin Queue descriptor */
-	struct efa_admin_aq_common_desc aq_common_desc;
-
 	/* Target interface address handle (opaque) */
 	u16 ah;
 
 	/* PD number */
 	u16 pd;
-};
+} __packed;
 
 struct efa_admin_destroy_ah_resp {
 	/* Common Admin Queue completion descriptor */
@@ -349,9 +331,6 @@ struct efa_admin_destroy_ah_resp {
  * on users working with very large datasets (i.e. full GPU memory mapping).
  */
 struct efa_admin_reg_mr_cmd {
-	/* Common Admin Queue descriptor */
-	struct efa_admin_aq_common_desc aq_common_desc;
-
 	/* Protection Domain */
 	u16 pd;
 
@@ -413,7 +392,7 @@ struct efa_admin_reg_mr_cmd {
 	 * the region.
 	 */
 	u64 iova;
-};
+} __packed;
 
 struct efa_admin_reg_mr_resp {
 	/* Common Admin Queue completion descriptor */
@@ -459,12 +438,9 @@ struct efa_admin_reg_mr_resp {
 };
 
 struct efa_admin_dereg_mr_cmd {
-	/* Common Admin Queue descriptor */
-	struct efa_admin_aq_common_desc aq_common_desc;
-
 	/* L_Key, memory region's l_key */
 	u32 l_key;
-};
+} __packed;
 
 struct efa_admin_dereg_mr_resp {
 	/* Common Admin Queue completion descriptor */
@@ -476,9 +452,6 @@ struct efa_admin_dereg_mr_resp {
  * Addresses in kernel verbs semantics, ready for fast registration use.
  */
 struct efa_admin_alloc_mr_cmd {
-	/* Common Admin Queue descriptor */
-	struct efa_admin_aq_common_desc aq_common_desc;
-
 	/* Protection Domain */
 	u16 pd;
 
@@ -487,7 +460,7 @@ struct efa_admin_alloc_mr_cmd {
 
 	/* Maximum number of pages this MR supports. */
 	u32 max_pages;
-};
+} __packed;
 
 struct efa_admin_alloc_mr_resp {
 	/* Common Admin Queue completion descriptor */
@@ -507,8 +480,6 @@ struct efa_admin_alloc_mr_resp {
 };
 
 struct efa_admin_create_cq_cmd {
-	struct efa_admin_aq_common_desc aq_common_desc;
-
 	/*
 	 * 4:0 : reserved5 - MBZ
 	 * 5 : interrupt_mode_enabled - if set, cq operates
@@ -561,7 +532,7 @@ struct efa_admin_create_cq_cmd {
 
 	/* UAR number */
 	u16 uar;
-};
+} __packed;
 
 struct efa_admin_create_cq_resp {
 	struct efa_admin_acq_common_desc acq_common_desc;
@@ -582,13 +553,11 @@ struct efa_admin_create_cq_resp {
 };
 
 struct efa_admin_destroy_cq_cmd {
-	struct efa_admin_aq_common_desc aq_common_desc;
-
 	u16 cq_idx;
 
 	/* MBZ */
 	u16 reserved1;
-};
+} __packed;
 
 struct efa_admin_destroy_cq_resp {
 	struct efa_admin_acq_common_desc acq_common_desc;
@@ -599,14 +568,7 @@ struct efa_admin_destroy_cq_resp {
  * buffer pointed by AQ entry
  */
 struct efa_admin_aq_get_stats_cmd {
-	struct efa_admin_aq_common_desc aq_common_descriptor;
-
-	union {
-		/* command specific inline data */
-		u32 inline_data_w1[3];
-
-		struct efa_admin_ctrl_buff_info control_buffer;
-	} u;
+	struct efa_admin_ctrl_buff_info control_buffer;
 
 	/* stats type as defined in enum efa_admin_get_stats_type */
 	u8 type;
@@ -615,7 +577,7 @@ struct efa_admin_aq_get_stats_cmd {
 	u8 scope;
 
 	u16 scope_modifier;
-};
+} __packed;
 
 struct efa_admin_basic_stats {
 	u64 tx_bytes;
@@ -903,14 +865,12 @@ struct efa_admin_hw_hints {
 };
 
 struct efa_admin_get_feature_cmd {
-	struct efa_admin_aq_common_desc aq_common_descriptor;
-
 	struct efa_admin_ctrl_buff_info control_buffer;
 
 	struct efa_admin_get_set_feature_common_desc feature_common;
 
 	u32 raw[11];
-};
+} __packed;
 
 struct efa_admin_get_feature_resp {
 	struct efa_admin_acq_common_desc acq_common_desc;
@@ -935,8 +895,6 @@ struct efa_admin_get_feature_resp {
 };
 
 struct efa_admin_set_feature_cmd {
-	struct efa_admin_aq_common_desc aq_common_descriptor;
-
 	struct efa_admin_ctrl_buff_info control_buffer;
 
 	struct efa_admin_get_set_feature_common_desc feature_common;
@@ -947,7 +905,7 @@ struct efa_admin_set_feature_cmd {
 		/* AENQ configuration */
 		struct efa_admin_feature_aenq_desc aenq;
 	} u;
-};
+} __packed;
 
 struct efa_admin_set_feature_resp {
 	struct efa_admin_acq_common_desc acq_common_desc;
@@ -957,10 +915,6 @@ struct efa_admin_set_feature_resp {
 	} u;
 };
 
-struct efa_admin_alloc_pd_cmd {
-	struct efa_admin_aq_common_desc aq_common_descriptor;
-};
-
 struct efa_admin_alloc_pd_resp {
 	struct efa_admin_acq_common_desc acq_common_desc;
 
@@ -972,23 +926,17 @@ struct efa_admin_alloc_pd_resp {
 };
 
 struct efa_admin_dealloc_pd_cmd {
-	struct efa_admin_aq_common_desc aq_common_descriptor;
-
 	/* PD number */
 	u16 pd;
 
 	/* MBZ */
 	u16 reserved;
-};
+} __packed;
 
 struct efa_admin_dealloc_pd_resp {
 	struct efa_admin_acq_common_desc acq_common_desc;
 };
 
-struct efa_admin_alloc_uar_cmd {
-	struct efa_admin_aq_common_desc aq_common_descriptor;
-};
-
 struct efa_admin_alloc_uar_resp {
 	struct efa_admin_acq_common_desc acq_common_desc;
 
@@ -1000,22 +948,18 @@ struct efa_admin_alloc_uar_resp {
 };
 
 struct efa_admin_dealloc_uar_cmd {
-	struct efa_admin_aq_common_desc aq_common_descriptor;
-
 	/* UAR number */
 	u16 uar;
 
 	/* MBZ */
 	u16 reserved;
-};
+} __packed;
 
 struct efa_admin_dealloc_uar_resp {
 	struct efa_admin_acq_common_desc acq_common_desc;
 };
 
 struct efa_admin_create_eq_cmd {
-	struct efa_admin_aq_common_desc aq_common_descriptor;
-
 	/* Size of the EQ in entries, must be power of 2 */
 	u16 depth;
 
@@ -1041,7 +985,7 @@ struct efa_admin_create_eq_cmd {
 
 	/* MBZ */
 	u32 reserved;
-};
+} __packed;
 
 struct efa_admin_create_eq_resp {
 	struct efa_admin_acq_common_desc acq_common_desc;
@@ -1054,14 +998,12 @@ struct efa_admin_create_eq_resp {
 };
 
 struct efa_admin_destroy_eq_cmd {
-	struct efa_admin_aq_common_desc aq_common_descriptor;
-
 	/* EQ number */
 	u16 eqn;
 
 	/* MBZ */
 	u16 reserved;
-};
+} __packed;
 
 struct efa_admin_destroy_eq_resp {
 	struct efa_admin_acq_common_desc acq_common_desc;
@@ -1134,10 +1076,8 @@ struct efa_admin_host_info {
 };
 
 struct efa_admin_service_cmd {
-	struct efa_admin_aq_common_desc aq_common_descriptor;
-
 	u8 buffer[60];
-};
+} __packed;
 
 struct efa_admin_service_resp {
 	struct efa_admin_acq_common_desc acq_common_desc;
@@ -1147,8 +1087,6 @@ struct efa_admin_service_resp {
 
 /* Create Counter command */
 struct efa_admin_create_event_counter_cmd {
-	struct efa_admin_aq_common_desc aq_common_descriptor;
-
 	/* UAR number */
 	u16 uar;
 
@@ -1157,7 +1095,7 @@ struct efa_admin_create_event_counter_cmd {
 
 	/* Counter physical address */
 	u64 paddr;
-};
+} __packed;
 
 struct efa_admin_create_event_counter_resp {
 	struct efa_admin_acq_common_desc acq_common_desc;
@@ -1170,11 +1108,9 @@ struct efa_admin_create_event_counter_resp {
 };
 
 struct efa_admin_destroy_event_counter_cmd {
-	struct efa_admin_aq_common_desc aq_common_descriptor;
-
 	/* Counter handle */
 	u32 cntr_handle;
-};
+} __packed;
 
 struct efa_admin_destroy_event_counter_resp {
 	struct efa_admin_acq_common_desc acq_common_desc;
@@ -1206,8 +1142,6 @@ struct efa_admin_event_counter_attach_qp_events {
 };
 
 struct efa_admin_attach_detach_event_counter_cmd {
-	struct efa_admin_aq_common_desc aq_common_descriptor;
-
 	/* Counter handle */
 	u32 cntr_handle;
 
@@ -1220,7 +1154,7 @@ struct efa_admin_attach_detach_event_counter_cmd {
 	union {
 		struct efa_admin_event_counter_attach_qp_events qp_events;
 	} u;
-};
+} __packed;
 
 struct efa_admin_attach_detach_event_counter_resp {
 	struct efa_admin_acq_common_desc acq_common_desc;
@@ -1235,8 +1169,6 @@ enum efa_admin_event_counter_modify_ops {
 };
 
 struct efa_admin_modify_event_counter_cmd {
-	struct efa_admin_aq_common_desc aq_common_descriptor;
-
 	/* Counter handle */
 	u32 cntr_handle;
 
@@ -1248,7 +1180,7 @@ struct efa_admin_modify_event_counter_cmd {
 
 	/* Value for SET or ADD */
 	u64 value;
-};
+} __packed;
 
 struct efa_admin_modify_event_counter_resp {
 	struct efa_admin_acq_common_desc acq_common_desc;
diff --git a/drivers/infiniband/hw/efa/efa_admin_defs.h b/drivers/infiniband/hw/efa/efa_admin_defs.h
index 02f86edabed8..0a14b3abe6f9 100644
--- a/drivers/infiniband/hw/efa/efa_admin_defs.h
+++ b/drivers/infiniband/hw/efa/efa_admin_defs.h
@@ -55,13 +55,7 @@ struct efa_admin_ctrl_buff_info {
 struct efa_admin_aq_entry {
 	struct efa_admin_aq_common_desc aq_common_descriptor;
 
-	union {
-		u32 inline_data_w1[3];
-
-		struct efa_admin_ctrl_buff_info control_buffer;
-	} u;
-
-	u32 inline_data_w4[12];
+	u32 request_payload[15];
 };
 
 struct efa_admin_acq_common_desc {
diff --git a/drivers/infiniband/hw/efa/efa_com.c b/drivers/infiniband/hw/efa/efa_com.c
index 7097d1c2f23d..8d8be22b76c8 100644
--- a/drivers/infiniband/hw/efa/efa_com.c
+++ b/drivers/infiniband/hw/efa/efa_com.c
@@ -634,8 +634,10 @@ static int efa_com_wait_and_process_admin_cq(struct efa_comp_ctx *comp_ctx,
 /**
  * efa_com_cmd_exec - Execute admin command
  * @aq: admin queue.
- * @cmd: the admin command to execute.
- * @cmd_size: the command size.
+ * @opcode: the admin command opcode.
+ * @flags: the admin command header flags.
+ * @payload: the admin command payload.
+ * @payload_size: the payload size.
  * @comp: command completion return entry.
  * @comp_size: command completion size.
  * Submit an admin command and then wait until the device will return a
@@ -645,22 +647,24 @@ static int efa_com_wait_and_process_admin_cq(struct efa_comp_ctx *comp_ctx,
  * @return - 0 on success, negative value on failure.
  */
 int efa_com_cmd_exec(struct efa_com_admin_queue *aq,
-		     struct efa_admin_aq_entry *cmd,
-		     size_t cmd_size,
-		     struct efa_admin_acq_entry *comp,
-		     size_t comp_size)
+		     u8 opcode, u8 flags,
+		     void *payload, size_t payload_size,
+		     struct efa_admin_acq_entry *comp, size_t comp_size)
 {
+	struct efa_admin_aq_entry aq_entry = {};
 	struct efa_comp_ctx *comp_ctx;
 	int err;
 
+	if (payload_size > sizeof(aq_entry.request_payload))
+		return -EINVAL;
+
 	might_sleep();
 
 	/* In case of queue FULL */
 	down(&aq->avail_cmds);
 
-	ibdev_dbg(aq->efa_dev, "%s (opcode %d)\n",
-		  efa_com_cmd_str(cmd->aq_common_descriptor.opcode),
-		  cmd->aq_common_descriptor.opcode);
+	ibdev_dbg(aq->efa_dev, "%s (opcode %d)\n", efa_com_cmd_str(opcode),
+		  opcode);
 
 	comp_ctx = efa_com_alloc_comp_ctx(aq);
 	if (!comp_ctx) {
@@ -669,13 +673,17 @@ int efa_com_cmd_exec(struct efa_com_admin_queue *aq,
 		return -EINVAL;
 	}
 
-	err = efa_com_submit_admin_cmd(aq, comp_ctx, cmd, cmd_size, comp, comp_size);
+	aq_entry.aq_common_descriptor.opcode = opcode;
+	aq_entry.aq_common_descriptor.flags = flags;
+	if (payload)
+		memcpy(aq_entry.request_payload, payload, payload_size);
+
+	err = efa_com_submit_admin_cmd(aq, comp_ctx, &aq_entry, sizeof(aq_entry), comp, comp_size);
 	if (err) {
 		ibdev_err_ratelimited(
 			aq->efa_dev,
 			"Failed to submit command %s (opcode %u) err %d\n",
-			efa_com_cmd_str(cmd->aq_common_descriptor.opcode),
-			cmd->aq_common_descriptor.opcode, err);
+			efa_com_cmd_str(opcode), opcode, err);
 
 		efa_com_dealloc_comp_ctx(aq, comp_ctx);
 		up(&aq->avail_cmds);
@@ -688,8 +696,7 @@ int efa_com_cmd_exec(struct efa_com_admin_queue *aq,
 		ibdev_err_ratelimited(
 			aq->efa_dev,
 			"Failed to process command %s (opcode %u) err %d\n",
-			efa_com_cmd_str(cmd->aq_common_descriptor.opcode),
-			cmd->aq_common_descriptor.opcode, err);
+			efa_com_cmd_str(opcode), opcode, err);
 		atomic64_inc(&aq->stats.cmd_err);
 	}
 
@@ -1156,7 +1163,6 @@ static int efa_com_create_eq(struct efa_com_dev *edev,
 	struct efa_admin_create_eq_cmd cmd = {};
 	int err;
 
-	cmd.aq_common_descriptor.opcode = EFA_ADMIN_CREATE_EQ;
 	EFA_SET(&cmd.caps, EFA_ADMIN_CREATE_EQ_CMD_ENTRY_SIZE_WORDS,
 		params->entry_size_in_bytes / 4);
 	cmd.depth = params->depth;
@@ -1166,11 +1172,9 @@ static int efa_com_create_eq(struct efa_com_dev *edev,
 	efa_com_set_dma_addr(params->dma_addr, &cmd.ba.mem_addr_high,
 			     &cmd.ba.mem_addr_low);
 
-	err = efa_com_cmd_exec(aq,
-			       (struct efa_admin_aq_entry *)&cmd,
-			       sizeof(cmd),
-			       (struct efa_admin_acq_entry *)&resp,
-			       sizeof(resp));
+	err = efa_com_cmd_exec(aq, EFA_ADMIN_CREATE_EQ, 0,
+			       &cmd, sizeof(cmd),
+			       (struct efa_admin_acq_entry *)&resp, sizeof(resp));
 	if (err) {
 		ibdev_err_ratelimited(edev->efa_dev,
 				      "Failed to create eq[%d]\n", err);
@@ -1190,14 +1194,11 @@ static void efa_com_destroy_eq(struct efa_com_dev *edev,
 	struct efa_admin_destroy_eq_cmd cmd = {};
 	int err;
 
-	cmd.aq_common_descriptor.opcode = EFA_ADMIN_DESTROY_EQ;
 	cmd.eqn = params->eqn;
 
-	err = efa_com_cmd_exec(aq,
-			       (struct efa_admin_aq_entry *)&cmd,
-			       sizeof(cmd),
-			       (struct efa_admin_acq_entry *)&resp,
-			       sizeof(resp));
+	err = efa_com_cmd_exec(aq, EFA_ADMIN_DESTROY_EQ, 0,
+			       &cmd, sizeof(cmd),
+			       (struct efa_admin_acq_entry *)&resp, sizeof(resp));
 	if (err)
 		ibdev_err_ratelimited(edev->efa_dev,
 				      "Failed to destroy EQ-%u [%d]\n", cmd.eqn,
diff --git a/drivers/infiniband/hw/efa/efa_com.h b/drivers/infiniband/hw/efa/efa_com.h
index 599db9d583bf..f979e36ec158 100644
--- a/drivers/infiniband/hw/efa/efa_com.h
+++ b/drivers/infiniband/hw/efa/efa_com.h
@@ -174,10 +174,9 @@ int efa_com_validate_version(struct efa_com_dev *edev);
 int efa_com_get_dma_width(struct efa_com_dev *edev);
 
 int efa_com_cmd_exec(struct efa_com_admin_queue *aq,
-		     struct efa_admin_aq_entry *cmd,
-		     size_t cmd_size,
-		     struct efa_admin_acq_entry *comp,
-		     size_t comp_size);
+		     u8 opcode, u8 flags,
+		     void *payload, size_t payload_size,
+		     struct efa_admin_acq_entry *comp, size_t comp_size);
 void efa_com_aenq_intr_handler(struct efa_com_dev *edev, void *data);
 void efa_com_eq_comp_intr_handler(struct efa_com_dev *edev,
 				  struct efa_com_eq *eeq);
diff --git a/drivers/infiniband/hw/efa/efa_com_cmd.c b/drivers/infiniband/hw/efa/efa_com_cmd.c
index 198a27d02b18..1b00f16b8ea8 100644
--- a/drivers/infiniband/hw/efa/efa_com_cmd.c
+++ b/drivers/infiniband/hw/efa/efa_com_cmd.c
@@ -17,8 +17,6 @@ int efa_com_create_qp(struct efa_com_dev *edev,
 	struct efa_com_admin_queue *aq = &edev->aq;
 	int err;
 
-	create_qp_cmd.aq_common_desc.opcode = EFA_ADMIN_CREATE_QP;
-
 	create_qp_cmd.pd = params->pd;
 	create_qp_cmd.qp_type = params->qp_type;
 	create_qp_cmd.rq_base_addr = params->rq_base_addr;
@@ -41,9 +39,8 @@ int efa_com_create_qp(struct efa_com_dev *edev,
 	if (params->sq_64_bit_req_id)
 		EFA_SET(&create_qp_cmd.flags, EFA_ADMIN_CREATE_QP_CMD_SQ_64_BIT_REQ_ID, 1);
 
-	err = efa_com_cmd_exec(aq,
-			       (struct efa_admin_aq_entry *)&create_qp_cmd,
-			       sizeof(create_qp_cmd),
+	err = efa_com_cmd_exec(aq, EFA_ADMIN_CREATE_QP, 0,
+			       &create_qp_cmd, sizeof(create_qp_cmd),
 			       (struct efa_admin_acq_entry *)&cmd_completion,
 			       sizeof(cmd_completion));
 	if (err) {
@@ -71,7 +68,6 @@ int efa_com_modify_qp(struct efa_com_dev *edev,
 	struct efa_admin_modify_qp_resp resp;
 	int err;
 
-	cmd.aq_common_desc.opcode = EFA_ADMIN_MODIFY_QP;
 	cmd.modify_mask = params->modify_mask;
 	cmd.qp_handle = params->qp_handle;
 	cmd.qp_state = params->qp_state;
@@ -81,11 +77,9 @@ int efa_com_modify_qp(struct efa_com_dev *edev,
 	cmd.sq_drained_async_notify = params->sq_drained_async_notify;
 	cmd.rnr_retry = params->rnr_retry;
 
-	err = efa_com_cmd_exec(aq,
-			       (struct efa_admin_aq_entry *)&cmd,
-			       sizeof(cmd),
-			       (struct efa_admin_acq_entry *)&resp,
-			       sizeof(resp));
+	err = efa_com_cmd_exec(aq, EFA_ADMIN_MODIFY_QP, 0,
+			       &cmd, sizeof(cmd),
+			       (struct efa_admin_acq_entry *)&resp, sizeof(resp));
 	if (err) {
 		ibdev_err_ratelimited(
 			edev->efa_dev,
@@ -106,14 +100,11 @@ int efa_com_query_qp(struct efa_com_dev *edev,
 	struct efa_admin_query_qp_resp resp;
 	int err;
 
-	cmd.aq_common_desc.opcode = EFA_ADMIN_QUERY_QP;
 	cmd.qp_handle = params->qp_handle;
 
-	err = efa_com_cmd_exec(aq,
-			       (struct efa_admin_aq_entry *)&cmd,
-			       sizeof(cmd),
-			       (struct efa_admin_acq_entry *)&resp,
-			       sizeof(resp));
+	err = efa_com_cmd_exec(aq, EFA_ADMIN_QUERY_QP, 0,
+			       &cmd, sizeof(cmd),
+			       (struct efa_admin_acq_entry *)&resp, sizeof(resp));
 	if (err) {
 		ibdev_err_ratelimited(edev->efa_dev,
 				      "Failed to query qp-%u [%d]\n",
@@ -138,12 +129,10 @@ int efa_com_destroy_qp(struct efa_com_dev *edev,
 	struct efa_com_admin_queue *aq = &edev->aq;
 	int err;
 
-	qp_cmd.aq_common_desc.opcode = EFA_ADMIN_DESTROY_QP;
 	qp_cmd.qp_handle = params->qp_handle;
 
-	err = efa_com_cmd_exec(aq,
-			       (struct efa_admin_aq_entry *)&qp_cmd,
-			       sizeof(qp_cmd),
+	err = efa_com_cmd_exec(aq, EFA_ADMIN_DESTROY_QP, 0,
+			       &qp_cmd, sizeof(qp_cmd),
 			       (struct efa_admin_acq_entry *)&cmd_completion,
 			       sizeof(cmd_completion));
 	if (err) {
@@ -165,7 +154,6 @@ int efa_com_create_cq(struct efa_com_dev *edev,
 	struct efa_com_admin_queue *aq = &edev->aq;
 	int err;
 
-	create_cmd.aq_common_desc.opcode = EFA_ADMIN_CREATE_CQ;
 	EFA_SET(&create_cmd.cq_caps_2,
 		EFA_ADMIN_CREATE_CQ_CMD_CQ_ENTRY_SIZE_WORDS,
 		params->entry_size_in_bytes / 4);
@@ -190,9 +178,8 @@ int efa_com_create_cq(struct efa_com_dev *edev,
 			     &create_cmd.cq_ba.mem_addr_high,
 			     &create_cmd.cq_ba.mem_addr_low);
 
-	err = efa_com_cmd_exec(aq,
-			       (struct efa_admin_aq_entry *)&create_cmd,
-			       sizeof(create_cmd),
+	err = efa_com_cmd_exec(aq, EFA_ADMIN_CREATE_CQ, 0,
+			       &create_cmd, sizeof(create_cmd),
 			       (struct efa_admin_acq_entry *)&cmd_completion,
 			       sizeof(cmd_completion));
 	if (err) {
@@ -219,11 +206,9 @@ int efa_com_destroy_cq(struct efa_com_dev *edev,
 	int err;
 
 	destroy_cmd.cq_idx = params->cq_idx;
-	destroy_cmd.aq_common_desc.opcode = EFA_ADMIN_DESTROY_CQ;
 
-	err = efa_com_cmd_exec(aq,
-			       (struct efa_admin_aq_entry *)&destroy_cmd,
-			       sizeof(destroy_cmd),
+	err = efa_com_cmd_exec(aq, EFA_ADMIN_DESTROY_CQ, 0,
+			       &destroy_cmd, sizeof(destroy_cmd),
 			       (struct efa_admin_acq_entry *)&destroy_resp,
 			       sizeof(destroy_resp));
 
@@ -244,9 +229,9 @@ int efa_com_register_mr(struct efa_com_dev *edev,
 	struct efa_admin_reg_mr_resp cmd_completion;
 	struct efa_com_admin_queue *aq = &edev->aq;
 	struct efa_admin_reg_mr_cmd mr_cmd = {};
+	u8 flags = 0;
 	int err;
 
-	mr_cmd.aq_common_desc.opcode = EFA_ADMIN_REG_MR;
 	mr_cmd.pd = params->pd;
 	mr_cmd.mr_length = params->mr_length_in_bytes;
 	EFA_SET(&mr_cmd.flags, EFA_ADMIN_REG_MR_CMD_PHYS_PAGE_SIZE_SHIFT,
@@ -264,16 +249,13 @@ int efa_com_register_mr(struct efa_com_dev *edev,
 			params->pbl.pbl.address.mem_addr_low;
 		mr_cmd.pbl.pbl.address.mem_addr_high =
 			params->pbl.pbl.address.mem_addr_high;
-		EFA_SET(&mr_cmd.aq_common_desc.flags,
-			EFA_ADMIN_AQ_COMMON_DESC_CTRL_DATA, 1);
+		EFA_SET(&flags, EFA_ADMIN_AQ_COMMON_DESC_CTRL_DATA, 1);
 		if (params->indirect)
-			EFA_SET(&mr_cmd.aq_common_desc.flags,
-				EFA_ADMIN_AQ_COMMON_DESC_CTRL_DATA_INDIRECT, 1);
+			EFA_SET(&flags, EFA_ADMIN_AQ_COMMON_DESC_CTRL_DATA_INDIRECT, 1);
 	}
 
-	err = efa_com_cmd_exec(aq,
-			       (struct efa_admin_aq_entry *)&mr_cmd,
-			       sizeof(mr_cmd),
+	err = efa_com_cmd_exec(aq, EFA_ADMIN_REG_MR, flags,
+			       &mr_cmd, sizeof(mr_cmd),
 			       (struct efa_admin_acq_entry *)&cmd_completion,
 			       sizeof(cmd_completion));
 	if (err) {
@@ -305,12 +287,10 @@ int efa_com_dereg_mr(struct efa_com_dev *edev,
 	struct efa_admin_dereg_mr_cmd mr_cmd = {};
 	int err;
 
-	mr_cmd.aq_common_desc.opcode = EFA_ADMIN_DEREG_MR;
 	mr_cmd.l_key = params->l_key;
 
-	err = efa_com_cmd_exec(aq,
-			       (struct efa_admin_aq_entry *)&mr_cmd,
-			       sizeof(mr_cmd),
+	err = efa_com_cmd_exec(aq, EFA_ADMIN_DEREG_MR, 0,
+			       &mr_cmd, sizeof(mr_cmd),
 			       (struct efa_admin_acq_entry *)&cmd_completion,
 			       sizeof(cmd_completion));
 	if (err) {
@@ -345,14 +325,11 @@ int efa_com_create_ah(struct efa_com_dev *edev,
 		return 0;
 	}
 
-	ah_cmd.aq_common_desc.opcode = EFA_ADMIN_CREATE_AH;
-
 	memcpy(ah_cmd.dest_addr, params->dest_addr, sizeof(ah_cmd.dest_addr));
 	ah_cmd.pd = params->pdn;
 
-	err = efa_com_cmd_exec(aq,
-			       (struct efa_admin_aq_entry *)&ah_cmd,
-			       sizeof(ah_cmd),
+	err = efa_com_cmd_exec(aq, EFA_ADMIN_CREATE_AH, 0,
+			       &ah_cmd, sizeof(ah_cmd),
 			       (struct efa_admin_acq_entry *)&cmd_completion,
 			       sizeof(cmd_completion));
 	if (err) {
@@ -389,13 +366,11 @@ int efa_com_destroy_ah(struct efa_com_dev *edev,
 	if (entry->usecnt > 1)
 		goto out_put;
 
-	ah_cmd.aq_common_desc.opcode = EFA_ADMIN_DESTROY_AH;
 	ah_cmd.ah = entry->ah;
 	ah_cmd.pd = entry->key.pd;
 
-	err = efa_com_cmd_exec(aq,
-			       (struct efa_admin_aq_entry *)&ah_cmd,
-			       sizeof(ah_cmd),
+	err = efa_com_cmd_exec(aq, EFA_ADMIN_DESTROY_AH, 0,
+			       &ah_cmd, sizeof(ah_cmd),
 			       (struct efa_admin_acq_entry *)&cmd_completion,
 			       sizeof(cmd_completion));
 	if (err) {
@@ -436,6 +411,7 @@ static int efa_com_get_feature_ex(struct efa_com_dev *edev,
 {
 	struct efa_admin_get_feature_cmd get_cmd = {};
 	struct efa_com_admin_queue *aq;
+	u8 flags = 0;
 	int err;
 
 	if (!efa_com_check_supported_feature_id(edev, feature_id)) {
@@ -447,11 +423,8 @@ static int efa_com_get_feature_ex(struct efa_com_dev *edev,
 
 	aq = &edev->aq;
 
-	get_cmd.aq_common_descriptor.opcode = EFA_ADMIN_GET_FEATURE;
-
 	if (control_buff_size)
-		EFA_SET(&get_cmd.aq_common_descriptor.flags,
-			EFA_ADMIN_AQ_COMMON_DESC_CTRL_DATA, 1);
+		EFA_SET(&flags, EFA_ADMIN_AQ_COMMON_DESC_CTRL_DATA, 1);
 
 	efa_com_set_dma_addr(control_buf_dma_addr,
 			     &get_cmd.control_buffer.address.mem_addr_high,
@@ -459,12 +432,9 @@ static int efa_com_get_feature_ex(struct efa_com_dev *edev,
 
 	get_cmd.control_buffer.length = control_buff_size;
 	get_cmd.feature_common.feature_id = feature_id;
-	err = efa_com_cmd_exec(aq,
-			       (struct efa_admin_aq_entry *)
-			       &get_cmd,
-			       sizeof(get_cmd),
-			       (struct efa_admin_acq_entry *)
-			       get_resp,
+	err = efa_com_cmd_exec(aq, EFA_ADMIN_GET_FEATURE, flags,
+			       &get_cmd, sizeof(get_cmd),
+			       (struct efa_admin_acq_entry *)get_resp,
 			       sizeof(*get_resp));
 
 	if (err) {
@@ -630,6 +600,7 @@ int efa_com_set_feature_ex(struct efa_com_dev *edev,
 			   u32 control_buff_size)
 {
 	struct efa_com_admin_queue *aq;
+	u8 flags = 0;
 	int err;
 
 	if (!efa_com_check_supported_feature_id(edev, feature_id)) {
@@ -641,11 +612,8 @@ int efa_com_set_feature_ex(struct efa_com_dev *edev,
 
 	aq = &edev->aq;
 
-	set_cmd->aq_common_descriptor.opcode = EFA_ADMIN_SET_FEATURE;
 	if (control_buff_size) {
-		set_cmd->aq_common_descriptor.flags = 0;
-		EFA_SET(&set_cmd->aq_common_descriptor.flags,
-			EFA_ADMIN_AQ_COMMON_DESC_CTRL_DATA, 1);
+		EFA_SET(&flags, EFA_ADMIN_AQ_COMMON_DESC_CTRL_DATA, 1);
 		efa_com_set_dma_addr(control_buf_dma_addr,
 				     &set_cmd->control_buffer.address.mem_addr_high,
 				     &set_cmd->control_buffer.address.mem_addr_low);
@@ -653,9 +621,8 @@ int efa_com_set_feature_ex(struct efa_com_dev *edev,
 
 	set_cmd->control_buffer.length = control_buff_size;
 	set_cmd->feature_common.feature_id = feature_id;
-	err = efa_com_cmd_exec(aq,
-			       (struct efa_admin_aq_entry *)set_cmd,
-			       sizeof(*set_cmd),
+	err = efa_com_cmd_exec(aq, EFA_ADMIN_SET_FEATURE, flags,
+			       set_cmd, sizeof(*set_cmd),
 			       (struct efa_admin_acq_entry *)set_resp,
 			       sizeof(*set_resp));
 
@@ -726,17 +693,12 @@ int efa_com_alloc_pd(struct efa_com_dev *edev,
 		     struct efa_com_alloc_pd_result *result)
 {
 	struct efa_com_admin_queue *aq = &edev->aq;
-	struct efa_admin_alloc_pd_cmd cmd = {};
 	struct efa_admin_alloc_pd_resp resp;
 	int err;
 
-	cmd.aq_common_descriptor.opcode = EFA_ADMIN_ALLOC_PD;
-
-	err = efa_com_cmd_exec(aq,
-			       (struct efa_admin_aq_entry *)&cmd,
-			       sizeof(cmd),
-			       (struct efa_admin_acq_entry *)&resp,
-			       sizeof(resp));
+	err = efa_com_cmd_exec(aq, EFA_ADMIN_ALLOC_PD, 0,
+			       NULL, 0,
+			       (struct efa_admin_acq_entry *)&resp, sizeof(resp));
 	if (err) {
 		ibdev_err_ratelimited(edev->efa_dev,
 				      "Failed to allocate pd[%d]\n", err);
@@ -756,14 +718,11 @@ int efa_com_dealloc_pd(struct efa_com_dev *edev,
 	struct efa_admin_dealloc_pd_resp resp;
 	int err;
 
-	cmd.aq_common_descriptor.opcode = EFA_ADMIN_DEALLOC_PD;
 	cmd.pd = params->pdn;
 
-	err = efa_com_cmd_exec(aq,
-			       (struct efa_admin_aq_entry *)&cmd,
-			       sizeof(cmd),
-			       (struct efa_admin_acq_entry *)&resp,
-			       sizeof(resp));
+	err = efa_com_cmd_exec(aq, EFA_ADMIN_DEALLOC_PD, 0,
+			       &cmd, sizeof(cmd),
+			       (struct efa_admin_acq_entry *)&resp, sizeof(resp));
 	if (err) {
 		ibdev_err_ratelimited(edev->efa_dev,
 				      "Failed to deallocate pd-%u [%d]\n",
@@ -778,17 +737,12 @@ int efa_com_alloc_uar(struct efa_com_dev *edev,
 		      struct efa_com_alloc_uar_result *result)
 {
 	struct efa_com_admin_queue *aq = &edev->aq;
-	struct efa_admin_alloc_uar_cmd cmd = {};
 	struct efa_admin_alloc_uar_resp resp;
 	int err;
 
-	cmd.aq_common_descriptor.opcode = EFA_ADMIN_ALLOC_UAR;
-
-	err = efa_com_cmd_exec(aq,
-			       (struct efa_admin_aq_entry *)&cmd,
-			       sizeof(cmd),
-			       (struct efa_admin_acq_entry *)&resp,
-			       sizeof(resp));
+	err = efa_com_cmd_exec(aq, EFA_ADMIN_ALLOC_UAR, 0,
+			       NULL, 0,
+			       (struct efa_admin_acq_entry *)&resp, sizeof(resp));
 	if (err) {
 		ibdev_err_ratelimited(edev->efa_dev,
 				      "Failed to allocate uar[%d]\n", err);
@@ -808,14 +762,11 @@ int efa_com_dealloc_uar(struct efa_com_dev *edev,
 	struct efa_admin_dealloc_uar_resp resp;
 	int err;
 
-	cmd.aq_common_descriptor.opcode = EFA_ADMIN_DEALLOC_UAR;
 	cmd.uar = params->uarn;
 
-	err = efa_com_cmd_exec(aq,
-			       (struct efa_admin_aq_entry *)&cmd,
-			       sizeof(cmd),
-			       (struct efa_admin_acq_entry *)&resp,
-			       sizeof(resp));
+	err = efa_com_cmd_exec(aq, EFA_ADMIN_DEALLOC_UAR, 0,
+			       &cmd, sizeof(cmd),
+			       (struct efa_admin_acq_entry *)&resp, sizeof(resp));
 	if (err) {
 		ibdev_err_ratelimited(edev->efa_dev,
 				      "Failed to deallocate uar-%u [%d]\n",
@@ -840,16 +791,13 @@ int efa_com_get_stats(struct efa_com_dev *edev,
 	struct efa_admin_basic_stats *bs;
 	int err;
 
-	cmd.aq_common_descriptor.opcode = EFA_ADMIN_GET_STATS;
 	cmd.type = params->type;
 	cmd.scope = params->scope;
 	cmd.scope_modifier = params->scope_modifier;
 
-	err = efa_com_cmd_exec(aq,
-			       (struct efa_admin_aq_entry *)&cmd,
-			       sizeof(cmd),
-			       (struct efa_admin_acq_entry *)&resp,
-			       sizeof(resp));
+	err = efa_com_cmd_exec(aq, EFA_ADMIN_GET_STATS, 0,
+			       &cmd, sizeof(cmd),
+			       (struct efa_admin_acq_entry *)&resp, sizeof(resp));
 	if (err) {
 		ibdev_err_ratelimited(
 			edev->efa_dev,
@@ -910,12 +858,11 @@ int efa_com_create_event_counter(struct efa_com_dev *edev,
 	struct efa_com_admin_queue *aq = &edev->aq;
 	int err;
 
-	cmd.aq_common_descriptor.opcode = EFA_ADMIN_CREATE_EVENT_COUNTER;
 	cmd.uar = params->uarn;
 	cmd.paddr = params->dma_addr;
 
-	err = efa_com_cmd_exec(aq, (struct efa_admin_aq_entry *)&cmd,
-			       sizeof(cmd),
+	err = efa_com_cmd_exec(aq, EFA_ADMIN_CREATE_EVENT_COUNTER, 0,
+			       &cmd, sizeof(cmd),
 			       (struct efa_admin_acq_entry *)&resp,
 			       sizeof(resp));
 	if (err) {
@@ -937,11 +884,10 @@ int efa_com_destroy_event_counter(struct efa_com_dev *edev,
 	struct efa_com_admin_queue *aq = &edev->aq;
 	int err;
 
-	cmd.aq_common_descriptor.opcode = EFA_ADMIN_DESTROY_EVENT_COUNTER;
 	cmd.cntr_handle = params->cntr_handle;
 
-	err = efa_com_cmd_exec(aq, (struct efa_admin_aq_entry *)&cmd,
-			       sizeof(cmd),
+	err = efa_com_cmd_exec(aq, EFA_ADMIN_DESTROY_EVENT_COUNTER, 0,
+			       &cmd, sizeof(cmd),
 			       (struct efa_admin_acq_entry *)&resp,
 			       sizeof(resp));
 	if (err) {
@@ -963,14 +909,13 @@ static int efa_com_attach_detach_event_counter(struct efa_com_dev *edev, u8 opco
 	struct efa_com_admin_queue *aq = &edev->aq;
 	int err;
 
-	cmd.aq_common_descriptor.opcode = opcode;
 	cmd.cntr_handle = cntr_handle;
 	cmd.attach_type = EFA_ADMIN_EVENT_COUNTER_ATTACH_QP_EVENTS;
 	cmd.u.qp_events.qp_handle = qp_handle;
 	cmd.u.qp_events.events = events;
 
-	err = efa_com_cmd_exec(aq, (struct efa_admin_aq_entry *)&cmd,
-			       sizeof(cmd),
+	err = efa_com_cmd_exec(aq, opcode, 0,
+			       &cmd, sizeof(cmd),
 			       (struct efa_admin_acq_entry *)&resp,
 			       sizeof(resp));
 	if (err) {
@@ -1014,13 +959,12 @@ int efa_com_modify_event_counter(struct efa_com_dev *edev,
 	struct efa_com_admin_queue *aq = &edev->aq;
 	int err;
 
-	cmd.aq_common_descriptor.opcode = EFA_ADMIN_MODIFY_EVENT_COUNTER;
 	cmd.cntr_handle = params->cntr_handle;
 	cmd.operation = params->operation;
 	cmd.value = params->value;
 
-	err = efa_com_cmd_exec(aq, (struct efa_admin_aq_entry *)&cmd,
-			       sizeof(cmd),
+	err = efa_com_cmd_exec(aq, EFA_ADMIN_MODIFY_EVENT_COUNTER, 0,
+			       &cmd, sizeof(cmd),
 			       (struct efa_admin_acq_entry *)&resp,
 			       sizeof(resp));
 	if (err) {
-- 
2.50.1

