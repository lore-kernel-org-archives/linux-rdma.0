From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V3 06/11] IB/core: Move rdma_is_upper_dev_rcu to header file
Date: Wed, 23 Dec 2015 14:56:52 +0200
Message-ID: <1450875417-19262-7-git-send-email-matanb@mellanox.com>
References: <1450875417-19262-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450875417-19262-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In order to validate the route, we need an easy way to check if a
net-device belongs to our RDMA device. Move this helper function
to a header file in order to make this check easier.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/core_priv.h     |   13 +++++++++++++
 drivers/infiniband/core/roce_gid_mgmt.c |   20 ++++----------------
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index d531f91..3b250a2 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -96,4 +96,17 @@ int ib_cache_setup_one(struct ib_device *device);
 void ib_cache_cleanup_one(struct ib_device *device);
 void ib_cache_release_one(struct ib_device *device);
 
+static inline bool rdma_is_upper_dev_rcu(struct net_device *dev,
+					 struct net_device *upper)
+{
+	struct net_device *_upper = NULL;
+	struct list_head *iter;
+
+	netdev_for_each_all_upper_dev_rcu(dev, _upper, iter)
+		if (_upper == upper)
+			break;
+
+	return _upper == upper;
+}
+
 #endif /* _CORE_PRIV_H */
diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniband/core/roce_gid_mgmt.c
index 1e3673f..06556c3 100644
--- a/drivers/infiniband/core/roce_gid_mgmt.c
+++ b/drivers/infiniband/core/roce_gid_mgmt.c
@@ -139,18 +139,6 @@ static enum bonding_slave_state is_eth_active_slave_of_bonding_rcu(struct net_de
 	return BONDING_SLAVE_STATE_NA;
 }
 
-static bool is_upper_dev_rcu(struct net_device *dev, struct net_device *upper)
-{
-	struct net_device *_upper = NULL;
-	struct list_head *iter;
-
-	netdev_for_each_all_upper_dev_rcu(dev, _upper, iter)
-		if (_upper == upper)
-			break;
-
-	return _upper == upper;
-}
-
 #define REQUIRED_BOND_STATES		(BONDING_SLAVE_STATE_ACTIVE |	\
 					 BONDING_SLAVE_STATE_NA)
 static int is_eth_port_of_netdev(struct ib_device *ib_dev, u8 port,
@@ -168,7 +156,7 @@ static int is_eth_port_of_netdev(struct ib_device *ib_dev, u8 port,
 	if (!real_dev)
 		real_dev = event_ndev;
 
-	res = ((is_upper_dev_rcu(rdma_ndev, event_ndev) &&
+	res = ((rdma_is_upper_dev_rcu(rdma_ndev, event_ndev) &&
 	       (is_eth_active_slave_of_bonding_rcu(rdma_ndev, real_dev) &
 		REQUIRED_BOND_STATES)) ||
 	       real_dev == rdma_ndev);
@@ -214,7 +202,7 @@ static int upper_device_filter(struct ib_device *ib_dev, u8 port,
 		return 1;
 
 	rcu_read_lock();
-	res = is_upper_dev_rcu(rdma_ndev, event_ndev);
+	res = rdma_is_upper_dev_rcu(rdma_ndev, event_ndev);
 	rcu_read_unlock();
 
 	return res;
@@ -244,7 +232,7 @@ static void enum_netdev_default_gids(struct ib_device *ib_dev,
 	rcu_read_lock();
 	if (!rdma_ndev ||
 	    ((rdma_ndev != event_ndev &&
-	      !is_upper_dev_rcu(rdma_ndev, event_ndev)) ||
+	      !rdma_is_upper_dev_rcu(rdma_ndev, event_ndev)) ||
 	     is_eth_active_slave_of_bonding_rcu(rdma_ndev,
 						netdev_master_upper_dev_get_rcu(rdma_ndev)) ==
 	     BONDING_SLAVE_STATE_INACTIVE)) {
@@ -274,7 +262,7 @@ static void bond_delete_netdev_default_gids(struct ib_device *ib_dev,
 
 	rcu_read_lock();
 
-	if (is_upper_dev_rcu(rdma_ndev, event_ndev) &&
+	if (rdma_is_upper_dev_rcu(rdma_ndev, event_ndev) &&
 	    is_eth_active_slave_of_bonding_rcu(rdma_ndev, real_dev) ==
 	    BONDING_SLAVE_STATE_INACTIVE) {
 		unsigned long gid_type_mask;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
