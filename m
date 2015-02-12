From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 05/22] IB/ipoib: change init sequence ordering
Date: Wed, 11 Feb 2015 20:43:28 -0500
Message-ID: <62512e3bfc58b85b706fdbde8b06f1476b21a376.1423703861.git.dledford@redhat.com>
References: <cover.1423703861.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1423703861.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1423703861.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1423703861.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In preparation for using per device work queues, we need to move the
start of the neighbor thread task to after ipoib_ib_dev_init and move
the destruction of the neighbor task to before ipoib_ib_dev_cleanup.
Otherwise we will end up freeing our workqueue with work possibly
still on it.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 58b5aa3b6f2..2cf81ef5141 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1262,15 +1262,13 @@ int ipoib_dev_init(struct net_device *dev, struct ib_device *ca, int port)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 
-	if (ipoib_neigh_hash_init(priv) < 0)
-		goto out;
 	/* Allocate RX/TX "rings" to hold queued skbs */
 	priv->rx_ring =	kzalloc(ipoib_recvq_size * sizeof *priv->rx_ring,
 				GFP_KERNEL);
 	if (!priv->rx_ring) {
 		printk(KERN_WARNING "%s: failed to allocate RX ring (%d entries)\n",
 		       ca->name, ipoib_recvq_size);
-		goto out_neigh_hash_cleanup;
+		goto out;
 	}
 
 	priv->tx_ring = vzalloc(ipoib_sendq_size * sizeof *priv->tx_ring);
@@ -1285,16 +1283,24 @@ int ipoib_dev_init(struct net_device *dev, struct ib_device *ca, int port)
 	if (ipoib_ib_dev_init(dev, ca, port))
 		goto out_tx_ring_cleanup;
 
+	/*
+	 * Must be after ipoib_ib_dev_init so we can allocate a per
+	 * device wq there and use it here
+	 */
+	if (ipoib_neigh_hash_init(priv) < 0)
+		goto out_dev_uninit;
+
 	return 0;
 
+out_dev_uninit:
+	ipoib_ib_dev_cleanup();
+
 out_tx_ring_cleanup:
 	vfree(priv->tx_ring);
 
 out_rx_ring_cleanup:
 	kfree(priv->rx_ring);
 
-out_neigh_hash_cleanup:
-	ipoib_neigh_hash_uninit(dev);
 out:
 	return -ENOMEM;
 }
@@ -1317,6 +1323,12 @@ void ipoib_dev_cleanup(struct net_device *dev)
 	}
 	unregister_netdevice_many(&head);
 
+	/*
+	 * Must be before ipoib_ib_dev_cleanup or we delete an in use
+	 * work queue
+	 */
+	ipoib_neigh_hash_uninit(dev);
+
 	ipoib_ib_dev_cleanup(dev);
 
 	kfree(priv->rx_ring);
@@ -1324,8 +1336,6 @@ void ipoib_dev_cleanup(struct net_device *dev)
 
 	priv->rx_ring = NULL;
 	priv->tx_ring = NULL;
-
-	ipoib_neigh_hash_uninit(dev);
 }
 
 static const struct header_ops ipoib_header_ops = {
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
