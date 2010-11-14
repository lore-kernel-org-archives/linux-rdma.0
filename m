From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 3/3] IB Netlink RDMA CM Plugin
Date: Sun, 14 Nov 2010 18:12:56 +0200
Message-ID: <4CE00A88.4070009@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

A new module that is an RDMA CM plugin for the Netlink infrastructure.
It depends on both ib_netlink and rdma_cm.
It registers the rdma cm to ib_netlink and 
forwards requests to the proper cma callbacks.

Signed-off-by: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/netlink_cma.c |   73 +++++++++++++++++++++++++++++++++
 1 files changed, 73 insertions(+), 0 deletions(-)
 create mode 100644 drivers/infiniband/core/netlink_cma.c

diff --git a/drivers/infiniband/core/netlink_cma.c b/drivers/infiniband/core/netlink_cma.c
new file mode 100644
index 0000000..dcf585c
--- /dev/null
+++ b/drivers/infiniband/core/netlink_cma.c
@@ -0,0 +1,73 @@
+/*
+ * Copyright (c) 2010 Voltaire Inc.  All rights reserved.
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
+#define pr_fmt(fmt) "%s:%s: " fmt, KBUILD_MODNAME, __func__
+
+#include <linux/module.h>
+#include <linux/netlink.h>
+#include <rdma/rdma_cm.h>
+
+#include <net/ib_netlink.h>
+
+MODULE_AUTHOR("Nir Muchtar");
+MODULE_DESCRIPTION("RDMA CM Netlink module");
+MODULE_LICENSE("Dual BSD/GPL");
+
+static int netlink_cma_get_data(int op, char *buf, int len)
+{
+	if (op == IBNL_RDMA_CM_STATS)
+		return cma_get_stats(buf, len);
+	pr_warn("Invalid operation (%d)\n", op);
+	return -EINVAL;
+}
+
+static int netlink_cma_get_size(int op, int *size)
+{
+	if (op == IBNL_RDMA_CM_STATS)
+		return cma_get_stats_size(size);
+	pr_warn("Invalid operation (%d)\n", op);
+	return -EINVAL;
+}
+
+static int __init netlink_cma_init(void)
+{
+	return ibnl_add_cb(IBNL_RDMA_CM, netlink_cma_get_size,
+		netlink_cma_get_data);
+}
+
+static void __exit netlink_cma_cleanup(void)
+{
+	ibnl_remove_cb(IBNL_RDMA_CM);
+}
+
+module_init(netlink_cma_init);
+module_exit(netlink_cma_cleanup);
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
