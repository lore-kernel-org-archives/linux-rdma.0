From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-cm] IB/core: Fix memory corruption in ib_cache_gid_set_default_gid
Date: Thu, 15 Oct 2015 15:01:02 +0300
Message-ID: <1444910463-5688-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doron Tsur <doront-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Doron Tsur <doront-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When ib_cache_gid_set_default_gid is called from several threads,
updating the table could make find_gid fail, therefore a negative
index will be retruned and an invalid table entry will be used.
Locking find_gid as well fixes this problem.

Fixes: 03db3a2d81e6 ('IB/core: Add RoCE GID table management')
Signed-off-by: Doron Tsur <doront-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

Hi Doug,

This patch fixes a bug in RoCE GID table implementation. When several
instances executes ib_cache_gid_set_default_gid, we could try to update
the same default GID (at the same index) simultaneously.
Therefore, find_gid will fail finding this default GID and we'll hit the
WARN_ON condition.

We hit this bug while testing this code under pressure of doing ifup/ifdown.

Thanks,
Matan

 drivers/infiniband/core/cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 8f66c67..87471ef 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -508,12 +508,12 @@ void ib_cache_gid_set_default_gid(struct ib_device *ib_dev, u8 port,
 	memset(&gid_attr, 0, sizeof(gid_attr));
 	gid_attr.ndev = ndev;
 
+	mutex_lock(&table->lock);
 	ix = find_gid(table, NULL, NULL, true, GID_ATTR_FIND_MASK_DEFAULT);
 
 	/* Coudn't find default GID location */
 	WARN_ON(ix < 0);
 
-	mutex_lock(&table->lock);
 	if (!__ib_cache_gid_get(ib_dev, port, ix,
 				&current_gid, &current_gid_attr) &&
 	    mode == IB_CACHE_GID_DEFAULT_MODE_SET &&
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
