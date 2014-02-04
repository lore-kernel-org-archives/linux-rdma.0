From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH master] RDMA/ocrdma: Fix load time panic during GID table init
Date: Tue, 4 Feb 2014 12:10:48 +0530
Message-ID: <bc0e7e5d-45c2-453f-ba7c-c81a1b1d1d94@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, selvin.xavier-HfQkIhtri/DQT0dZR+AlfA@public.gmane.org, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

driver should use rdma_vlan_dev_real_dev() instead of using vlan_dev_real_dev()
while building GID table for a vlan interface.

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 91443bc..f7b1b27 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -161,7 +161,9 @@ static void ocrdma_add_vlan_sgids(struct ocrdma_dev *dev)
 
 	rcu_read_lock();
 	for_each_netdev_rcu(&init_net, tmp) {
-		if (netdev == tmp || vlan_dev_real_dev(tmp) == netdev) {
+		if (
+			netdev && (netdev == tmp ||
+				rdma_vlan_dev_real_dev(tmp) == netdev)) {
 			if (!netif_running(tmp) || !netif_oper_up(tmp))
 				continue;
 			if (netdev != tmp) {
@@ -208,7 +210,7 @@ static int ocrdma_inet6addr_event(struct notifier_block *notifier,
 	is_vlan = netdev->priv_flags & IFF_802_1Q_VLAN;
 	if (is_vlan) {
 		vid = vlan_dev_vlan_id(netdev);
-		netdev = vlan_dev_real_dev(netdev);
+		netdev = rdma_vlan_dev_real_dev(netdev);
 	}
 
 	rcu_read_lock();
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
