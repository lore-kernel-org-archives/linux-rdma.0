From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 5/9] IB/ipoib: Use dedicated workqueues per interface
Date: Sat, 21 Feb 2015 19:27:03 -0500
Message-ID: <1cfdf15058cea312f07c2907490a1d7300603c40.1424562072.git.dledford@redhat.com>
References: <cover.1424562072.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1424562072.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1424562072.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1424562072.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

During my recent work on the rtnl lock deadlock in the IPoIB driver, I
saw that even once I fixed the apparent races for a single device, as
soon as that device had any children, new races popped up.  It turns
out that this is because no matter how well we protect against races
on a single device, the fact that all devices use the same workqueue,
and flush_workqueue() flushes *everything* from that workqueue means
that we would also have to prevent all races between different devices
(for instance, ipoib_mcast_restart_task on interface ib0 can race with
ipoib_mcast_flush_dev on interface ib0.8002, resulting in a deadlock on
the rtnl_lock).

There are several possible solutions to this problem:

Make carrier_on_task and mcast_restart_task try to take the rtnl for
some set period of time and if they fail, then bail.  This runs the
real risk of dropping work on the floor, which can end up being its
own separate kind of deadlock.

Set some global flag in the driver that says some device is in the
middle of going down, letting all tasks know to bail.  Again, this can
drop work on the floor.

Or the method this patch attempts to use, which is when we bring an
interface up, create a workqueue specifically for that interface, so
that when we take it back down, we are flushing only those tasks
associated with our interface.  In addition, keep the global
workqueue, but now limit it to only flush tasks.  In this way, the
flush tasks can always flush the device specific work queues without
having deadlock issues.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h           |  1 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        | 18 +++++++--------
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        |  6 ++---
 drivers/infiniband/ulp/ipoib/ipoib_main.c      | 28 +++++++++++++----------
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 20 ++++++++---------
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c     | 31 +++++++++++++++++++++++---
 6 files changed, 66 insertions(+), 38 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index d7562beb542..e940cd9f847 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -317,6 +317,7 @@ struct ipoib_dev_priv {
 	struct list_head multicast_list;
 	struct rb_root multicast_tree;
 
+	struct workqueue_struct *wq;
 	struct delayed_work mcast_task;
 	struct work_struct carrier_on_task;
 	struct work_struct flush_light;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 933efcea0d0..56959adb6c7 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -474,7 +474,7 @@ static int ipoib_cm_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *even
 	}
 
 	spin_lock_irq(&priv->lock);
-	queue_delayed_work(ipoib_workqueue,
+	queue_delayed_work(priv->wq,
 			   &priv->cm.stale_task, IPOIB_CM_RX_DELAY);
 	/* Add this entry to passive ids list head, but do not re-add it
 	 * if IB_EVENT_QP_LAST_WQE_REACHED has moved it to flush list. */
@@ -576,7 +576,7 @@ void ipoib_cm_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 			spin_lock_irqsave(&priv->lock, flags);
 			list_splice_init(&priv->cm.rx_drain_list, &priv->cm.rx_reap_list);
 			ipoib_cm_start_rx_drain(priv);
-			queue_work(ipoib_workqueue, &priv->cm.rx_reap_task);
+			queue_work(priv->wq, &priv->cm.rx_reap_task);
 			spin_unlock_irqrestore(&priv->lock, flags);
 		} else
 			ipoib_warn(priv, "cm recv completion event with wrid %d (> %d)\n",
@@ -603,7 +603,7 @@ void ipoib_cm_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 				spin_lock_irqsave(&priv->lock, flags);
 				list_move(&p->list, &priv->cm.rx_reap_list);
 				spin_unlock_irqrestore(&priv->lock, flags);
-				queue_work(ipoib_workqueue, &priv->cm.rx_reap_task);
+				queue_work(priv->wq, &priv->cm.rx_reap_task);
 			}
 			return;
 		}
@@ -827,7 +827,7 @@ void ipoib_cm_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
 
 		if (test_and_clear_bit(IPOIB_FLAG_INITIALIZED, &tx->flags)) {
 			list_move(&tx->list, &priv->cm.reap_list);
-			queue_work(ipoib_workqueue, &priv->cm.reap_task);
+			queue_work(priv->wq, &priv->cm.reap_task);
 		}
 
 		clear_bit(IPOIB_FLAG_OPER_UP, &tx->flags);
@@ -1255,7 +1255,7 @@ static int ipoib_cm_tx_handler(struct ib_cm_id *cm_id,
 
 		if (test_and_clear_bit(IPOIB_FLAG_INITIALIZED, &tx->flags)) {
 			list_move(&tx->list, &priv->cm.reap_list);
-			queue_work(ipoib_workqueue, &priv->cm.reap_task);
+			queue_work(priv->wq, &priv->cm.reap_task);
 		}
 
 		spin_unlock_irqrestore(&priv->lock, flags);
@@ -1284,7 +1284,7 @@ struct ipoib_cm_tx *ipoib_cm_create_tx(struct net_device *dev, struct ipoib_path
 	tx->dev = dev;
 	list_add(&tx->list, &priv->cm.start_list);
 	set_bit(IPOIB_FLAG_INITIALIZED, &tx->flags);
-	queue_work(ipoib_workqueue, &priv->cm.start_task);
+	queue_work(priv->wq, &priv->cm.start_task);
 	return tx;
 }
 
@@ -1295,7 +1295,7 @@ void ipoib_cm_destroy_tx(struct ipoib_cm_tx *tx)
 	if (test_and_clear_bit(IPOIB_FLAG_INITIALIZED, &tx->flags)) {
 		spin_lock_irqsave(&priv->lock, flags);
 		list_move(&tx->list, &priv->cm.reap_list);
-		queue_work(ipoib_workqueue, &priv->cm.reap_task);
+		queue_work(priv->wq, &priv->cm.reap_task);
 		ipoib_dbg(priv, "Reap connection for gid %pI6\n",
 			  tx->neigh->daddr + 4);
 		tx->neigh = NULL;
@@ -1417,7 +1417,7 @@ void ipoib_cm_skb_too_long(struct net_device *dev, struct sk_buff *skb,
 
 	skb_queue_tail(&priv->cm.skb_queue, skb);
 	if (e)
-		queue_work(ipoib_workqueue, &priv->cm.skb_task);
+		queue_work(priv->wq, &priv->cm.skb_task);
 }
 
 static void ipoib_cm_rx_reap(struct work_struct *work)
@@ -1450,7 +1450,7 @@ static void ipoib_cm_stale_task(struct work_struct *work)
 	}
 
 	if (!list_empty(&priv->cm.passive_ids))
-		queue_delayed_work(ipoib_workqueue,
+		queue_delayed_work(priv->wq,
 				   &priv->cm.stale_task, IPOIB_CM_RX_DELAY);
 	spin_unlock_irq(&priv->lock);
 }
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index cb02466a0eb..2a56b7a11a9 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -655,7 +655,7 @@ void ipoib_reap_ah(struct work_struct *work)
 	__ipoib_reap_ah(dev);
 
 	if (!test_bit(IPOIB_STOP_REAPER, &priv->flags))
-		queue_delayed_work(ipoib_workqueue, &priv->ah_reap_task,
+		queue_delayed_work(priv->wq, &priv->ah_reap_task,
 				   round_jiffies_relative(HZ));
 }
 
@@ -665,7 +665,7 @@ static void ipoib_flush_ah(struct net_device *dev, int flush)
 
 	cancel_delayed_work(&priv->ah_reap_task);
 	if (flush)
-		flush_workqueue(ipoib_workqueue);
+		flush_workqueue(priv->wq);
 	ipoib_reap_ah(&priv->ah_reap_task.work);
 }
 
@@ -714,7 +714,7 @@ int ipoib_ib_dev_open(struct net_device *dev, int flush)
 	}
 
 	clear_bit(IPOIB_STOP_REAPER, &priv->flags);
-	queue_delayed_work(ipoib_workqueue, &priv->ah_reap_task,
+	queue_delayed_work(priv->wq, &priv->ah_reap_task,
 			   round_jiffies_relative(HZ));
 
 	if (!test_and_set_bit(IPOIB_FLAG_INITIALIZED, &priv->flags))
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 002ff0da9fa..64effe4faf7 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -839,7 +839,7 @@ static void ipoib_set_mcast_list(struct net_device *dev)
 		return;
 	}
 
-	queue_work(ipoib_workqueue, &priv->restart_task);
+	queue_work(priv->wq, &priv->restart_task);
 }
 
 static u32 ipoib_addr_hash(struct ipoib_neigh_hash *htbl, u8 *daddr)
@@ -954,7 +954,7 @@ static void ipoib_reap_neigh(struct work_struct *work)
 	__ipoib_reap_neigh(priv);
 
 	if (!test_bit(IPOIB_STOP_NEIGH_GC, &priv->flags))
-		queue_delayed_work(ipoib_workqueue, &priv->neigh_reap_task,
+		queue_delayed_work(priv->wq, &priv->neigh_reap_task,
 				   arp_tbl.gc_interval);
 }
 
@@ -1133,7 +1133,7 @@ static int ipoib_neigh_hash_init(struct ipoib_dev_priv *priv)
 
 	/* start garbage collection */
 	clear_bit(IPOIB_STOP_NEIGH_GC, &priv->flags);
-	queue_delayed_work(ipoib_workqueue, &priv->neigh_reap_task,
+	queue_delayed_work(priv->wq, &priv->neigh_reap_task,
 			   arp_tbl.gc_interval);
 
 	return 0;
@@ -1643,10 +1643,11 @@ sysfs_failed:
 
 register_failed:
 	ib_unregister_event_handler(&priv->event_handler);
+	flush_workqueue(ipoib_workqueue);
 	/* Stop GC if started before flush */
 	set_bit(IPOIB_STOP_NEIGH_GC, &priv->flags);
 	cancel_delayed_work(&priv->neigh_reap_task);
-	flush_workqueue(ipoib_workqueue);
+	flush_workqueue(priv->wq);
 
 event_failed:
 	ipoib_dev_cleanup(priv->dev);
@@ -1709,6 +1710,7 @@ static void ipoib_remove_one(struct ib_device *device)
 
 	list_for_each_entry_safe(priv, tmp, dev_list, list) {
 		ib_unregister_event_handler(&priv->event_handler);
+		flush_workqueue(ipoib_workqueue);
 
 		rtnl_lock();
 		dev_change_flags(priv->dev, priv->dev->flags & ~IFF_UP);
@@ -1717,7 +1719,7 @@ static void ipoib_remove_one(struct ib_device *device)
 		/* Stop GC */
 		set_bit(IPOIB_STOP_NEIGH_GC, &priv->flags);
 		cancel_delayed_work(&priv->neigh_reap_task);
-		flush_workqueue(ipoib_workqueue);
+		flush_workqueue(priv->wq);
 
 		unregister_netdev(priv->dev);
 		free_netdev(priv->dev);
@@ -1752,14 +1754,16 @@ static int __init ipoib_init_module(void)
 		return ret;
 
 	/*
-	 * We create our own workqueue mainly because we want to be
-	 * able to flush it when devices are being removed.  We can't
-	 * use schedule_work()/flush_scheduled_work() because both
-	 * unregister_netdev() and linkwatch_event take the rtnl lock,
-	 * so flush_scheduled_work() can deadlock during device
-	 * removal.
+	 * We create a global workqueue here that is used for all flush
+	 * operations.  However, if you attempt to flush a workqueue
+	 * from a task on that same workqueue, it deadlocks the system.
+	 * We want to be able to flush the tasks associated with a
+	 * specific net device, so we also create a workqueue for each
+	 * netdevice.  We queue up the tasks for that device only on
+	 * its private workqueue, and we only queue up flush events
+	 * on our global flush workqueue.  This avoids the deadlocks.
 	 */
-	ipoib_workqueue = create_singlethread_workqueue("ipoib");
+	ipoib_workqueue = create_singlethread_workqueue("ipoib_flush");
 	if (!ipoib_workqueue) {
 		ret = -ENOMEM;
 		goto err_fs;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index c63a598d0b4..9d3c1ed576e 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -403,16 +403,15 @@ static int ipoib_mcast_join_complete(int status,
 		mcast->backoff = 1;
 		mutex_lock(&mcast_mutex);
 		if (test_bit(IPOIB_MCAST_RUN, &priv->flags))
-			queue_delayed_work(ipoib_workqueue,
-					   &priv->mcast_task, 0);
+			queue_delayed_work(priv->wq, &priv->mcast_task, 0);
 		mutex_unlock(&mcast_mutex);
 
 		/*
-		 * Defer carrier on work to ipoib_workqueue to avoid a
+		 * Defer carrier on work to priv->wq to avoid a
 		 * deadlock on rtnl_lock here.
 		 */
 		if (mcast == priv->broadcast)
-			queue_work(ipoib_workqueue, &priv->carrier_on_task);
+			queue_work(priv->wq, &priv->carrier_on_task);
 
 		status = 0;
 		goto out;
@@ -438,7 +437,7 @@ static int ipoib_mcast_join_complete(int status,
 	mutex_lock(&mcast_mutex);
 	spin_lock_irq(&priv->lock);
 	if (test_bit(IPOIB_MCAST_RUN, &priv->flags))
-		queue_delayed_work(ipoib_workqueue, &priv->mcast_task,
+		queue_delayed_work(priv->wq, &priv->mcast_task,
 				   mcast->backoff * HZ);
 	spin_unlock_irq(&priv->lock);
 	mutex_unlock(&mcast_mutex);
@@ -511,8 +510,7 @@ static void ipoib_mcast_join(struct net_device *dev, struct ipoib_mcast *mcast,
 
 		mutex_lock(&mcast_mutex);
 		if (test_bit(IPOIB_MCAST_RUN, &priv->flags))
-			queue_delayed_work(ipoib_workqueue,
-					   &priv->mcast_task,
+			queue_delayed_work(priv->wq, &priv->mcast_task,
 					   mcast->backoff * HZ);
 		mutex_unlock(&mcast_mutex);
 	}
@@ -552,8 +550,8 @@ void ipoib_mcast_join_task(struct work_struct *work)
 			ipoib_warn(priv, "failed to allocate broadcast group\n");
 			mutex_lock(&mcast_mutex);
 			if (test_bit(IPOIB_MCAST_RUN, &priv->flags))
-				queue_delayed_work(ipoib_workqueue,
-						   &priv->mcast_task, HZ);
+				queue_delayed_work(priv->wq, &priv->mcast_task,
+						   HZ);
 			mutex_unlock(&mcast_mutex);
 			return;
 		}
@@ -609,7 +607,7 @@ int ipoib_mcast_start_thread(struct net_device *dev)
 
 	mutex_lock(&mcast_mutex);
 	if (!test_and_set_bit(IPOIB_MCAST_RUN, &priv->flags))
-		queue_delayed_work(ipoib_workqueue, &priv->mcast_task, 0);
+		queue_delayed_work(priv->wq, &priv->mcast_task, 0);
 	mutex_unlock(&mcast_mutex);
 
 	return 0;
@@ -627,7 +625,7 @@ int ipoib_mcast_stop_thread(struct net_device *dev, int flush)
 	mutex_unlock(&mcast_mutex);
 
 	if (flush)
-		flush_workqueue(ipoib_workqueue);
+		flush_workqueue(priv->wq);
 
 	return 0;
 }
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
index c56d5d44c53..34628403fd8 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
@@ -157,6 +157,16 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 		goto out_free_pd;
 	}
 
+	/*
+	 * the various IPoIB tasks assume they will never race against
+	 * themselves, so always use a single thread workqueue
+	 */
+	priv->wq = create_singlethread_workqueue("ipoib_wq");
+	if (!priv->wq) {
+		printk(KERN_WARNING "ipoib: failed to allocate device WQ\n");
+		goto out_free_mr;
+	}
+
 	size = ipoib_recvq_size + 1;
 	ret = ipoib_cm_dev_init(dev);
 	if (!ret) {
@@ -165,12 +175,13 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 			size += ipoib_recvq_size + 1; /* 1 extra for rx_drain_qp */
 		else
 			size += ipoib_recvq_size * ipoib_max_conn_qp;
-	}
+	} else
+		goto out_free_wq;
 
 	priv->recv_cq = ib_create_cq(priv->ca, ipoib_ib_completion, NULL, dev, size, 0);
 	if (IS_ERR(priv->recv_cq)) {
 		printk(KERN_WARNING "%s: failed to create receive CQ\n", ca->name);
-		goto out_free_mr;
+		goto out_cm_dev_cleanup;
 	}
 
 	priv->send_cq = ib_create_cq(priv->ca, ipoib_send_comp_handler, NULL,
@@ -236,12 +247,19 @@ out_free_send_cq:
 out_free_recv_cq:
 	ib_destroy_cq(priv->recv_cq);
 
+out_cm_dev_cleanup:
+	ipoib_cm_dev_cleanup(dev);
+
+out_free_wq:
+	destroy_workqueue(priv->wq);
+	priv->wq = NULL;
+
 out_free_mr:
 	ib_dereg_mr(priv->mr);
-	ipoib_cm_dev_cleanup(dev);
 
 out_free_pd:
 	ib_dealloc_pd(priv->pd);
+
 	return -ENODEV;
 }
 
@@ -265,11 +283,18 @@ void ipoib_transport_dev_cleanup(struct net_device *dev)
 
 	ipoib_cm_dev_cleanup(dev);
 
+	if (priv->wq) {
+		flush_workqueue(priv->wq);
+		destroy_workqueue(priv->wq);
+		priv->wq = NULL;
+	}
+
 	if (ib_dereg_mr(priv->mr))
 		ipoib_warn(priv, "ib_dereg_mr failed\n");
 
 	if (ib_dealloc_pd(priv->pd))
 		ipoib_warn(priv, "ib_dealloc_pd failed\n");
+
 }
 
 void ipoib_event(struct ib_event_handler *handler,
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
