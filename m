From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 2/2] mlx5: Convert explicitly to signed char
Date: Wed, 30 Aug 2017 17:19:24 +0300
Message-ID: <1504102764-21638-3-git-send-email-yishaih@mellanox.com>
References: <1504102764-21638-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1504102764-21638-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The 0x80 value is a canonical way to mark as not-used in intrinsics
function calls.

However the gcc compiler is not aware of this convention and compilation
with -Werror=overflow option will cause to compilation failure, because
_mm_set_epi8() call expects chars as an input.

In order to avoid it, we will convert 0x80 to be -128.

Fixes: 00c91653ef9a ("mlx5: Add WQE segments implementation")
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/mlx5dv.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index 5d11625..e9efcf5 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -499,7 +499,7 @@ void mlx5dv_x86_set_ctrl_seg(struct mlx5_wqe_ctrl_seg *seg, uint16_t pi,
 				     (signature << 24) | (opcode << 16) | (opmod << 8) | fm_ce_se);
 	__m128i mask = _mm_set_epi8(15, 14, 13, 12,	/* immediate */
 				     0,			/* signal/fence_mode */
-				     0x80, 0x80,	/* reserved */
+				     -128, -128,	/* reserved */
 				     3,			/* signature */
 				     6,			/* data size */
 				     8, 9, 10,		/* QP num */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
