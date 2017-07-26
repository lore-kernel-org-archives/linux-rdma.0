From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-rc 01/11] IB/ipoib: Fix race between light events and interface restart
Date: Wed, 26 Jul 2017 21:12:22 +0300
Message-ID: <20170726181232.7363-2-leon@kernel.org>
References: <20170726181232.7363-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170726181232.7363-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

A potential race between light_event and interface restart
may attach multicast group to an already attached QP.

Scenario:
light_event flow goes through ipoib_mcast_dev_flush function,
if a context switch occurs before calling ipoib_mcast_remove_list,
then we may face a situation where the broadcast of the priv is null
and the corresponding QP is not detached yet.
If an "interface restart" runs during the previous context switch,
the following scenario occurs:
When the device goes up, ipoib_ib_dev_up function will be called,
it will send a new registration request to the broadcast group and then
attach the group to the QP that was not detached before.

     IPOIB_FLUSH_LIGHT                                          INTERFACE RESTART

    __ipoib_ib_dev_flush                                                |
        |                                                               |
        |                                                               |
        |                                                               |
    ipoib_mcast_dev_flush                                               |
    Move mcast list and broadcast to remove_list                        |
        |                                                               |
        |                                                               |
    Context Switch-->                                                   |
        |                                                       ipoib_ib_dev_down
        |                                                               |
        |                                                               |
        |                                                       ipoib_ib_dev_up
        |                                                               |
        |                                                               |
        |                                                       ipoib_mcast_join_task
        |                                                       allocate new broadcast
        |                                                               |
        |                                                               |
        |                                                       Attach QP to multicast group
        |                                                               |
        |                                                               |
        |                                                       <--Context Switch
    ipoib_mcast_leave
    Detach QP from multicast group

Signed-off-by: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h           | 1 +
 drivers/infiniband/ulp/ipoib/ipoib_main.c      | 1 +
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 2 ++
 3 files changed, 4 insertions(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index ff50a7bd66d8..7ac25059c40f 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -336,6 +336,7 @@ struct ipoib_dev_priv {
 	unsigned long flags;
 
 	struct rw_semaphore vlan_rwsem;
+	struct mutex mcast_mutex;
 
 	struct rb_root  path_tree;
 	struct list_head path_list;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 4ce315c92b48..144187b407bd 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1877,6 +1877,7 @@ static void ipoib_build_priv(struct net_device *dev)
 	priv->dev = dev;
 	spin_lock_init(&priv->lock);
 	init_rwsem(&priv->vlan_rwsem);
+	mutex_init(&priv->mcast_mutex);
 
 	INIT_LIST_HEAD(&priv->path_list);
 	INIT_LIST_HEAD(&priv->child_intfs);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 057f58e6afca..0a0b2ce45cbc 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -838,6 +838,7 @@ void ipoib_mcast_dev_flush(struct net_device *dev)
 	struct ipoib_mcast *mcast, *tmcast;
 	unsigned long flags;
 
+	mutex_lock(&priv->mcast_mutex);
 	ipoib_dbg_mcast(priv, "flushing multicast list\n");
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -865,6 +866,7 @@ void ipoib_mcast_dev_flush(struct net_device *dev)
 			wait_for_completion(&mcast->done);
 
 	ipoib_mcast_remove_list(&remove_list);
+	mutex_unlock(&priv->mcast_mutex);
 }
 
 static int ipoib_mcast_addr_is_valid(const u8 *addr, const u8 *broadcast)
-- 
2.13.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
