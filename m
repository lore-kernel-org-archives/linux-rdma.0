From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] mlx5_core: Adjust hca_cap.uar_page_sz to conform to Connect-IB spec
Date: Wed, 10 Jul 2013 14:31:03 +0300
Message-ID: <1373455863-19955-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Sparse check reported an endianness bug regarding assignment to hca_cap.uar_page_sz. 
Fix the declaration of this field to be __be16 (which is what is indicated in the 
firmware spec), renaming the field to log_uar_pg_size to conform to the spec, and 
incidentally fix the endianness bug reported by sparse.

Reported-by: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c |    2 +-
 include/linux/mlx5/device.h                    |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index f21cc39..12242de 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -212,7 +212,7 @@ static int handle_hca_cap(struct mlx5_core_dev *dev)
 		set_ctx->hca_cap.log_max_qp = dev->profile->log_max_qp;
 
 	memset(&set_out, 0, sizeof(set_out));
-	set_ctx->hca_cap.uar_page_sz = cpu_to_be16(PAGE_SHIFT - 12);
+	set_ctx->hca_cap.log_uar_page_sz = cpu_to_be16(PAGE_SHIFT - 12);
 	set_ctx->hdr.opcode = cpu_to_be16(MLX5_CMD_OP_SET_HCA_CAP);
 	err = mlx5_cmd_exec(dev, set_ctx, sizeof(*set_ctx),
 				 &set_out, sizeof(set_out));
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 5139091..8de8d8f 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -317,8 +317,8 @@ struct mlx5_hca_cap {
 	u8	log_max_pd;
 	u8	rsvd25;
 	u8	log_max_xrcd;
-	u8	rsvd26[40];
-	__be32  uar_page_sz;
+	u8	rsvd26[42];
+	__be16  log_uar_page_sz;
 	u8	rsvd27[28];
 	u8	log_msx_atomic_size_qp;
 	u8	rsvd28[2];
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
