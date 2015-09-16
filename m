From: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 15/32] IB/rxe: Address vector manipulation functions
Date: Wed, 16 Sep 2015 16:42:49 +0300
Message-ID: <1442410986-28232-16-git-send-email-kamalh@mellanox.com>
References: <1442410986-28232-1-git-send-email-kamalh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442410986-28232-1-git-send-email-kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Functions to manipulate Address Vector.

Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/staging/rxe/rxe_av.c | 87 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)
 create mode 100644 drivers/staging/rxe/rxe_av.c

diff --git a/drivers/staging/rxe/rxe_av.c b/drivers/staging/rxe/rxe_av.c
new file mode 100644
index 0000000..cc4b179
--- /dev/null
+++ b/drivers/staging/rxe/rxe_av.c
@@ -0,0 +1,87 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *	   Redistribution and use in source and binary forms, with or
+ *	   without modification, are permitted provided that the following
+ *	   conditions are met:
+ *
+ *		- Redistributions of source code must retain the above
+ *		  copyright notice, this list of conditions and the following
+ *		  disclaimer.
+ *
+ *		- Redistributions in binary form must reproduce the above
+ *		  copyright notice, this list of conditions and the following
+ *		  disclaimer in the documentation and/or other materials
+ *		  provided with the distribution.
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
+#include "rxe.h"
+#include "rxe_loc.h"
+
+int rxe_av_chk_attr(struct rxe_dev *rxe, struct ib_ah_attr *attr)
+{
+	struct rxe_port *port;
+
+	if (attr->port_num < 1 || attr->port_num > rxe->num_ports) {
+		pr_info("rxe: invalid port_num = %d\n", attr->port_num);
+		return -EINVAL;
+	}
+
+	port = &rxe->port[attr->port_num - 1];
+
+	if (attr->ah_flags & IB_AH_GRH) {
+		if (attr->grh.sgid_index > port->attr.gid_tbl_len) {
+			pr_info("rxe: invalid sgid index = %d\n",
+				attr->grh.sgid_index);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+int rxe_av_from_attr(struct rxe_dev *rxe, u8 port_num,
+		     struct rxe_av *av, struct ib_ah_attr *attr)
+{
+	memset(av, 0, sizeof(*av));
+	memcpy(&av->grh, &attr->grh, sizeof(attr->grh));
+	av->port_num = port_num;
+	return 0;
+}
+
+int rxe_av_to_attr(struct rxe_dev *rxe, struct rxe_av *av,
+		   struct ib_ah_attr *attr)
+{
+	memcpy(&attr->grh, &av->grh, sizeof(av->grh));
+	attr->port_num = av->port_num;
+	return 0;
+}
+
+int rxe_av_fill_ip_info(struct rxe_dev *rxe,
+			struct rxe_av *av,
+			struct ib_ah_attr *attr,
+			struct ib_gid_attr *sgid_attr,
+			union ib_gid *sgid)
+{
+	rdma_gid2ip(&av->sgid_addr._sockaddr, sgid);
+	rdma_gid2ip(&av->dgid_addr._sockaddr, &attr->grh.dgid);
+	av->network_type = ib_gid_to_network_type(sgid_attr->gid_type, sgid);
+
+	return 0;
+}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
