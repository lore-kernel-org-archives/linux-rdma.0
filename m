From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] i40iw: Replace list_for_each_entry macro with safe version
Date: Wed, 30 Nov 2016 15:08:34 -0600
Message-ID: <20161130210834.14076-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Use list_for_each_entry_safe macro for the IPv6 addr list
as IPv6 addresses can be deleted while going through the
list.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c   | 4 ++--
 drivers/infiniband/hw/i40iw/i40iw_main.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 93ae764..9a14880 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -1644,7 +1644,7 @@ static enum i40iw_status_code i40iw_add_mqh_6(struct i40iw_device *iwdev,
 {
 	struct net_device *ip_dev;
 	struct inet6_dev *idev;
-	struct inet6_ifaddr *ifp;
+	struct inet6_ifaddr *ifp, *tmp;
 	enum i40iw_status_code ret = 0;
 	struct i40iw_cm_listener *child_listen_node;
 	unsigned long flags;
@@ -1659,7 +1659,7 @@ static enum i40iw_status_code i40iw_add_mqh_6(struct i40iw_device *iwdev,
 				i40iw_pr_err("idev == NULL\n");
 				break;
 			}
-			list_for_each_entry(ifp, &idev->addr_list, if_list) {
+			list_for_each_entry_safe(ifp, tmp, &idev->addr_list, if_list) {
 				i40iw_debug(&iwdev->sc_dev,
 					    I40IW_DEBUG_CM,
 					    "IP=%pI6, vlan_id=%d, MAC=%pM\n",
diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index d86bb6e..4ce05b8 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -1164,7 +1164,7 @@ static void i40iw_add_ipv6_addr(struct i40iw_device *iwdev)
 {
 	struct net_device *ip_dev;
 	struct inet6_dev *idev;
-	struct inet6_ifaddr *ifp;
+	struct inet6_ifaddr *ifp, *tmp;
 	u32 local_ipaddr6[4];
 
 	rcu_read_lock();
@@ -1177,7 +1177,7 @@ static void i40iw_add_ipv6_addr(struct i40iw_device *iwdev)
 				i40iw_pr_err("ipv6 inet device not found\n");
 				break;
 			}
-			list_for_each_entry(ifp, &idev->addr_list, if_list) {
+			list_for_each_entry_safe(ifp, tmp, &idev->addr_list, if_list) {
 				i40iw_pr_info("IP=%pI6, vlan_id=%d, MAC=%pM\n", &ifp->addr,
 					      rdma_vlan_dev_vlan_id(ip_dev), ip_dev->dev_addr);
 				i40iw_copy_ip_ntohl(local_ipaddr6,
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
