From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 18/31] IB/core: Refactor to avoid unnecessary check on GID lookup miss
Date: Tue, 14 Nov 2017 14:52:05 +0200
Message-ID: <20171114125218.20477-19-leon@kernel.org>
References: <20171114125218.20477-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114125218.20477-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Currently on every gid entry comparison miss found variable is checked;
which is not needed as those two comparison fail already indicate that
GID is not found yet.
So refactor to avoid such check and copy the GID index when found.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cache.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index e5bba898741d..72643d5a7f6d 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -573,27 +573,24 @@ static int ib_cache_gid_find_by_filter(struct ib_device *ib_dev,
 		struct ib_gid_attr attr;
 
 		if (table->data_vec[i].props & GID_TABLE_ENTRY_INVALID)
-			goto next;
+			continue;
 
 		if (memcmp(gid, &table->data_vec[i].gid, sizeof(*gid)))
-			goto next;
+			continue;
 
 		memcpy(&attr, &table->data_vec[i].attr, sizeof(attr));
 
-		if (filter(gid, &attr, context))
+		if (filter(gid, &attr, context)) {
 			found = true;
-
-next:
-		if (found)
+			if (index)
+				*index = i;
 			break;
+		}
 	}
 	read_unlock_irqrestore(&table->rwlock, flags);
 
 	if (!found)
 		return -ENOENT;
-
-	if (index)
-		*index = i;
 	return 0;
 }
 
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
