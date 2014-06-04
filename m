From: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 14/15] RDMA/ocrdma: Initialize the GID table while registering the device
Date: Wed, 4 Jun 2014 23:49:14 +0530
Message-ID: <3818c97f-12df-4d2e-8d00-1ca19541945b@CMEXHTCAS1.ad.emulex.com>
References: <1401905955-28117-1-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-2-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-3-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-4-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-5-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-6-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-7-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-8-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-9-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-10-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-11-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-12-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-13-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-14-git-send-email-selvin.xavier@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1401905955-28117-14-git-send-email-selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Current GID table gets updated only at the time of inet notification.
Fixing this by initializing the table at the time of device registration.

Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c |   53 ++++++++++++++++++++++++++++
 1 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 0d90c7f..256a06b 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -388,6 +388,58 @@ static void ocrdma_remove_sysfiles(struct ocrdma_dev *dev)
 		device_remove_file(&dev->ibdev.dev, ocrdma_attributes[i]);
 }
 
+static void ocrdma_init_ipv4_gids(struct ocrdma_dev *dev,
+				  struct net_device *net)
+{
+	struct in_device *in_dev;
+	union ib_gid gid;
+	in_dev = in_dev_get(net);
+	if (in_dev) {
+		for_ifa(in_dev) {
+			ipv6_addr_set_v4mapped(ifa->ifa_address,
+					       (struct in6_addr *)&gid);
+			ocrdma_add_sgid(dev, &gid);
+		}
+		endfor_ifa(in_dev);
+		in_dev_put(in_dev);
+	}
+}
+
+static void ocrdma_init_ipv6_gids(struct ocrdma_dev *dev,
+				  struct net_device *net)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	struct inet6_dev *in6_dev;
+	union ib_gid  *pgid;
+	struct inet6_ifaddr *ifp;
+	in6_dev = in6_dev_get(net);
+	if (in6_dev) {
+		read_lock_bh(&in6_dev->lock);
+		list_for_each_entry(ifp, &in6_dev->addr_list, if_list) {
+			pgid = (union ib_gid *)&ifp->addr;
+			ocrdma_add_sgid(dev, pgid);
+		}
+		read_unlock_bh(&in6_dev->lock);
+		in6_dev_put(in6_dev);
+	}
+#endif
+}
+
+static void ocrdma_init_gid_table(struct ocrdma_dev *dev)
+{
+	struct  net_device *net_dev;
+
+	for_each_netdev(&init_net, net_dev) {
+		struct net_device *real_dev = rdma_vlan_dev_real_dev(net_dev) ?
+				rdma_vlan_dev_real_dev(net_dev) : net_dev;
+
+		if (real_dev == dev->nic_info.netdev) {
+			ocrdma_init_ipv4_gids(dev, net_dev);
+			ocrdma_init_ipv6_gids(dev, net_dev);
+		}
+	}
+}
+
 static struct ocrdma_dev *ocrdma_add(struct be_dev_info *dev_info)
 {
 	int status = 0, i;
@@ -416,6 +468,7 @@ static struct ocrdma_dev *ocrdma_add(struct be_dev_info *dev_info)
 		goto alloc_err;
 
 	ocrdma_init_service_level(dev);
+	ocrdma_init_gid_table(dev);
 	status = ocrdma_register_device(dev);
 	if (status)
 		goto alloc_err;
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
