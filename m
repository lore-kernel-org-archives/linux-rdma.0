From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: mthca - check for NULL mode in uverbs_devnode()
Date: Sat, 2 Jul 2011 12:45:45 -0500
Message-ID: <20110702174542.GA7417@baloo.cartoons>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Unloading ib_mthca crashes with a NULL pointer dereference because
devtmpfs_delete_node() calls device_get_devnode() with mode as NULL.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>

--- 
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index e49a85f..56898b6 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -826,7 +826,8 @@ static void ib_uverbs_remove_one(struct ib_device *device)
 
 static char *uverbs_devnode(struct device *dev, mode_t *mode)
 {
-	*mode = 0666;
+	if (mode)
+		*mode = 0666;
 	return kasprintf(GFP_KERNEL, "infiniband/%s", dev_name(dev));
 }
 

-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
