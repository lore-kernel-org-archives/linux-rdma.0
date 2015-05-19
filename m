From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v4 for-next 05/14] net: Add info for NETDEV_CHANGEUPPER event
Date: Tue, 19 May 2015 17:27:08 +0300
Message-ID: <1432045637-9090-6-git-send-email-matanb@mellanox.com>
References: <1432045637-9090-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432045637-9090-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Consumers of NETDEV_CHANGEUPPER event sometimes want
to know which upper device was linked/unlinked and which
operation was carried. Adding extra information in the
notifier info block.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/linux/netdevice.h | 14 ++++++++++++++
 net/core/dev.c            | 12 ++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index dbad4d7..637cc21 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3554,6 +3554,20 @@ struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 struct sk_buff *skb_mac_gso_segment(struct sk_buff *skb,
 				    netdev_features_t features);
 
+enum netdev_changeupper_event {
+	NETDEV_CHANGEUPPER_LINK,
+	NETDEV_CHANGEUPPER_UNLINK,
+};
+
+struct netdev_changeupper_info {
+	struct netdev_notifier_info	info; /* must be first */
+	enum netdev_changeupper_event	event;
+	struct net_device		*upper;
+};
+
+void netdev_changeupper_info_change(struct net_device *dev,
+				    struct netdev_changeupper_info *info);
+
 struct netdev_bonding_info {
 	ifslave	slave;
 	ifbond	master;
diff --git a/net/core/dev.c b/net/core/dev.c
index c7ba038..b52f648 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5198,6 +5198,7 @@ static int __netdev_upper_dev_link(struct net_device *dev,
 				   void *private)
 {
 	struct netdev_adjacent *i, *j, *to_i, *to_j;
+	struct netdev_changeupper_info changeupper_info;
 	int ret = 0;
 
 	ASSERT_RTNL();
@@ -5253,7 +5254,10 @@ static int __netdev_upper_dev_link(struct net_device *dev,
 			goto rollback_lower_mesh;
 	}
 
-	call_netdevice_notifiers(NETDEV_CHANGEUPPER, dev);
+	changeupper_info.event = NETDEV_CHANGEUPPER_LINK;
+	changeupper_info.upper = upper_dev;
+	call_netdevice_notifiers_info(NETDEV_CHANGEUPPER, dev,
+				      &changeupper_info.info);
 	return 0;
 
 rollback_lower_mesh:
@@ -5349,6 +5353,7 @@ void netdev_upper_dev_unlink(struct net_device *dev,
 			     struct net_device *upper_dev)
 {
 	struct netdev_adjacent *i, *j;
+	struct netdev_changeupper_info changeupper_info;
 	ASSERT_RTNL();
 
 	__netdev_adjacent_dev_unlink_neighbour(dev, upper_dev);
@@ -5370,7 +5375,10 @@ void netdev_upper_dev_unlink(struct net_device *dev,
 	list_for_each_entry(i, &upper_dev->all_adj_list.upper, list)
 		__netdev_adjacent_dev_unlink(dev, i->dev);
 
-	call_netdevice_notifiers(NETDEV_CHANGEUPPER, dev);
+	changeupper_info.event = NETDEV_CHANGEUPPER_UNLINK;
+	changeupper_info.upper = upper_dev;
+	call_netdevice_notifiers_info(NETDEV_CHANGEUPPER, dev,
+				      &changeupper_info.info);
 }
 EXPORT_SYMBOL(netdev_upper_dev_unlink);
 
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
