From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 03/17] IB/core: Release allocated memory in cache setup failure
Date: Thu,  3 Nov 2016 07:02:19 +0200
Message-ID: <1478149353-12125-4-git-send-email-leon@kernel.org>
References: <1478149353-12125-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478149353-12125-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The failure in ib_cache_setup_one function during
ib_register_device will leave leaked allocated memory.

Fixes: 03db3a2d81e6 ("IB/core: Add RoCE GID table management")
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cache.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 1a2984c..ae04826 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -770,12 +770,8 @@ static int _gid_table_setup_one(struct ib_device *ib_dev)
 	int err = 0;
 
 	table = kcalloc(ib_dev->phys_port_cnt, sizeof(*table), GFP_KERNEL);
-
-	if (!table) {
-		pr_warn("failed to allocate ib gid cache for %s\n",
-			ib_dev->name);
+	if (!table)
 		return -ENOMEM;
-	}
 
 	for (port = 0; port < ib_dev->phys_port_cnt; port++) {
 		u8 rdma_port = port + rdma_start_port(ib_dev);
@@ -1170,14 +1166,13 @@ int ib_cache_setup_one(struct ib_device *device)
 					  GFP_KERNEL);
 	if (!device->cache.pkey_cache ||
 	    !device->cache.lmc_cache) {
-		pr_warn("Couldn't allocate cache for %s\n", device->name);
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto free;
 	}
 
 	err = gid_table_setup_one(device);
 	if (err)
-		/* Allocated memory will be cleaned in the release function */
-		return err;
+		goto free;
 
 	for (p = 0; p <= rdma_end_port(device) - rdma_start_port(device); ++p)
 		ib_cache_update(device, p + rdma_start_port(device));
@@ -1192,6 +1187,9 @@ int ib_cache_setup_one(struct ib_device *device)
 
 err:
 	gid_table_cleanup_one(device);
+free:
+	kfree(device->cache.pkey_cache);
+	kfree(device->cache.lmc_cache);
 	return err;
 }
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
