From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/13] IB-mgmt: Provide MAD definitions with libibumad
Date: Wed, 3 Nov 2010 16:11:56 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B837B376@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The only definitions for MAD data types are in ib_types.h, which
is an opensm file.  The libibumad interface is essentially useless
without these data types.  Add new header files to libibumad
with basic MAD data types.

The definitions and structures are based on those defined in
the linux kernel.  Only an initial framework is given, basically
the values for various methods, attributes, etc. along with
structure definitions for the common, rmpp, and vendor specific
headers.  Other data structures are left for future development.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 libibmad/include/infiniband/mad.h         |    0 
 libibumad/include/infiniband/umad_types.h |  192 +++++++++++++++++++++++++++++
 2 files changed, 192 insertions(+), 0 deletions(-)
 mode change 100644 => 100755 libibmad/include/infiniband/mad.h
 create mode 100755 libibumad/include/infiniband/umad_types.h

diff --git a/libibmad/include/infiniband/mad.h b/libibmad/include/infiniband/mad.h
old mode 100644
new mode 100755
diff --git a/libibumad/include/infiniband/umad_types.h b/libibumad/include/infiniband/umad_types.h
new file mode 100755
index 0000000..54b7e72
--- /dev/null
+++ b/libibumad/include/infiniband/umad_types.h
@@ -0,0 +1,192 @@
+/*
+ * Copyright (c) 2004 Mellanox Technologies Ltd.  All rights reserved.
+ * Copyright (c) 2004 Infinicon Corporation.  All rights reserved.
+ * Copyright (c) 2004, 2010 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2004 Topspin Corporation.  All rights reserved.
+ * Copyright (c) 2004-2006 Voltaire Corporation.  All rights reserved.
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
+#ifndef _UMAD_TYPES_H
+#define _UMAD_TYPES_H
+
+#include <stdint.h>
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
+#define UMAD_BASE_VERSION		1
+
+/* Management classes */
+enum {
+	UMAD_CLASS_SUBN_LID_ROUTED	= 0x01,
+	UMAD_CLASS_SUBN_DIRECTED_ROUTE	= 0x81,
+	UMAD_CLASS_SUBN_ADM		= 0x03,
+	UMAD_CLASS_PERF_MGMT		= 0x04,
+	UMAD_CLASS_BM			= 0x05,
+	UMAD_CLASS_DEVICE_MGMT		= 0x06,
+	UMAD_CLASS_CM			= 0x07,
+	UMAD_CLASS_SNMP			= 0x08,
+	UMAD_CLASS_VENDOR_RANGE1_START	= 0x09,
+	UMAD_CLASS_VENDOR_RANGE1_END	= 0x0F,
+	UMAD_CLASS_DEVICE_ADM		= 0x10,
+	UMAD_CLASS_BOOT_MGMT		= 0x11,
+	UMAD_CLASS_BIS			= 0x12,
+	UMAD_CLASS_CONG_MGMT		= 0x21,
+	UMAD_CLASS_VENDOR_RANGE2_START	= 0x30,
+	UMAD_CLASS_VENDOR_RANGE2_END	= 0x4F
+};
+
+/* Management methods */
+enum {
+	UMAD_METHOD_GET			= 0x01,
+	UMAD_METHOD_SET			= 0x02,
+	UMAD_METHOD_GET_RESP		= 0x81,
+	UMAD_METHOD_SEND		= 0x03,
+	UMAD_METHOD_TRAP		= 0x05,
+	UMAD_METHOD_REPORT		= 0x06,
+	UMAD_METHOD_REPORT_RESP		= 0x86,
+	UMAD_METHOD_TRAP_REPRESS	= 0x07,
+	UMAD_METHOD_RESP		= 0x80
+};
+
+enum {
+	UMAD_STATUS_SUCCESS  = 0x0000,
+	UMAD_STATUS_BUSY     = 0x0001,
+	UMAD_STATUS_REDIRECT = 0x0002,
+
+	/* Invalid fields, bits 2-4 */
+	UMAD_STATUS_BAD_VERSION          = (1 << 2),
+	UMAD_STATUS_METHOD_NOT_SUPPORTED = (2 << 2),
+	UMAD_STATUS_ATTR_NOT_SUPPORTED   = (3 << 2),
+	UMAD_STATUS_INVALID_ATTR_VALUE   = (7 << 2),
+
+	UMAD_STATUS_CLASS_MASK = 0xFF00
+};
+
+/* Attributes common to multiple classes */
+enum {
+	UMAD_ATTR_CLASS_PORT_INFO	= 0x0001,
+	UMAD_ATTR_NOTICE		= 0x0002,
+	UMAD_ATTR_INFORM_INFO		= 0x0003
+};
+
+/* RMPP information */
+#define UMAD_RMPP_VERSION		1
+enum {
+	UMAD_RMPP_TYPE_DATA		= 1,
+	UMAD_RMPP_TYPE_ACK		= 2,
+	UMAD_RMPP_TYPE_STOP		= 3,
+	UMAD_RMPP_TYPE_ABORT		= 4,
+
+	UMAD_RMPP_FLAG_MASK		= 0x07,
+	UMAD_RMPP_FLAG_ACTIVE		= 1,
+	UMAD_RMPP_FLAG_FIRST		= (1 << 1),
+	UMAD_RMPP_FLAG_LAST		= (1 << 2),
+
+	UMAD_RMPP_RESP_TIME_SHIFT	= 3,
+	UMAD_RMPP_NO_RESP_TIME		= 0x1F,
+
+	UMAD_RMPP_STATUS_SUCCESS	= 0,
+	UMAD_RMPP_STATUS_RESX		= 1,
+	UMAD_RMPP_STATUS_ABORT_MIN	= 118,
+	UMAD_RMPP_STATUS_T2L		= 118,
+	UMAD_RMPP_STATUS_BAD_LEN	= 119,
+	UMAD_RMPP_STATUS_BAD_SEG	= 120,
+	UMAD_RMPP_STATUS_BADT		= 121,
+	UMAD_RMPP_STATUS_W2S		= 122,
+	UMAD_RMPP_STATUS_S2B		= 123,
+	UMAD_RMPP_STATUS_BAD_STATUS	= 124,
+	UMAD_RMPP_STATUS_UNV		= 125,
+	UMAD_RMPP_STATUS_TMR		= 126,
+	UMAD_RMPP_STATUS_UNSPEC		= 127,
+	UMAD_RMPP_STATUS_ABORT_MAX	= 127
+};
+
+enum {
+	UMAD_LEN_DATA			= 232,
+	UMAD_LEN_RMPP_DATA		= 220,
+	UMAD_LEN_VENDOR_DATA		= 216,
+};
+
+struct umad_hdr {
+	uint8_t	 base_version;
+	uint8_t	 mgmt_class;
+	uint8_t	 class_version;
+	uint8_t	 method;
+	uint16_t status;
+	uint16_t class_specific;
+	uint64_t tid;
+	uint16_t attr_id;
+	uint16_t resv;
+	uint32_t attr_mod;
+};
+
+struct umad_rmpp_hdr {
+	uint8_t	 rmpp_version;
+	uint8_t	 rmpp_type;
+	uint8_t	 rmpp_rtime_flags;
+	uint8_t	 rmpp_status;
+	uint32_t seg_num;
+	uint32_t paylen_newwin;
+};
+
+struct umad_packet {
+	struct umad_hdr		mad_hdr;
+	uint8_t			data[UMAD_LEN_DATA];
+};
+
+struct umad_rmpp_packet {
+	struct umad_hdr		mad_hdr;
+	struct umad_rmpp_hdr	rmpp_hdr;
+	uint8_t			data[UMAD_LEN_RMPP_DATA];
+};
+
+struct umad_vendor_packet {
+	struct umad_hdr		mad_hdr;
+	struct umad_rmpp_hdr	rmpp_hdr;
+	uint8_t			reserved;
+	uint8_t			oui[3];
+	uint8_t			data[UMAD_LEN_VENDOR_DATA];
+};
+
+enum {
+	UMAD_OPENIB_OUI		= 0x001405
+};
+
+END_C_DECLS
+#endif				/* _UMAD_TYPES_H */


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
