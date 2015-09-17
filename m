From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-rc 2/2] IB/ipoib: Add cleanup to sendonly multicast objects
Date: Thu, 17 Sep 2015 13:38:03 +0300
Message-ID: <1442486283-9699-3-git-send-email-ogerlitz@mellanox.com>
References: <1442486283-9699-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442486283-9699-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Sendonly multicast group entries are potentially created by the driver during
the xmit flow. Their objects remain in the driver memory, plus the related group
existing in the SM and the fabric till the driver goes down, even if no one
uses that multicast entry anymore.

Since this is sendonly, they are also not part of the kernel decvice multicast
list and hence invocation of the set_rx_mode ndo will not cleam them up either.

Each multicast entry has at least one neigh object, hence we can clean the
sendonly mcast object / leave the group by using the existing neigh notification
mechanism initiated from __ipoib_reap_neigh().

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h           |  6 ++
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 87 ++++++++++++++++++++++++++
 2 files changed, 93 insertions(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 5b719e2..7cbd7d1 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -417,6 +417,12 @@ struct ipoib_path {
 	int  		      valid;
 };
 
+struct ipoib_free_sendonly_task {
+	struct work_struct work;
+	struct ipoib_mcast *mcast;
+	struct ipoib_dev_priv *priv;
+};
+
 enum ipoib_neigh_state {
 	IPOIB_NEIGH_CREATED,
 	IPOIB_NEIGH_REMOVED,
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 09a1748..e3d035e 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -702,6 +702,91 @@ static int ipoib_mcast_leave(struct net_device *dev, struct ipoib_mcast *mcast)
 	return 0;
 }
 
+/* leave / free sendonly mcast */
+static void ipoib_sendonly_free_work(struct work_struct *work)
+{
+	unsigned long flags;
+	struct ipoib_mcast *tmcast;
+	bool found = false;
+	struct ipoib_free_sendonly_task *so_work =
+		container_of(work, struct ipoib_free_sendonly_task, work);
+	struct ipoib_mcast *mcast = so_work->mcast;
+	struct ipoib_dev_priv *priv = so_work->priv;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	/*
+	 * check the mcast is still in the list.
+	 * make sure we are not racing against ipoib_mcast_dev_flush
+	 */
+	list_for_each_entry(tmcast, &priv->multicast_list, list)
+		if (!memcmp(tmcast->mcmember.mgid.raw,
+			    mcast->mcmember.mgid.raw,
+			    sizeof(union ib_gid)))
+			found = true;
+
+	if (!found) {
+		pr_info("%s mcast: %pI6 already removed\n", __func__,
+			mcast->mcmember.mgid.raw);
+		spin_unlock(&priv->lock);
+		local_irq_restore(flags);
+		goto out;
+	}
+
+	/* delete from multicast_list and rb_tree */
+	rb_erase(&mcast->rb_node, &priv->multicast_tree);
+	list_del(&mcast->list);
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	/*
+	 * make sure the in-flight joins have finished before we attempt
+	 * to leave
+	 */
+	if (test_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags))
+		wait_for_completion(&mcast->done);
+
+	ipoib_mcast_leave(mcast->dev, mcast);
+	ipoib_mcast_free(mcast);
+
+out:
+	kfree(so_work);
+}
+
+/* get notification from the neigh that connected to mcast on its state */
+static int handle_neigh_state_change(struct ipoib_dev_priv *priv,
+				     enum ipoib_neigh_state state, void *context)
+{
+	struct ipoib_mcast *mcast = context;
+
+	switch (state) {
+	case IPOIB_NEIGH_REMOVED:
+		/* In sendonly the kernel doesn't clean mcast groups, so we use
+		 * the gc mechanism of the neigh that connected to that mcast in
+		 * order to clean them
+		 */
+		if (test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags)) {
+			struct ipoib_free_sendonly_task *sendonly_mcast_work;
+
+			sendonly_mcast_work = kzalloc(sizeof(*sendonly_mcast_work), GFP_KERNEL);
+			if (!sendonly_mcast_work)
+				return -ENOMEM;
+
+			INIT_WORK(&sendonly_mcast_work->work,
+				  ipoib_sendonly_free_work);
+			sendonly_mcast_work->mcast = mcast;
+			sendonly_mcast_work->priv = priv;
+			queue_work(priv->wq, &sendonly_mcast_work->work);
+		}
+		break;
+	default:
+		pr_info("%s doesn't handle state %d for mcast: %pI6\n",
+			__func__, state, mcast->mcmember.mgid.raw);
+		break;
+	}
+
+	return 0;
+}
+
 void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buff *skb)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
@@ -762,6 +847,8 @@ void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buff *skb)
 				kref_get(&mcast->ah->ref);
 				neigh->ah	= mcast->ah;
 				list_add_tail(&neigh->list, &mcast->neigh_list);
+				neigh->state_callback = handle_neigh_state_change;
+				neigh->context = mcast;
 			}
 		}
 		spin_unlock_irqrestore(&priv->lock, flags);
-- 
2.3.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
