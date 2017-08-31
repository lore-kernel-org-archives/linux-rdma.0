From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 2/2] mlx5: Fix compile warning upon calling _mm_set_epi8()
Date: Thu, 31 Aug 2017 15:42:26 +0300
Message-ID: <1504183346-10742-3-git-send-email-yishaih@mellanox.com>
References: <1504183346-10742-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1504183346-10742-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The _mm_shuffle_epi8 call requires 0x80 to set the output byte
to zero, but _mm_set_epi8() accepts char. If GCC is compiling
in a configuration with a signed char then it can produce
a -Werror=overflow warning.

Fixing that by considering the value of CHAR_MIN at the compilation
phase to pass the matching char value.

Fixes: 00c91653ef9a ("mlx5: Add WQE segments implementation")
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/mlx5dv.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index 5d11625..2219e62 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -36,6 +36,7 @@
 #include <linux/types.h> /* For the __be64 type */
 #include <endian.h>
 #if defined(__SSE3__)
+#include <limits.h>
 #include <emmintrin.h>
 #include <tmmintrin.h>
 #endif /* defined(__SSE3__) */
@@ -499,7 +500,11 @@ void mlx5dv_x86_set_ctrl_seg(struct mlx5_wqe_ctrl_seg *seg, uint16_t pi,
 				     (signature << 24) | (opcode << 16) | (opmod << 8) | fm_ce_se);
 	__m128i mask = _mm_set_epi8(15, 14, 13, 12,	/* immediate */
 				     0,			/* signal/fence_mode */
-				     0x80, 0x80,	/* reserved */
+#if CHAR_MIN
+				     -128, -128,        /* reserved */
+#else
+				     0x80, 0x80,        /* reserved */
+#endif
 				     3,			/* signature */
 				     6,			/* data size */
 				     8, 9, 10,		/* QP num */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
