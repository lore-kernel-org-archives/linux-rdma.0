From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 01/11] IB/core: Fix no default GIDs when netdevice reregisters
Date: Wed, 22 Jun 2016 17:27:22 +0300
Message-ID: <1466605652-24798-2-git-send-email-leonro@mellanox.com>
References: <1466605652-24798-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466605652-24798-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Currently, when the netdevice returned by get_netdev is unregistered,
we delete all GIDs (including the default GIDs) and reset their
attributes. Therefore, when we re-register it, no default GIDs
will be assigned (as their "default GID") attribute will be reset.
Fixing this by keeping "default GID" attribute.

Fixes: 03db3a2d81e6 ('IB/core: Add RoCE GID table management')
Signed-off-by: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cache.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 0409667..1a2984c 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -411,7 +411,9 @@ int ib_cache_gid_del_all_netdev_gids(struct ib_device *ib_dev, u8 port,
 
 	for (ix = 0; ix < table->sz; ix++)
 		if (table->data_vec[ix].attr.ndev == ndev)
-			if (!del_gid(ib_dev, port, table, ix, false))
+			if (!del_gid(ib_dev, port, table, ix,
+				     !!(table->data_vec[ix].props &
+					GID_TABLE_ENTRY_DEFAULT)))
 				deleted = true;
 
 	write_unlock_irq(&table->rwlock);
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
