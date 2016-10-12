From: David Ahern <dsa@cumulusnetworks.com>
Subject: [PATCH net-next 10/11] net: Add warning if any lower device is still in adjacency list
Date: Wed, 12 Oct 2016 13:51:58 -0700
Message-ID: <1476305519-28833-11-git-send-email-dsa@cumulusnetworks.com>
References: <1476305519-28833-1-git-send-email-dsa@cumulusnetworks.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1476305519-28833-1-git-send-email-dsa@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
To: jiri@mellanox.com, netdev@vger.kernel.org, davem@davemloft.net
Cc: dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net, jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org, David Ahern <dsa@cumulusnetworks.com>
List-Id: linux-rdma@vger.kernel.org

Lower list should be empty just like upper.

Signed-off-by: David Ahern <dsa@cumulusnetworks.com>
---
 net/core/dev.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 0f9b0985a84c..52e70a3d61a4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5361,6 +5361,20 @@ struct net_device *netdev_master_upper_dev_get(struct net_device *dev)
 }
 EXPORT_SYMBOL(netdev_master_upper_dev_get);
 
+/**
+ * netdev_has_any_lower_dev - Check if device is linked to some device
+ * @dev: device
+ *
+ * Find out if a device is linked to a lower device and return true in case
+ * it is. The caller must hold the RTNL lock.
+ */
+static bool netdev_has_any_lower_dev(struct net_device *dev)
+{
+	ASSERT_RTNL();
+
+	return !list_empty(&dev->adj_list.lower);
+}
+
 void *netdev_adjacent_get_private(struct list_head *adj_list)
 {
 	struct netdev_adjacent *adj;
@@ -6746,6 +6760,7 @@ static void rollback_registered_many(struct list_head *head)
 
 		/* Notifier chain MUST detach us all upper devices. */
 		WARN_ON(netdev_has_any_upper_dev(dev));
+		WARN_ON(netdev_has_any_lower_dev(dev));
 
 		/* Remove entries from kobject tree */
 		netdev_unregister_kobject(dev);
-- 
2.1.4
