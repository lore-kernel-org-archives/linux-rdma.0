From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 4/7] IB/core: Fix removal of default GID cache entry
Date: Sat,  4 Jun 2016 15:15:21 +0300
Message-ID: <1465042524-25852-5-git-send-email-leon@kernel.org>
References: <1465042524-25852-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465042524-25852-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aviv Heller <avivh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Aviv Heller <avivh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When deleting a default GID from the cache, its gid_type field is set
to 0.

This could set the gid_type to RoCE v1 for a RoCE v2 default GID,
essentially making it inaccessible to future modifications, since it
is no longer found by find_gid().

This fix preserves the gid_type value for default gids during cache
operations.

Fixes: b39ffa1df505 ('IB/core: Add gid_type to gid attribute')
Signed-off-by: Aviv Heller <avivh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cache.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index c2e257d..0409667 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -178,6 +178,7 @@ static int write_gid(struct ib_device *ib_dev, u8 port,
 {
 	int ret = 0;
 	struct net_device *old_net_dev;
+	enum ib_gid_type old_gid_type;
 
 	/* in rdma_cap_roce_gid_table, this funciton should be protected by a
 	 * sleep-able lock.
@@ -199,6 +200,7 @@ static int write_gid(struct ib_device *ib_dev, u8 port,
 	}
 
 	old_net_dev = table->data_vec[ix].attr.ndev;
+	old_gid_type = table->data_vec[ix].attr.gid_type;
 	if (old_net_dev && old_net_dev != attr->ndev)
 		dev_put(old_net_dev);
 	/* if modify_gid failed, just delete the old gid */
@@ -207,10 +209,14 @@ static int write_gid(struct ib_device *ib_dev, u8 port,
 		attr = &zattr;
 		table->data_vec[ix].context = NULL;
 	}
-	if (default_gid)
-		table->data_vec[ix].props |= GID_TABLE_ENTRY_DEFAULT;
+
 	memcpy(&table->data_vec[ix].gid, gid, sizeof(*gid));
 	memcpy(&table->data_vec[ix].attr, attr, sizeof(*attr));
+	if (default_gid) {
+		table->data_vec[ix].props |= GID_TABLE_ENTRY_DEFAULT;
+		if (action == GID_TABLE_WRITE_ACTION_DEL)
+			table->data_vec[ix].attr.gid_type = old_gid_type;
+	}
 	if (table->data_vec[ix].attr.ndev &&
 	    table->data_vec[ix].attr.ndev != old_net_dev)
 		dev_hold(table->data_vec[ix].attr.ndev);
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
