From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH fixes 2/2] IB/ipoib: Fix RCU pointer dereference to wrong object
Date: Mon, 13 Aug 2012 17:39:50 +0300
Message-ID: <1344868790-21146-3-git-send-email-ogerlitz@mellanox.com>
References: <1344868790-21146-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1344868790-21146-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Commit 63b70d8 "IPoIB: Use a private hash table for path lookup
in xmit path" introduced a bug where in ipoib_neigh_free (which
is called from few errors flows in the driver) rcu_dereference is
invoked with the wrong pointer object, which results in a crash.

Signed-off-by: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 97920b7..3e2085a 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1052,7 +1052,7 @@ void ipoib_neigh_free(struct ipoib_neigh *neigh)
 	for (n = rcu_dereference_protected(*np,
 					    lockdep_is_held(&ntbl->rwlock));
 	     n != NULL;
-	     n = rcu_dereference_protected(neigh->hnext,
+	     n = rcu_dereference_protected(*np,
 					lockdep_is_held(&ntbl->rwlock))) {
 		if (n == neigh) {
 			/* found */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
