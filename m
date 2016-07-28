From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libmlx5 7/6] combine inline_hdr and inline_hdr_start
Date: Wed, 27 Jul 2016 21:32:34 -0400
Message-ID: <1469669554-23782-1-git-send-email-jarod@redhat.com>
References: <1469647047-7544-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469647047-7544-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I can't see any good reason why inline_hdr and inline_hdr_start should be
two separate arrays in struct mlx5_wqe_eth_seg. The only time I see
anything actually accessed by dereferencing either inline_hdr or
inline_hdr_start is when the MLX5_ETH_L2_INLINE_HEADER_SIZE or less bytes
are copied into inline_hdr_start. By default, it's 18 bytes, copied to
what is a 2-byte and a 16-byte array back to back in the struct, and
coverity and clang both sound alarms because the code says "just write 18
bytes into that 2-byte array", which in practice is ultimately fine, but
again, why?...

I propose to just add two bytes to inline_hdr and drop inline_hdr_start.

CC: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/qp.c  | 4 ++--
 src/wqe.h | 3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/src/qp.c b/src/qp.c
index 8bb66be..f4a22be 100644
--- a/src/qp.c
+++ b/src/qp.c
@@ -369,14 +369,14 @@ static inline int copy_eth_inline_headers(struct ibv_qp *ibqp,
 
 	if (likely(wr->sg_list[0].length >= MLX5_ETH_L2_INLINE_HEADER_SIZE)) {
 		inl_hdr_copy_size = MLX5_ETH_L2_INLINE_HEADER_SIZE;
-		memcpy(eseg->inline_hdr_start,
+		memcpy(eseg->inline_hdr,
 		       (void *)(uintptr_t)wr->sg_list[0].addr,
 		       inl_hdr_copy_size);
 	} else {
 		for (j = 0; j < wr->num_sge && inl_hdr_size > 0; ++j) {
 			inl_hdr_copy_size = min(wr->sg_list[j].length,
 						inl_hdr_size);
-			memcpy(eseg->inline_hdr_start +
+			memcpy(eseg->inline_hdr +
 			       (MLX5_ETH_L2_INLINE_HEADER_SIZE - inl_hdr_size),
 			       (void *)(uintptr_t)wr->sg_list[j].addr,
 			       inl_hdr_copy_size);
diff --git a/src/wqe.h b/src/wqe.h
index c2622d5..d979232 100644
--- a/src/wqe.h
+++ b/src/wqe.h
@@ -92,8 +92,7 @@ struct mlx5_wqe_eth_seg {
 	uint16_t	mss;
 	uint32_t	rsvd2;
 	uint16_t	inline_hdr_sz;
-	uint8_t		inline_hdr_start[2];
-	uint8_t		inline_hdr[16];
+	uint8_t		inline_hdr[MLX5_ETH_L2_INLINE_HEADER_SIZE];
 };
 
 struct mlx5_wqe_ctrl_seg {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
