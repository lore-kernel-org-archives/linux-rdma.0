From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next V2 2/6] IB/IPoIB: Separate control and data related initializations
Date: Mon, 10 Apr 2017 11:22:26 +0300
Message-ID: <20170410082230.10662-3-leonro@mellanox.com>
References: <20170410082230.10662-1-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170410082230.10662-1-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch prepares init and teardown flows so we can call them
through ipoib_options function pointers.

It arranges that area of code as the following:
 * All operations which deal with the resource allocation/deletion
   are performed in one place.
 * All operations that are control oriented, meaning that they are not
   connected to a specific hardware, are performed in a separate place.

The operations for allocation of hardware resources are now in the
function ipoib_dev_init_default, and the deletion of all the resources
are in ipoib_dev_uninit_default

The only exception is the creation of the PD object,
which is used both for resource allocation (create QP etc.)
and for control flows like creating AH.

It also does:
 * Move creation of rx_ring and tx_ring to be in the resources
   allocation area.
 * Move the function ipoib_ib_dev_open that does the open device
   to the control area instead of the dev_init which creates resources.

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h       |   3 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c    |  38 +++-------
 drivers/infiniband/ulp/ipoib/ipoib_main.c  | 116 ++++++++++++++++++++++++-----
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c |  40 +---------
 4 files changed, 109 insertions(+), 88 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index bed233bf45c3..bc71a90c57e3 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -492,13 +492,14 @@ void ipoib_flush_paths(struct net_device *dev);
 int ipoib_check_sm_sendonly_fullmember_support(struct ipoib_dev_priv *priv);
 struct ipoib_dev_priv *ipoib_intf_alloc(const char *format);

-int ipoib_ib_dev_init(struct net_device *dev, struct ib_device *ca, int port);
+void ipoib_ib_tx_timer_func(unsigned long ctx);
 void ipoib_ib_dev_flush_light(struct work_struct *work);
 void ipoib_ib_dev_flush_normal(struct work_struct *work);
 void ipoib_ib_dev_flush_heavy(struct work_struct *work);
 void ipoib_pkey_event(struct work_struct *work);
 void ipoib_ib_dev_cleanup(struct net_device *dev);

+void ipoib_dev_uninit_default(struct net_device *dev);
 int ipoib_ib_dev_open(struct net_device *dev);
 void ipoib_ib_dev_up(struct net_device *dev);
 void ipoib_ib_dev_down(struct net_device *dev);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 12c4f84a6639..f9dd2bb676aa 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -692,7 +692,7 @@ static void ipoib_stop_ah(struct net_device *dev)
 	ipoib_flush_ah(dev);
 }

-static void ipoib_ib_tx_timer_func(unsigned long ctx)
+void ipoib_ib_tx_timer_func(unsigned long ctx)
 {
 	drain_tx_cq((struct net_device *)ctx);
 }
@@ -913,32 +913,6 @@ void ipoib_ib_dev_stop(struct net_device *dev)
 	ib_req_notify_cq(priv->recv_cq, IB_CQ_NEXT_COMP);
 }

-int ipoib_ib_dev_init(struct net_device *dev, struct ib_device *ca, int port)
-{
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
-
-	priv->ca = ca;
-	priv->port = port;
-	priv->qp = NULL;
-
-	if (ipoib_transport_dev_init(dev, ca)) {
-		printk(KERN_WARNING "%s: ipoib_transport_dev_init failed\n", ca->name);
-		return -ENODEV;
-	}
-
-	setup_timer(&priv->poll_timer, ipoib_ib_tx_timer_func,
-		    (unsigned long) dev);
-
-	if (dev->flags & IFF_UP) {
-		if (ipoib_ib_dev_open(dev)) {
-			ipoib_transport_dev_cleanup(dev);
-			return -ENODEV;
-		}
-	}
-
-	return 0;
-}
-
 /*
  * Takes whatever value which is in pkey index 0 and updates priv->pkey
  * returns 0 if the pkey value was changed.
@@ -1236,7 +1210,13 @@ void ipoib_ib_dev_cleanup(struct net_device *dev)
 	 */
 	ipoib_stop_ah(dev);

-	ipoib_transport_dev_cleanup(dev);
-}
+	clear_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
+
+	ipoib_dev_uninit_default(dev);

+	if (priv->pd) {
+		ib_dealloc_pd(priv->pd);
+		priv->pd = NULL;
+	}
+}

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index d1d3fb7a6127..ef8e51ccb1cd 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1622,8 +1622,23 @@ static void ipoib_neigh_hash_uninit(struct net_device *dev)
 	wait_for_completion(&priv->ntbl.deleted);
 }

+void ipoib_dev_uninit_default(struct net_device *dev)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);

-int ipoib_dev_init(struct net_device *dev, struct ib_device *ca, int port)
+	ipoib_transport_dev_cleanup(dev);
+
+	ipoib_cm_dev_cleanup(dev);
+
+	kfree(priv->rx_ring);
+	vfree(priv->tx_ring);
+
+	priv->rx_ring = NULL;
+	priv->tx_ring = NULL;
+}
+
+static int ipoib_dev_init_default(struct net_device *dev, struct ib_device *ca,
+				  int port)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);

@@ -1642,29 +1657,95 @@ int ipoib_dev_init(struct net_device *dev, struct ib_device *ca, int port)

 	/* priv->tx_head, tx_tail & tx_outstanding are already 0 */

-	if (ipoib_ib_dev_init(dev, ca, port))
+	if (ipoib_transport_dev_init(dev, ca)) {
+		pr_warn("%s: ipoib_transport_dev_init failed\n", ca->name);
 		goto out_tx_ring_cleanup;
+	}
+
+	setup_timer(&priv->poll_timer, ipoib_ib_tx_timer_func,
+		    (unsigned long)dev);
+
+	return 0;
+
+out_tx_ring_cleanup:
+	vfree(priv->tx_ring);
+
+out_rx_ring_cleanup:
+	kfree(priv->rx_ring);
+
+out:
+	return -ENOMEM;
+}
+
+int ipoib_dev_init(struct net_device *dev, struct ib_device *ca, int port)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	int ret = -ENOMEM;
+
+	priv->ca = ca;
+	priv->port = port;
+	priv->qp = NULL;

 	/*
-	 * Must be after ipoib_ib_dev_init so we can allocate a per
-	 * device wq there and use it here
+	 * the various IPoIB tasks assume they will never race against
+	 * themselves, so always use a single thread workqueue
 	 */
-	if (ipoib_neigh_hash_init(priv) < 0)
+	priv->wq = alloc_ordered_workqueue("ipoib_wq", WQ_MEM_RECLAIM);
+	if (!priv->wq) {
+		pr_warn("%s: failed to allocate device WQ\n", dev->name);
+		goto out;
+	}
+
+	/* create pd, which used both for control and datapath*/
+	priv->pd = ib_alloc_pd(priv->ca, 0);
+	if (IS_ERR(priv->pd)) {
+		pr_warn("%s: failed to allocate PD\n", ca->name);
+		goto clean_wq;
+	}
+
+	ret = ipoib_dev_init_default(dev, ca, port);
+	if (ret) {
+		pr_warn("%s failed to init HW resource\n", dev->name);
+		goto out_free_pd;
+	}
+
+	/* after qp created set dev address */
+	priv->dev->dev_addr[1] = (priv->qp->qp_num >> 16) & 0xff;
+	priv->dev->dev_addr[2] = (priv->qp->qp_num >>  8) & 0xff;
+	priv->dev->dev_addr[3] = (priv->qp->qp_num) & 0xff;
+
+	if (ipoib_neigh_hash_init(priv) < 0) {
+		pr_warn("%s failed to init neigh hash\n", dev->name);
 		goto out_dev_uninit;
+	}
+
+	if (dev->flags & IFF_UP) {
+		if (ipoib_ib_dev_open(dev)) {
+			pr_warn("%s failed to open device\n", dev->name);
+			ret = -ENODEV;
+			goto out_dev_uninit;
+		}
+	}

 	return 0;

 out_dev_uninit:
 	ipoib_ib_dev_cleanup(dev);

-out_tx_ring_cleanup:
-	vfree(priv->tx_ring);
+out_free_pd:
+	if (priv->pd) {
+		ib_dealloc_pd(priv->pd);
+		priv->pd = NULL;
+	}

-out_rx_ring_cleanup:
-	kfree(priv->rx_ring);
+clean_wq:
+	if (priv->wq) {
+		destroy_workqueue(priv->wq);
+		priv->wq = NULL;
+	}

 out:
-	return -ENOMEM;
+	return ret;
 }

 void ipoib_dev_cleanup(struct net_device *dev)
@@ -1685,19 +1766,16 @@ void ipoib_dev_cleanup(struct net_device *dev)
 	}
 	unregister_netdevice_many(&head);

-	/*
-	 * Must be before ipoib_ib_dev_cleanup or we delete an in use
-	 * work queue
-	 */
 	ipoib_neigh_hash_uninit(dev);

 	ipoib_ib_dev_cleanup(dev);

-	kfree(priv->rx_ring);
-	vfree(priv->tx_ring);
-
-	priv->rx_ring = NULL;
-	priv->tx_ring = NULL;
+	/* no more works over the priv->wq */
+	if (priv->wq) {
+		flush_workqueue(priv->wq);
+		destroy_workqueue(priv->wq);
+		priv->wq = NULL;
+	}
 }

 static int ipoib_set_vf_link_state(struct net_device *dev, int vf, int link_state)
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
index 189dcd1709d2..529b9509a2c4 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
@@ -147,22 +147,6 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 	int ret, size;
 	int i;

-	priv->pd = ib_alloc_pd(priv->ca, 0);
-	if (IS_ERR(priv->pd)) {
-		printk(KERN_WARNING "%s: failed to allocate PD\n", ca->name);
-		return -ENODEV;
-	}
-
-	/*
-	 * the various IPoIB tasks assume they will never race against
-	 * themselves, so always use a single thread workqueue
-	 */
-	priv->wq = alloc_ordered_workqueue("ipoib_wq", WQ_MEM_RECLAIM);
-	if (!priv->wq) {
-		printk(KERN_WARNING "ipoib: failed to allocate device WQ\n");
-		goto out_free_pd;
-	}
-
 	size = ipoib_recvq_size + 1;
 	ret = ipoib_cm_dev_init(dev);
 	if (!ret) {
@@ -173,7 +157,7 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 			size += ipoib_recvq_size * ipoib_max_conn_qp;
 	} else
 		if (ret != -ENOSYS)
-			goto out_free_wq;
+			return -ENODEV;

 	cq_attr.cqe = size;
 	priv->recv_cq = ib_create_cq(priv->ca, ipoib_ib_completion, NULL,
@@ -212,10 +196,6 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 		goto out_free_send_cq;
 	}

-	priv->dev->dev_addr[1] = (priv->qp->qp_num >> 16) & 0xff;
-	priv->dev->dev_addr[2] = (priv->qp->qp_num >>  8) & 0xff;
-	priv->dev->dev_addr[3] = (priv->qp->qp_num      ) & 0xff;
-
 	for (i = 0; i < MAX_SKB_FRAGS + 1; ++i)
 		priv->tx_sge[i].lkey = priv->pd->local_dma_lkey;

@@ -247,13 +227,6 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 out_cm_dev_cleanup:
 	ipoib_cm_dev_cleanup(dev);

-out_free_wq:
-	destroy_workqueue(priv->wq);
-	priv->wq = NULL;
-
-out_free_pd:
-	ib_dealloc_pd(priv->pd);
-
 	return -ENODEV;
 }

@@ -266,7 +239,6 @@ void ipoib_transport_dev_cleanup(struct net_device *dev)
 			ipoib_warn(priv, "ib_qp_destroy failed\n");

 		priv->qp = NULL;
-		clear_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
 	}

 	if (ib_destroy_cq(priv->send_cq))
@@ -274,16 +246,6 @@ void ipoib_transport_dev_cleanup(struct net_device *dev)

 	if (ib_destroy_cq(priv->recv_cq))
 		ipoib_warn(priv, "ib_cq_destroy (recv) failed\n");
-
-	ipoib_cm_dev_cleanup(dev);
-
-	if (priv->wq) {
-		flush_workqueue(priv->wq);
-		destroy_workqueue(priv->wq);
-		priv->wq = NULL;
-	}
-
-	ib_dealloc_pd(priv->pd);
 }

 void ipoib_event(struct ib_event_handler *handler,
--
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
