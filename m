From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC v2 for accelerated IPoIB 04/6] IB/verb: Add ipoib_options struct and API
Date: Mon, 20 Mar 2017 21:08:26 +0200
Message-ID: <1490036908-12528-5-git-send-email-erezsh@mellanox.com>
References: <1490036908-12528-1-git-send-email-erezsh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490036908-12528-1-git-send-email-erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


The idea is to allow vendors to optimize IPoIB data path.
New struct that includes functions and data member is exposed.
It exposes set of callback functions for handling data path flows in IPoIB driver.
Each vendor can support these set of functions in order to optimize its
specific data path, and let IPoIB to leverage its data path.
The code of IPoIB driver was changed accordingly, and works in both ways
with vendor specific implementation and without.
There is an assumption, that vendors should give the full set of functions
and not only part of them, in order to work properly.

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/rdma/ib_ipoib_accel_ops.h | 61 +++++++++++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h           | 30 +++++++++++++++++++
 2 files changed, 91 insertions(+)
 create mode 100644 include/rdma/ib_ipoib_accel_ops.h

diff --git a/include/rdma/ib_ipoib_accel_ops.h b/include/rdma/ib_ipoib_accel_ops.h
new file mode 100644
index 000000000000..352672de6edf
--- /dev/null
+++ b/include/rdma/ib_ipoib_accel_ops.h
@@ -0,0 +1,61 @@
+/*
+ * Copyright (c) 2017 Mellanox Technologies Ltd.  All rights reserved.
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
+#if !defined(IB_IPOIB_ACCEL_OPS_H)
+#define IB_IPOIB_ACCEL_OPS_H
+
+#include <rdma/ib_verbs.h>
+
+/* ipoib rdma netdev's private data structure */
+struct ipoib_rdma_netdev {
+	struct rdma_netdev rn;  /* keep this first */
+	void *context;
+	u32 qpn;
+	/* followed by device private data */
+	char *dev_priv[0];
+};
+
+static inline void *ipoib_priv(const struct net_device *dev)
+{
+	struct rdma_netdev *rn = netdev_priv(dev);
+
+	return rn->clnt_priv;
+}
+
+static inline void *ipoib_accl_priv(const struct net_device *dev)
+{
+	struct ipoib_rdma_netdev *ipoib_rn = netdev_priv(dev);
+
+	return ipoib_rn->dev_priv;
+}
+
+#endif /* IB_IPOIB_ACCEL_OPS_H */
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 85b9034c8cfc..94203ba07562 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1901,6 +1901,36 @@ struct ib_port_immutable {
 	u32                           max_mad_size;
 };
 
+/* rdma netdev type - specifies protocol type */
+enum rdma_netdev_t {
+	RDMA_NETDEV_OPA_VNIC,
+	RDMA_NETDEV_IPOIB
+};
+
+struct ipoib_ah;
+
+/**
+ * struct rdma_netdev - rdma netdev
+ * For cases where netstack interfacing is required.
+ */
+struct rdma_netdev {
+	void *clnt_priv;
+
+	/* control functions */
+	void (*set_id)(struct net_device *netdev, int id);
+	/* send packet */
+	void (*send)(struct net_device *dev, struct sk_buff *skb,
+		     struct ipoib_ah *address, u32 dqpn, u32 dqkey);
+
+	/* multicast */
+	int (*attach_mcast)(struct net_device *dev, struct ib_device *hca,
+			    union ib_gid *gid, u16 mlid, int set_qkey);
+	int (*detach_mcast)(struct net_device *dev, struct ib_device *hca,
+			    union ib_gid *gid, u16 mlid);
+	/* rdma-netdev private members */
+	struct ib_device *hca;
+};
+
 struct ib_device {
 	struct device                *dma_device;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
