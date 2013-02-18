From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] libibumad: add string functions for various defines
Date: Mon, 18 Feb 2013 15:36:38 -0800
Message-ID: <20130218153638.2b452d138f0918b945bcdb71@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


This patch adds "enum to string" conversions of the enums in the headers
files submitted by Sean Hefty on 1/28/2013

Some of this code was originally proposed by Sean in 2010 as part of user space
madeye: http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg06185.html

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 Makefile.am                     |   13 ++-
 include/infiniband/umad_sm.h    |   31 ++--
 include/infiniband/umad_str.h   |  333 +++++++++++++++++++++++++++++++++++++++
 include/infiniband/umad_types.h |    4 +-
 man/umad_attribute_str.3        |    3 +
 man/umad_class_str.3            |   49 ++++++
 man/umad_cm_attr_str.3          |    3 +
 man/umad_mad_status_str.3       |    3 +
 man/umad_method_str.3           |    3 +
 man/umad_sa_attr_str.3          |    3 +
 man/umad_sm_attr_str.3          |    3 +
 11 files changed, 430 insertions(+), 18 deletions(-)
 create mode 100644 include/infiniband/umad_str.h
 create mode 100644 man/umad_attribute_str.3
 create mode 100644 man/umad_class_str.3
 create mode 100644 man/umad_cm_attr_str.3
 create mode 100644 man/umad_mad_status_str.3
 create mode 100644 man/umad_method_str.3
 create mode 100644 man/umad_sa_attr_str.3
 create mode 100644 man/umad_sm_attr_str.3

diff --git a/Makefile.am b/Makefile.am
index 14e2389..1855628 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -15,7 +15,15 @@ man_MANS = man/umad_debug.3 man/umad_get_ca.3 \
 	   man/umad_get_pkey.3 \
 	   man/umad_register.3 man/umad_register_oui.3 man/umad_unregister.3 \
 	   man/umad_send.3 man/umad_recv.3 man/umad_poll.3 \
-	   man/umad_get_issm_path.3
+	   man/umad_get_issm_path.3 \
+	   man/umad_attribute_str.3 \
+	   man/umad_class_str.3 \
+	   man/umad_cm_attr_str.3 \
+	   man/umad_mad_status_str.3 \
+	   man/umad_method_str.3 \
+	   man/umad_sa_attr_str.3 \
+	   man/umad_sm_attr_str.3
+
 
 lib_LTLIBRARIES = libibumad.la
 
@@ -38,7 +46,8 @@ libibumadinclude_HEADERS = $(srcdir)/include/infiniband/umad.h \
 	$(srcdir)/include/infiniband/umad_types.h \
 	$(srcdir)/include/infiniband/umad_sa.h \
 	$(srcdir)/include/infiniband/umad_sm.h \
-	$(srcdir)/include/infiniband/umad_cm.h
+	$(srcdir)/include/infiniband/umad_cm.h \
+	$(srcdir)/include/infiniband/umad_str.h
 
 EXTRA_DIST = $(srcdir)/include/infiniband/umad.h \
 	libibumad.spec.in libibumad.spec \
diff --git a/include/infiniband/umad_sm.h b/include/infiniband/umad_sm.h
index 10348d4..f6ee171 100755
--- a/include/infiniband/umad_sm.h
+++ b/include/infiniband/umad_sm.h
@@ -55,21 +55,22 @@ enum {
 
 /* Subnet management attributes */
 enum {
-	UMAD_SMP_ATTR_NODE_DESC		= 0x0010,
-	UMAD_SMP_ATTR_NODE_INFO		= 0x0011,
-	UMAD_SMP_ATTR_SWITCH_INFO	= 0x0012,
-	UMAD_SMP_ATTR_GUID_INFO		= 0x0014,
-	UMAD_SMP_ATTR_PORT_INFO		= 0x0015,
-	UMAD_SMP_ATTR_PKEY_TABLE	= 0x0016,
-	UMAD_SMP_ATTR_SLVL_TABLE	= 0x0017,
-	UMAD_SMP_ATTR_VL_ARB_TABLE	= 0x0018,
-	UMAD_SMP_ATTR_LINEAR_FT		= 0x0019,
-	UMAD_SMP_ATTR_RANDOM_FT		= 0x001A,
-	UMAD_SMP_ATTR_MCAST_FT		= 0x001B,
-	UMAD_SMP_ATTR_SM_INFO		= 0x0020,
-	UMAD_SMP_ATTR_VENDOR_DIAG	= 0x0030,
-	UMAD_SMP_ATTR_LED_INFO		= 0x0031,
-	UMAD_SMP_ATTR_VENDOR_MASK	= 0xFF00
+	UMAD_SMP_ATTR_NODE_DESC			= 0x0010,
+	UMAD_SMP_ATTR_NODE_INFO			= 0x0011,
+	UMAD_SMP_ATTR_SWITCH_INFO		= 0x0012,
+	UMAD_SMP_ATTR_GUID_INFO			= 0x0014,
+	UMAD_SMP_ATTR_PORT_INFO			= 0x0015,
+	UMAD_SMP_ATTR_PKEY_TABLE		= 0x0016,
+	UMAD_SMP_ATTR_SLVL_TABLE		= 0x0017,
+	UMAD_SMP_ATTR_VL_ARB_TABLE		= 0x0018,
+	UMAD_SMP_ATTR_LINEAR_FT			= 0x0019,
+	UMAD_SMP_ATTR_RANDOM_FT			= 0x001A,
+	UMAD_SMP_ATTR_MCAST_FT			= 0x001B,
+	UMAD_SMP_ATTR_LINK_SPD_WIDTH_TABLE	= 0x001C,
+	UMAD_SMP_ATTR_SM_INFO			= 0x0020,
+	UMAD_SMP_ATTR_VENDOR_DIAG		= 0x0030,
+	UMAD_SMP_ATTR_LED_INFO			= 0x0031,
+	UMAD_SMP_ATTR_VENDOR_MASK		= 0xFF00
 };
 
 enum {
diff --git a/include/infiniband/umad_str.h b/include/infiniband/umad_str.h
new file mode 100644
index 0000000..c44e2d0
--- /dev/null
+++ b/include/infiniband/umad_str.h
@@ -0,0 +1,333 @@
+/*
+ * Copyright (c) 2004, 2005, 2010 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2013 Lawrence Livermore National Security. All rights reserved.
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
+#ifndef _UMAD_STR_H
+#define _UMAD_STR_H
+
+#include <arpa/inet.h>
+#include <infiniband/umad.h>
+#include <infiniband/umad_types.h>
+#include <infiniband/umad_sm.h>
+#include <infiniband/umad_sa.h>
+#include <infiniband/umad_cm.h>
+
+#ifdef __cplusplus
+#  define BEGIN_C_DECLS extern "C" {
+#  define END_C_DECLS   }
+#else				/* !__cplusplus */
+#  define BEGIN_C_DECLS
+#  define END_C_DECLS
+#endif				/* __cplusplus */
+
+BEGIN_C_DECLS
+
+static inline char * umad_class_str(uint8_t mgmt_class)
+{
+	switch (mgmt_class) {
+		case UMAD_CLASS_SUBN_LID_ROUTED:
+		case UMAD_CLASS_SUBN_DIRECTED_ROUTE:
+			return("Subn");
+		case UMAD_CLASS_SUBN_ADM:
+			return("SubnAdm");
+		case UMAD_CLASS_PERF_MGMT:
+			return("Perf");
+		case UMAD_CLASS_BM:
+			return("BM");
+		case UMAD_CLASS_DEVICE_MGMT:
+			return("DevMgt");
+		case UMAD_CLASS_CM:
+			return("ComMgt");
+		case UMAD_CLASS_SNMP:
+			return("SNMP");
+		case UMAD_CLASS_DEVICE_ADM:
+			return("DevAdm");
+		case UMAD_CLASS_BOOT_MGMT:
+			return("BootMgt");
+		case UMAD_CLASS_BIS:
+			return("BIS");
+		case UMAD_CLASS_CONG_MGMT:
+			return("CongestionManagment");
+		default:
+			break;
+	}
+
+	if ((UMAD_CLASS_VENDOR_RANGE1_START <= mgmt_class
+		&& mgmt_class <= UMAD_CLASS_VENDOR_RANGE1_END)
+	    || (UMAD_CLASS_VENDOR_RANGE2_START <= mgmt_class
+		&& mgmt_class <= UMAD_CLASS_VENDOR_RANGE2_END))
+		return("Vendor");
+
+	if (UMAD_CLASS_APPLICATION_START <= mgmt_class
+	    && mgmt_class <= UMAD_CLASS_APPLICATION_END) {
+		return("Application");
+	}
+	return ("<unknown>");
+}
+
+static inline char * umad_method_str(uint8_t method)
+{
+	switch(method) {
+		case UMAD_METHOD_GET:
+			return ("Get");
+		case UMAD_METHOD_SET:
+			return ("Set");
+		case UMAD_METHOD_GET_RESP:
+			return ("GetResp");
+		case UMAD_METHOD_SEND:
+			return ("Send");
+		case UMAD_METHOD_TRAP:
+			return ("Trap");
+		case UMAD_METHOD_REPORT:
+			return ("Report");
+		case UMAD_METHOD_REPORT_RESP:
+			return ("ReportResp");
+		case UMAD_METHOD_TRAP_REPRESS:
+			return ("TrapRepress");
+		case UMAD_METHOD_RESP:
+			return ("Resp");
+		case UMAD_SA_METHOD_GET_TABLE:
+			return ("GetTable");
+		case UMAD_SA_METHOD_GET_TABLE_RESP:
+			return ("GetTableResp");
+		case UMAD_SA_METHOD_DELETE:
+			return ("Delete");
+		case UMAD_SA_METHOD_DELETE_RESP:
+			return ("DeleteResp");
+		case UMAD_SA_METHOD_GET_MULTI:
+			return ("GetMulti");
+		case UMAD_SA_METHOD_GET_MULTI_RESP:
+			return ("GetMultiResp");
+		case UMAD_SA_METHOD_GET_TRACE_TABLE:
+			return ("GetTraceTable");
+	}
+	return ("<unknown>");
+}
+
+#define UMAD_GENERIC_ATTRIBUTE_STR \
+		case UMAD_ATTR_CLASS_PORT_INFO: \
+			return "Class Port Info"; \
+		case UMAD_ATTR_NOTICE: \
+			return "Notice"; \
+		case UMAD_ATTR_INFORM_INFO: \
+			return "Inform Info"
+
+static inline char * umad_sm_attr_str(be16_t attr_id)
+{
+	switch(ntohs(attr_id)) {
+
+		UMAD_GENERIC_ATTRIBUTE_STR;
+
+		case UMAD_SMP_ATTR_NODE_DESC:
+			return ("NodeDescription");
+		case UMAD_SMP_ATTR_NODE_INFO:
+			return ("NodeInfo");
+		case UMAD_SMP_ATTR_SWITCH_INFO:
+			return ("SwitchInfo");
+		case UMAD_SMP_ATTR_GUID_INFO:
+			return ("GUIDInfo");
+		case UMAD_SMP_ATTR_PORT_INFO:
+			return ("PortInfo");
+		case UMAD_SMP_ATTR_PKEY_TABLE:
+			return ("P_KeyTable");
+		case UMAD_SMP_ATTR_SLVL_TABLE:
+			return ("SLtoVLMappingTable");
+		case UMAD_SMP_ATTR_VL_ARB_TABLE:
+			return ("VLArbitrationTable");
+		case UMAD_SMP_ATTR_LINEAR_FT:
+			return ("LinearForwardingTable");
+		case UMAD_SMP_ATTR_RANDOM_FT:
+			return ("RandomForwardingTable");
+		case UMAD_SMP_ATTR_MCAST_FT:
+			return ("MulticastForwardingTable");
+		case UMAD_SMP_ATTR_SM_INFO:
+			return ("SMInfo");
+		case UMAD_SMP_ATTR_VENDOR_DIAG:
+			return ("VendorDiag");
+		case UMAD_SMP_ATTR_LED_INFO:
+			return ("LedInfo");
+		case UMAD_SMP_ATTR_LINK_SPD_WIDTH_TABLE:
+			return ("LinkSpeedWidthPairsTable");
+	}
+	return ("<unknown>");
+}
+
+static inline char * umad_sa_attr_str(be16_t attr_id)
+{
+	switch(ntohs(attr_id)) {
+
+		UMAD_GENERIC_ATTRIBUTE_STR;
+
+		case UMAD_SA_ATTR_NODE_REC:
+			return ("NodeRecord");
+		case UMAD_SA_ATTR_PORT_INFO_REC:
+			return ("PortInfoRecord");
+		case UMAD_SA_ATTR_SLVL_REC:
+			return ("SLtoVLMappingTableRecord");
+		case UMAD_SA_ATTR_SWITCH_INFO_REC:
+			return ("SwitchInfoRecord");
+		case UMAD_SA_ATTR_LINEAR_FT_REC:
+			return ("LinearForwardingTableRecord");
+		case UMAD_SA_ATTR_RANDOM_FT_REC:
+			return ("RandomForwardingTableRecord");
+		case UMAD_SA_ATTR_MCAST_FT_REC:
+			return ("MulticastForwardingTableRecord");
+		case UMAD_SA_ATTR_SM_INFO_REC:
+			return ("SMInfoRecord");
+		case UMAD_SA_ATTR_INFORM_INFO_REC:
+			return ("InformInfoRecord");
+		case UMAD_SA_ATTR_LINK_REC:
+			return ("LinkRecord");
+		case UMAD_SA_ATTR_GUID_INFO_REC:
+			return ("GuidInfoRecord");
+		case UMAD_SA_ATTR_SERVICE_REC:
+			return ("ServiceRecord");
+		case UMAD_SA_ATTR_PKEY_TABLE_REC:
+			return ("P_KeyTableRecord");
+		case UMAD_SA_ATTR_PATH_REC:
+			return ("PathRecord");
+		case UMAD_SA_ATTR_VL_ARB_REC:
+			return ("VLArbitrationTableRecord");
+		case UMAD_SA_ATTR_MCMEMBER_REC:
+			return ("MCMemberRecord");
+		case UMAD_SA_ATTR_TRACE_REC:
+			return ("TraceRecord");
+		case UMAD_SA_ATTR_MULTI_PATH_REC:
+			return ("MultiPathRecord");
+		case UMAD_SA_ATTR_SERVICE_ASSOC_REC:
+			return ("ServiceAssociationRecord");
+	}
+	return ("<unknown>");
+}
+
+static inline char * umad_cm_attr_str(be16_t attr_id)
+{
+	switch(ntohs(attr_id)) {
+
+		UMAD_GENERIC_ATTRIBUTE_STR;
+
+		case UMAD_CM_ATTR_REQ:
+			return "ConnectRequest";
+		case UMAD_CM_ATTR_MRA:
+			return "MsgRcptAck";
+		case UMAD_CM_ATTR_REJ:
+			return "ConnectReject";
+		case UMAD_CM_ATTR_REP:
+			return "ConnectReply";
+		case UMAD_CM_ATTR_RTU:
+			return "ReadyToUse";
+		case UMAD_CM_ATTR_DREQ:
+			return "DisconnectRequest";
+		case UMAD_CM_ATTR_DREP:
+			return "DisconnectReply";
+		case UMAD_CM_ATTR_SIDR_REQ:
+			return "ServiceIDResReq";
+		case UMAD_CM_ATTR_SIDR_REP:
+			return "ServiceIDResReqResp";
+		case UMAD_CM_ATTR_LAP:
+			return "LoadAlternatePath";
+		case UMAD_CM_ATTR_APR:
+			return "AlternatePathResponse";
+	}
+	return ("<unknown>");
+}
+
+static inline char * umad_attribute_str(uint8_t mgmt_class, be16_t attr_id)
+{
+	switch (mgmt_class) {
+		case UMAD_CLASS_SUBN_LID_ROUTED:
+		case UMAD_CLASS_SUBN_DIRECTED_ROUTE:
+			return(umad_sm_attr_str(attr_id));
+		case UMAD_CLASS_SUBN_ADM:
+			return(umad_sa_attr_str(attr_id));
+		case UMAD_CLASS_CM:
+			return(umad_cm_attr_str(attr_id));
+	}
+
+	switch(ntohs(attr_id)) {
+		UMAD_GENERIC_ATTRIBUTE_STR;
+	}
+
+	return ("<unknown>");
+}
+
+static inline char * umad_mad_status_str(be16_t status, char * buf, size_t len)
+{
+	size_t n = len;
+	int rc = 0;
+
+	status = ntohs(status);
+
+	if (status & 0x0001) {
+		rc = snprintf(buf, n, "busy");
+		if (rc < 0 || rc >= n)
+			goto done;
+		n -= rc;
+		buf += rc;
+	}
+
+	if (status & 0x0002) {
+		rc = snprintf(buf, n, " redirection required");
+		if (rc < 0 || rc >= n)
+			goto done;
+		n -= rc;
+		buf += rc;
+	}
+
+	switch((status & 0x001C) >> 2) {
+	case 1:
+		rc = snprintf(buf, n, " bad version");
+		break;
+	case 2:
+		rc = snprintf(buf, n, " method not supported");
+		break;
+	case 3:
+		rc = snprintf(buf, n, " method/attribute combo not supported");
+		break;
+	case 7:
+		rc = snprintf(buf, n, " invalid attribute/modifier value");
+		break;
+	}
+
+	if (rc < 0 || rc >= n)
+		goto done;
+	n -= rc;
+	buf += rc;
+
+	if (n == len)
+		snprintf(buf, n, "Success");
+done:
+	return (buf);
+}
+
+END_C_DECLS
+#endif /* _UMAD_STR_H */
diff --git a/include/infiniband/umad_types.h b/include/infiniband/umad_types.h
index bf93add..6f2f3d5 100755
--- a/include/infiniband/umad_types.h
+++ b/include/infiniband/umad_types.h
@@ -64,10 +64,12 @@ enum {
 	UMAD_CLASS_SNMP			= 0x08,
 	UMAD_CLASS_VENDOR_RANGE1_START	= 0x09,
 	UMAD_CLASS_VENDOR_RANGE1_END	= 0x0F,
-	UMAD_CLASS_DEVICE_ADM		= 0x10,
+	UMAD_CLASS_APPLICATION_START	= 0x10,
+	UMAD_CLASS_DEVICE_ADM		= UMAD_CLASS_APPLICATION_START,
 	UMAD_CLASS_BOOT_MGMT		= 0x11,
 	UMAD_CLASS_BIS			= 0x12,
 	UMAD_CLASS_CONG_MGMT		= 0x21,
+	UMAD_CLASS_APPLICATION_END	= 0x2F,
 	UMAD_CLASS_VENDOR_RANGE2_START	= 0x30,
 	UMAD_CLASS_VENDOR_RANGE2_END	= 0x4F
 };
diff --git a/man/umad_attribute_str.3 b/man/umad_attribute_str.3
new file mode 100644
index 0000000..f5e6b02
--- /dev/null
+++ b/man/umad_attribute_str.3
@@ -0,0 +1,3 @@
+.\" -*- nroff -*-
+.\"
+.so man3/umad_class_str.3
diff --git a/man/umad_class_str.3 b/man/umad_class_str.3
new file mode 100644
index 0000000..1b5ef27
--- /dev/null
+++ b/man/umad_class_str.3
@@ -0,0 +1,49 @@
+.\" -*- nroff -*-
+.\"
+.TH UMAD_CLASS_STR 3  "Feb 15, 2013" "OpenIB" "OpenIB Programmer\'s Manual"
+.SH "NAME"
+umad_*_str \- class of inline functions to return string representations of enums
+
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/umad_str.h>
+.sp
+.BI "char * umad_class_str(uint8_t mgmt_class)"
+.BI "char * umad_method_str(uint8_t method)"
+.BI "char * umad_mad_status_str(be16_t status, char * buf, size_t len)"
+
+.B "char * umad_attribute_str(uint8_t mgmt_class, be16_t attr_id)"
+.B "char * umad_sm_attr_str(be16_t attr_id)"
+.B "char * umad_sa_attr_str(be16_t attr_id)"
+.B "char * umad_cm_attr_str(be16_t attr_id)"
+
+.SH "DESCRIPTION"
+
+.B "char * umad_class_str(uint8_t mgmt_class)"
+Return string value of management class enum
+
+.B "char * umad_method_str(uint8_t method)"
+Return string value of method enum
+
+.B "char * umad_mad_status_str(be16_t status, char * buf, size_t len)"
+Print MAD status into buf and return buf
+
+.B "char * umad_attribute_str(uint8_t mgmt_class, be16_t attr_id)"
+Return string value of attribute specified in attr_id based on mgmt_class specified.
+
+.B "char * umad_sm_attr_str(be16_t attr_id)"
+Return string of SM attribute specified
+
+.B "char * umad_sa_attr_str(be16_t attr_id)"
+Return string of SA attribute specified
+
+.B "char * umad_cm_attr_str(be16_t attr_id)"
+Return string of CM attribute specified
+
+.SH "RETURN VALUE"
+
+Returns a string representations of the fields specified.
+
+.SH "AUTHOR"
+.TP
+Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
diff --git a/man/umad_cm_attr_str.3 b/man/umad_cm_attr_str.3
new file mode 100644
index 0000000..f5e6b02
--- /dev/null
+++ b/man/umad_cm_attr_str.3
@@ -0,0 +1,3 @@
+.\" -*- nroff -*-
+.\"
+.so man3/umad_class_str.3
diff --git a/man/umad_mad_status_str.3 b/man/umad_mad_status_str.3
new file mode 100644
index 0000000..f5e6b02
--- /dev/null
+++ b/man/umad_mad_status_str.3
@@ -0,0 +1,3 @@
+.\" -*- nroff -*-
+.\"
+.so man3/umad_class_str.3
diff --git a/man/umad_method_str.3 b/man/umad_method_str.3
new file mode 100644
index 0000000..f5e6b02
--- /dev/null
+++ b/man/umad_method_str.3
@@ -0,0 +1,3 @@
+.\" -*- nroff -*-
+.\"
+.so man3/umad_class_str.3
diff --git a/man/umad_sa_attr_str.3 b/man/umad_sa_attr_str.3
new file mode 100644
index 0000000..f5e6b02
--- /dev/null
+++ b/man/umad_sa_attr_str.3
@@ -0,0 +1,3 @@
+.\" -*- nroff -*-
+.\"
+.so man3/umad_class_str.3
diff --git a/man/umad_sm_attr_str.3 b/man/umad_sm_attr_str.3
new file mode 100644
index 0000000..f5e6b02
--- /dev/null
+++ b/man/umad_sm_attr_str.3
@@ -0,0 +1,3 @@
+.\" -*- nroff -*-
+.\"
+.so man3/umad_class_str.3
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
