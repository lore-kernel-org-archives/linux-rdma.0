From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/7] libibumad: Add basic SM definitions to umad
Date: Thu, 28 Apr 2011 16:01:41 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF261A1F411D@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add a new header file, umad_sm.h, to libibumad that contains
basic SM MAD definitions.

Only the SM attributes values, new methods, and base SM MAD
format are given.  SM attribute structure definitions are
left for future development.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/infiniband/umad_sm.h |  102 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 102 insertions(+), 0 deletions(-)
 create mode 100755 include/infiniband/umad_sm.h

diff --git a/include/infiniband/umad_sm.h b/include/infiniband/umad_sm.h
new file mode 100755
index 0000000..62c75da
--- /dev/null
+++ b/include/infiniband/umad_sm.h
@@ -0,0 +1,102 @@
+/*
+ * Copyright (c) 2004 Mellanox Technologies Ltd.  All rights reserved.
+ * Copyright (c) 2004 Infinicon Corporation.  All rights reserved.
+ * Copyright (c) 2004 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2004 Topspin Corporation.  All rights reserved.
+ * Copyright (c) 2004 Voltaire Corporation.  All rights reserved.
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
+ */
+
+#ifndef _UMAD_SM_H
+#define _UMAD_SM_H
+
+#include <infiniband/umad_types.h>
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
+enum {
+	UMAD_SMP_DIRECTION		= 0x8000,
+};
+
+/* Subnet management attributes */
+enum {
+	UMAD_SMP_ATTR_NODE_DESC		= 0x0010,
+	UMAD_SMP_ATTR_NODE_INFO		= 0x0011,
+	UMAD_SMP_ATTR_SWITCH_INFO	= 0x0012,
+	UMAD_SMP_ATTR_GUID_INFO		= 0x0014,
+	UMAD_SMP_ATTR_PORT_INFO		= 0x0015,
+	UMAD_SMP_ATTR_PKEY_TABLE	= 0x0016,
+	UMAD_SMP_ATTR_SLVL_TABLE	= 0x0017,
+	UMAD_SMP_ATTR_VL_ARB_TABLE	= 0x0018,
+	UMAD_SMP_ATTR_LINEAR_FT		= 0x0019,
+	UMAD_SMP_ATTR_RANDOM_FT		= 0x001A,
+	UMAD_SMP_ATTR_MCAST_FT		= 0x001B,
+	UMAD_SMP_ATTR_SM_INFO		= 0x0020,
+	UMAD_SMP_ATTR_VENDOR_DIAG	= 0x0030,
+	UMAD_SMP_ATTR_LED_INFO		= 0x0031,
+	UMAD_SMP_ATTR_VENDOR_MASK	= 0xFF00
+};
+
+enum {
+	UMAD_LEN_SMP_DATA		= 64,
+	UMAD_SMP_MAX_HOPS		= 64
+};
+
+struct umad_smp {
+	uint8_t	 base_version;
+	uint8_t	 mgmt_class;
+	uint8_t	 class_version;
+	uint8_t	 method;
+	uint16_t status;
+	uint8_t  hop_ptr;
+	uint8_t  hop_cnt;
+	uint64_t tid;
+	uint16_t attr_id;
+	uint16_t resv;
+	uint32_t attr_mod;
+	uint64_t mkey;
+	uint16_t dr_slid;
+	uint16_t dr_dlid;
+	uint8_t  reserved[28];
+	uint8_t  data[UMAD_LEN_SMP_DATA];
+	uint8_t  initial_path[UMAD_SMP_MAX_HOPS];
+	uint8_t  return_path[UMAD_SMP_MAX_HOPS];
+};
+
+END_C_DECLS
+#endif				/* _UMAD_SM_H */


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
