From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [for-next PATCH] IB/IPoIB: typo error
Date: Mon, 30 Jul 2012 18:20:30 +0300
Message-ID: <1343661630-1350-1-git-send-email-shlomop@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

was is_held should be lockdep_is_held

Reporetd by: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Signed-off-by: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 61318a7..f1ff2f4 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -882,7 +882,7 @@ static void __ipoib_reap_neigh(struct ipoib_dev_priv *priv)
 		struct ipoib_neigh __rcu **np = &htbl->buckets[i];
 
 		while ((neigh = rcu_dereference_protected(*np,
-				is_held(&ntbl->rwlock))) != NULL) {
+				lockdep_is_held(&ntbl->rwlock))) != NULL) {
 			/* was the neigh idle for two GC periods */
 			if (time_after(neigh_obsolete, neigh->alive)) {
 				rcu_assign_pointer(*np,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
