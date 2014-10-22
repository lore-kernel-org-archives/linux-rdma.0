From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] iba/ib_types.h: Add support for new MAD SM:PortInfoExtended
 and for modifying PM:PortExtendedSpeedsCounters
Date: Wed, 22 Oct 2014 08:41:09 -0400
Message-ID: <5447A5E5.4080502@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Dan Ben-Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This commit is to support IBA spec changes for SM:PortInfoExtended and
PM:PortExtendedSpeedsCounters).

This change includes:
1. Adding new capability mask parse options for SM:PortInfo:CapabilityMask2.
2. Adding new capability mask parse options for
SM:PortInfoExtended:CapabilityMask.
3. Adding new capability mask parse options for
PM:ClassPortInfo:CapabilityMask.
4. Adding structs for SM:PortInfoExtended and for
SA:PortInfoExtendedRecord.

Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/iba/ib_types.h |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/include/iba/ib_types.h b/include/iba/ib_types.h
index 59bd424..93c706e 100644
--- a/include/iba/ib_types.h
+++ b/include/iba/ib_types.h
@@ -3528,6 +3528,9 @@ typedef struct _ib_class_port_info {
 #define IB_PM_EXT_WIDTH_NOIETF_SUP		(CL_HTON16(((uint16_t)1)<<10))
 #define IB_PM_SAMPLES_ONLY_SUP			(CL_HTON16(((uint16_t)1)<<11))
 #define IB_PM_PC_XMIT_WAIT_SUP			(CL_HTON16(((uint16_t)1)<<12))
+#define IS_PM_INH_LMTD_PKEY_MC_CONSTR_ERR	(CL_HTON16(((uint16_t)1)<<13))
+#define IS_PM_RSFEC_COUNTERS_SUP		(CL_HTON16(((uint16_t)1)<<14))
+#define IB_PM_IS_QP1_DROP_SUP			(CL_HTON16(((uint16_t)1)<<15))
 
 /****f* IBA Base: Types/ib_class_set_resp_time_val
 * NAME
@@ -4660,6 +4663,37 @@ typedef struct _ib_port_info {
 #define IB_PORT_CAP_HAS_MCAST_FDB_TOP (CL_HTON32(0x40000000))
 #define IB_PORT_CAP_HAS_HIER_INFO (CL_HTON32(0x80000000))
 
+#define IB_PORT_CAP2_IS_SET_NODE_DESC_SUPPORTED (CL_HTON16(0x0001))
+#define IB_PORT_CAP2_IS_PORT_INFO_EXT_SUPPORTED (CL_HTON16(0x0002))
+
+/****s* IBA Base: Types/ib_port_info_ext_t
+* NAME
+*	ib_port_info_ext_t
+*
+* DESCRIPTION
+*	IBA defined PortInfoExtended. (14.2.5.19)
+*
+* SYNOPSIS
+*/
+#include <complib/cl_packon.h>
+typedef struct _ib_port_info_ext {
+	ib_net32_t cap_mask;
+	ib_net16_t fec_mode_active;
+	ib_net16_t fdr_fec_mode_sup;
+	ib_net16_t fdr_fec_mode_enable;
+	ib_net16_t edr_fec_mode_sup;
+	ib_net16_t edr_fec_mode_enable;
+	uint8_t reserved[50];
+} PACK_SUFFIX ib_port_info_ext_t;
+#include <complib/cl_packoff.h>
+/************/
+
+#define IB_PORT_EXT_NO_FEC_MODE_ACTIVE		    0
+#define IB_PORT_EXT_FIRE_CODE_FEC_MODE_ACTIVE	    (CL_HTON16(0x0001))
+#define IB_PORT_EXT_RS_FEC_MODE_ACTIVE		    (CL_HTON16(0x0002))
+#define IB_PORT_EXT_LOW_LATENCY_RS_FEC_MODE_ACTIVE  (CL_HTON16(0x0003))
+
+#define IB_PORT_EXT_CAP_IS_FEC_MODE_SUPPORTED (CL_HTON32(0x00000001))
 /****f* IBA Base: Types/ib_port_info_get_port_state
 * NAME
 *	ib_port_info_get_port_state
@@ -6358,6 +6392,15 @@ typedef struct _ib_portinfo_record {
 #include <complib/cl_packoff.h>
 
 #include <complib/cl_packon.h>
+typedef struct _ib_portinfoext_record {
+	ib_net16_t lid;
+	uint8_t port_num;
+	uint8_t options;
+	ib_port_info_ext_t port_info_ext;
+} PACK_SUFFIX ib_portinfoext_record_t;
+#include <complib/cl_packoff.h>
+
+#include <complib/cl_packon.h>
 typedef struct _ib_link_record {
 	ib_net16_t from_lid;
 	uint8_t from_port_num;
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
