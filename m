From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V4 for-next 4/4] IB/ipoib: Support SendOnlyFullMember MCG for SendOnly join
Date: Mon, 16 May 2016 15:28:14 +0300
Message-ID: <1463401694-19247-5-git-send-email-erezsh@mellanox.com>
References: <1463401694-19247-1-git-send-email-erezsh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1463401694-19247-1-git-send-email-erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Check (via an SA query) if the SM supports the new option for SendOnly
multicast joins.
If the SM supports that option it will use the new join state to create
such multicast group.
If SendOnlyFullMember is supported, we wouldn't use faked FullMember state
join for SendOnly MCG, use the correct state if supported.

This check is performed at every invocation of mcast_restart task, to be
sure that the driver stays in sync with the current state of the SM.

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h           |  2 +
 drivers/infiniband/ulp/ipoib/ipoib_main.c      | 72 ++++++++++++++++++++++++++
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 38 +++++++++-----
 3 files changed, 99 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index caec8e9..c51f618 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -392,6 +392,7 @@ struct ipoib_dev_priv {
 	struct ipoib_ethtool_st ethtool;
 	struct timer_list poll_timer;
 	unsigned max_send_sge;
+	bool sm_fullmember_sendonly_support;
 };
 
 struct ipoib_ah {
@@ -476,6 +477,7 @@ void ipoib_reap_ah(struct work_struct *work);
 
 void ipoib_mark_paths_invalid(struct net_device *dev);
 void ipoib_flush_paths(struct net_device *dev);
+int ipoib_check_sm_sendonly_fullmember_support(struct ipoib_dev_priv *priv);
 struct ipoib_dev_priv *ipoib_intf_alloc(const char *format);
 
 int ipoib_ib_dev_init(struct net_device *dev, struct ib_device *ca, int port);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 3b630e5..72be933 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -117,6 +117,8 @@ int ipoib_open(struct net_device *dev)
 
 	set_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags);
 
+	priv->sm_fullmember_sendonly_support = false;
+
 	if (ipoib_ib_dev_open(dev)) {
 		if (!test_bit(IPOIB_PKEY_ASSIGNED, &priv->flags))
 			return 0;
@@ -629,6 +631,76 @@ void ipoib_mark_paths_invalid(struct net_device *dev)
 	spin_unlock_irq(&priv->lock);
 }
 
+struct classport_info_context {
+	struct ipoib_dev_priv	*priv;
+	struct completion	done;
+	struct ib_sa_query	*sa_query;
+};
+
+static void classport_info_query_cb(int status, struct ib_class_port_info *rec,
+				    void *context)
+{
+	struct classport_info_context *cb_ctx = context;
+	struct ipoib_dev_priv *priv;
+
+	WARN_ON(!context);
+
+	priv = cb_ctx->priv;
+
+	if (status) {
+		pr_debug("device: %s failed query classport_info status: %d\n",
+			 priv->dev->name, status);
+		/* keeps the default, will try next mcast_restart */
+		priv->sm_fullmember_sendonly_support = false;
+		goto out;
+	}
+	if (ib_get_cpi_capmask2(rec) &
+	    IB_SA_CAP_MASK2_SENDONLY_FULL_MEM_SUPPORT) {
+		pr_debug("device: %s enabled fullmember-sendonly for sendonly MCG\n",
+			 priv->dev->name);
+		priv->sm_fullmember_sendonly_support = true;
+	} else {
+		pr_debug("device: %s disabled fullmember-sendonly for sendonly MCG\n",
+			 priv->dev->name);
+		priv->sm_fullmember_sendonly_support = false;
+	}
+
+out:
+	complete(&cb_ctx->done);
+}
+
+int ipoib_check_sm_sendonly_fullmember_support(struct ipoib_dev_priv *priv)
+{
+	struct classport_info_context *callback_context;
+	int ret;
+
+	callback_context = kmalloc(sizeof(*callback_context), GFP_KERNEL);
+	if (!callback_context)
+		return -ENOMEM;
+
+	callback_context->priv = priv;
+	init_completion(&callback_context->done);
+
+	ret = ib_sa_classport_info_rec_query(&ipoib_sa_client,
+					     priv->ca, priv->port, 3000,
+					     GFP_KERNEL,
+					     classport_info_query_cb,
+					     callback_context,
+					     &callback_context->sa_query);
+	if (ret < 0) {
+		pr_info("%s failed to send ib_sa_classport_info query, ret: %d\n",
+			priv->dev->name, ret);
+		kfree(callback_context);
+		return ret;
+	}
+
+	/* waiting for the callback to finish before returnning */
+	wait_for_completion(&callback_context->done);
+	kfree(callback_context);
+
+	return ret;
+}
+
 void ipoib_flush_paths(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 2588931..fc3e50e 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -64,6 +64,9 @@ struct ipoib_mcast_iter {
 	unsigned int       send_only;
 };
 
+/* join state that allows creating mcg with sendonly member request */
+#define SENDONLY_FULLMEMBER_JOIN	8
+
 /*
  * This should be called with the priv->lock held
  */
@@ -326,12 +329,23 @@ void ipoib_mcast_carrier_on_task(struct work_struct *work)
 	struct ipoib_dev_priv *priv = container_of(work, struct ipoib_dev_priv,
 						   carrier_on_task);
 	struct ib_port_attr attr;
+	int ret;
 
 	if (ib_query_port(priv->ca, priv->port, &attr) ||
 	    attr.state != IB_PORT_ACTIVE) {
 		ipoib_dbg(priv, "Keeping carrier off until IB port is active\n");
 		return;
 	}
+	/*
+	 * Check if can send sendonly MCG's with sendonly-fullmember join state.
+	 * It done here after the successfully join to the broadcast group,
+	 * because the broadcast group must always be joined first and is always
+	 * re-joined if the SM changes substantially.
+	 */
+	ret = ipoib_check_sm_sendonly_fullmember_support(priv);
+	if (ret < 0)
+		pr_debug("%s failed query sm support for sendonly-fullmember (ret: %d)\n",
+			 priv->dev->name, ret);
 
 	/*
 	 * Take rtnl_lock to avoid racing with ipoib_stop() and
@@ -515,22 +529,20 @@ static int ipoib_mcast_join(struct net_device *dev, struct ipoib_mcast *mcast)
 		rec.hop_limit	  = priv->broadcast->mcmember.hop_limit;
 
 		/*
-		 * Send-only IB Multicast joins do not work at the core
-		 * IB layer yet, so we can't use them here.  However,
-		 * we are emulating an Ethernet multicast send, which
-		 * does not require a multicast subscription and will
-		 * still send properly.  The most appropriate thing to
+		 * Send-only IB Multicast joins work at the core IB layer but
+		 * require specific SM support.
+		 * We can use such joins here only if the current SM supports that feature.
+		 * However, if not, we emulate an Ethernet multicast send,
+		 * which does not require a multicast subscription and will
+		 * still send properly. The most appropriate thing to
 		 * do is to create the group if it doesn't exist as that
 		 * most closely emulates the behavior, from a user space
-		 * application perspecitive, of Ethernet multicast
-		 * operation.  For now, we do a full join, maybe later
-		 * when the core IB layers support send only joins we
-		 * will use them.
+		 * application perspective, of Ethernet multicast operation.
 		 */
-#if 0
-		if (test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags))
-			rec.join_state = 4;
-#endif
+		if (test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags) &&
+		    priv->sm_fullmember_sendonly_support)
+			/* SM supports sendonly-fullmember, otherwise fallback to full-member */
+			rec.join_state = SENDONLY_FULLMEMBER_JOIN;
 	}
 	spin_unlock_irq(&priv->lock);
 
-- 
1.7.11.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
