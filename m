From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH V2 2/2] IB/core: Move SM class defines from ib_mad.h to ib_smi.h
Date: Thu,  3 Sep 2015 14:16:30 -0400
Message-ID: <1441304190-29212-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When the hfi1 driver was added these definitions were moved from the qib driver
to ib_mad.h to be used by both qib and hfi1.  They should have been moved to
ib_smi.h instead.

Fixes: d4ab347005fb ("IB/core: Add core header changes needed for OPA")
Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
Changes from V1:
	Fix Nits from Hal

 drivers/infiniband/hw/qib/qib_ruc.c |  1 +
 include/rdma/ib_mad.h               | 45 -----------------------------------
 include/rdma/ib_smi.h               | 47 +++++++++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 45 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_ruc.c b/drivers/infiniband/hw/qib/qib_ruc.c
index f42bd0f47577..22e356ca8058 100644
--- a/drivers/infiniband/hw/qib/qib_ruc.c
+++ b/drivers/infiniband/hw/qib/qib_ruc.c
@@ -32,6 +32,7 @@
  */
 
 #include <linux/spinlock.h>
+#include <rdma/ib_smi.h>
 
 #include "qib.h"
 #include "qib_mad.h"
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index 7f2cf855a0b6..188df91d5851 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -144,31 +144,6 @@
 #define IB_NOTICE_PROD_ROUTER		cpu_to_be16(3)
 #define IB_NOTICE_PROD_CLASS_MGR	cpu_to_be16(4)
 
-/*
- * Generic trap/notice numbers
- */
-#define IB_NOTICE_TRAP_LLI_THRESH	cpu_to_be16(129)
-#define IB_NOTICE_TRAP_EBO_THRESH	cpu_to_be16(130)
-#define IB_NOTICE_TRAP_FLOW_UPDATE	cpu_to_be16(131)
-#define IB_NOTICE_TRAP_CAP_MASK_CHG	cpu_to_be16(144)
-#define IB_NOTICE_TRAP_SYS_GUID_CHG	cpu_to_be16(145)
-#define IB_NOTICE_TRAP_BAD_MKEY		cpu_to_be16(256)
-#define IB_NOTICE_TRAP_BAD_PKEY		cpu_to_be16(257)
-#define IB_NOTICE_TRAP_BAD_QKEY		cpu_to_be16(258)
-
-/*
- * Generic trap/notice other local changes flags (trap 144).
- */
-#define IB_NOTICE_TRAP_LSE_CHG		0x04	/* Link Speed Enable changed */
-#define IB_NOTICE_TRAP_LWE_CHG		0x02	/* Link Width Enable changed */
-#define IB_NOTICE_TRAP_NODE_DESC_CHG	0x01
-
-/*
- * Generic trap/notice M_Key volation flags in dr_trunc_hop (trap 256).
- */
-#define IB_NOTICE_TRAP_DR_NOTICE	0x80
-#define IB_NOTICE_TRAP_DR_TRUNC		0x40
-
 enum {
 	IB_MGMT_MAD_HDR = 24,
 	IB_MGMT_MAD_DATA = 232,
@@ -282,21 +257,6 @@ struct ib_class_port_info {
 	__be32			trap_qkey;
 };
 
-struct ib_node_info {
-	u8 base_version;
-	u8 class_version;
-	u8 node_type;
-	u8 num_ports;
-	__be64 sys_guid;
-	__be64 node_guid;
-	__be64 port_guid;
-	__be16 partition_cap;
-	__be16 device_id;
-	__be32 revision;
-	u8 local_port_num;
-	u8 vendor_id[3];
-} __packed;
-
 struct ib_mad_notice_attr {
 	u8 generic_type;
 	u8 prod_type_msb;
@@ -361,11 +321,6 @@ struct ib_mad_notice_attr {
 	} details;
 };
 
-struct ib_vl_weight_elem {
-	u8      vl;     /* VL is low 5 bits, upper 3 bits reserved */
-	u8      weight;
-};
-
 /**
  * ib_mad_send_buf - MAD data buffer and work request for sends.
  * @next: A pointer used to chain together MADs for posting.
diff --git a/include/rdma/ib_smi.h b/include/rdma/ib_smi.h
index 98b9086d769a..b439e988408e 100644
--- a/include/rdma/ib_smi.h
+++ b/include/rdma/ib_smi.h
@@ -119,10 +119,57 @@ struct ib_port_info {
 	u8 link_roundtrip_latency[3];
 };
 
+struct ib_node_info {
+	u8 base_version;
+	u8 class_version;
+	u8 node_type;
+	u8 num_ports;
+	__be64 sys_guid;
+	__be64 node_guid;
+	__be64 port_guid;
+	__be16 partition_cap;
+	__be16 device_id;
+	__be32 revision;
+	u8 local_port_num;
+	u8 vendor_id[3];
+} __packed;
+
+struct ib_vl_weight_elem {
+	u8      vl;     /* IB: VL is low 4 bits, upper 4 bits reserved */
+                        /* OPA: VL is low 5 bits, upper 3 bits reserved */
+	u8      weight;
+};
+
 static inline u8
 ib_get_smp_direction(struct ib_smp *smp)
 {
 	return ((smp->status & IB_SMP_DIRECTION) == IB_SMP_DIRECTION);
 }
 
+/*
+ * SM Trap/Notice numbers
+ */
+#define IB_NOTICE_TRAP_LLI_THRESH	cpu_to_be16(129)
+#define IB_NOTICE_TRAP_EBO_THRESH	cpu_to_be16(130)
+#define IB_NOTICE_TRAP_FLOW_UPDATE	cpu_to_be16(131)
+#define IB_NOTICE_TRAP_CAP_MASK_CHG	cpu_to_be16(144)
+#define IB_NOTICE_TRAP_SYS_GUID_CHG	cpu_to_be16(145)
+#define IB_NOTICE_TRAP_BAD_MKEY		cpu_to_be16(256)
+#define IB_NOTICE_TRAP_BAD_PKEY		cpu_to_be16(257)
+#define IB_NOTICE_TRAP_BAD_QKEY		cpu_to_be16(258)
+
+/*
+ * Other local changes flags (trap 144).
+ */
+#define IB_NOTICE_TRAP_LSE_CHG		0x04	/* Link Speed Enable changed */
+#define IB_NOTICE_TRAP_LWE_CHG		0x02	/* Link Width Enable changed */
+#define IB_NOTICE_TRAP_NODE_DESC_CHG	0x01
+
+/*
+ * M_Key volation flags in dr_trunc_hop (trap 256).
+ */
+#define IB_NOTICE_TRAP_DR_NOTICE	0x80
+#define IB_NOTICE_TRAP_DR_TRUNC		0x40
+
+
 #endif /* IB_SMI_H */
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
