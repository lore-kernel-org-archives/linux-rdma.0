From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-rc 1/2] IB/ipoib: Add mechanism for ipoib neigh state change notifications
Date: Thu, 17 Sep 2015 13:38:02 +0300
Message-ID: <1442486283-9699-2-git-send-email-ogerlitz@mellanox.com>
References: <1442486283-9699-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442486283-9699-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add callback function to the ipoib_neigh struct in order to add the
ability to inform the object that holds the neigh on its current state.

Each neigh object is kept by one and only one object (from type
path_record or multicast object), now this object can act accordingly
the change in the neigh state.

The callback should pay attention to the context it runs on, and should
act/run according to that context limitation, for example on the neigh
reap flow, the neigh calls the callback under spinlock etc.

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h      | 11 +++++++++++
 drivers/infiniband/ulp/ipoib/ipoib_main.c |  4 ++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index ca28736..5b719e2 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -417,6 +417,14 @@ struct ipoib_path {
 	int  		      valid;
 };
 
+enum ipoib_neigh_state {
+	IPOIB_NEIGH_CREATED,
+	IPOIB_NEIGH_REMOVED,
+};
+
+typedef int (*state_callback_fn)(struct ipoib_dev_priv *priv,
+				 enum ipoib_neigh_state state, void *context);
+
 struct ipoib_neigh {
 	struct ipoib_ah    *ah;
 #ifdef CONFIG_INFINIBAND_IPOIB_CM
@@ -432,6 +440,9 @@ struct ipoib_neigh {
 	struct rcu_head     rcu;
 	atomic_t	    refcnt;
 	unsigned long       alive;
+	/* add the ability to notify the objects that hold that neigh */
+	state_callback_fn state_callback;
+	void *context;
 };
 
 #define IPOIB_UD_MTU(ib_mtu)		(ib_mtu - IPOIB_ENCAP_LEN)
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 36536ce..6176441 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1179,6 +1179,10 @@ static void __ipoib_reap_neigh(struct ipoib_dev_priv *priv)
 				rcu_assign_pointer(*np,
 						   rcu_dereference_protected(neigh->hnext,
 									     lockdep_is_held(&priv->lock)));
+				/* inform state if requested */
+				if (neigh->state_callback != NULL)
+					neigh->state_callback(priv, IPOIB_NEIGH_REMOVED, neigh->context);
+
 				/* remove from path/mc list */
 				list_del(&neigh->list);
 				call_rcu(&neigh->rcu, ipoib_neigh_reclaim);
-- 
2.3.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
