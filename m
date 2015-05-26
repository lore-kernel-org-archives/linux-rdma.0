From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] IB/ipoib: Fix RCU annotations in ipoib_neigh_hash_init()
Date: Tue, 26 May 2015 15:03:48 +0200
Message-ID: <55646F34.9010803@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that sparse complains about ipoib_neigh_hash_init(). This
patch does not change any functionality. See also patch "IPoIB:
Fix memory leak in the neigh table deletion flow" (commit ID
66172c09938b).

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 9e1b203..fec8207 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1128,7 +1128,7 @@ static int ipoib_neigh_hash_init(struct ipoib_dev_priv *priv)
 {
 	struct ipoib_neigh_table *ntbl = &priv->ntbl;
 	struct ipoib_neigh_hash *htbl;
-	struct ipoib_neigh **buckets;
+	struct ipoib_neigh __rcu **buckets;
 	u32 size;
 
 	clear_bit(IPOIB_NEIGH_TBL_FLUSH, &priv->flags);
@@ -1146,7 +1146,7 @@ static int ipoib_neigh_hash_init(struct ipoib_dev_priv *priv)
 	htbl->size = size;
 	htbl->mask = (size - 1);
 	htbl->buckets = buckets;
-	ntbl->htbl = htbl;
+	RCU_INIT_POINTER(ntbl->htbl, htbl);
 	htbl->ntbl = ntbl;
 	atomic_set(&ntbl->entries, 0);
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
