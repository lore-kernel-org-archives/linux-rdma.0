From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 rdma-core 2/7] libhns: Add verbs of querying device and querying port
Date: Fri, 11 Nov 2016 12:57:25 +0800
Message-ID: <1478840250-92558-3-git-send-email-oulijun@huawei.com>
References: <1478840250-92558-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478840250-92558-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch mainly introduces query verbs for querying device
and querying port.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
v4/v3/v2:
- No change over the v1

v1:
- The initial submit
---
 providers/hns/hns_roce_u.c       |  7 ++++
 providers/hns/hns_roce_u.h       |  4 +++
 providers/hns/hns_roce_u_verbs.c | 73 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 84 insertions(+)
 create mode 100644 providers/hns/hns_roce_u_verbs.c

diff --git a/providers/hns/hns_roce_u.c b/providers/hns/hns_roce_u.c
index bda4dd8..c0f6fe9 100644
--- a/providers/hns/hns_roce_u.c
+++ b/providers/hns/hns_roce_u.c
@@ -95,12 +95,19 @@ static struct ibv_context *hns_roce_alloc_context(struct ibv_device *ibdev,
 
 	pthread_spin_init(&context->uar_lock, PTHREAD_PROCESS_PRIVATE);
 
+	context->ibv_ctx.ops.query_device  = hns_roce_u_query_device;
+	context->ibv_ctx.ops.query_port    = hns_roce_u_query_port;
+
+	if (hns_roce_u_query_device(&context->ibv_ctx, &dev_attrs))
+		goto tptr_free;
+
 	context->max_qp_wr = dev_attrs.max_qp_wr;
 	context->max_sge = dev_attrs.max_sge;
 	context->max_cqe = dev_attrs.max_cqe;
 
 	return &context->ibv_ctx;
 
+tptr_free:
 err_free:
 	free(context);
 	return NULL;
diff --git a/providers/hns/hns_roce_u.h b/providers/hns/hns_roce_u.h
index 3eef171..aa58ee6 100644
--- a/providers/hns/hns_roce_u.h
+++ b/providers/hns/hns_roce_u.h
@@ -83,4 +83,8 @@ static inline struct hns_roce_context *to_hr_ctx(struct ibv_context *ibv_ctx)
 	return container_of(ibv_ctx, struct hns_roce_context, ibv_ctx);
 }
 
+int hns_roce_u_query_device(struct ibv_context *context,
+			    struct ibv_device_attr *attr);
+int hns_roce_u_query_port(struct ibv_context *context, uint8_t port,
+			  struct ibv_port_attr *attr);
 #endif /* _HNS_ROCE_U_H */
diff --git a/providers/hns/hns_roce_u_verbs.c b/providers/hns/hns_roce_u_verbs.c
new file mode 100644
index 0000000..be55fe8
--- /dev/null
+++ b/providers/hns/hns_roce_u_verbs.c
@@ -0,0 +1,73 @@
+/*
+ * Copyright (c) 2016 Hisilicon Limited.
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
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <pthread.h>
+#include <sys/mman.h>
+#include <fcntl.h>
+#include <unistd.h>
+
+#include "hns_roce_u.h"
+
+int hns_roce_u_query_device(struct ibv_context *context,
+			    struct ibv_device_attr *attr)
+{
+	int ret;
+	struct ibv_query_device cmd;
+	unsigned long raw_fw_ver;
+	unsigned int major, minor, sub_minor;
+
+	ret = ibv_cmd_query_device(context, attr, &raw_fw_ver, &cmd,
+				   sizeof(cmd));
+	if (ret)
+		return ret;
+
+	major	   = (raw_fw_ver >> 32) & 0xffff;
+	minor	   = (raw_fw_ver >> 16) & 0xffff;
+	sub_minor = raw_fw_ver & 0xffff;
+
+	snprintf(attr->fw_ver, sizeof(attr->fw_ver), "%d.%d.%03d", major, minor,
+		 sub_minor);
+
+	return 0;
+}
+
+int hns_roce_u_query_port(struct ibv_context *context, uint8_t port,
+			  struct ibv_port_attr *attr)
+{
+	struct ibv_query_port cmd;
+
+	return ibv_cmd_query_port(context, port, attr, &cmd, sizeof(cmd));
+}
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
