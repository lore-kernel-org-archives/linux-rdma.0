From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next] IB/core: Add ordered workqueue for RoCE GID management
Date: Tue, 30 May 2017 09:58:06 +0300
Message-ID: <20170530065806.6245-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Currently the RoCE GID management uses the ib_wq to do add and delete new GIDs
according to the netdev events.

The ib_wq isn't an ordered workqueue and thus two work elements can be executed
concurrently which will result in unexpected behavior and inconsistency of the
GIDs cache content.

Example:
ifconfig eth1 11.11.11.11/16 up

This command will invoke the following netdev events in the following order:
1. NETDEV_UP
2. NETDEV_DOWN
3. NETDEV_UP

If (2) and (3) will be executed concurrently or in reverse order, instead of
having a new GID with 11.11.11.11 IP, we will end up without any new GIDs.

Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/roce_gid_mgmt.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniband/core/roce_gid_mgmt.c
index db958d3207ef..94a9eefb3cfc 100644
--- a/drivers/infiniband/core/roce_gid_mgmt.c
+++ b/drivers/infiniband/core/roce_gid_mgmt.c
@@ -42,6 +42,8 @@
 #include <rdma/ib_cache.h>
 #include <rdma/ib_addr.h>

+static struct workqueue_struct *gid_cache_wq;
+
 enum gid_op_type {
 	GID_DEL = 0,
 	GID_ADD
@@ -560,7 +562,7 @@ static int netdevice_queue_work(struct netdev_event_work_cmd *cmds,
 	}
 	INIT_WORK(&ndev_work->work, netdevice_event_work_handler);

-	queue_work(ib_wq, &ndev_work->work);
+	queue_work(gid_cache_wq, &ndev_work->work);

 	return NOTIFY_DONE;
 }
@@ -693,7 +695,7 @@ static int addr_event(struct notifier_block *this, unsigned long event,
 	dev_hold(ndev);
 	work->gid_attr.ndev   = ndev;

-	queue_work(ib_wq, &work->work);
+	queue_work(gid_cache_wq, &work->work);

 	return NOTIFY_DONE;
 }
@@ -740,6 +742,10 @@ static struct notifier_block nb_inet6addr = {

 int __init roce_gid_mgmt_init(void)
 {
+	gid_cache_wq = alloc_ordered_workqueue("gid-cache-wq", 0);
+	if (!gid_cache_wq)
+		return -ENOMEM;
+
 	register_inetaddr_notifier(&nb_inetaddr);
 	if (IS_ENABLED(CONFIG_IPV6))
 		register_inet6addr_notifier(&nb_inet6addr);
@@ -764,4 +770,5 @@ void __exit roce_gid_mgmt_cleanup(void)
 	 * ib-core is removed, all physical devices have been removed,
 	 * so no issue with remaining hardware contexts.
 	 */
+	destroy_workqueue(gid_cache_wq);
 }
--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
