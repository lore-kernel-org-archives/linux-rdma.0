From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 14/17] IB/ocrdma: Remove and fix debug prints after allocation failure
Date: Thu,  3 Nov 2016 16:44:22 +0200
Message-ID: <1478184265-9620-15-git-send-email-leon@kernel.org>
References: <1478184265-9620-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478184265-9620-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The prints after [k|v][m|z|c]alloc() functions are not needed,
because in case of failure, allocator will print their internal
error prints anyway.

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 5 ++---
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c | 4 +---
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 67fc0b6..12b27e7 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1596,10 +1596,9 @@ void ocrdma_alloc_pd_pool(struct ocrdma_dev *dev)
 
 	dev->pd_mgr = kzalloc(sizeof(struct ocrdma_pd_resource_mgr),
 			      GFP_KERNEL);
-	if (!dev->pd_mgr) {
-		pr_err("%s(%d)Memory allocation failure.\n", __func__, dev->id);
+	if (!dev->pd_mgr)
 		return;
-	}
+
 	status = ocrdma_mbx_alloc_pd_range(dev);
 	if (status) {
 		pr_err("%s(%d) Unable to initialize PD pool, using default.\n",
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
index 8bef09a..f8e4b0a 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
@@ -84,10 +84,8 @@ bool ocrdma_alloc_stats_resources(struct ocrdma_dev *dev)
 
 	/* Alloc debugfs mem */
 	mem->debugfs_mem = kzalloc(OCRDMA_MAX_DBGFS_MEM, GFP_KERNEL);
-	if (!mem->debugfs_mem) {
-		pr_err("%s: stats debugfs mem allocation failed\n", __func__);
+	if (!mem->debugfs_mem)
 		return false;
-	}
 
 	return true;
 }
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
