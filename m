From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [infiniband-diags] [libibmad] Support new ibccquery congestion
	control tool
Date: Mon, 19 Sep 2011 15:06:29 -0700
Message-ID: <1316469989.25283.728.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-EW9u4/8DaArGa39hECr+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-EW9u4/8DaArGa39hECr+
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

The following patches add a new tool ibccquery to infiniband-diags.  It
supports the querying of various congestion control settings.  Related
updates to libibmad are also included.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory


--=-EW9u4/8DaArGa39hECr+
Content-Disposition: attachment; filename=0001-Add-support-for-congestion-control-mads.patch
Content-Type: message/rfc822; name=0001-Add-support-for-congestion-control-mads.patch

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Tue, 2 Aug 2011 11:16:54 -0700
Subject: [PATCH 1/2] Add support for congestion control mads
Message-Id: <1316469891.25283.724.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 Makefile.am              |    2 +-
 include/infiniband/mad.h |  184 +++++++++++++++++++++++++++++++++++++++++++++-
 src/cc.c                 |   81 ++++++++++++++++++++
 src/dump.c               |   84 +++++++++++++++++++++
 src/fields.c             |  126 +++++++++++++++++++++++++++++++
 src/libibmad.map         |   15 ++++
 src/mad.c                |   13 +++-
 7 files changed, 501 insertions(+), 4 deletions(-)
 create mode 100644 src/cc.c

diff --git a/Makefile.am b/Makefile.am
index 0a9e55d..b96657e 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -16,7 +16,7 @@ endif
 libibmad_la_SOURCES = src/dump.c src/fields.c src/mad.c src/portid.c \
 		      src/resolve.c src/rpc.c src/sa.c src/smp.c src/gs.c \
 		      src/serv.c src/register.c src/vendor.c src/bm.c \
-		      src/mad_internal.h
+		      src/mad_internal.h src/cc.c
 
 libibmad_la_LDFLAGS = -version-info $(ibmad_api_version) \
     -export-dynamic $(libibmad_version_script)
diff --git a/include/infiniband/mad.h b/include/infiniband/mad.h
index 25c1141..1811e3a 100644
--- a/include/infiniband/mad.h
+++ b/include/infiniband/mad.h
@@ -70,6 +70,10 @@ BEGIN_C_DECLS
 #define IB_BM_DATA_SZ		(IB_MAD_SIZE - IB_BM_DATA_OFFS)
 #define IB_BM_BKEY_OFFS		24
 #define IB_BM_BKEY_AND_DATA_SZ	(IB_MAD_SIZE - IB_BM_BKEY_OFFS)
+#define IB_CC_DATA_OFFS         64
+#define IB_CC_DATA_SZ           (IB_MAD_SIZE - IB_CC_DATA_OFFS)
+#define IB_CC_LOG_DATA_OFFS     32 
+#define IB_CC_LOG_DATA_SZ       (IB_MAD_SIZE - IB_CC_LOG_DATA_OFFS)
 
 enum MAD_CLASSES {
 	IB_SMI_CLASS = 0x1,
@@ -217,6 +221,17 @@ enum BM_ATTR_ID {
 	IB_BM_ATTR_LAST
 };
 
+enum CC_ATTRI_ID {
+	IB_CC_ATTR_CONGESTION_INFO = 0x11,
+	IB_CC_ATTR_CONGESTION_KEY_INFO = 0x12,
+	IB_CC_ATTR_CONGESTION_LOG = 0x13,
+	IB_CC_ATTR_SWITCH_CONGESTION_SETTING = 0x14,
+	IB_CC_ATTR_SWITCH_PORT_CONGESTION_SETTING = 0x15,
+	IB_CC_ATTR_CA_CONGESTION_SETTING = 0x16,
+	IB_CC_ATTR_CONGESTION_CONTROL_TABLE = 0x17,
+	IB_CC_ATTR_TIMESTAMP = 0x18,
+};
+
 #define IB_VENDOR_OPENIB_PING_CLASS	(IB_VENDOR_RANGE2_START_CLASS + 2)
 #define IB_VENDOR_OPENIB_SYSSTAT_CLASS	(IB_VENDOR_RANGE2_START_CLASS + 3)
 #define IB_OPENIB_OUI			(0x001405)
@@ -269,6 +284,23 @@ typedef struct {
 	int error;		/* errno */
 } ib_rpc_v1_t;
 
+typedef struct {
+	int mgtclass;
+	int method;
+	ib_attr_t attr;
+	uint32_t rstatus;       /* return status */
+	int dataoffs;
+	int datasz;
+	uint64_t mkey;
+	uint64_t trid;          /* used for out mad if nonzero, return real val */
+	uint64_t mask;          /* for sa mads */
+	unsigned recsz;         /* for sa mads (attribute offset) */
+	int timeout;
+	uint32_t oui;           /* for vendor range 2 mads */
+	int error;		/* errno */
+	uint64_t cckey;
+} ib_rpc_cc_t;
+
 typedef struct portid {
 	int lid;		/* lid or 0 if directed route */
 	ib_dr_path_t drpath;
@@ -1038,6 +1070,144 @@ enum MAD_FIELDS {
 	IB_MLNX_EXT_PORT_LINK_SPEED_ACTIVE_F,
 	IB_MLNX_EXT_PORT_LAST_F,
 
+	/*
+	 * Congestion Control Mad fields
+	 * bytes 24-31 of congestion control mad
+	 */
+	IB_CC_CCKEY_F,
+
+	/*
+	 * CongestionInfo fields
+	 */
+	IB_CC_CONGESTION_INFO_FIRST_F,
+	IB_CC_CONGESTION_INFO_F = IB_CC_CONGESTION_INFO_FIRST_F,
+	IB_CC_CONGESTION_INFO_CONTROL_TABLE_CAP_F,
+	IB_CC_CONGESTION_INFO_LAST_F,
+
+	/*
+	 * CongestionKeyInfo fields
+	 */
+	IB_CC_CONGESTION_KEY_INFO_FIRST_F,
+	IB_CC_CONGESTION_KEY_INFO_CC_KEY_F = IB_CC_CONGESTION_KEY_INFO_FIRST_F,
+	IB_CC_CONGESTION_KEY_INFO_CC_KEY_PROTECT_BIT_F,
+	IB_CC_CONGESTION_KEY_INFO_CC_KEY_LEASE_PERIOD_F,
+	IB_CC_CONGESTION_KEY_INFO_CC_KEY_VIOLATIONS_F,
+	IB_CC_CONGESTION_KEY_INFO_LAST_F,
+
+	/*
+	 * CongestionLog (common) fields
+	 */
+	IB_CC_CONGESTION_LOG_FIRST_F,
+	IB_CC_CONGESTION_LOG_LOGTYPE_F = IB_CC_CONGESTION_LOG_FIRST_F,
+	IB_CC_CONGESTION_LOG_CONGESTION_FLAGS_F,
+	IB_CC_CONGESTION_LOG_LAST_F,
+
+	/*
+	 * CongestionLog (Switch) fields
+	 */
+	IB_CC_CONGESTION_LOG_SWITCH_FIRST_F,
+	IB_CC_CONGESTION_LOG_SWITCH_LOG_EVENTS_COUNTER_F = IB_CC_CONGESTION_LOG_SWITCH_FIRST_F,
+	IB_CC_CONGESTION_LOG_SWITCH_CURRENT_TIME_STAMP_F,
+	IB_CC_CONGESTION_LOG_SWITCH_PORTMAP_F,
+	IB_CC_CONGESTION_LOG_SWITCH_LAST_F,
+
+	/*
+	 * CongestionLogEvent (Switch) fields
+	 */
+	IB_CC_CONGESTION_LOG_ENTRY_SWITCH_FIRST_F,
+	IB_CC_CONGESTION_LOG_ENTRY_SWITCH_SLID_F = IB_CC_CONGESTION_LOG_ENTRY_SWITCH_FIRST_F,
+	IB_CC_CONGESTION_LOG_ENTRY_SWITCH_DLID_F,
+	IB_CC_CONGESTION_LOG_ENTRY_SWITCH_SL_F,
+	IB_CC_CONGESTION_LOG_ENTRY_SWITCH_TIMESTAMP_F,
+	IB_CC_CONGESTION_LOG_ENTRY_SWITCH_LAST_F,
+
+	/*
+	 * CongestionLog (CA) fields
+	 */
+	IB_CC_CONGESTION_LOG_CA_FIRST_F,
+	IB_CC_CONGESTION_LOG_CA_THRESHOLD_EVENT_COUNTER_F = IB_CC_CONGESTION_LOG_CA_FIRST_F,
+	IB_CC_CONGESTION_LOG_CA_THRESHOLD_CONGESTION_EVENT_MAP_F,
+	IB_CC_CONGESTION_LOG_CA_CURRENT_TIMESTAMP_F,
+	IB_CC_CONGESTION_LOG_CA_LAST_F,
+
+	/*
+	 * CongestionLogEvent (CA) fields
+	 */
+	IB_CC_CONGESTION_LOG_ENTRY_CA_FIRST_F,
+	IB_CC_CONGESTION_LOG_ENTRY_CA_LOCAL_QP_CN_ENTRY_F = IB_CC_CONGESTION_LOG_ENTRY_CA_FIRST_F,
+	IB_CC_CONGESTION_LOG_ENTRY_CA_SL_CN_ENTRY_F,
+	IB_CC_CONGESTION_LOG_ENTRY_CA_SERVICE_TYPE_CN_ENTRY_F,
+	IB_CC_CONGESTION_LOG_ENTRY_CA_REMOTE_QP_NUMBER_CN_ENTRY_F,
+	IB_CC_CONGESTION_LOG_ENTRY_CA_LOCAL_LID_CN_F,
+	IB_CC_CONGESTION_LOG_ENTRY_CA_REMOTE_LID_CN_ENTRY_F,
+	IB_CC_CONGESTION_LOG_ENTRY_CA_TIMESTAMP_CN_ENTRY_F,
+	IB_CC_CONGESTION_LOG_ENTRY_CA_LAST_F,
+
+	/*
+	 * SwitchCongestionSetting fields
+	 */
+	IB_CC_SWITCH_CONGESTION_SETTING_FIRST_F,
+	IB_CC_SWITCH_CONGESTION_SETTING_CONTROL_MAP_F = IB_CC_SWITCH_CONGESTION_SETTING_FIRST_F,
+	IB_CC_SWITCH_CONGESTION_SETTING_VICTIM_MASK_F,
+	IB_CC_SWITCH_CONGESTION_SETTING_CREDIT_MASK_F,
+	IB_CC_SWITCH_CONGESTION_SETTING_THRESHOLD_F,
+	IB_CC_SWITCH_CONGESTION_SETTING_PACKET_SIZE_F,
+	IB_CC_SWITCH_CONGESTION_SETTING_CS_THRESHOLD_F,
+	IB_CC_SWITCH_CONGESTION_SETTING_CS_RETURN_DELAY_F,
+	IB_CC_SWITCH_CONGESTION_SETTING_MARKING_RATE_F,
+	IB_CC_SWITCH_CONGESTION_SETTING_LAST_F,
+
+	/*
+	 * SwitchPortCongestionSettingElement fields
+	 */
+	IB_CC_SWITCH_PORT_CONGESTION_SETTING_ELEMENT_FIRST_F,
+	IB_CC_SWITCH_PORT_CONGESTION_SETTING_ELEMENT_VALID_F = IB_CC_SWITCH_PORT_CONGESTION_SETTING_ELEMENT_FIRST_F,
+	IB_CC_SWITCH_PORT_CONGESTION_SETTING_ELEMENT_CONTROL_TYPE_F,
+	IB_CC_SWITCH_PORT_CONGESTION_SETTING_ELEMENT_THRESHOLD_F,
+	IB_CC_SWITCH_PORT_CONGESTION_SETTING_ELEMENT_PACKET_SIZE_F,
+	IB_CC_SWITCH_PORT_CONGESTION_SETTING_ELEMENT_CONG_PARM_MARKING_RATE_F,
+	IB_CC_SWITCH_PORT_CONGESTION_SETTING_ELEMENT_LAST_F,
+
+	/*
+	 * CACongestionSetting fields
+	 */
+	IB_CC_CA_CONGESTION_SETTING_FIRST_F,
+	IB_CC_CA_CONGESTION_SETTING_PORT_CONTROL_F = IB_CC_CA_CONGESTION_SETTING_FIRST_F,
+	IB_CC_CA_CONGESTION_SETTING_CONTROL_MAP_F,
+	IB_CC_CA_CONGESTION_SETTING_LAST_F,
+
+	/*
+	 * CACongestionEntry fields
+	 */
+	IB_CC_CA_CONGESTION_ENTRY_FIRST_F,
+	IB_CC_CA_CONGESTION_ENTRY_CCTI_TIMER_F = IB_CC_CA_CONGESTION_ENTRY_FIRST_F,
+	IB_CC_CA_CONGESTION_ENTRY_CCTI_INCREASE_F,
+	IB_CC_CA_CONGESTION_ENTRY_TRIGGER_THRESHOLD_F,
+	IB_CC_CA_CONGESTION_ENTRY_CCTI_MIN_F,
+	IB_CC_CA_CONGESTION_ENTRY_LAST_F,
+
+	/*
+	 * CongestionControlTable fields
+	 */
+	IB_CC_CONGESTION_CONTROL_TABLE_FIRST_F,
+	IB_CC_CONGESTION_CONTROL_TABLE_CCTI_LIMIT_F = IB_CC_CONGESTION_CONTROL_TABLE_FIRST_F,
+	IB_CC_CONGESTION_CONTROL_TABLE_LAST_F,
+
+	/*
+	 * CongestionControlTableEntry fields
+	 */
+	IB_CC_CONGESTION_CONTROL_TABLE_ENTRY_FIRST_F,
+	IB_CC_CONGESTION_CONTROL_TABLE_ENTRY_CCT_SHIFT_F = IB_CC_CONGESTION_CONTROL_TABLE_ENTRY_FIRST_F,
+	IB_CC_CONGESTION_CONTROL_TABLE_ENTRY_CCT_MULTIPLIER_F,
+	IB_CC_CONGESTION_CONTROL_TABLE_ENTRY_LAST_F,
+
+	/*
+	 * Timestamp fields
+	 */
+	IB_CC_TIMESTAMP_FIRST_F,
+	IB_CC_TIMESTAMP_F = IB_CC_TIMESTAMP_FIRST_F,
+	IB_CC_TIMESTAMP_LAST_F,
+
 	IB_FIELD_LAST_		/* must be last */
 };
 
@@ -1300,6 +1470,12 @@ MAD_EXPORT uint8_t *smp_set_status_via(void *data, ib_portid_t * portid,
 				       unsigned timeout, int *rstatus,
 				       const struct ibmad_port *srcport);
 
+/* cc.c */
+MAD_EXPORT void *cc_query_status_via(void *rcvbuf, ib_portid_t * portid,
+				     unsigned attrid, unsigned mod, unsigned timeout,
+				     int *rstatus, const struct ibmad_port * srcport,
+				     uint64_t cckey);
+
 /* sa.c */
 uint8_t *sa_call(void *rcvbuf, ib_portid_t * portid, ib_sa_call_t * sa,
 		 unsigned timeout) DEPRECATED;
@@ -1377,7 +1553,13 @@ MAD_EXPORT ib_mad_dump_fn
     mad_dump_perfcounters_sw_port_vl_congestion, mad_dump_perfcounters_rcv_con_ctrl,
     mad_dump_perfcounters_sl_rcv_fecn, mad_dump_perfcounters_sl_rcv_becn,
     mad_dump_perfcounters_xmit_con_ctrl, mad_dump_perfcounters_vl_xmit_time_cong,
-    mad_dump_mlnx_ext_port_info;
+    mad_dump_mlnx_ext_port_info, mad_dump_cc_congestioninfo, mad_dump_cc_congestionkeyinfo,
+    mad_dump_cc_congestionlog, mad_dump_cc_congestionlogswitch,
+    mad_dump_cc_congestionlogentryswitch, mad_dump_cc_congestionlogca,
+    mad_dump_cc_congestionlogentryca, mad_dump_cc_switchcongestionsetting,
+    mad_dump_cc_switchportcongestionsettingelement, mad_dump_cc_cacongestionsetting,
+    mad_dump_cc_cacongestionentry, mad_dump_cc_congestioncontroltable,
+    mad_dump_cc_congestioncontroltableentry, mad_dump_cc_timestamp;
 
 MAD_EXPORT void mad_dump_fields(char *buf, int bufsz, void *val, int valsz,
 				int start, int end);
diff --git a/src/cc.c b/src/cc.c
new file mode 100644
index 0000000..36231f7
--- /dev/null
+++ b/src/cc.c
@@ -0,0 +1,81 @@
+/*
+ * Copyright (c) 2011 Lawrence Livermore National Lab.  All rights reserved.
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
+#  include <config.h>
+#endif				/* HAVE_CONFIG_H */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include <infiniband/mad.h>
+#include "mad_internal.h"
+
+#undef DEBUG
+#define DEBUG 	if (ibdebug)	IBWARN
+
+void *cc_query_status_via(void *rcvbuf, ib_portid_t * portid,
+			  unsigned attrid, unsigned mod, unsigned timeout,
+			  int *rstatus, const struct ibmad_port * srcport,
+			  uint64_t cckey)
+{
+	ib_rpc_cc_t rpc = { 0 };
+	void *res;
+
+	DEBUG("attr 0x%x mod 0x%x route %s", attrid, mod, portid2str(portid));
+	rpc.method = IB_MAD_METHOD_GET;
+	rpc.attr.id = attrid;
+	rpc.attr.mod = mod;
+	rpc.timeout = timeout;
+	if (attrid == IB_CC_ATTR_CONGESTION_LOG) {
+		rpc.datasz = IB_CC_LOG_DATA_SZ;
+		rpc.dataoffs = IB_CC_LOG_DATA_OFFS;
+	}
+	else {
+		rpc.datasz = IB_CC_DATA_SZ;
+		rpc.dataoffs = IB_CC_DATA_OFFS;
+	}
+	rpc.mgtclass = IB_CC_CLASS;
+	rpc.cckey = cckey;
+
+	portid->qp = 1;
+	if (!portid->qkey)
+		portid->qkey = IB_DEFAULT_QP1_QKEY;
+
+	res = mad_rpc(srcport, (ib_rpc_t *)&rpc, portid, rcvbuf, rcvbuf);
+	if (rstatus)
+		*rstatus = rpc.rstatus;
+
+	return res;
+}
diff --git a/src/dump.c b/src/dump.c
index 00831a3..309865b 100644
--- a/src/dump.c
+++ b/src/dump.c
@@ -969,6 +969,90 @@ void mad_dump_mlnx_ext_port_info(char *buf, int bufsz, void *val, int valsz)
 		     IB_MLNX_EXT_PORT_LAST_F);
 }
 
+void mad_dump_cc_congestioninfo(char *buf, int bufsz, void *val, int valsz)
+{
+	_dump_fields(buf, bufsz, val, IB_CC_CONGESTION_INFO_FIRST_F,
+		     IB_CC_CONGESTION_INFO_LAST_F);
+}
+
+void mad_dump_cc_congestionkeyinfo(char *buf, int bufsz, void *val, int valsz)
+{
+	_dump_fields(buf, bufsz, val, IB_CC_CONGESTION_KEY_INFO_FIRST_F,
+		     IB_CC_CONGESTION_KEY_INFO_LAST_F);
+}
+
+void mad_dump_cc_congestionlog(char *buf, int bufsz, void *val, int valsz)
+{
+	_dump_fields(buf, bufsz, val, IB_CC_CONGESTION_LOG_FIRST_F,
+		     IB_CC_CONGESTION_LOG_LAST_F);
+}
+
+void mad_dump_cc_congestionlogswitch(char *buf, int bufsz, void *val, int valsz)
+{
+	_dump_fields(buf, bufsz, val, IB_CC_CONGESTION_LOG_SWITCH_FIRST_F,
+		     IB_CC_CONGESTION_LOG_SWITCH_LAST_F);
+}
+
+void mad_dump_cc_congestionlogentryswitch(char *buf, int bufsz, void *val, int valsz)
+{
+	_dump_fields(buf, bufsz, val, IB_CC_CONGESTION_LOG_ENTRY_SWITCH_FIRST_F,
+		     IB_CC_CONGESTION_LOG_ENTRY_SWITCH_LAST_F);
+}
+
+void mad_dump_cc_congestionlogca(char *buf, int bufsz, void *val, int valsz)
+{
+	_dump_fields(buf, bufsz, val, IB_CC_CONGESTION_LOG_CA_FIRST_F,
+		     IB_CC_CONGESTION_LOG_CA_LAST_F);
+}
+
+void mad_dump_cc_congestionlogentryca(char *buf, int bufsz, void *val, int valsz)
+{
+	_dump_fields(buf, bufsz, val, IB_CC_CONGESTION_LOG_ENTRY_CA_FIRST_F,
+		     IB_CC_CONGESTION_LOG_ENTRY_CA_LAST_F);
+}
+
+void mad_dump_cc_switchcongestionsetting(char *buf, int bufsz, void *val, int valsz)
+{
+	_dump_fields(buf, bufsz, val, IB_CC_SWITCH_CONGESTION_SETTING_FIRST_F,
+		     IB_CC_SWITCH_CONGESTION_SETTING_LAST_F);
+}
+
+void mad_dump_cc_switchportcongestionsettingelement(char *buf, int bufsz, void *val, int valsz)
+{
+	_dump_fields(buf, bufsz, val, IB_CC_SWITCH_PORT_CONGESTION_SETTING_ELEMENT_FIRST_F,
+		     IB_CC_SWITCH_PORT_CONGESTION_SETTING_ELEMENT_LAST_F);
+}
+
+void mad_dump_cc_cacongestionsetting(char *buf, int bufsz, void *val, int valsz)
+{
+	_dump_fields(buf, bufsz, val, IB_CC_CA_CONGESTION_SETTING_FIRST_F,
+		     IB_CC_CA_CONGESTION_SETTING_LAST_F);
+}
+
+void mad_dump_cc_cacongestionentry(char *buf, int bufsz, void *val, int valsz)
+{
+	_dump_fields(buf, bufsz, val, IB_CC_CA_CONGESTION_ENTRY_FIRST_F,
+		     IB_CC_CA_CONGESTION_ENTRY_LAST_F);
+}
+
+void mad_dump_cc_congestioncontroltable(char *buf, int bufsz, void *val, int valsz)
+{
+	_dump_fields(buf, bufsz, val, IB_CC_CONGESTION_CONTROL_TABLE_FIRST_F,
+		     IB_CC_CONGESTION_CONTROL_TABLE_LAST_F);
+}
+
+void mad_dump_cc_congestioncontroltableentry(char *buf, int bufsz, void *val, int valsz)
+{
+	_dump_fields(buf, bufsz, val, IB_CC_CONGESTION_CONTROL_TABLE_ENTRY_FIRST_F,
+		     IB_CC_CONGESTION_CONTROL_TABLE_ENTRY_LAST_F);
+}
+
+void mad_dump_cc_timestamp(char *buf, int bufsz, void *val, int valsz)
+{
+	_dump_fields(buf, bufsz, val, IB_CC_TIMESTAMP_FIRST_F,
+		     IB_CC_TIMESTAMP_LAST_F);
+}
+
 void xdump(FILE * file, char *msg, void *p, int size)
 {
 #define HEX(x)  ((x) < 10 ? '0' + (x) : 'a' + ((x) -10))
diff --git a/src/fields.c b/src/fields.c
index 45c07dd..c7402b7 100644
--- a/src/fields.c
+++ b/src/fields.c
@@ -783,6 +783,132 @@ static const ib_field_t ib_mad_f[] = {
 	{BITSOFFS(120, 8), "LinkSpeedActive", mad_dump_hex},
 	{0, 0},			/* IB_MLNX_EXT_PORT_LAST_F */
 
+	/*
+	 * Congestion Control Mad fields
+	 * bytes 24-31 of congestion control mad
+	 */
+	{192, 64, "CC_Key", mad_dump_hex},	/* IB_CC_CCKEY_F */
+
+	/*
+	 * CongestionInfo fields
+	 */
+	{BITSOFFS(0, 16), "CongestionInfo", mad_dump_hex},
+	{BITSOFFS(16, 8), "ControlTableCap", mad_dump_uint},
+	{0, 0},			/* IB_CC_CONGESTION_INFO_LAST_F */
+
+	/*
+	 * CongestionKeyInfo fields
+	 */
+	{0, 64, "CC_Key", mad_dump_hex},
+	{BITSOFFS(64, 1), "CC_KeyProtectBit", mad_dump_uint},
+	{BITSOFFS(80, 16), "CC_KeyLeasePeriod", mad_dump_uint},
+	{BITSOFFS(96, 16), "CC_KeyViolations", mad_dump_uint},
+	{0, 0},			/* IB_CC_CONGESTION_KEY_INFO_LAST_F */
+
+	/*
+	 * CongestionLog (common) fields
+	 */
+	{BITSOFFS(0, 8), "LogType", mad_dump_uint},
+	{BITSOFFS(8, 8), "CongestionFlags", mad_dump_hex},
+	{0, 0},			/* IB_CC_CONGESTION_LOG_LAST_F */
+
+	/*
+	 * CongestionLog (Switch) fields
+	 */
+	{BITSOFFS(16, 16), "LogEventsCounter", mad_dump_uint},
+	{32, 32, "CurrentTimeStamp", mad_dump_uint},
+	{64, 256, "PortMap", mad_dump_array},
+	{0, 0},			/* IB_CC_CONGESTION_LOG_SWITCH_LAST_F */
+
+	/*
+	 * CongestionLogEvent (Switch) fields
+	 */
+	{BITSOFFS(0, 16), "SLID", mad_dump_uint},
+	{BITSOFFS(16, 16), "DLID", mad_dump_uint},
+	{BITSOFFS(32, 4), "SL", mad_dump_uint},
+	{64, 32, "Timestamp", mad_dump_uint},
+	{0, 0},			/* IB_CC_CONGESTION_LOG_ENTRY_SWITCH_LAST_F */
+
+	/*
+	 * CongestionLog (CA) fields
+	 */
+	{BITSOFFS(16, 16), "ThresholdEventCounter", mad_dump_uint},
+	{BITSOFFS(32, 16), "ThresholdCongestionEventMap", mad_dump_hex},
+	/* XXX: Q3/2010 errata lists offset 48, but that means field is not
+	 * world aligned.  Assume will be aligned to offset 64 later.
+	 */
+	{BITSOFFS(64, 32), "CurrentTimeStamp", mad_dump_uint},
+	{0, 0},			/* IB_CC_CONGESTION_LOG_CA_LAST_F */
+
+	/*
+	 * CongestionLogEvent (CA) fields
+	 */
+	{BITSOFFS(0, 24), "Local_QP_CN_Entry", mad_dump_uint},
+	{BITSOFFS(24, 4), "SL_CN_Entry", mad_dump_uint},
+	{BITSOFFS(28, 4), "Service_Type_CN_Entry", mad_dump_hex},
+	{BITSOFFS(32, 24), "Remote_QP_Number_CN_Entry", mad_dump_uint},
+	{BITSOFFS(64, 16), "Local_LID_CN", mad_dump_uint},
+	{BITSOFFS(80, 16), "Remote_LID_CN_Entry", mad_dump_uint},
+	{BITSOFFS(96, 32), "Timestamp_CN_Entry", mad_dump_uint},
+	{0, 0},			/* IB_CC_CONGESTION_LOG_ENTRY_CA_LAST_F */
+
+	/*
+	 * SwitchCongestionSetting fields
+	 */
+	{0, 32, "Control_Map", mad_dump_hex},
+	{32, 256, "Victim_Mask", mad_dump_array},
+	{288, 256, "Credit_Mask", mad_dump_array},
+	{BITSOFFS(544, 4), "Threshold", mad_dump_uint},
+	{BITSOFFS(552, 8), "Packet_Size", mad_dump_uint},
+	{BITSOFFS(560, 4), "CS_Threshold", mad_dump_uint},
+	{BITSOFFS(576, 16), "CS_ReturnDelay", mad_dump_hex}, /* TODO: CCT dump */
+	{BITSOFFS(592, 16), "Marking_Rate", mad_dump_uint},
+	{0, 0},			/* IB_CC_SWITCH_CONGESTION_SETTING_LAST_F */
+
+	/*
+	 * SwitchPortCongestionSettingElement fields
+	 */
+	{BITSOFFS(0, 1), "Valid", mad_dump_uint},
+	{BITSOFFS(1, 1), "Control_Type", mad_dump_uint},
+	{BITSOFFS(4, 4), "Threshold", mad_dump_hex},
+	{BITSOFFS(8, 8), "Packet_Size", mad_dump_uint},
+	{BITSOFFS(16, 16), "Cong_Parm_Marking_Rate", mad_dump_uint},
+	{0, 0},			/* IB_CC_SWITCH_PORT_CONGESTION_SETTING_ELEMENT_LAST_F */
+
+	/*
+	 * CACongestionSetting fields
+	 */
+	{BITSOFFS(0, 16), "Port_Control", mad_dump_hex},
+	{BITSOFFS(16, 16), "Control_Map", mad_dump_hex},
+	{0, 0},			/* IB_CC_CA_CONGESTION_SETTING_LAST_F */
+
+	/*
+	 * CACongestionEntry fields
+	 */
+	{BITSOFFS(0, 16), "CCTI_Timer", mad_dump_uint},
+	{BITSOFFS(16, 8), "CCTI_Increase", mad_dump_uint},
+	{BITSOFFS(24, 8), "Trigger_Threshold", mad_dump_uint},
+	{BITSOFFS(32, 8), "CCTI_Min", mad_dump_uint},
+	{0, 0},			/* IB_CC_CA_CONGESTION_SETTING_ENTRY_LAST_F */
+
+	/*
+	 * CongestionControlTable fields
+	 */
+	{BITSOFFS(0, 16), "CCTI_Limit", mad_dump_uint},
+	{0, 0},			/* IB_CC_CONGESTION_CONTROL_TABLE_LAST_F */
+
+	/*
+	 * CongestionControlTableEntry fields
+	 */
+	{BITSOFFS(0, 2), "CCT_Shift", mad_dump_uint},
+	{BITSOFFS(2, 14), "CCT_Multipler", mad_dump_uint},
+	{0, 0},			/* IB_CC_CONGESTION_CONTROL_TABLE_ENTRY_LAST_F */
+
+	/*
+	 * Timestamp fields
+	 */
+	{0, 32, "Timestamp", mad_dump_uint},
+
 	{0, 0}			/* IB_FIELD_LAST_ */
 
 };
diff --git a/src/libibmad.map b/src/libibmad.map
index 508c18b..56d0655 100644
--- a/src/libibmad.map
+++ b/src/libibmad.map
@@ -47,6 +47,20 @@ IBMAD_1.3 {
 		mad_dump_perfcounters_sl_rcv_becn;
 		mad_dump_perfcounters_xmit_con_ctrl;
 		mad_dump_perfcounters_vl_xmit_time_cong;
+		mad_dump_cc_congestioninfo;
+		mad_dump_cc_congestionkeyinfo;
+		mad_dump_cc_congestionlog;
+		mad_dump_cc_congestionlogswitch;
+		mad_dump_cc_congestionlogentryswitch;
+		mad_dump_cc_congestionlogca;
+		mad_dump_cc_congestionlogentryca;
+		mad_dump_cc_switchcongestionsetting;
+		mad_dump_cc_switchportcongestionsettingelement;
+		mad_dump_cc_cacongestionsetting;
+		mad_dump_cc_cacongestionentry;
+		mad_dump_cc_congestioncontroltable;
+		mad_dump_cc_congestioncontroltableentry;
+		mad_dump_cc_timestamp;
 		mad_dump_portstates;
 		mad_dump_portstate;
 		mad_dump_rhex;
@@ -129,5 +143,6 @@ IBMAD_1.3 {
 		mad_field_name;
 		bm_call_via;
 		mad_dump_port_ext_speeds_counters;
+		cc_query_status_via;
 	local: *;
 };
diff --git a/src/mad.c b/src/mad.c
index 463c61d..70a69dd 100644
--- a/src/mad.c
+++ b/src/mad.c
@@ -79,12 +79,16 @@ int mad_get_retries(const struct ibmad_port *srcport)
 void *mad_encode(void *buf, ib_rpc_t * rpc, ib_dr_path_t * drpath, void *data)
 {
 	int is_resp = rpc->method & IB_MAD_RESPONSE;
+	int mgtclass;
 
 	/* first word */
 	mad_set_field(buf, 0, IB_MAD_METHOD_F, rpc->method);
 	mad_set_field(buf, 0, IB_MAD_RESPONSE_F, is_resp ? 1 : 0);
-	mad_set_field(buf, 0, IB_MAD_CLASSVER_F,
-		      (rpc->mgtclass & 0xff) == IB_SA_CLASS ? 2 : 1);
+	mgtclass = rpc->mgtclass & 0xff;
+	if (mgtclass == IB_SA_CLASS || mgtclass == IB_CC_CLASS)
+		mad_set_field(buf, 0, IB_MAD_CLASSVER_F, 2);
+	else
+		mad_set_field(buf, 0, IB_MAD_CLASSVER_F, 1);
 	mad_set_field(buf, 0, IB_MAD_MGMTCLASS_F, rpc->mgtclass & 0xff);
 	mad_set_field(buf, 0, IB_MAD_BASEVER_F, 1);
 
@@ -134,6 +138,11 @@ void *mad_encode(void *buf, ib_rpc_t * rpc, ib_dr_path_t * drpath, void *data)
 	if ((rpc->mgtclass & 0xff) == IB_SA_CLASS)
 		mad_set_field64(buf, 0, IB_SA_COMPMASK_F, rpc->mask);
 
+	if ((rpc->mgtclass & 0xff) == IB_CC_CLASS) {
+		ib_rpc_cc_t *rpccc = (ib_rpc_cc_t *)rpc;
+		mad_set_field64(buf, 0, IB_CC_CCKEY_F, rpccc->cckey);
+	}
+
 	if (data)
 		memcpy((char *)buf + rpc->dataoffs, data, rpc->datasz);
 
-- 
1.7.1


--=-EW9u4/8DaArGa39hECr+
Content-Disposition: attachment; filename=0001-Support-ibccquery-congestion-control-query-tool.patch
Content-Type: message/rfc822; name=0001-Support-ibccquery-congestion-control-query-tool.patch

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Tue, 2 Aug 2011 11:15:07 -0700
Subject: [PATCH] Support ibccquery, congestion control query tool.
Message-Id: <1316469891.25283.725.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 Makefile.am     |    3 +-
 man/ibccquery.8 |   85 +++++++++++
 src/ibccquery.c |  427 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 514 insertions(+), 1 deletions(-)
 create mode 100644 man/ibccquery.8
 create mode 100644 src/ibccquery.c

diff --git a/Makefile.am b/Makefile.am
index 76bde30..4f284a7 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -14,7 +14,7 @@ sbin_PROGRAMS = src/ibaddr src/ibnetdiscover src/ibping src/ibportstate \
 	        src/ibroute src/ibstat src/ibsysstat src/ibtracert \
 	        src/perfquery src/sminfo src/smpdump src/smpquery \
 	        src/saquery src/vendstat src/iblinkinfo \
-		src/ibqueryerrors src/ibcacheedit
+		src/ibqueryerrors src/ibcacheedit src/ibccquery
 
 if ENABLE_TEST_UTILS
 sbin_PROGRAMS += src/ibsendtrap src/mcm_rereg_test
@@ -61,6 +61,7 @@ src_ibsendtrap_SOURCES = src/ibsendtrap.c
 src_vendstat_SOURCES = src/vendstat.c
 src_mcm_rereg_test_SOURCES = src/mcm_rereg_test.c
 src_iblinkinfo_SOURCES = src/iblinkinfo.c
+src_ibccquery_SOURCES = src/ibccquery.c
 src_iblinkinfo_LDFLAGS = -L$(top_builddir)/libibnetdisc -libnetdisc
 src_ibqueryerrors_SOURCES = src/ibqueryerrors.c
 src_ibqueryerrors_LDFLAGS = -L$(top_builddir)/libibnetdisc -libnetdisc
diff --git a/man/ibccquery.8 b/man/ibccquery.8
new file mode 100644
index 0000000..b0bed46
--- /dev/null
+++ b/man/ibccquery.8
@@ -0,0 +1,85 @@
+.TH CCQUERY 8 "Aug 10, 2011" "OpenIB" "OpenIB Diagnostics"
+
+.SH NAME
+ibccquery \- query congestion control settings/info
+
+.SH SYNOPSIS
+.B ibccquery
+[\-d(ebug)] [\-G(uid)] [\-C ca_name] [\-P ca_port] [\-t(imeout) timeout_ms]
+[\-V(ersion)] [\-h(elp)] [\-c cckey] <op> <lid|guid> [port]
+
+.SH DESCRIPTION
+.PP
+.Bibccquery support the querying of settings and other information related
+to congestion control.
+
+.SH OPTIONS
+
+.PP
+.TP
+Current supported operations and their parameters:
+  CongestionInfo (CI) <addr>
+  CongestionKeyInfo (CK) <addr>
+  CongestionLog (CL) <addr>
+  SwitchCongestionSetting (SS) <addr>
+  SwitchPortCongestionSetting (SP) <addr> [<portnum>]
+  CACongestionSetting (CS) <addr>
+  CongestionControlTable (CT) <addr>
+  Timestamp (TI) <addr>
+
+.TP
+\fB\-c\-fR, \fB\-\-cckey\fR <cckey>
+Specify a congestion control (CC) key.  If none is specified, a key of 0 is used.
+
+.SH COMMON OPTIONS
+
+Most OpenIB diagnostics take the following common flags. The exact list of
+supported flags per utility can be found in the usage message and can be shown
+using the util_name -h syntax.
+
+# Debugging flags
+.PP
+\-d      raise the IB debugging level.
+        May be used several times (-ddd or -d -d -d).
+.PP
+\-e      show send and receive errors (timeouts and others)
+.PP
+\-h      show the usage message
+.PP
+\-v      increase the application verbosity level.
+        May be used several times (-vv or -v -v -v)
+.PP
+\-V      show the version info.
+
+# Addressing flags
+.PP
+\-G      use GUID address argument. In most cases, it is the Port GUID.
+        Example:
+        "0x08f1040023"
+.PP
+\-s <smlid>      use 'smlid' as the target lid for SM/SA queries.
+
+# Other common flags:
+.PP
+\-C <ca_name>    use the specified ca_name.
+.PP
+\-P <ca_port>    use the specified ca_port.
+.PP
+\-t <timeout_ms> override the default timeout for the solicited mads.
+
+If a port and/or CA name is specified, the user request is
+attempted to be fulfilled, and will fail if it is not possible.
+
+.SH EXAMPLES
+
+.PP
+ibccquery CongestionInfo 3		# Congestion Info by lid
+.PP
+ibccquery SwitchPortCongestionSetting 3	# Query all Switch Port Congestion Settings
+.PP
+ibccquery SwitchPortCongestionSetting 3 1 # Query Switch Port Congestion Setting for port 1
+
+.SH AUTHOR
+.TP
+Albert Chu
+.RI < chu11-i2BcT+NCU+M@public.gmane.org >
diff --git a/src/ibccquery.c b/src/ibccquery.c
new file mode 100644
index 0000000..a7fd79f
--- /dev/null
+++ b/src/ibccquery.c
@@ -0,0 +1,427 @@
+/*
+ * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
+ * Copyright (c) 2011 Mellanox Technologies LTD.  All rights reserved.
+ * Copyright (c) 2011 Lawrence Livermore National Lab.  All rights reserved.
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
+#  include <config.h>
+#endif				/* HAVE_CONFIG_H */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include <getopt.h>
+#include <netinet/in.h>
+
+#define __STDC_FORMAT_MACROS
+#include <inttypes.h>
+
+#include <infiniband/mad.h>
+
+#include "ibdiag_common.h"
+
+struct ibmad_port *srcport;
+
+typedef char *(op_fn_t) (ib_portid_t * dest, char **argv, int argc);
+
+typedef struct match_rec {
+	const char *name, *alias;
+	op_fn_t *fn;
+	unsigned opt_portnum;
+} match_rec_t;
+
+static op_fn_t class_port_info;
+static op_fn_t congestion_info;
+static op_fn_t congestion_key_info;
+static op_fn_t congestion_log;
+static op_fn_t switch_congestion_setting;
+static op_fn_t switch_port_congestion_setting;
+static op_fn_t ca_congestion_setting;
+static op_fn_t congestion_control_table;
+static op_fn_t timestamp_dump;
+
+static const match_rec_t match_tbl[] = {
+	{"ClassPortInfo", "CP", class_port_info, 0},
+	{"CongestionInfo", "CI", congestion_info, 0},
+	{"CongestionKeyInfo", "CK", congestion_key_info, 0},
+	{"CongestionLog", "CL", congestion_log, 0},
+	{"SwitchCongestionSetting", "SS", switch_congestion_setting, 0},
+	{"SwitchPortCongestionSetting", "SP", switch_port_congestion_setting, 1},
+	{"CACongestionSetting", "CS", ca_congestion_setting, 0},
+	{"CongestionControlTable", "CT", congestion_control_table, 0},
+	{"Timestamp", "TI", timestamp_dump, 0},
+	{0}
+};
+
+uint64_t cckey = 0;
+
+/*******************************************/
+static char *class_port_info(ib_portid_t * dest, char **argv, int argc)
+{
+	char buf[2048];
+	char data[IB_CC_DATA_SZ] = { 0 };
+
+	if (!cc_query_status_via(data, dest, CLASS_PORT_INFO,
+				 0, 0, NULL, srcport, cckey))
+		return "class port info query failed";
+
+	mad_dump_classportinfo(buf, sizeof buf, data, sizeof data);
+
+	printf("# ClassPortInfo: %s\n%s", portid2str(dest), buf);
+	return NULL;
+}
+
+static char *congestion_info(ib_portid_t * dest, char **argv, int argc)
+{
+	char buf[2048];
+	char data[IB_CC_DATA_SZ] = { 0 };
+
+	if (!cc_query_status_via(data, dest, IB_CC_ATTR_CONGESTION_INFO,
+				 0, 0, NULL, srcport, cckey))
+		return "congestion info query failed";
+
+	mad_dump_cc_congestioninfo(buf, sizeof buf, data, sizeof data);
+
+	printf("# CongestionInfo: %s\n%s", portid2str(dest), buf);
+	return NULL;
+}
+
+static char *congestion_key_info(ib_portid_t * dest, char **argv, int argc)
+{
+	char buf[2048];
+	char data[IB_CC_DATA_SZ] = { 0 };
+	
+	if (!cc_query_status_via(data, dest, IB_CC_ATTR_CONGESTION_KEY_INFO,
+				 0, 0, NULL, srcport, cckey))
+		return "congestion key info query failed";
+
+	mad_dump_cc_congestionkeyinfo(buf, sizeof buf, data, sizeof data);
+
+	printf("# CongestionKeyInfo: %s\n%s", portid2str(dest), buf);
+	return NULL;
+}
+
+static char *congestion_log(ib_portid_t * dest, char **argv, int argc)
+{
+	char buf[2048];
+	char data[IB_CC_LOG_DATA_SZ] = { 0 };
+	char emptybuf[16] = { 0 };
+	int i, type;
+
+	if (!cc_query_status_via(data, dest, IB_CC_ATTR_CONGESTION_LOG,
+				 0, 0, NULL, srcport, cckey))
+		return "congestion log query failed";
+
+	mad_decode_field((uint8_t *)data, IB_CC_CONGESTION_LOG_LOGTYPE_F, &type);
+
+	if (type != 1 && type != 2)
+		return "unrecognized log type";
+
+	mad_dump_cc_congestionlog(buf, sizeof buf, data, sizeof data);
+
+	printf("# CongestionLog: %s\n%s", portid2str(dest), buf);
+
+	if (type == 1) {
+		mad_dump_cc_congestionlogswitch(buf, sizeof buf, data, sizeof data);
+		printf("%s\n", buf);
+		for (i = 0; i < 15; i++) {
+			/* output only if entry not 0 */
+			if (memcmp(data + 40 + i * 12, emptybuf, 12)) {
+				mad_dump_cc_congestionlogentryswitch(buf, sizeof buf,
+								     data + 40 + i * 12,
+								     12);
+				printf("%s\n", buf);
+			}
+		}
+	}
+	else {
+		/* XXX: Q3/2010 errata lists first entry offset at 80, but we assume
+		 * will be updated to 96 once CurrentTimeStamp field is word aligned.
+		 * In addition, assume max 13 log events instead of 16.  Due to 
+		 * errata changes increasing size of CA log event, 16 log events is
+		 * no longer possible to fit in max MAD size.
+		 */
+		mad_dump_cc_congestionlogca(buf, sizeof buf, data, sizeof data);
+		printf("%s\n", buf);
+		for (i = 0; i < 13; i++) {
+			/* output only if entry not 0 */
+			if (memcmp(data + 12 + i * 16, emptybuf, 16)) {
+				mad_dump_cc_congestionlogentryca(buf, sizeof buf,
+								 data + 12 + i * 16,
+								 16);
+				printf("%s\n", buf);
+			}
+		}
+	}
+
+	return NULL;
+}
+
+static char *switch_congestion_setting(ib_portid_t * dest, char **argv, int argc)
+{
+	char buf[2048];
+	char data[IB_CC_DATA_SZ] = { 0 };
+	
+	if (!cc_query_status_via(data, dest, IB_CC_ATTR_SWITCH_CONGESTION_SETTING,
+				 0, 0, NULL, srcport, cckey))
+		return "switch congestion setting query failed";
+
+	mad_dump_cc_switchcongestionsetting(buf, sizeof buf, data, sizeof data);
+
+	printf("# SwitchCongestionSetting: %s\n%s", portid2str(dest), buf);
+	return NULL;
+}
+
+static char *switch_port_congestion_setting(ib_portid_t * dest, char **argv, int argc)
+{
+	char buf[2048];
+	char data[IB_CC_DATA_SZ] = { 0 };
+	int type, numports, maxblocks, i, j;
+	int portnum = 0;
+	int outputcount = 0;
+
+	if (argc > 0)
+		portnum = strtol(argv[0], 0, 0);
+
+	/* Figure out number of ports first */
+	if (!smp_query_via(data, dest, IB_ATTR_NODE_INFO, 0, 0, srcport))
+		return "node info query failed";
+
+	mad_decode_field((uint8_t *)data, IB_NODE_TYPE_F, &type);
+	mad_decode_field((uint8_t *)data, IB_NODE_NPORTS_F, &numports);
+
+	if (type != IB_NODE_SWITCH)
+		return "destination not a switch";
+
+	printf("# SwitchPortCongestionSetting: %s\n", portid2str(dest));
+
+	if (portnum) {
+		if (portnum > numports)
+			return "invalid port number specified";
+
+		memset(data, '\0', sizeof data);
+		if (!cc_query_status_via(data, dest, IB_CC_ATTR_SWITCH_PORT_CONGESTION_SETTING,
+					 (portnum - 1) / 32, 0, NULL, srcport, cckey))
+			return "switch congestion setting query failed";
+
+		mad_dump_cc_switchportcongestionsettingelement(buf, sizeof buf,
+							       data + (((portnum % 32) - 1) * 4),
+							       4);
+		printf("%s", buf);
+		return NULL;
+	}
+
+	/* else get all port info */
+
+	maxblocks = ((numports - 1) / 32) + 1;
+
+	for (i = 0; i < maxblocks; i++) {
+		memset(data, '\0', sizeof data);
+		if (!cc_query_status_via(data, dest, IB_CC_ATTR_SWITCH_PORT_CONGESTION_SETTING,
+					 i, 0, NULL, srcport, cckey))
+			return "switch congestion setting query failed";
+
+		for (j = 0; j < 32 && outputcount < numports; j++) {
+			printf("Port:............................%u\n", i * 32 + j + 1);
+			mad_dump_cc_switchportcongestionsettingelement(buf, sizeof buf,
+								       data + j * 4,
+								       4);
+			printf("%s\n", buf);
+			outputcount++;
+		}
+	}
+
+	return NULL;
+}
+
+static char *ca_congestion_setting(ib_portid_t * dest, char **argv, int argc)
+{
+	char buf[2048];
+	char data[IB_CC_DATA_SZ] = { 0 };
+	int i;
+	
+	if (!cc_query_status_via(data, dest, IB_CC_ATTR_CA_CONGESTION_SETTING,
+				 0, 0, NULL, srcport, cckey))
+		return "ca congestion setting query failed";
+
+	mad_dump_cc_cacongestionsetting(buf, sizeof buf, data, sizeof data);
+
+	printf("# CACongestionSetting: %s\n%s\n", portid2str(dest), buf);
+
+	for (i = 0; i < 16; i++) {
+		printf("SL:..............................%u\n", i);
+		mad_dump_cc_cacongestionentry(buf, sizeof buf,
+					      data + 4 + i * 8,
+					      8);
+		printf("%s\n", buf);
+	}
+	return NULL;
+}
+
+static char *congestion_control_table(ib_portid_t * dest, char **argv, int argc)
+{
+	char buf[2048];
+	char data[IB_CC_DATA_SZ] = { 0 };
+	int limit, outputcount = 0;
+	int i, j;
+	
+	if (!cc_query_status_via(data, dest, IB_CC_ATTR_CONGESTION_CONTROL_TABLE,
+				 0, 0, NULL, srcport, cckey))
+		return "congestion control table query failed";
+
+	mad_decode_field((uint8_t *)data, IB_CC_CONGESTION_CONTROL_TABLE_FIRST_F, &limit);
+
+	mad_dump_cc_congestioncontroltable(buf, sizeof buf, data, sizeof data);
+
+	printf("# CongestionControlTable: %s\n%s\n", portid2str(dest), buf);
+
+	if (!limit)
+		return NULL;
+
+	for (i = 0; i < ((limit - 1)/64) + 1; i++) {
+
+		/* first query done */
+		if (i)
+			if (!cc_query_status_via(data, dest, IB_CC_ATTR_CONGESTION_CONTROL_TABLE,
+					  i, 0, NULL, srcport, cckey))
+				return "congestion control table query failed";
+
+		for (j = 0; j < 64 && outputcount < limit; j++) {
+			printf("Entry:...........................%u\n", i*64 + j);
+			mad_dump_cc_congestioncontroltableentry(buf, sizeof buf,
+								data + 4 + j * 2,
+								sizeof data - 4 - j * 2);
+			printf("%s\n", buf);
+			outputcount++;
+		}
+	}
+	return NULL;
+}
+
+static char *timestamp_dump(ib_portid_t * dest, char **argv, int argc)
+{
+	char buf[2048];
+	char data[IB_CC_DATA_SZ] = { 0 };
+
+	if (!cc_query_status_via(data, dest, IB_CC_ATTR_TIMESTAMP,
+				 0, 0, NULL, srcport, cckey))
+		return "timestamp query failed";
+
+	mad_dump_cc_timestamp(buf, sizeof buf, data, sizeof data);
+
+	printf("# Timestamp: %s\n%s", portid2str(dest), buf);
+	return NULL;
+}
+
+static op_fn_t *match_op(char *name)
+{
+	const match_rec_t *r;
+	unsigned len = strlen(name);
+	for (r = match_tbl; r->name; r++)
+		if (!strncasecmp(r->name, name, len) ||
+		    (r->alias && !strncasecmp(r->alias, name, len)))
+			return r->fn;
+	return NULL;
+}
+
+static int process_opt(void *context, int ch, char *optarg)
+{
+	switch (ch) {
+	case 'c':
+		cckey = (uint64_t) strtoull(optarg, 0, 0);
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	char usage_args[1024];
+	int mgmt_classes[4] =
+	    { IB_SMI_CLASS, IB_SMI_DIRECT_CLASS, IB_SA_CLASS, IB_CC_CLASS };
+	ib_portid_t portid = { 0 };
+	char *err;
+	op_fn_t *fn;
+	const match_rec_t *r;
+	int n;
+
+	const struct ibdiag_opt opts[] = {
+		{"cckey", 'c', 1, "<key>", "CC key"},
+		{0}
+	};
+	const char *usage_examples[] = {
+		"CongestionInfo 3\t\t\t# Congestion Info by lid",
+		"SwitchPortCongestionSetting 3\t# Query all Switch Port Congestion Settings",
+		"SwitchPortCongestionSetting 3 1\t# Query Switch Port Congestion Setting for port 1",
+		NULL
+	};
+
+	n = sprintf(usage_args, "[-c key] <op> <lid|guid>\n"
+		    "\nSupported ops (and aliases, case insensitive):\n");
+	for (r = match_tbl; r->name; r++) {
+		n += snprintf(usage_args + n, sizeof(usage_args) - n,
+			      "  %s (%s) <lid|guid>%s\n", r->name,
+			      r->alias ? r->alias : "",
+			      r->opt_portnum ? " [<portnum>]" : "");
+		if (n >= sizeof(usage_args))
+			exit(-1);
+	}
+
+	ibdiag_process_opts(argc, argv, NULL, "D", opts, process_opt,
+			    usage_args, usage_examples);
+
+	argc -= optind;
+	argv += optind;
+
+	if (argc < 2)
+		ibdiag_show_usage();
+
+	if (!(fn = match_op(argv[0])))
+		IBERROR("operation '%s' not supported", argv[0]);
+
+	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 4);
+	if (!srcport)
+		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
+
+	if (ib_resolve_portid_str_via(&portid, argv[1], ibd_dest_type,
+				      ibd_sm_id, srcport) < 0)
+		IBERROR("can't resolve destination %s", argv[1]);
+	if ((err = fn(&portid, argv + 2, argc - 2)))
+		IBERROR("operation %s: %s", argv[0], err);
+
+	mad_rpc_close_port(srcport);
+	exit(0);
+}
-- 
1.7.1


--=-EW9u4/8DaArGa39hECr+
Content-Disposition: attachment; filename=0002-Support-classportinfo-dump-function.patch
Content-Type: message/rfc822; name=0002-Support-classportinfo-dump-function.patch

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Wed, 7 Sep 2011 11:02:52 -0700
Subject: [PATCH 2/2] Support classportinfo dump function
Message-Id: <1316469891.25283.726.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 include/infiniband/mad.h |    3 ++-
 src/dump.c               |    6 ++++++
 src/libibmad.map         |    1 +
 3 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/include/infiniband/mad.h b/include/infiniband/mad.h
index 1811e3a..199b05f 100644
--- a/include/infiniband/mad.h
+++ b/include/infiniband/mad.h
@@ -1559,7 +1559,8 @@ MAD_EXPORT ib_mad_dump_fn
     mad_dump_cc_congestionlogentryca, mad_dump_cc_switchcongestionsetting,
     mad_dump_cc_switchportcongestionsettingelement, mad_dump_cc_cacongestionsetting,
     mad_dump_cc_cacongestionentry, mad_dump_cc_congestioncontroltable,
-    mad_dump_cc_congestioncontroltableentry, mad_dump_cc_timestamp;
+    mad_dump_cc_congestioncontroltableentry, mad_dump_cc_timestamp,
+    mad_dump_classportinfo;
 
 MAD_EXPORT void mad_dump_fields(char *buf, int bufsz, void *val, int valsz,
 				int start, int end);
diff --git a/src/dump.c b/src/dump.c
index 309865b..d4512c0 100644
--- a/src/dump.c
+++ b/src/dump.c
@@ -1053,6 +1053,12 @@ void mad_dump_cc_timestamp(char *buf, int bufsz, void *val, int valsz)
 		     IB_CC_TIMESTAMP_LAST_F);
 }
 
+void mad_dump_classportinfo(char *buf, int bufsz, void *val, int valsz)
+{
+	/* no FIRST_F and LAST_F for CPI field enums, must do a hack */
+	_dump_fields(buf, bufsz, val, IB_CPI_BASEVER_F, IB_CPI_TRAP_QKEY_F + 1);
+}
+
 void xdump(FILE * file, char *msg, void *p, int size)
 {
 #define HEX(x)  ((x) < 10 ? '0' + (x) : 'a' + ((x) -10))
diff --git a/src/libibmad.map b/src/libibmad.map
index 56d0655..a64288d 100644
--- a/src/libibmad.map
+++ b/src/libibmad.map
@@ -61,6 +61,7 @@ IBMAD_1.3 {
 		mad_dump_cc_congestioncontroltable;
 		mad_dump_cc_congestioncontroltableentry;
 		mad_dump_cc_timestamp;
+		mad_dump_classportinfo;
 		mad_dump_portstates;
 		mad_dump_portstate;
 		mad_dump_rhex;
-- 
1.7.1


--=-EW9u4/8DaArGa39hECr+--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
