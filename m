From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC 1/3] IB/IPoIB: Support SRIOV standard configuration
Date: Thu, 21 May 2015 19:24:05 +0300
Message-ID: <1432225447-6536-2-git-send-email-ogerlitz@mellanox.com>
References: <1432225447-6536-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432225447-6536-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Standard configuration of SRIOV VFs through the host is done over the
following chain of calls: libvirt --> netlink --> PF netdevice

When this comes to IB/IPoIB we should normalize this into the verbs
framework so we further go: PF IPoIB --> verbs API --> PF HW driver

Virtualization systems assign VMs 48 bits mac, to allow working with
non-modified SW layers (open-stack, libvirt, etc), we can safely
extend this mac to unique 64 bits GUID. Hence the IPoIB ndo_set_vf_mac
entry calls the set_vf_guid verb.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c |   39 +++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h                   |    4 +++
 2 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 9e1b203..8f82870 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1357,6 +1357,43 @@ void ipoib_dev_cleanup(struct net_device *dev)
 	priv->tx_ring = NULL;
 }
 
+static int ipoib_get_vf_config(struct net_device *dev, int vf, struct ifla_vf_info *ivf)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+
+	if (priv->ca->get_vf_config)
+		return priv->ca->get_vf_config(priv->ca, priv->port, vf, ivf);
+	else
+		return -EINVAL;
+}
+
+static int ipoib_set_vf_mac(struct net_device *dev, int queue, u8 *mac)
+{
+	char *raw_guid;
+	u64 guid = 0;
+
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+
+	raw_guid = (char *)&guid;
+	raw_guid[0] = mac[0];
+	raw_guid[1] = mac[1];
+	raw_guid[2] = mac[2];
+	raw_guid[3] = 0xff;
+	raw_guid[4] = 0xfe;
+	raw_guid[5] = mac[3];
+	raw_guid[6] = mac[4];
+	raw_guid[7] = mac[5];
+
+	guid &= ~(cpu_to_be64(1ULL << 56));
+	guid |= cpu_to_be64(1ULL << 57);
+
+	if (priv->ca->set_vf_guid)
+		return priv->ca->set_vf_guid(priv->ca, priv->port, queue, guid);
+	else
+		return -EINVAL;
+}
+
+
 static const struct header_ops ipoib_header_ops = {
 	.create	= ipoib_hard_header,
 };
@@ -1371,6 +1408,8 @@ static const struct net_device_ops ipoib_netdev_ops = {
 	.ndo_tx_timeout		 = ipoib_timeout,
 	.ndo_set_rx_mode	 = ipoib_set_mcast_list,
 	.ndo_get_iflink		 = ipoib_get_iflink,
+	.ndo_get_vf_config	 = ipoib_get_vf_config,
+	.ndo_set_vf_mac	 	 = ipoib_set_vf_mac,
 };
 
 void ipoib_setup(struct net_device *dev)
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 65994a1..6589520 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -53,6 +53,7 @@
 #include <linux/atomic.h>
 #include <linux/mmu_notifier.h>
 #include <asm/uaccess.h>
+#include <linux/if_link.h>
 
 extern struct workqueue_struct *ib_wq;
 
@@ -1653,6 +1654,9 @@ struct ib_device {
 	int			   (*check_mr_status)(struct ib_mr *mr, u32 check_mask,
 						      struct ib_mr_status *mr_status);
 
+	int 			  (*set_vf_guid)  (struct ib_device *device, int port, int vf, u64 guid);
+	int 			  (*get_vf_config)(struct ib_device *device, int port, int vf, struct ifla_vf_info *ivf);
+
 	struct ib_dma_mapping_ops   *dma_ops;
 
 	struct module               *owner;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
