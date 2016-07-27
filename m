From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libmlx5 3/6] fix buffer overrun copying inline header
Date: Wed, 27 Jul 2016 15:17:24 -0400
Message-ID: <1469647047-7544-4-git-send-email-jarod@redhat.com>
References: <1469647047-7544-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469647047-7544-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

At present, the size of eseg->inline_hdr_start is 16 bits, while
MLX5_ETH_L2_INLINE_HEADER_SIZE is 18, so there are attempts made to copy
18 bits into 16 bits of storage. The mlx5_dbg() statement in
copy_eth_inline_header() suggests that perhaps
MLX5_ETH_L2_INLINE_HEADER_SIZE should be only 16, not 18. So either that
needs to be changed, or the inline_hdr_start array needs to be bumped up
to 3 bytes instead of 2.

CC: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/wqe.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/wqe.h b/src/wqe.h
index c2622d5..c0e176d 100644
--- a/src/wqe.h
+++ b/src/wqe.h
@@ -77,7 +77,7 @@ struct mlx5_eqe_qp_srq {
 };
 
 enum {
-	MLX5_ETH_L2_INLINE_HEADER_SIZE	= 18,
+	MLX5_ETH_L2_INLINE_HEADER_SIZE	= 16,
 };
 
 enum {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
