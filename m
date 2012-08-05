From: yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Subject: [PATCH] net/mlx4_core: Fix num mtt issues
Date: Sun,  5 Aug 2012 19:37:31 +0300
Message-ID: <1344184651-22151-1-git-send-email-yishaih@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch solves 2 issues:
driver failed to load when log num mtt is 26 or higher

- In that case the required allocation is 4MB or higher and kmalloc
  fails.

- In case of error vmalloc/vfree functions are used instead of
  kmalloc/kfree

mlx4 core limitation of log num mtt higher than 28
- In that case driver failed to load as of crossing the 2GB ICM
  boundary.

- When we auto scaling number of MTTs with the size of the system memory
  this limit should be considered.

TODO: fix the reason why the value 28 is the higher bound to log num mtt.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/mlx4.h    |    5 +++++
 drivers/net/ethernet/mellanox/mlx4/mr.c      |   21 +++++++++++++++------
 drivers/net/ethernet/mellanox/mlx4/profile.c |    7 ++++---
 3 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
index 59ebc03..964e33c 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -60,6 +60,11 @@
 #define MLX4_FS_MGM_LOG_ENTRY_SIZE	7
 #define MLX4_FS_NUM_MCG			(1 << 17)
 
+/* When a higher value than 28 is used we get a failure via initializing
+     the event queue table as of trying to allocate more than 2GB in ICM.
+*/
+#define MLX4_MAX_LOG_NUM_MTT 28
+
 enum {
 	MLX4_FS_L2_HASH = 0,
 	MLX4_FS_L2_L3_L4_HASH,
diff --git a/drivers/net/ethernet/mellanox/mlx4/mr.c b/drivers/net/ethernet/mellanox/mlx4/mr.c
index af55b7c..31f672a 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx4/mr.c
@@ -115,7 +115,7 @@ static void mlx4_buddy_free(struct mlx4_buddy *buddy, u32 seg, int order)
 
 static int mlx4_buddy_init(struct mlx4_buddy *buddy, int max_order)
 {
-	int i, s;
+	int i, s, j;
 
 	buddy->max_order = max_order;
 	spin_lock_init(&buddy->lock);
@@ -130,8 +130,11 @@ static int mlx4_buddy_init(struct mlx4_buddy *buddy, int max_order)
 	for (i = 0; i <= buddy->max_order; ++i) {
 		s = BITS_TO_LONGS(1 << (buddy->max_order - i));
 		buddy->bits[i] = kmalloc(s * sizeof (long), GFP_KERNEL);
-		if (!buddy->bits[i])
-			goto err_out_free;
+		if (!buddy->bits[i]) {
+			buddy->bits[i] = vmalloc(s * sizeof(long));
+			if (!buddy->bits[i])
+				goto err_out_free;
+		}
 		bitmap_zero(buddy->bits[i], 1 << (buddy->max_order - i));
 	}
 
@@ -141,8 +144,11 @@ static int mlx4_buddy_init(struct mlx4_buddy *buddy, int max_order)
 	return 0;
 
 err_out_free:
-	for (i = 0; i <= buddy->max_order; ++i)
-		kfree(buddy->bits[i]);
+	for (j = 0; j < i; ++j)
+		if (is_vmalloc_addr(buddy->bits[j]))
+			vfree(buddy->bits[j]);
+		else
+			kfree(buddy->bits[j]);
 
 err_out:
 	kfree(buddy->bits);
@@ -156,7 +162,10 @@ static void mlx4_buddy_cleanup(struct mlx4_buddy *buddy)
 	int i;
 
 	for (i = 0; i <= buddy->max_order; ++i)
-		kfree(buddy->bits[i]);
+		if (is_vmalloc_addr(buddy->bits[i]))
+			vfree(buddy->bits[i]);
+		else
+			kfree(buddy->bits[i]);
 
 	kfree(buddy->bits);
 	kfree(buddy->num_free);
diff --git a/drivers/net/ethernet/mellanox/mlx4/profile.c b/drivers/net/ethernet/mellanox/mlx4/profile.c
index 9ee4725..e3af4f3 100644
--- a/drivers/net/ethernet/mellanox/mlx4/profile.c
+++ b/drivers/net/ethernet/mellanox/mlx4/profile.c
@@ -98,14 +98,15 @@ u64 mlx4_make_profile(struct mlx4_dev *dev,
 	 * memory (with PAGE_SIZE entries).
 	 *
 	 * This number has to be a power of two and fit into 32 bits
-	 * due to device limitations, so cap this at 2^31 as well.
-	 * That limits us to 8TB of memory registration per HCA with
+	 * due to device limitations, so cap this at 2^28 as well.
+	 * That limits us to 1TB of memory registration per HCA with
 	 * 4KB pages, which is probably OK for the next few months.
 	 */
 	si_meminfo(&si);
 	request->num_mtt =
 		roundup_pow_of_two(max_t(unsigned, request->num_mtt,
-					 min(1UL << 31,
+					 min(1UL << (MLX4_MAX_LOG_NUM_MTT -
+					 log_mtts_per_seg),
 					     si.totalram >> (log_mtts_per_seg - 1))));
 
 	profile[MLX4_RES_QP].size     = dev_cap->qpc_entry_sz;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
