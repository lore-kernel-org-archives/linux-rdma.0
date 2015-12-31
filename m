From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/ipoib: Expose ioctl command to retrieve SGID of a given socket
Date: Thu, 31 Dec 2015 06:41:15 -0800
Message-ID: <1451572875-24961-1-git-send-email-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

To support security applications, that need to filter out connections based
on SGID, an ioctl command to retrieve SGID of a given socket is added.

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/Makefile      |    3 +-
 drivers/infiniband/ulp/ipoib/ipoib.h       |   11 ++
 drivers/infiniband/ulp/ipoib/ipoib_ioctl.c |  152 ++++++++++++++++++++++++++++
 drivers/infiniband/ulp/ipoib/ipoib_main.c  |    6 +
 4 files changed, 171 insertions(+), 1 deletions(-)
 create mode 100644 drivers/infiniband/ulp/ipoib/ipoib_ioctl.c

diff --git a/drivers/infiniband/ulp/ipoib/Makefile b/drivers/infiniband/ulp/ipoib/Makefile
index e5430dd..9915cf8 100644
--- a/drivers/infiniband/ulp/ipoib/Makefile
+++ b/drivers/infiniband/ulp/ipoib/Makefile
@@ -6,7 +6,8 @@ ib_ipoib-y					:= ipoib_main.o \
 						   ipoib_verbs.o \
 						   ipoib_vlan.o \
 						   ipoib_ethtool.o \
-						   ipoib_netlink.o
+						   ipoib_netlink.o \
+						   ipoib_ioctl.o
 ib_ipoib-$(CONFIG_INFINIBAND_IPOIB_CM)		+= ipoib_cm.o
 ib_ipoib-$(CONFIG_INFINIBAND_IPOIB_DEBUG)	+= ipoib_fs.o
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index edc5b85..01b8d4d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -434,6 +434,15 @@ struct ipoib_neigh {
 	unsigned long       alive;
 };
 
+/* ioctl API */
+#define IPOIBGETSGUID		SIOCDEVPRIVATE
+
+struct ipoib_ioctl_getsgid_data {
+	u64	gid;
+	u64	subnet_prefix;
+	int	fd;
+};
+
 #define IPOIB_UD_MTU(ib_mtu)		(ib_mtu - IPOIB_ENCAP_LEN)
 #define IPOIB_UD_BUF_SIZE(ib_mtu)	(ib_mtu + IB_GRH_BYTES)
 
@@ -452,6 +461,7 @@ void ipoib_del_neighs_by_gid(struct net_device *dev, u8 *gid);
 extern struct workqueue_struct *ipoib_workqueue;
 
 /* functions */
+struct list_head *ipoib_get_dev_list(struct ib_device *dev);
 
 int ipoib_poll(struct napi_struct *napi, int budget);
 void ipoib_ib_completion(struct ib_cq *cq, void *dev_ptr);
@@ -467,6 +477,7 @@ static inline void ipoib_put_ah(struct ipoib_ah *ah)
 int ipoib_open(struct net_device *dev);
 int ipoib_add_pkey_attr(struct net_device *dev);
 int ipoib_add_umcast_attr(struct net_device *dev);
+int ipoib_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
 
 void ipoib_send(struct net_device *dev, struct sk_buff *skb,
 		struct ipoib_ah *address, u32 qpn);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ioctl.c b/drivers/infiniband/ulp/ipoib/ipoib_ioctl.c
new file mode 100644
index 0000000..124d545
--- /dev/null
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ioctl.c
@@ -0,0 +1,152 @@
+/*
+ * Copyright (c) 2015 Oracle Corporation.  All rights reserved.
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
+#include <net/arp.h>
+#include <linux/jhash.h>
+#include <net/inet_sock.h>
+#include <net/route.h>
+
+#include "ipoib.h"
+
+static int ipoib_get_sguid(struct net_device *dev, int fd, u64 *sgid,
+			   u64 *subnet_prefix)
+{
+	struct socket *sock;
+	struct inet_sock *inetsock;
+	struct neighbour *neigh;
+	int rc = 0;
+	union ib_gid *gid;
+	struct list_head *dev_list = 0;
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	u16 pkey_index = priv->pkey_index;
+	struct ipoib_dev_priv *child_priv;
+
+	sock = sockfd_lookup(fd, &rc);
+	if (IS_ERR_OR_NULL(sock))
+		return -EINVAL;
+
+	inetsock = inet_sk(sock->sk);
+
+	neigh = neigh_lookup(&arp_tbl, &inetsock->inet_daddr, dev);
+	if (!IS_ERR_OR_NULL(neigh))
+		goto found;
+
+	/* If not found try in all other ipoib devices */
+	dev_list = ipoib_get_dev_list(priv->ca);
+	if (!dev_list)
+		return -EINVAL;
+
+	list_for_each_entry(priv, dev_list, list) {
+		if (priv->pkey_index == pkey_index) {
+			neigh = neigh_lookup(&arp_tbl, &inetsock->inet_daddr,
+					     priv->dev);
+			if (!IS_ERR_OR_NULL(neigh))
+				goto found;
+		}
+		list_for_each_entry(child_priv, &priv->child_intfs, list) {
+			if (child_priv->pkey_index == pkey_index) {
+				neigh = neigh_lookup(&arp_tbl,
+						     &inetsock->inet_daddr,
+						     child_priv->dev);
+				if (!IS_ERR_OR_NULL(neigh))
+					goto found;
+			}
+		}
+	}
+
+	return -ENODEV;
+
+found:
+	if (!(neigh->nud_state & NUD_VALID))
+		return -EINVAL;
+
+	gid = (union ib_gid *)(neigh->ha + 4);
+	*sgid = be64_to_cpu(gid->global.interface_id);
+	*subnet_prefix = be64_to_cpu(gid->global.subnet_prefix);
+
+	neigh_release(neigh);
+
+	return 0;
+}
+
+static int ipoib_ioctl_getsguid(struct net_device *dev, struct ifreq *ifr)
+{
+	struct ipoib_ioctl_getsgid_data req_data;
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	int rc;
+
+	rc = copy_from_user(&req_data, ifr->ifr_data,
+			    sizeof(struct ipoib_ioctl_getsgid_data));
+	if (rc != 0) {
+		ipoib_warn(priv, "ioctl fail to copy request data\n");
+		return -EINVAL;
+	}
+	rc = ipoib_get_sguid(dev, req_data.fd, &req_data.gid,
+			     &req_data.subnet_prefix);
+	if (rc) {
+		ipoib_warn(priv, "Invalid fd %d (err=%d)\n",
+			   req_data.fd, rc);
+		return rc;
+	}
+	ipoib_dbg(priv, "ioctl_getsgid: subnet_prefix=0x%llx\n",
+		  req_data.subnet_prefix);
+	ipoib_dbg(priv, "ioctl_getsgid: src_gid=0x%llx\n", req_data.gid);
+	rc = copy_to_user(ifr->ifr_data, &req_data,
+			  sizeof(struct ipoib_ioctl_getsgid_data));
+	if (rc != 0) {
+		ipoib_warn(priv,
+			   "ioctl fail to copy back request data\n");
+		return -EINVAL;
+	}
+
+	return rc;
+}
+
+int ipoib_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	int rc = -EINVAL;
+
+	switch (cmd) {
+	case IPOIBGETSGUID:
+		rc = ipoib_ioctl_getsguid(dev, ifr);
+		if (rc != 0)
+			return -EINVAL;
+		break;
+	default:
+		ipoib_warn(priv, "invalid ioctl opcode 0x%x\n", cmd);
+		rc = -EINVAL;
+		break;
+	}
+
+	return rc;
+}
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index babba05..15665af 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1619,6 +1619,7 @@ static const struct net_device_ops ipoib_netdev_ops = {
 	.ndo_tx_timeout		 = ipoib_timeout,
 	.ndo_set_rx_mode	 = ipoib_set_mcast_list,
 	.ndo_get_iflink		 = ipoib_get_iflink,
+	.ndo_do_ioctl		 = ipoib_do_ioctl,
 };
 
 void ipoib_setup(struct net_device *dev)
@@ -1962,6 +1963,11 @@ static void ipoib_add_one(struct ib_device *device)
 	ib_set_client_data(device, &ipoib_client, dev_list);
 }
 
+struct list_head *ipoib_get_dev_list(struct ib_device *dev)
+{
+	return ib_get_client_data(dev, &ipoib_client);
+}
+
 static void ipoib_remove_one(struct ib_device *device, void *client_data)
 {
 	struct ipoib_dev_priv *priv, *tmp;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
