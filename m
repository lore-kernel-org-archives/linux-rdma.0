From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 9/9] mlx5_core: Change optimal_reclaimed_pages for better performance
Date: Wed, 23 Oct 2013 09:53:21 +0300
Message-ID: <1382511201-7061-10-git-send-email-eli@mellanox.com>
References: <1382511201-7061-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382511201-7061-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Change optimal_reclaimed_pages() to increase the output size of each reclaim
pages command. This change reduces significantly the amount of reclaim pages
commands issued to FW when the driver is unloaded which reduces the overall
driver unload time.

Signed-off-by: Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index 013aa42..ba816c2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -454,14 +454,19 @@ int mlx5_satisfy_startup_pages(struct mlx5_core_dev *dev, int boot)
 	return give_pages(dev, func_id, npages, 0);
 }
 
+enum {
+	MLX5_BLKS_FOR_RECLAIM_PAGES = 12
+};
+
 static int optimal_reclaimed_pages(void)
 {
 	struct mlx5_cmd_prot_block *block;
 	struct mlx5_cmd_layout *lay;
 	int ret;
 
-	ret = (sizeof(lay->in) + sizeof(block->data) -
-	       sizeof(struct mlx5_manage_pages_outbox)) / 8;
+	ret = (sizeof(lay->out) + MLX5_BLKS_FOR_RECLAIM_PAGES * sizeof(block->data) -
+	       sizeof(struct mlx5_manage_pages_outbox)) /
+	       FIELD_SIZEOF(struct mlx5_manage_pages_outbox, pas[0]);
 
 	return ret;
 }
-- 
1.8.1.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
