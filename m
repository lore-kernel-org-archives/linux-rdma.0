From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] libibumad: add string functions for various enums
Date: Fri, 1 Mar 2013 11:40:34 -0800
Message-ID: <20130301114034.85fdbe136d503d803cb167ae@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

NOTE: One remaining question is:

Should umad_common_mad_status_str return "Success" if reserved bits 5-7 are not 0?

Some of this code was originally proposed by Sean in 2010 as part of user space
madeye: http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg06185.html

Changes from V1:
	Move functions into library calls
	remove funky marco obfuscation
	remove public access to umad_[sm|sa|cm]_attr_str functions
Changes from V2:
	fix build
	Added mgmt_class to umad_method_str call
	remove "inline" from man page
	change return values to const char *
	remove UMAD_METHOD_RESP from umad_class_str
	Use UMAD_STATUS_x values in umad_mad_status_str decode.
	change umad_mad_status_str to 2 functions with const char * type
		umad_common_mad_status_str
		umad_sa_mad_status_str
	update man page
	rebase to master branch

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 Makefile.am                     |   16 ++-
 include/infiniband/umad_sm.h    |   31 ++--
 include/infiniband/umad_str.h   |   57 +++++++
 include/infiniband/umad_types.h |    7 +-
 man/umad_attribute_str.3        |    3 +
 man/umad_class_str.3            |   45 ++++++
 man/umad_mad_status_str.3       |    3 +
 man/umad_method_str.3           |    3 +
 src/libibumad.map               |    4 +
 src/umad_str.c                  |  333 +++++++++++++++++++++++++++++++++++++++
 10 files changed, 481 insertions(+), 21 deletions(-)
 create mode 100644 include/infiniband/umad_str.h
 create mode 100644 man/umad_attribute_str.3
 create mode 100644 man/umad_class_str.3
 create mode 100644 man/umad_mad_status_str.3
 create mode 100644 man/umad_method_str.3
 create mode 100644 src/umad_str.c

diff --git a/Makefile.am b/Makefile.am
index 14e2389..2868c8d 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,7 +1,9 @@
 ACLOCAL_AMFLAGS = -I config
 SUBDIRS = .
 
-INCLUDES = -I$(srcdir)/include/infiniband -I$(includedir)
+INCLUDES = -I$(srcdir)/include/infiniband \
+	   -I$(srcdir)/include \
+	   -I$(includedir)
 
 man_MANS = man/umad_debug.3 man/umad_get_ca.3 \
 	   man/umad_get_ca_portguids.3 man/umad_get_cas_names.3 \
@@ -15,7 +17,12 @@ man_MANS = man/umad_debug.3 man/umad_get_ca.3 \
 	   man/umad_get_pkey.3 \
 	   man/umad_register.3 man/umad_register_oui.3 man/umad_unregister.3 \
 	   man/umad_send.3 man/umad_recv.3 man/umad_poll.3 \
-	   man/umad_get_issm_path.3
+	   man/umad_get_issm_path.3 \
+	   man/umad_attribute_str.3 \
+	   man/umad_class_str.3 \
+	   man/umad_mad_status_str.3 \
+	   man/umad_method_str.3
+
 
 lib_LTLIBRARIES = libibumad.la
 
@@ -27,7 +34,7 @@ else
 libibumad_version_script =
 endif
 
-libibumad_la_SOURCES = src/umad.c src/sysfs.c
+libibumad_la_SOURCES = src/umad.c src/sysfs.c src/umad_str.c
 libibumad_la_LDFLAGS = -version-info $(ibumad_api_version) \
     -export-dynamic $(libibumad_version_script)
 libibumad_la_DEPENDENCIES = $(srcdir)/src/libibumad.map
@@ -38,7 +45,8 @@ libibumadinclude_HEADERS = $(srcdir)/include/infiniband/umad.h \
 	$(srcdir)/include/infiniband/umad_types.h \
 	$(srcdir)/include/infiniband/umad_sa.h \
 	$(srcdir)/include/infiniband/umad_sm.h \
-	$(srcdir)/include/infiniband/umad_cm.h
+	$(srcdir)/include/infiniband/umad_cm.h \
+	$(srcdir)/include/infiniband/umad_str.h
 
 EXTRA_DIST = $(srcdir)/include/infiniband/umad.h \
 	libibumad.spec.in libibumad.spec \
diff --git a/include/infiniband/umad_sm.h b/include/infiniband/umad_sm.h
index 10348d4..f6ee171 100644
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
index 0000000..941fa33
--- /dev/null
+++ b/include/infiniband/umad_str.h
@@ -0,0 +1,57 @@
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
+#include <infiniband/umad.h>
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
+const char * umad_class_str(uint8_t mgmt_class);
+const char * umad_method_str(uint8_t mgmt_class, uint8_t method);
+const char * umad_attribute_str(uint8_t mgmt_class, be16_t attr_id);
+
+const char * umad_common_mad_status_str(be16_t status);
+const char * umad_sa_mad_status_str(be16_t status);
+
+END_C_DECLS
+#endif /* _UMAD_STR_H */
diff --git a/include/infiniband/umad_types.h b/include/infiniband/umad_types.h
index b548a3b..32c747a 100644
--- a/include/infiniband/umad_types.h
+++ b/include/infiniband/umad_types.h
@@ -65,10 +65,12 @@ enum {
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
@@ -97,7 +99,8 @@ enum {
 	UMAD_STATUS_ATTR_NOT_SUPPORTED   = (3 << 2),
 	UMAD_STATUS_INVALID_ATTR_VALUE   = (7 << 2),
 
-	UMAD_STATUS_CLASS_MASK = 0xFF00
+	UMAD_STATUS_INVALID_FIELD_MASK = 0x001C,
+	UMAD_STATUS_CLASS_MASK         = 0xFF00
 };
 
 /* Attributes common to multiple classes */
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
index 0000000..5bc813b
--- /dev/null
+++ b/man/umad_class_str.3
@@ -0,0 +1,45 @@
+.\" -*- nroff -*-
+.\"
+.TH UMAD_CLASS_STR 3  "Feb 15, 2013" "OpenIB" "OpenIB Programmer\'s Manual"
+.SH "NAME"
+umad_*_str \- class of functions to return string representations of enums
+
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/umad_str.h>
+.sp
+.BI "const char * umad_class_str(uint8_t mgmt_class)"
+.BI "const char * umad_method_str(uint8_t mgmt_class, uint8_t method)"
+.BI "const char * umad_attribute_str(uint8_t mgmt_class, be16_t attr_id)"
+
+.BI "const char * umad_common_mad_status_str(be16_t status)"
+.BI "const char * umad_sa_mad_status_str(be16_t status)"
+
+.SH "DESCRIPTION"
+
+.B "const char * umad_class_str(uint8_t mgmt_class)"
+Return string value of management class enum
+
+.B "const char * umad_method_str(uint8_t mgmt_class, uint8_t method)"
+Return string value of the method for the mgmt_class specified
+
+.B "const char * umad_attribute_str(uint8_t mgmt_class, be16_t attr_id)"
+Return string value of attribute specified in attr_id based on mgmt_class specified.
+
+.B "const char * umad_common_mad_status_str(be16_t status)"
+Return string value for common MAD status values
+
+.B "const char * umad_sa_mad_status_str(be16_t status)"
+Return string value for SA MAD status values
+
+
+.B NOTE:
+Not all classes are supported.
+
+.SH "RETURN VALUE"
+
+Returns a string representations of the fields specified.
+
+.SH "AUTHOR"
+.TP
+Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
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
diff --git a/src/libibumad.map b/src/libibumad.map
index 0154b7f..af68d11 100644
--- a/src/libibumad.map
+++ b/src/libibumad.map
@@ -30,5 +30,9 @@ IBUMAD_1.0 {
 		umad_debug;
 		umad_addr_dump;
 		umad_dump;
+		umad_class_str;
+		umad_method_str;
+		umad_mad_status_str;
+		umad_attribute_str;
 	local: *;
 };
diff --git a/src/umad_str.c b/src/umad_str.c
new file mode 100644
index 0000000..6dca087
--- /dev/null
+++ b/src/umad_str.c
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
+
+#include <stdio.h>
+#include <arpa/inet.h>
+#include <infiniband/umad.h>
+#include <infiniband/umad_types.h>
+#include <infiniband/umad_sm.h>
+#include <infiniband/umad_sa.h>
+#include <infiniband/umad_cm.h>
+
+const char * umad_class_str(uint8_t mgmt_class)
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
+static char * umad_common_method_str(uint8_t method)
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
+		default:
+			return ("<unknown");
+	}
+}
+
+static char * umad_sa_method_str(uint8_t method)
+{
+	switch(method) {
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
+		default:
+			return (umad_common_method_str(method));
+	}
+}
+
+const char * umad_method_str(uint8_t mgmt_class, uint8_t method)
+{
+	if (mgmt_class == UMAD_CLASS_SUBN_ADM)
+		return(umad_sa_method_str(method));
+
+	return (umad_common_method_str(method));
+}
+
+const char * umad_common_mad_status_str(be16_t status)
+{
+	status = ntohs(status);
+
+	if (status & UMAD_STATUS_BUSY)
+		return ("Busy");
+
+	if (status & UMAD_STATUS_REDIRECT)
+		return ("Redirection required");
+
+	switch(status & UMAD_STATUS_INVALID_FIELD_MASK) {
+		case UMAD_STATUS_BAD_VERSION:
+			return ("Bad Version");
+		case UMAD_STATUS_METHOD_NOT_SUPPORTED:
+			return ("Method not supported");
+		case UMAD_STATUS_ATTR_NOT_SUPPORTED:
+			return ("Method/Attribute combo not supported");
+		case UMAD_STATUS_INVALID_ATTR_VALUE:
+			return ("Invalid attribute/modifier field");
+	}
+	return ("Success");
+}
+
+const char * umad_sa_mad_status_str(be16_t status)
+{
+	status = ntohs(status);
+	switch((status & UMAD_STATUS_CLASS_MASK) >> 8) {
+		case UMAD_SA_STATUS_SUCCESS:
+			return ("Success");
+		case UMAD_SA_STATUS_NO_RESOURCES:
+			return ("No Resources");
+		case UMAD_SA_STATUS_REQ_INVALID:
+			return ("Request Invalid");
+		case UMAD_SA_STATUS_NO_RECORDS:
+			return ("No Records");
+		case UMAD_SA_STATUS_TOO_MANY_RECORDS:
+			return ("Too Many Records");
+		case UMAD_SA_STATUS_INVALID_GID:
+			return ("Invalid GID");
+		case UMAD_SA_STATUS_INSUF_COMPS:
+			return ("Insufficient Components");
+		case UMAD_SA_STATUS_REQ_DENIED:
+			return ("Request Denied");
+		case UMAD_SA_STATUS_PRI_SUGGESTED:
+			return ("Priority Suggested");
+	}
+	return ("Undefined Error");
+}
+
+static char *umad_common_attr_str(be16_t attr_id)
+{
+	switch(ntohs(attr_id)) {
+		case UMAD_ATTR_CLASS_PORT_INFO:
+			return "Class Port Info";
+		case UMAD_ATTR_NOTICE:
+			return "Notice";
+		case UMAD_ATTR_INFORM_INFO:
+			return "Inform Info";
+		default:
+			return "<unknown>";
+	}
+}
+
+static char * umad_sm_attr_str(be16_t attr_id)
+{
+	switch(ntohs(attr_id)) {
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
+		default:
+			return (umad_common_attr_str(attr_id));
+	}
+	return ("<unknown>");
+}
+
+static char * umad_sa_attr_str(be16_t attr_id)
+{
+	switch(ntohs(attr_id)) {
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
+		default:
+			return (umad_common_attr_str(attr_id));
+	}
+	return ("<unknown>");
+}
+
+static char * umad_cm_attr_str(be16_t attr_id)
+{
+	switch(ntohs(attr_id)) {
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
+		default:
+			return (umad_common_attr_str(attr_id));
+	}
+	return ("<unknown>");
+}
+
+const char * umad_attribute_str(uint8_t mgmt_class, be16_t attr_id)
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
+	return (umad_common_attr_str(attr_id));
+}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
