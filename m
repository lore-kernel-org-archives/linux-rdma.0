From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC for accelerated IPoIB 04/26] IB/verb: Add ipoib_options struct and API
Date: Wed,  1 Mar 2017 16:02:12 +0200
Message-ID: <1488376954-8346-5-git-send-email-erezsh@mellanox.com>
References: <1488376954-8346-1-git-send-email-erezsh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1488376954-8346-1-git-send-email-erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


The idea is to allow vendors to optimize IPoIB data path.
The new structure exposes set of callback functions for handling
data path flows in IPoIB driver.
Each vendor can support these set of functions in order to optimize its
specific data path, and let IPoIB to leverage its data path.
The code of IPoIB driver was changed accordingly, and works in both ways
with vendor specific implementation and without.
There is an assumption, that vendors should give the full set of functions
and not only part of them, in order to work properly.

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/rdma/ib_ipoib_accel_ops.h | 71 +++++++++++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h           |  9 +++++
 2 files changed, 80 insertions(+)
 create mode 100644 include/rdma/ib_ipoib_accel_ops.h

diff --git a/include/rdma/ib_ipoib_accel_ops.h b/include/rdma/ib_ipoib_accel_ops.h
new file mode 100644
index 000000000000..e2b177f01ab5
--- /dev/null
+++ b/include/rdma/ib_ipoib_accel_ops.h
@@ -0,0 +1,71 @@
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
+struct ipoib_ah;
+
+struct ib_ipoib_accel_ops {
+
+	/*
+	 * HW provider driver creates the net_device for IPoIB.
+	 * hca: The current ib device.
+	 * name: is the format of the new network device (probably ib%d)
+	 */
+	struct net_device * (*create_netdev)(struct ib_device *hca,
+					     const char *name,
+					     void (*setup)(struct net_device *));
+
+	/* IB resource allocation function, returns new UD QP */
+	int (*ib_dev_init)(struct net_device *dev, int *qp_num);
+	void (*ib_dev_cleanup)(struct net_device *dev);
+
+	/* handle network stack when open/stop device */
+	int (*ib_dev_open)(struct net_device *dev);
+	int (*ib_dev_stop)(struct net_device *dev);
+
+	/* send packet */
+	void (*send)(struct net_device *dev, struct sk_buff *skb,
+		     struct ipoib_ah *address, u32 dqpn, u32 dqkey);
+
+	/* multicast */
+	int (*attach_mcast)(struct net_device *dev, union ib_gid *gid,
+			    u16 lid, int set_qkey);
+	int (*detach_mcast)(struct net_device *dev, union ib_gid *gid,
+			     u16 lid);
+
+};
+
+#endif /* IB_IPOIB_ACCEL_OPS_H */
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 89f5bd4e1d52..68e3bf25450d 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2147,6 +2147,7 @@ struct ib_device {
 						struct ib_wq_attr *attr,
 						u32 wq_attr_mask,
 						struct ib_udata *udata);
+	struct ib_ipoib_accel_ops * (*get_ipoib_accel_ops)(struct ib_device *device);
 	struct ib_rwq_ind_table *  (*create_rwq_ind_table)(struct ib_device *device,
 							   struct ib_rwq_ind_table_init_attr *init_attr,
 							   struct ib_udata *udata);
@@ -2322,6 +2323,14 @@ static inline u8 rdma_start_port(const struct ib_device *device)
 	return rdma_cap_ib_switch(device) ? 0 : 1;
 }
 
+static inline struct ib_ipoib_accel_ops *ib_get_ipoib_accel_ops(struct ib_device *device)
+{
+	if (!device->get_ipoib_accel_ops)
+		return NULL;
+
+	return device->get_ipoib_accel_ops(device);
+}
+
 /**
  * rdma_end_port - Return the last valid port number for the device
  * specified
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
