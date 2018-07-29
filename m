From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 02/10] IB/ipoib: Use cancel_delayed_work_sync for neigh-clean task
Date: Sun, 29 Jul 2018 11:34:52 +0300
Message-ID: <20180729083500.5352-3-leon@kernel.org>
References: <20180729083500.5352-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180729083500.5352-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Denis Drozdov <denisd@mellanox.com>, Erez Shitrit <erezsh@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh@mellanox.com>

The neigh_reap_task is self restarting, but so long as we call
cancel_delayed_work_sync() it will be guaranteed to not be running and
never start again. Thus we don't need to have the racy
IPOIB_STOP_NEIGH_GC bit, or the confusing mismatch of places sometimes
calling flush_workqueue after the cancel.

This fixes a situation where the GC work could have been left running
in some rare situations.

Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 7ca9013bf05c..7cd42619deb2 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1661,7 +1661,7 @@ static void ipoib_neigh_hash_uninit(struct net_device *dev)
 	/* Stop GC if called at init fail need to cancel work */
 	stopped = test_and_set_bit(IPOIB_STOP_NEIGH_GC, &priv->flags);
 	if (!stopped)
-		cancel_delayed_work(&priv->neigh_reap_task);
+		cancel_delayed_work_sync(&priv->neigh_reap_task);
 
 	ipoib_flush_neighs(priv);
 
@@ -1837,7 +1837,7 @@ void ipoib_dev_cleanup(struct net_device *dev)
 	list_for_each_entry_safe(cpriv, tcpriv, &priv->child_intfs, list) {
 		/* Stop GC on child */
 		set_bit(IPOIB_STOP_NEIGH_GC, &cpriv->flags);
-		cancel_delayed_work(&cpriv->neigh_reap_task);
+		cancel_delayed_work_sync(&cpriv->neigh_reap_task);
 		unregister_netdevice_queue(cpriv->dev, &head);
 	}
 	unregister_netdevice_many(&head);
@@ -2346,7 +2346,7 @@ static struct net_device *ipoib_add_port(const char *format,
 	flush_workqueue(ipoib_workqueue);
 	/* Stop GC if started before flush */
 	set_bit(IPOIB_STOP_NEIGH_GC, &priv->flags);
-	cancel_delayed_work(&priv->neigh_reap_task);
+	cancel_delayed_work_sync(&priv->neigh_reap_task);
 	flush_workqueue(priv->wq);
 	ipoib_dev_cleanup(priv->dev);
 
@@ -2412,7 +2412,7 @@ static void ipoib_remove_one(struct ib_device *device, void *client_data)
 
 		/* Stop GC */
 		set_bit(IPOIB_STOP_NEIGH_GC, &priv->flags);
-		cancel_delayed_work(&priv->neigh_reap_task);
+		cancel_delayed_work_sync(&priv->neigh_reap_task);
 		flush_workqueue(priv->wq);
 
 		/* Wrap rtnl_lock/unlock with mutex to protect sysfs calls */
-- 
2.14.4
