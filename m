From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] Adding Congestion Control definitions.
Date: Mon, 21 Mar 2011 18:20:17 +0200
Message-ID: <20110321162017.GA5062@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Adding Congestion Control definitions as described in IB spec A10
and Link Working Group Errata Q3/2010.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 Makefile.am              |    4 +-
 include/infiniband/mad.h |   67 +++++++++++++++++++++++++++++-
 src/ccm.c                |  102 ++++++++++++++++++++++++++++++++++++++++++++++
 src/dump.c               |   25 +++++++++++
 src/fields.c             |   47 +++++++++++++++++++++-
 src/libibmad.map         |    2 +
 src/mad.c                |    3 +-
 7 files changed, 244 insertions(+), 6 deletions(-)
 create mode 100644 src/ccm.c

diff --git a/Makefile.am b/Makefile.am
index 0a9e55d..2b3d363 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -15,8 +15,8 @@ endif
 
 libibmad_la_SOURCES = src/dump.c src/fields.c src/mad.c src/portid.c \
 		      src/resolve.c src/rpc.c src/sa.c src/smp.c src/gs.c \
-		      src/serv.c src/register.c src/vendor.c src/bm.c \
-		      src/mad_internal.h
+		      src/serv.c src/register.c src/vendor.c src/bm.c src/ccm.c\
+                      src/mad_internal.h
 
 libibmad_la_LDFLAGS = -version-info $(ibmad_api_version) \
     -export-dynamic $(libibmad_version_script)
diff --git a/include/infiniband/mad.h b/include/infiniband/mad.h
index 7571a61..1790bd6 100644
--- a/include/infiniband/mad.h
+++ b/include/infiniband/mad.h
@@ -66,6 +66,18 @@ BEGIN_C_DECLS
 #define IB_BM_DATA_SZ		(IB_MAD_SIZE - IB_BM_DATA_OFFS)
 #define IB_BM_BKEY_OFFS		24
 #define IB_BM_BKEY_AND_DATA_SZ	(IB_MAD_SIZE - IB_BM_BKEY_OFFS)
+#define IB_CC_DATA_OFFS         24
+#define IB_CC_DATA_SZ           (IB_MAD_SIZE - IB_CC_DATA_OFFS)
+#define CC_KEY_OFFSET          64	/* bits */
+#define LOG_RESERVED           256	/* bits */
+#define CC_KEY_BLOCK_SIZE      8
+#define CCM_SWITCH_LOG                 1
+#define CCM_CA_LOG                     2
+#define CCM_SWITCH_ENTRY_LIST_OFFSET   40 + CC_KEY_BLOCK_SIZE
+#define CCM_CA_ENTRY_LIST_OFFSET       8 + CC_KEY_BLOCK_SIZE
+#define CCM_SWITCH_ENTRY_LIST_LENGTH   15
+#define CCM_CA_ENTRY_LIST_LENGTH       16
+#define CCM_SWITCH_ENTRY_SIZE          12
 
 enum MAD_CLASSES {
 	IB_SMI_CLASS = 0x1,
@@ -140,6 +152,21 @@ enum SMI_ATTR_ID {
 	IB_ATTR_LAST
 };
 
+enum CC_ATTR_ID {
+	IB_CC_ATTR_CLASS_PORT_INFO = 0X01,
+	IB_CC_ATTR_NOTICE = 0X02,
+	IB_CC_ATTR_CONGESTION_INFO = 0X11,
+	IB_CC_ATTR_CONGESTION_KEY_INFO = 0X12,
+	IB_CC_ATTR_CONGESTION_LOG = 0X13,
+	IB_CC_ATTR_SWITCH_CONGESTION_SETTING = 0X14,
+	IB_CC_ATTR_SWITCH_PORT_CONGESTION_SWTTING = 0X15,
+	IB_CC_ATTR_CA_CONGESTION_SETTING = 0X16,
+	IB_CC_ATTR_CONGESTION_CONTROL_TABLE = 0X17,
+	IB_CC_ATTR_TIME_STAMP = 0X18,
+
+	IB_CC_ATTR_LAST
+};
+
 enum SA_ATTR_ID {
 	IB_SA_ATTR_NOTICE = 0x02,
 	IB_SA_ATTR_INFORMINFO = 0x03,
@@ -706,6 +733,36 @@ enum MAD_FIELDS {
 	IB_PSC_SAMPLES_ONLY_OPT_MASK_F,
 	IB_PSC_LAST_F,
 
+	IB_CC_LOG_FIRST_F,
+	IB_CC_LOG_LOGTYPE_F = IB_CC_LOG_FIRST_F,
+	IB_CC_LOG_CONGESTION_FLAGS_F,
+	IB_CC_LOG_LOG_EVENTS_COUNTER_F,
+	IB_CC_LOG_CURRENT_TIME_STAMP_F,
+	IB_CC_LOG_PORTMAP_F,
+	IB_CC_LOG_CONGESTION_ENTRY_LIST,
+	IB_CC_LOG_LAST_F,
+
+	IB_CC_LOG_EVENT_FIRST_F,
+	IB_CC_LOG_EVENT_SLID_F = IB_CC_LOG_EVENT_FIRST_F,
+	IB_CC_LOG_EVENT_DLID_F,
+	IB_CC_LOG_EVENT_SL_F,
+	IB_CC_LOG_EVENT_RESERVED_F,
+	IB_CC_LOG_EVENT_TIMESTAMP_F,
+	IB_CC_LOG_EVENT_LAST,
+
+	IB_CC_SWITCH_SET_FIRST_F,
+	IB_CC_SWITCH_SET_CONTROL_MAP_F = IB_CC_SWITCH_SET_FIRST_F,
+	IB_CC_SWITCH_SET_VICTIM_MASK_F,
+	IB_CC_SWITCH_SET_CREDIT_MASK_F,
+	IB_CC_SWITCH_SET_THRESHOLD_F,
+	IB_CC_SWITCH_SET_RESERVED1_F,
+	IB_CC_SWITCH_SET_PACKET_SIZE_F,
+	IB_CC_SWITCH_SET_CS_THRESHOLD_F,
+	IB_CC_SWITCH_SET_RESERVED2_F,
+	IB_CC_SWITCH_SET_RETURN_DELAY_F,
+	IB_CC_SWITCH_SET_MARKING_RATE_F,
+	IB_CC_SWITCH_SET_LAST_F,
+
 	IB_FIELD_LAST_		/* must be last */
 };
 
@@ -1013,6 +1070,14 @@ MAD_EXPORT uint8_t *performance_reset_via(void *rcvbuf, ib_portid_t * dest,
 MAD_EXPORT uint8_t *bm_call_via(void *data, ib_portid_t * portid,
 				ib_bm_call_t * call,
 				struct ibmad_port *srcport);
+/* ccm.c */
+uint8_t *cc_set_via(void *rcvbuf, ib_portid_t * dest,
+		    uint8_t * cc_key, unsigned timeout,
+		    unsigned id, const struct ibmad_port *srcport);
+
+uint8_t *cc_query_via(void *rcvbuf, ib_portid_t * dest, uint8_t * cc_key,
+		      unsigned timeout, unsigned id,
+		      const struct ibmad_port *srcport);
 
 /* dump.c */
 MAD_EXPORT ib_mad_dump_fn
@@ -1029,7 +1094,7 @@ MAD_EXPORT ib_mad_dump_fn
     mad_dump_switchinfo, mad_dump_perfcounters, mad_dump_perfcounters_ext,
     mad_dump_perfcounters_xmt_sl, mad_dump_perfcounters_rcv_sl,
     mad_dump_perfcounters_xmt_disc, mad_dump_perfcounters_rcv_err,
-    mad_dump_portsamples_control;
+    mad_dump_portsamples_control, mad_dump_cc_list;
 
 MAD_EXPORT void mad_dump_fields(char *buf, int bufsz, void *val, int valsz,
 				int start, int end);
diff --git a/src/ccm.c b/src/ccm.c
new file mode 100644
index 0000000..078e2b4
--- /dev/null
+++ b/src/ccm.c
@@ -0,0 +1,102 @@
+/*
+ * Copyright (c) 2004-2007 Voltaire Inc.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ */
+
+#if HAVE_CONFIG_H
+#include <config.h>
+#endif				/* HAVE_CONFIG_H */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include <infiniband/umad.h>
+#include <infiniband/mad.h>
+
+#undef DEBUG
+#define DEBUG   if (ibdebug)    IBWARN
+
+uint8_t *cc_query_via(void *rcvbuf, ib_portid_t * dest, uint8_t * cc_key,
+		      unsigned timeout, unsigned id,
+		      const struct ibmad_port *srcport)
+{
+	ib_rpc_t rpc = { 0 };
+	int lid = dest->lid;
+
+	if (lid == -1) {
+		IBWARN("only lid routed is supported");
+		return 0;
+	}
+
+	rpc.mgtclass = IB_CC_CLASS;
+	rpc.method = IB_MAD_METHOD_GET;
+	rpc.attr.id = id;
+
+	/* Same for attribute IDs */
+	// TODO set cc_key
+	memcpy(rcvbuf, cc_key, CC_KEY_BLOCK_SIZE);
+	rpc.attr.mod = 0;
+	rpc.timeout = timeout;
+	rpc.datasz = IB_CC_DATA_SZ;
+	rpc.dataoffs = IB_CC_DATA_OFFS;
+
+	dest->qp = 1;
+
+	return mad_rpc(srcport, &rpc, dest, rcvbuf, rcvbuf);
+}
+
+uint8_t *cc_set_via(void *rcvbuf, ib_portid_t * dest,
+		    uint8_t * cc_key, unsigned timeout,
+		    unsigned id, const struct ibmad_port * srcport)
+{
+	ib_rpc_t rpc = { 0 };
+	int lid = dest->lid;
+
+	if (lid == -1) {
+		IBWARN("only lid routed is supported");
+		return 0;
+	}
+
+	rpc.mgtclass = IB_CC_CLASS;
+	rpc.method = IB_MAD_METHOD_SET;
+	rpc.attr.id = id;
+
+	/* Same for attribute IDs */
+	memcpy(rcvbuf, cc_key, CC_KEY_BLOCK_SIZE);
+	rpc.attr.mod = 0;
+	rpc.timeout = timeout;
+	rpc.datasz = IB_CC_DATA_SZ;
+	rpc.dataoffs = IB_CC_DATA_OFFS;
+	dest->qp = 1;
+
+	return mad_rpc(srcport, &rpc, dest, rcvbuf, rcvbuf);
+}
diff --git a/src/dump.c b/src/dump.c
index c29f625..67c8d3f 100644
--- a/src/dump.c
+++ b/src/dump.c
@@ -591,6 +591,7 @@ static inline void ib_slvl_get_i(ib_slvl_table_t * tbl, int i, uint8_t * vl)
 }
 
 #define IB_NUM_VL_ARB_ELEMENTS_IN_BLOCK 32
+#define IB_NUM_CONGESTION_ENTRIES 15
 
 typedef struct _ib_vl_arb_table {
 	struct {
@@ -599,6 +600,15 @@ typedef struct _ib_vl_arb_table {
 	} vl_entry[IB_NUM_VL_ARB_ELEMENTS_IN_BLOCK];
 } ib_vl_arb_table_t;
 
+typedef struct _ib_cc_log_entry {
+
+	uint16_t res_vl;
+	uint16_t weight;
+	uint32_t sl_res;
+	uint32_t timestamp;
+
+} ib_cc_log_entry_t;
+
 static inline void ib_vl_arb_get_vl(uint8_t res_vl, uint8_t * const vl)
 {
 	*vl = res_vl & 0x0F;
@@ -715,6 +725,21 @@ void mad_dump_perfcounters_ext(char *buf, int bufsz, void *val, int valsz)
 	_dump_fields(buf, bufsz, val, IB_PC_EXT_FIRST_F, IB_PC_EXT_LAST_F);
 }
 
+void mad_dump_cc_list(char *buf, int bufsz, void *val, int valsz)
+{
+	int i;
+	int n = 0;
+	ib_cc_log_entry_t *ib_cc_table = (ib_cc_log_entry_t *) val;
+
+	for (i = 0; i < IB_NUM_CONGESTION_ENTRIES; i++) {
+		n += sprintf(buf + n, "\nentry %d: ", i + 1);
+		n += _dump_fields(buf + n, bufsz - n, ib_cc_table + i,
+				  IB_CC_LOG_EVENT_FIRST_F,
+				  IB_CC_LOG_EVENT_LAST);
+	}
+	sprintf(buf + n, "\n");
+}
+
 void mad_dump_perfcounters_xmt_sl(char *buf, int bufsz, void *val, int valsz)
 {
 	int cnt;
diff --git a/src/fields.c b/src/fields.c
index d992065..4c51d4d 100644
--- a/src/fields.c
+++ b/src/fields.c
@@ -467,7 +467,7 @@ static const ib_field_t ib_mad_f[] = {
 	{80, 16, "PortDLIDMappingErrors", mad_dump_uint},
 	{96, 16, "PortVLMappingErrors", mad_dump_uint},
 	{112, 16, "PortLoopingErrors", mad_dump_uint},
-	{0, 0},                 /* IB_PC_RCV_ERR_LAST_F */
+	{0, 0},			/* IB_PC_RCV_ERR_LAST_F */
 
 	/*
 	 * PortSamplesControl fields
@@ -504,6 +504,51 @@ static const ib_field_t ib_mad_f[] = {
 	{576, 64, "SamplesOnlyOptionMask", mad_dump_hex},
 	{0, 0},			/* IB_PSC_LAST_F */
 
+	/*
+	 * Congestion Log
+	 */
+	{BITSOFFS(0 + CC_KEY_OFFSET, 8), "LogType", mad_dump_hex},
+	{BITSOFFS(8 + CC_KEY_OFFSET, 8), "CongestionFlag", mad_dump_hex},
+	{BITSOFFS(16 + CC_KEY_OFFSET, 16), "LogEventCounter", mad_dump_uint},
+	{32 + CC_KEY_OFFSET, 32, "CurrentTimeStamp", mad_dump_hex},
+	{64 + CC_KEY_OFFSET, 256, "PortMap", mad_dump_array},
+	{320 + CC_KEY_OFFSET, 1440, "CongestionEntryList", mad_dump_cc_list},
+	{0, 0},			/* IB_CC_LOG_LAST_F */
+
+	/*
+	 * Congestion Log Event (entry list)
+	 */
+	{BITSOFFS(0, 16), "SLID", mad_dump_uint},
+	{BITSOFFS(16, 16), "DLID", mad_dump_uint},
+	{BITSOFFS(32, 4), "SL", mad_dump_uint},
+	{BITSOFFS(36, 28), "Reserved", mad_dump_uint},
+	{64, 32, "TimeStamp", mad_dump_hex},
+	{0, 0},			/* IB_CC_LOG_EVENT_LAST */
+
+	/*
+	 * Switch Congestion Setting
+	 */
+	{0 + CC_KEY_OFFSET + LOG_RESERVED, 32, "ControlMap", mad_dump_hex},
+	{32 + CC_KEY_OFFSET + LOG_RESERVED, 256, "Victim_Mask", mad_dump_array},
+	{288 + CC_KEY_OFFSET + LOG_RESERVED, 256, "Credit_Mask",
+	 mad_dump_array},
+	{BITSOFFS(544 + CC_KEY_OFFSET + LOG_RESERVED, 4), "Threshold",
+	 mad_dump_hex},
+	{BITSOFFS(548 + CC_KEY_OFFSET + LOG_RESERVED, 4), "Reserved",
+	 mad_dump_uint},
+	{BITSOFFS(552 + CC_KEY_OFFSET + LOG_RESERVED, 8), "PacketSize",
+	 mad_dump_uint},
+	{BITSOFFS(560 + CC_KEY_OFFSET + LOG_RESERVED, 4), "CS_threshold",
+	 mad_dump_uint},
+	{BITSOFFS(564 + CC_KEY_OFFSET + LOG_RESERVED, 12), "Reserved",
+	 mad_dump_uint},
+	{BITSOFFS(576 + CC_KEY_OFFSET + LOG_RESERVED, 16), "CS_returnDelay",
+	 mad_dump_uint},
+	{BITSOFFS(592 + CC_KEY_OFFSET + LOG_RESERVED, 16), "MarkingRate",
+	 mad_dump_uint},
+
+	{0, 0},			/* IB_CC_SWITCH_SET_LAST_F */
+
 	{0, 0}			/* IB_FIELD_LAST_ */
 
 };
diff --git a/src/libibmad.map b/src/libibmad.map
index 5778e3e..bccce45 100644
--- a/src/libibmad.map
+++ b/src/libibmad.map
@@ -110,5 +110,7 @@ IBMAD_1.3 {
 		ib_resolve_self_via;
 		mad_field_name;
 		bm_call_via;
+                cc_query_via;
+                cc_set_via;
 	local: *;
 };
diff --git a/src/mad.c b/src/mad.c
index acd0e85..c22b689 100644
--- a/src/mad.c
+++ b/src/mad.c
@@ -82,8 +82,7 @@ void *mad_encode(void *buf, ib_rpc_t * rpc, ib_dr_path_t * drpath, void *data)
 	/* first word */
 	mad_set_field(buf, 0, IB_MAD_METHOD_F, rpc->method);
 	mad_set_field(buf, 0, IB_MAD_RESPONSE_F, is_resp ? 1 : 0);
-	mad_set_field(buf, 0, IB_MAD_CLASSVER_F,
-		      rpc->mgtclass == IB_SA_CLASS ? 2 : 1);
+	mad_set_field(buf, 0, IB_MAD_CLASSVER_F,mgmt_class_vers( rpc->mgtclass));
 	mad_set_field(buf, 0, IB_MAD_MGMTCLASS_F, rpc->mgtclass);
 	mad_set_field(buf, 0, IB_MAD_BASEVER_F, 1);
 
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
