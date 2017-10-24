From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V3 rdma-core 1/5] libhns: Add new PCI device matching for hip08
Date: Tue, 24 Oct 2017 21:21:45 +0800
Message-ID: <1508851309-183263-2-git-send-email-oulijun@huawei.com>
References: <1508851309-183263-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508851309-183263-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Init userspace frame for matching hip08 RoCE device.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 providers/hns/hns_roce_u.c       | 12 +++++++++++-
 providers/hns/hns_roce_u.h       |  5 ++++-
 providers/hns/hns_roce_u_hw_v2.c | 41 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 56 insertions(+), 2 deletions(-)
 create mode 100644 providers/hns/hns_roce_u_hw_v2.c

diff --git a/providers/hns/hns_roce_u.c b/providers/hns/hns_roce_u.c
index c27212a..ababd9c 100644
--- a/providers/hns/hns_roce_u.c
+++ b/providers/hns/hns_roce_u.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2016 Hisilicon Limited.
+ * Copyright (c) 2016-2017 Hisilicon Limited.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -44,10 +44,20 @@
 #define HID_LEN			15
 #define DEV_MATCH_LEN		128
 
+#ifndef PCI_VENDOR_ID_HUAWEI
+#define PCI_VENDOR_ID_HUAWEI			0x19E5
+#endif
+
 static const struct verbs_match_ent hca_table[] = {
 	VERBS_MODALIAS_MATCH("acpi*:HISI00D1:*", &hns_roce_u_hw_v1),
 	VERBS_MODALIAS_MATCH("of:N*T*Chisilicon,hns-roce-v1C*", &hns_roce_u_hw_v1),
 	VERBS_MODALIAS_MATCH("of:N*T*Chisilicon,hns-roce-v1", &hns_roce_u_hw_v1),
+	VERBS_PCI_MATCH(PCI_VENDOR_ID_HUAWEI, 0xA222, &hns_roce_u_hw_v2),
+	VERBS_PCI_MATCH(PCI_VENDOR_ID_HUAWEI, 0xA223, &hns_roce_u_hw_v2),
+	VERBS_PCI_MATCH(PCI_VENDOR_ID_HUAWEI, 0xA224, &hns_roce_u_hw_v2),
+	VERBS_PCI_MATCH(PCI_VENDOR_ID_HUAWEI, 0xA225, &hns_roce_u_hw_v2),
+	VERBS_PCI_MATCH(PCI_VENDOR_ID_HUAWEI, 0xA226, &hns_roce_u_hw_v2),
+	VERBS_PCI_MATCH(PCI_VENDOR_ID_HUAWEI, 0xA227, &hns_roce_u_hw_v2),
 	{}
 };
 
diff --git a/providers/hns/hns_roce_u.h b/providers/hns/hns_roce_u.h
index d0e2351..568bfc3 100644
--- a/providers/hns/hns_roce_u.h
+++ b/providers/hns/hns_roce_u.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2016 Hisilicon Limited.
+ * Copyright (c) 2016-2017 Hisilicon Limited.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -50,6 +50,8 @@
 #define HNS_ROCE_TPTR_OFFSET		0x1000
 #define HNS_ROCE_HW_VER1		('h' << 24 | 'i' << 16 | '0' << 8 | '6')
 
+#define HNS_ROCE_HW_VER2		('h' << 24 | 'i' << 16 | '0' << 8 | '8')
+
 #define PFX				"hns: "
 
 #define roce_get_field(origin, mask, shift) \
@@ -249,5 +251,6 @@ void hns_roce_free_buf(struct hns_roce_buf *buf);
 void hns_roce_init_qp_indices(struct hns_roce_qp *qp);
 
 extern struct hns_roce_u_hw hns_roce_u_hw_v1;
+extern struct hns_roce_u_hw hns_roce_u_hw_v2;
 
 #endif /* _HNS_ROCE_U_H */
diff --git a/providers/hns/hns_roce_u_hw_v2.c b/providers/hns/hns_roce_u_hw_v2.c
new file mode 100644
index 0000000..a580bad
--- /dev/null
+++ b/providers/hns/hns_roce_u_hw_v2.c
@@ -0,0 +1,41 @@
+/*
+ * Copyright (c) 2016-2017 Hisilicon Limited.
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
+#include <stdio.h>
+#include <string.h>
+#include <malloc.h>
+#include "hns_roce_u.h"
+#include "hns_roce_u_db.h"
+
+struct hns_roce_u_hw hns_roce_u_hw_v2 = {
+	.hw_version = HNS_ROCE_HW_VER2,
+};
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
