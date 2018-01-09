From: Denis Drozdov <denisd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 net 1/2] rtnl: device allocation/free via rtnl_link_ops
Date: Tue,  9 Jan 2018 23:42:46 +0200
Message-ID: <1515534167-13062-2-git-send-email-denisd@mellanox.com>
References: <20180101224347.xdxguvvr4g7jrxq4@inn>
 <1515534167-13062-1-git-send-email-denisd@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515534167-13062-1-git-send-email-denisd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org
Cc: jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Denis Drozdov <denisd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Introduced new rtnl_link_ops callbacks: alloc_link()
to allocate multi-queue netdev and free_link() to release
the netdevice. free_link() appoints to free_netdev by
default and could be reassigned.

These calls should be used by IB ULP code to allocate and
release both enhanced and non-enhanced IB drivers and aren't
necessary by the regular drivers.

Fixes: cd565b4b51e5 ("IB/IPoIB: Support acceleration options callbacks")
Signed-off-by: Denis Drozdov <denisd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/net/rtnetlink.h |  4 ++++
 net/core/dev.c          |  2 ++
 net/core/rtnetlink.c    | 29 ++++++++++++++++++++++-------
 3 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index ead01874..f02975e 100644
--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -70,6 +70,10 @@ struct rtnl_link_ops {
 					    struct nlattr *data[],
 					    struct netlink_ext_ack *extack);
 
+	struct net_device      *(*alloc_link)(struct net *src_net,
+					      const char *dev_name,
+					      struct nlattr *tb[]);
+	void			(*free_link)(struct net_device *dev);
 	int			(*newlink)(struct net *src_net,
 					   struct net_device *dev,
 					   struct nlattr *tb[],
diff --git a/net/core/dev.c b/net/core/dev.c
index 0e0ba36..850bcbd 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7967,6 +7967,8 @@ void netdev_run_todo(void)
 
 		if (dev->priv_destructor)
 			dev->priv_destructor(dev);
+		if (dev->rtnl_link_ops && dev->rtnl_link_ops->free_link)
+			dev->rtnl_link_ops->free_link(dev);
 		if (dev->needs_free_netdev)
 			free_netdev(dev);
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 778d7f0..a87557b 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2556,10 +2556,18 @@ struct net_device *rtnl_create_link(struct net *net,
 	else if (ops->get_num_rx_queues)
 		num_rx_queues = ops->get_num_rx_queues();
 
-	dev = alloc_netdev_mqs(ops->priv_size, ifname, name_assign_type,
-			       ops->setup, num_tx_queues, num_rx_queues);
-	if (!dev)
-		return ERR_PTR(-ENOMEM);
+	if (ops->alloc_link) {
+		dev = ops->alloc_link(net, ifname, tb);
+
+		if (IS_ERR(dev))
+			return dev;
+	} else {
+		dev = alloc_netdev_mqs(ops->priv_size, ifname,
+				       name_assign_type, ops->setup,
+				       num_tx_queues, num_rx_queues);
+		if (!dev)
+			return ERR_PTR(-ENOMEM);
+	}
 
 	dev_net_set(dev, net);
 	dev->rtnl_link_ops = ops;
@@ -2820,14 +2828,21 @@ static int rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 			 */
 			if (err < 0) {
 				/* If device is not registered at all, free it now */
-				if (dev->reg_state == NETREG_UNINITIALIZED)
-					free_netdev(dev);
+				if (dev->reg_state == NETREG_UNINITIALIZED) {
+					if (ops->free_link)
+						ops->free_link(dev);
+					else
+						free_netdev(dev);
+				}
 				goto out;
 			}
 		} else {
 			err = register_netdevice(dev);
 			if (err < 0) {
-				free_netdev(dev);
+				if (ops->free_link)
+					ops->free_link(dev);
+				else
+					free_netdev(dev);
 				goto out;
 			}
 		}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
