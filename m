From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/3] IB/core: Expose out of order data placement capability
Date: Mon, 12 Jun 2017 09:49:16 +0300
Message-ID: <20170612064918.12510-2-leon@kernel.org>
References: <20170612064918.12510-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170612064918.12510-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch exposes out of order data placement capability to enable
HCA to report it.
It also defines optional QP attribute that can be set when moving QP
from INIT to RTR state to make use of this feature on a particular QP.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 Documentation/infiniband/out_of_order.txt | 60 +++++++++++++++++++++++++++++++
 drivers/infiniband/core/verbs.c           |  9 +++--
 include/rdma/ib_verbs.h                   | 22 ++++++++++++
 3 files changed, 88 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/infiniband/out_of_order.txt

diff --git a/Documentation/infiniband/out_of_order.txt b/Documentation/infiniband/out_of_order.txt
new file mode 100644
index 000000000000..9c585f6801fc
--- /dev/null
+++ b/Documentation/infiniband/out_of_order.txt
@@ -0,0 +1,60 @@
+Out of order data placement
+===========================
+
+This document describes out of order data placement feature and its
+user interface.
+
+1. Overview
+===========
+
+In certain fabric configurations IB packets for a given QP may take up
+different paths in a network from source to destination. This results
+into reaching packets out of order at the receiver side. Instead of
+dropping packets, handling out of order packets can improve overall
+network performance in following ways.
+(a) improve network utilization by avoiding retransmission
+(b) avoiding latency increase due to retransmission
+
+2. Description
+==============
+
+This is optional feature of an HCA.
+Enablement of this feature is done on per QP basis.
+This optional QP attribute is set when a QP state is changed from INIT
+to RTR.
+
+Out of order data placement capability indicates that if HCA receives
+out of order RDMA packets, their data placement can be done at the
+desired memory destination given in the packet(s). This is applicable
+to RDMA read and write operations.
+
+Send queue work requests are still completed in-order regardless of
+their data placement order at requester or responder side.
+
+In-order semantics is always guaranteed by setting the Fence
+indicator for appropriate WRs.
+
+An application shall not depend on the contents of the RDMA write buffer
+at the responder until one of the following occurred:
+- Completion of the RDMA WRITE with immediate data receive completion.
+- Arrival and completion of the subsequent SEND message.
+- Update of a memory element by subsequent ATOMIC operation.
+
+An application shall not depend on the contents of the RDMA read buffer
+at the requester until one of the following occurred:
+- Completion of the RDMA READ work request if requested or such
+  work request completes with error status.
+- Completion of the subsequent work request.
+
+3. Usage
+========
+
+(a) ibv_query_device_ex returns out of order data placement
+capability at ooo_caps structure for a given transport.
+Whenever HCA supports such capability for each transport user
+should get IB_OOO_RW_DATA_PLACEMENT set in the caps.
+
+(b) When such capability is set, user can set
+IB_QP_OOO_RW_DATA_PLACEMENT while invoking ibv_modify_qp().
+IB_QP_OOO_RW_DATA_PLACEMENT is optional attribute which is supported
+only when QP state transions from INIT to RTR state.
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 4792f5209ac2..7e761bedd1ad 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -957,13 +957,16 @@ static const struct {
 						 IB_QP_PKEY_INDEX),
 				 [IB_QPT_RC]  = (IB_QP_ALT_PATH			|
 						 IB_QP_ACCESS_FLAGS		|
-						 IB_QP_PKEY_INDEX),
+						 IB_QP_PKEY_INDEX		|
+						 IB_QP_OOO_RW_DATA_PLACEMENT),
 				 [IB_QPT_XRC_INI] = (IB_QP_ALT_PATH		|
 						 IB_QP_ACCESS_FLAGS		|
-						 IB_QP_PKEY_INDEX),
+						 IB_QP_PKEY_INDEX		|
+						 IB_QP_OOO_RW_DATA_PLACEMENT),
 				 [IB_QPT_XRC_TGT] = (IB_QP_ALT_PATH		|
 						 IB_QP_ACCESS_FLAGS		|
-						 IB_QP_PKEY_INDEX),
+						 IB_QP_PKEY_INDEX		|
+						 IB_QP_OOO_RW_DATA_PLACEMENT),
 				 [IB_QPT_SMI] = (IB_QP_PKEY_INDEX		|
 						 IB_QP_QKEY),
 				 [IB_QPT_GSI] = (IB_QP_PKEY_INDEX		|
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index ba8314ec5768..c507f2f0773a 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -278,6 +278,26 @@ struct ib_rss_caps {
 	u32 max_rwq_indirection_table_size;
 };
 
+/*
+ * Out of order data placement capability bits.
+ * Out of order data placement means, if HCA receives RDMA packets in
+ * out of order manner, their data placement can be done at the desired
+ * memory destination given in the packet(s). This is applicable
+ * to RDMA read and write operations.
+ * Send queue work requests are still completed in-order regardless of their
+ * data placement order at local or remote end.
+ */
+enum ib_ooo_transport_caps {
+	IB_OOO_RW_DATA_PLACEMENT	= (1 << 0),
+};
+
+struct ib_ooo_caps {
+	u32 rc_caps;
+	u32 xrc_caps;
+	u32 ud_caps;
+	u32 uc_caps;
+};
+
 enum ib_cq_creation_flags {
 	IB_CQ_FLAGS_TIMESTAMP_COMPLETION   = 1 << 0,
 	IB_CQ_FLAGS_IGNORE_OVERRUN	   = 1 << 1,
@@ -338,6 +358,7 @@ struct ib_device_attr {
 	struct ib_rss_caps	rss_caps;
 	u32			max_wq_type_rq;
 	u32			raw_packet_caps; /* Use ib_raw_packet_caps enum */
+	struct ib_ooo_caps	ooo_caps;
 };
 
 enum ib_mtu {
@@ -1157,6 +1178,7 @@ enum ib_qp_attr_mask {
 	IB_QP_RESERVED3			= (1<<23),
 	IB_QP_RESERVED4			= (1<<24),
 	IB_QP_RATE_LIMIT		= (1<<25),
+	IB_QP_OOO_RW_DATA_PLACEMENT	= (1 << 26),
 };
 
 enum ib_qp_state {
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
