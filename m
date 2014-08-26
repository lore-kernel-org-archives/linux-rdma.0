From: Andreea-Cristina Bernat <bernat.ada-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] ipoib: ipoib_main: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER()
Date: Tue, 26 Aug 2014 17:49:21 +0300
Message-ID: <20140826144921.GA2950@ada>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mschmidt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

According to RCU_INIT_POINTER()'s block comment 3.a, it can be used if
"3.   The referenced data structure has already been exposed to readers either
at compile time or via rcu_assign_pointer() -and-
 a.   You have not made -any- reader-visible changes to this structure since
then".

These cases fulfill the conditions above because between the
rcu_dereference_protected() calls and the rcu_assign_pointer() calls there are
no updates of those values.
Therefore, this patch makes the replacements.

The following Coccinelle semantic patch was used:
@@
@@

- rcu_assign_pointer
+ RCU_INIT_POINTER
  (...,
(
 rtnl_dereference(...)
|
 rcu_dereference_protected(...)
) )

Signed-off-by: Andreea-Cristina Bernat <bernat.ada-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 64cd5b5..c348b14 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -929,7 +929,7 @@ static void __ipoib_reap_neigh(struct ipoib_dev_priv *priv)
 							  lockdep_is_held(&priv->lock))) != NULL) {
 			/* was the neigh idle for two GC periods */
 			if (time_after(neigh_obsolete, neigh->alive)) {
-				rcu_assign_pointer(*np,
+				RCU_INIT_POINTER(*np,
 						   rcu_dereference_protected(neigh->hnext,
 									     lockdep_is_held(&priv->lock)));
 				/* remove from path/mc list */
@@ -1024,7 +1024,7 @@ struct ipoib_neigh *ipoib_neigh_alloc(u8 *daddr,
 	atomic_inc(&neigh->refcnt);
 	neigh->alive = jiffies;
 	/* put in hash */
-	rcu_assign_pointer(neigh->hnext,
+	RCU_INIT_POINTER(neigh->hnext,
 			   rcu_dereference_protected(htbl->buckets[hash_val],
 						     lockdep_is_held(&priv->lock)));
 	rcu_assign_pointer(htbl->buckets[hash_val], neigh);
@@ -1092,7 +1092,7 @@ void ipoib_neigh_free(struct ipoib_neigh *neigh)
 					lockdep_is_held(&priv->lock))) {
 		if (n == neigh) {
 			/* found */
-			rcu_assign_pointer(*np,
+			RCU_INIT_POINTER(*np,
 					   rcu_dereference_protected(neigh->hnext,
 								     lockdep_is_held(&priv->lock)));
 			/* remove from parent list */
@@ -1177,7 +1177,7 @@ void ipoib_del_neighs_by_gid(struct net_device *dev, u8 *gid)
 							  lockdep_is_held(&priv->lock))) != NULL) {
 			/* delete neighs belong to this parent */
 			if (!memcmp(gid, neigh->daddr + 4, sizeof (union ib_gid))) {
-				rcu_assign_pointer(*np,
+				RCU_INIT_POINTER(*np,
 						   rcu_dereference_protected(neigh->hnext,
 									     lockdep_is_held(&priv->lock)));
 				/* remove from parent list */
@@ -1219,7 +1219,7 @@ static void ipoib_flush_neighs(struct ipoib_dev_priv *priv)
 
 		while ((neigh = rcu_dereference_protected(*np,
 				       lockdep_is_held(&priv->lock))) != NULL) {
-			rcu_assign_pointer(*np,
+			RCU_INIT_POINTER(*np,
 					   rcu_dereference_protected(neigh->hnext,
 								     lockdep_is_held(&priv->lock)));
 			/* remove from path/mc list */
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
