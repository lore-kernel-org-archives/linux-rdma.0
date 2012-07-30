From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [for-next PATCH] IB/IPoIB: correct typo errors
Date: Mon, 30 Jul 2012 12:44:01 +0300
Message-ID: <1343641441-11942-1-git-send-email-shlomop@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

used 'ntbl->lock' instead of 'ntbl->rwlock'.
wrong pointer type in non CM stub 'ipoib_cm_enabled' in function prototype.

Reported-by: Fengguang Wu <wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Signed-off-by: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h      |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 4965f90..ca43901 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -591,7 +591,7 @@ static inline int ipoib_cm_admin_enabled(struct net_device *dev)
 {
 	return 0;
 }
-static inline int ipoib_cm_enabled(struct net_device *dev, struct neighbour *n)
+static inline int ipoib_cm_enabled(struct net_device *dev, u8 *hwaddr)
 
 {
 	return 0;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index a68ce4e..61318a7 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -882,7 +882,7 @@ static void __ipoib_reap_neigh(struct ipoib_dev_priv *priv)
 		struct ipoib_neigh __rcu **np = &htbl->buckets[i];
 
 		while ((neigh = rcu_dereference_protected(*np,
-				lockdep_is_held(&ntbl->lock))) != NULL) {
+				is_held(&ntbl->rwlock))) != NULL) {
 			/* was the neigh idle for two GC periods */
 			if (time_after(neigh_obsolete, neigh->alive)) {
 				rcu_assign_pointer(*np,
@@ -962,7 +962,7 @@ struct ipoib_neigh *ipoib_neigh_alloc(u8 *daddr,
 					    lockdep_is_held(&ntbl->rwlock));
 	     neigh != NULL;
 	     neigh = rcu_dereference_protected(neigh->hnext,
-					lockdep_is_held(&ntbl->lock))) {
+					lockdep_is_held(&ntbl->rwlock))) {
 		if (memcmp(daddr, neigh->daddr, INFINIBAND_ALEN) == 0) {
 			/* found, take one ref on behalf of the caller */
 			if (!atomic_inc_not_zero(&neigh->refcnt)) {
@@ -1051,7 +1051,7 @@ void ipoib_neigh_free(struct ipoib_neigh *neigh)
 					    lockdep_is_held(&ntbl->rwlock));
 	     n != NULL;
 	     n = rcu_dereference_protected(neigh->hnext,
-					lockdep_is_held(&ntbl->lock))) {
+					lockdep_is_held(&ntbl->rwlock))) {
 		if (n == neigh) {
 			/* found */
 			rcu_assign_pointer(*np,
@@ -1135,7 +1135,7 @@ void ipoib_del_neighs_by_gid(struct net_device *dev, u8 *gid)
 		struct ipoib_neigh __rcu **np = &htbl->buckets[i];
 
 		while ((neigh = rcu_dereference_protected(*np,
-				lockdep_is_held(&ntbl->lock))) != NULL) {
+				lockdep_is_held(&ntbl->rwlock))) != NULL) {
 			/* delete neighs belong to this parent */
 			if (!memcmp(gid, neigh->daddr + 4, sizeof (union ib_gid))) {
 				rcu_assign_pointer(*np,
@@ -1175,7 +1175,7 @@ static void ipoib_flush_neighs(struct ipoib_dev_priv *priv)
 		struct ipoib_neigh __rcu **np = &htbl->buckets[i];
 
 		while ((neigh = rcu_dereference_protected(*np,
-				lockdep_is_held(&ntbl->lock))) != NULL) {
+				lockdep_is_held(&ntbl->rwlock))) != NULL) {
 			rcu_assign_pointer(*np,
 				   rcu_dereference_protected(neigh->hnext,
 					lockdep_is_held(&ntbl->rwlock)));
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
