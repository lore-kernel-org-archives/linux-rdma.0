From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] RDMA/ocrdma: add default gid at index 0
Date: Fri, 22 Aug 2014 16:57:19 +0530
Message-ID: <331110be-6d82-452c-be1a-ffbccbfca4b1@CMEXHTCAS1.ad.emulex.com>
References: <1408706840-21339-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1408706840-21339-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch adds the code to initialize default gid
at index 0. Rest of the ip4 and ip6 gid addition
remains as it is.

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 256a06b..cb7b52a 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -388,6 +388,15 @@ static void ocrdma_remove_sysfiles(struct ocrdma_dev *dev)
 		device_remove_file(&dev->ibdev.dev, ocrdma_attributes[i]);
 }
 
+static void ocrdma_add_default_sgid(struct ocrdma_dev *dev)
+{
+	/* GID Index 0 - Invariant manufacturer-assigned EUI-64 */
+	union ib_gid *sgid = &dev->sgid_tbl[0];
+
+	sgid->global.subnet_prefix = cpu_to_be64(0xfe80000000000000LL);
+	ocrdma_get_guid(dev, &sgid->raw[8]);
+}
+
 static void ocrdma_init_ipv4_gids(struct ocrdma_dev *dev,
 				  struct net_device *net)
 {
@@ -434,6 +443,7 @@ static void ocrdma_init_gid_table(struct ocrdma_dev *dev)
 				rdma_vlan_dev_real_dev(net_dev) : net_dev;
 
 		if (real_dev == dev->nic_info.netdev) {
+			ocrdma_add_default_sgid(dev);
 			ocrdma_init_ipv4_gids(dev, net_dev);
 			ocrdma_init_ipv6_gids(dev, net_dev);
 		}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
