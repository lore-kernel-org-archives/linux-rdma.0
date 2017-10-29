From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 2/2] mlx5: Fix wrong bitmap table allocation size calculation
Date: Sun, 29 Oct 2017 15:01:10 +0200
Message-ID: <1509282070-1391-3-git-send-email-yishaih@mellanox.com>
References: <1509282070-1391-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1509282070-1391-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This fixes wrong element size calculation during allocation
of bitmap table. We divide the number of required bits in the bitmap
into groups (elements) of sizeof(long) which can be 4 or more bytes
(architecture depended) but allocating num_elements * 4 bytes of
memory for the table.

Signed-off-by: Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/buf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/providers/mlx5/buf.c b/providers/mlx5/buf.c
index 8196db6..0ba8188 100644
--- a/providers/mlx5/buf.c
+++ b/providers/mlx5/buf.c
@@ -51,7 +51,7 @@ static int mlx5_bitmap_init(struct mlx5_bitmap *bitmap, uint32_t num,
 	bitmap->avail = num;
 	bitmap->mask = mask;
 	bitmap->avail = bitmap->max;
-	bitmap->table = calloc(BITS_TO_LONGS(bitmap->max), sizeof(uint32_t));
+	bitmap->table = calloc(BITS_TO_LONGS(bitmap->max), sizeof(long));
 	if (!bitmap->table)
 		return -ENOMEM;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
