From: Mike Marciniszyn <mike.marciniszyn@intel.com>
Subject: [PATCH 1/2] staging/rdma/hfi1: add definitions for OPA traps
Date: Thu, 10 Dec 2015 09:59:34 -0500
Message-ID: <20151210145934.22192.48913.stgit@phlsvslse11.ph.intel.com>
References: <20151210145904.22192.40996.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20151210145904.22192.40996.stgit@phlsvslse11.ph.intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: devel@driverdev.osuosl.org
Cc: linux-rdma@vger.kernel.org, dledford@redhat.com, linux-next@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john@intel.com>

These new definitions will be used by follow-on
patches for formating and sending OPA traps.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Jubin John <jubin.john@intel.com>
---
 drivers/staging/rdma/hfi1/mad.h |  114 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)

diff --git a/drivers/staging/rdma/hfi1/mad.h b/drivers/staging/rdma/hfi1/mad.h
index 4745750..f031775 100644
--- a/drivers/staging/rdma/hfi1/mad.h
+++ b/drivers/staging/rdma/hfi1/mad.h
@@ -60,7 +60,121 @@
 #endif
 #include "opa_compat.h"
 
+/*
+ * OPA Traps
+ */
+#define OPA_TRAP_GID_NOW_IN_SERVICE             cpu_to_be16(64)
+#define OPA_TRAP_GID_OUT_OF_SERVICE             cpu_to_be16(65)
+#define OPA_TRAP_ADD_MULTICAST_GROUP            cpu_to_be16(66)
+#define OPA_TRAL_DEL_MULTICAST_GROUP            cpu_to_be16(67)
+#define OPA_TRAP_UNPATH                         cpu_to_be16(68)
+#define OPA_TRAP_REPATH                         cpu_to_be16(69)
+#define OPA_TRAP_PORT_CHANGE_STATE              cpu_to_be16(128)
+#define OPA_TRAP_LINK_INTEGRITY                 cpu_to_be16(129)
+#define OPA_TRAP_EXCESSIVE_BUFFER_OVERRUN       cpu_to_be16(130)
+#define OPA_TRAP_FLOW_WATCHDOG                  cpu_to_be16(131)
+#define OPA_TRAP_CHANGE_CAPABILITY              cpu_to_be16(144)
+#define OPA_TRAP_CHANGE_SYSGUID                 cpu_to_be16(145)
+#define OPA_TRAP_BAD_M_KEY                      cpu_to_be16(256)
+#define OPA_TRAP_BAD_P_KEY                      cpu_to_be16(257)
+#define OPA_TRAP_BAD_Q_KEY                      cpu_to_be16(258)
+#define OPA_TRAP_SWITCH_BAD_PKEY                cpu_to_be16(259)
+#define OPA_SMA_TRAP_DATA_LINK_WIDTH            cpu_to_be16(2048)
 
+/*
+ * Generic trap/notice other local changes flags (trap 144).
+ */
+#define	OPA_NOTICE_TRAP_LWDE_CHG        0x08 /* Link Width Downgrade Enable
+					      * changed
+					      */
+#define OPA_NOTICE_TRAP_LSE_CHG         0x04 /* Link Speed Enable changed */
+#define OPA_NOTICE_TRAP_LWE_CHG         0x02 /* Link Width Enable changed */
+#define OPA_NOTICE_TRAP_NODE_DESC_CHG   0x01
+
+struct opa_mad_notice_attr {
+	u8 generic_type;
+	u8 prod_type_msb;
+	__be16 prod_type_lsb;
+	__be16 trap_num;
+	__be16 toggle_count;
+	__be32 issuer_lid;
+	__be32 reserved1;
+	union ib_gid issuer_gid;
+
+	union {
+		struct {
+			u8	details[64];
+		} raw_data;
+
+		struct {
+			union ib_gid	gid;
+		} __packed ntc_64_65_66_67;
+
+		struct {
+			__be32	lid;
+		} __packed ntc_128;
+
+		struct {
+			__be32	lid;		/* where violation happened */
+			u8	port_num;	/* where violation happened */
+		} __packed ntc_129_130_131;
+
+		struct {
+			__be32	lid;		/* LID where change occurred */
+			__be32	new_cap_mask;	/* new capability mask */
+			__be16	reserved2;
+			__be16	cap_mask;
+			__be16	change_flags;	/* low 4 bits only */
+		} __packed ntc_144;
+
+		struct {
+			__be64	new_sys_guid;
+			__be32	lid;		/* lid where sys guid changed */
+		} __packed ntc_145;
+
+		struct {
+			__be32	lid;
+			__be32	dr_slid;
+			u8	method;
+			u8	dr_trunc_hop;
+			__be16	attr_id;
+			__be32	attr_mod;
+			__be64	mkey;
+			u8	dr_rtn_path[30];
+		} __packed ntc_256;
+
+		struct {
+			__be32		lid1;
+			__be32		lid2;
+			__be32		key;
+			u8		sl;	/* SL: high 5 bits */
+			u8		reserved3[3];
+			union ib_gid	gid1;
+			union ib_gid	gid2;
+			__be32		qp1;	/* high 8 bits reserved */
+			__be32		qp2;	/* high 8 bits reserved */
+		} __packed ntc_257_258;
+
+		struct {
+			__be16		flags;	/* low 8 bits reserved */
+			__be16		pkey;
+			__be32		lid1;
+			__be32		lid2;
+			u8		sl;	/* SL: high 5 bits */
+			u8		reserved4[3];
+			union ib_gid	gid1;
+			union ib_gid	gid2;
+			__be32		qp1;	/* high 8 bits reserved */
+			__be32		qp2;	/* high 8 bits reserved */
+		} __packed ntc_259;
+
+		struct {
+			__be32	lid;
+		} __packed ntc_2048;
+
+	};
+	u8	class_data[0];
+};
 
 #define IB_VLARB_LOWPRI_0_31    1
 #define IB_VLARB_LOWPRI_32_63   2
