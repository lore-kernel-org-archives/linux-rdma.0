From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v1 03/15] IB/core: Change roce_rescan_device to return void
Date: Thu,  4 Jan 2018 11:06:33 +0200
Message-ID: <20180104090645.4901-4-leon@kernel.org>
References: <20180104090645.4901-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180104090645.4901-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

It always returns 0. Change return type to void.

Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cache.c         | 7 +------
 drivers/infiniband/core/core_priv.h     | 2 +-
 drivers/infiniband/core/roce_gid_mgmt.c | 4 +---
 3 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 7babdbceb6d0..fc4022884dbb 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -821,12 +821,7 @@ static int gid_table_setup_one(struct ib_device *ib_dev)
 	if (err)
 		return err;
 
-	err = roce_rescan_device(ib_dev);
-
-	if (err) {
-		gid_table_cleanup_one(ib_dev);
-		gid_table_release_one(ib_dev);
-	}
+	roce_rescan_device(ib_dev);
 
 	return err;
 }
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 0b62ff4bbb25..6b58267b64c6 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -138,7 +138,7 @@ int ib_cache_gid_del_all_netdev_gids(struct ib_device *ib_dev, u8 port,
 int roce_gid_mgmt_init(void);
 void roce_gid_mgmt_cleanup(void);
 
-int roce_rescan_device(struct ib_device *ib_dev);
+void roce_rescan_device(struct ib_device *ib_dev);
 unsigned long roce_gid_type_mask_support(struct ib_device *ib_dev, u8 port);
 
 int ib_cache_setup_one(struct ib_device *device);
diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniband/core/roce_gid_mgmt.c
index 90e3889b7fbe..ebfe45739ca7 100644
--- a/drivers/infiniband/core/roce_gid_mgmt.c
+++ b/drivers/infiniband/core/roce_gid_mgmt.c
@@ -412,12 +412,10 @@ static void enum_all_gids_of_dev_cb(struct ib_device *ib_dev,
 
 /* This function will rescan all of the network devices in the system
  * and add their gids, as needed, to the relevant RoCE devices. */
-int roce_rescan_device(struct ib_device *ib_dev)
+void roce_rescan_device(struct ib_device *ib_dev)
 {
 	ib_enum_roce_netdev(ib_dev, pass_all_filter, NULL,
 			    enum_all_gids_of_dev_cb, NULL);
-
-	return 0;
 }
 
 static void callback_for_addr_gid_device_scan(struct ib_device *device,
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
