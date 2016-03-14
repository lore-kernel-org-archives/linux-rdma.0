From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx4 1/2] Handling 0-length sge correctly
Date: Mon, 14 Mar 2016 13:47:34 +0200
Message-ID: <1457956055-2593-2-git-send-email-noaos@mellanox.com>
References: <1457956055-2593-1-git-send-email-noaos@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457956055-2593-1-git-send-email-noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When the driver sees a 0-length sge, it should transform that into a
0-length inline segment entry.

The HW will then will not add any data to the outgoing package when
it encounters that inline entry.

Reviewed-by: Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx4.h | 8 ++++++++
 src/qp.c   | 5 ++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/src/mlx4.h b/src/mlx4.h
index 519d8f4..f8d2051 100644
--- a/src/mlx4.h
+++ b/src/mlx4.h
@@ -92,6 +92,14 @@ enum {
 	MLX4_STAT_RATE_OFFSET		= 5
 };
 
+#ifndef likely
+#ifdef __GNUC__
+#define likely(x)       __builtin_expect(!!(x),1)
+#else
+#define likely(x)      (x)
+#endif
+#endif
+
 enum {
 	MLX4_QP_TABLE_BITS		= 8,
 	MLX4_QP_TABLE_SIZE		= 1 << MLX4_QP_TABLE_BITS,
diff --git a/src/qp.c b/src/qp.c
index bc2d2e1..05874d2 100644
--- a/src/qp.c
+++ b/src/qp.c
@@ -170,7 +170,10 @@ static void set_data_seg(struct mlx4_wqe_data_seg *dseg, struct ibv_sge *sg)
 	 */
 	wmb();
 
-	dseg->byte_count = htonl(sg->length);
+	if (likely(sg->length))
+		dseg->byte_count = htonl(sg->length);
+	else
+		dseg->byte_count = htonl(0x80000000);
 }
 
 int mlx4_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
