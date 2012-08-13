From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH fix V2 1/2] net/mlx4_core: Allow large mlx4_buddy objects
Date: Mon, 13 Aug 2012 11:15:06 +0300
Message-ID: <1344845707-23157-2-git-send-email-ogerlitz@mellanox.com>
References: <1344845707-23157-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1344845707-23157-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

mlx4_buddy_init is using kmalloc, and was failing when the required size
was beyond the max supported value. Enhance it to use vmalloc if kmalloc
fails and take that into account when freeing the elements as well.

This fix a driver load failure when log num mtt is 26 or higher, and
is a step in the direction of allowing to register large amounts
of memory.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/mr.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

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
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
