From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH fixes-3.12 07/15] mlx5: Keep polling to reclaim pages while any returned
Date: Wed, 11 Sep 2013 16:35:28 +0300
Message-ID: <1378906536-6925-8-git-send-email-ogerlitz@mellanox.com>
References: <1378906536-6925-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378906536-6925-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, elic-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Change mlx5_reclaim_startup_pages() to keep polling while any pages are
returned. If none are returned, keep polling for five more seconds before
exiting with an error message.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index 4a3e137..83bdcb3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -88,6 +88,10 @@ struct mlx5_manage_pages_outbox {
 	__be64			pas[0];
 };
 
+enum {
+	MAX_RECLAIM_TIME_MILI	= 5000,
+};
+
 static int insert_page(struct mlx5_core_dev *dev, u64 addr, struct page *page, u16 func_id)
 {
 	struct rb_root *root = &dev->priv.page_root;
@@ -283,6 +287,9 @@ static int reclaim_pages(struct mlx5_core_dev *dev, u32 func_id, int npages,
 	int err;
 	int i;
 
+	if (nclaimed)
+		*nclaimed = 0;
+
 	memset(&in, 0, sizeof(in));
 	outlen = sizeof(*out) + npages * sizeof(out->pas[0]);
 	out = mlx5_vzalloc(outlen);
@@ -394,20 +401,25 @@ static int optimal_reclaimed_pages(void)
 
 int mlx5_reclaim_startup_pages(struct mlx5_core_dev *dev)
 {
-	unsigned long end = jiffies + msecs_to_jiffies(5000);
+	unsigned long end = jiffies + msecs_to_jiffies(MAX_RECLAIM_TIME_MILI);
 	struct fw_page *fwp;
 	struct rb_node *p;
+	int nclaimed = 0;
 	int err;
 
 	do {
 		p = rb_first(&dev->priv.page_root);
 		if (p) {
 			fwp = rb_entry(p, struct fw_page, rb_node);
-			err = reclaim_pages(dev, fwp->func_id, optimal_reclaimed_pages(), NULL);
+			err = reclaim_pages(dev, fwp->func_id,
+					    optimal_reclaimed_pages(),
+					    &nclaimed);
 			if (err) {
 				mlx5_core_warn(dev, "failed reclaiming pages (%d)\n", err);
 				return err;
 			}
+			if (nclaimed)
+				end = jiffies + msecs_to_jiffies(MAX_RECLAIM_TIME_MILI);
 		}
 		if (time_after(jiffies, end)) {
 			mlx5_core_warn(dev, "FW did not return all pages. giving up...\n");
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
