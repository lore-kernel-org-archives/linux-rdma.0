From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 4/4] mlx5: Use enum to indicate adapter page size
Date: Thu, 24 Oct 2013 12:01:03 +0300
Message-ID: <1382605263-6822-5-git-send-email-eli@mellanox.com>
References: <1382605263-6822-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382605263-6822-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The Connect-IB adapter has an inherent page size which equals 4K. Define an new
enum that equals the page shift and use it instead of using the value 12
throughout the code.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/cq.c              | 2 +-
 drivers/infiniband/hw/mlx5/qp.c              | 5 +++--
 drivers/infiniband/hw/mlx5/srq.c             | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 2 +-
 include/linux/mlx5/device.h                  | 4 ++++
 5 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index eecac7b..2834477 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -620,7 +620,7 @@ static int create_cq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq,
 	}
 	mlx5_fill_page_array(&cq->buf.buf, (*cqb)->pas);
 
-	(*cqb)->ctx.log_pg_sz = cq->buf.buf.page_shift - 12;
+	(*cqb)->ctx.log_pg_sz = cq->buf.buf.page_shift - MLX5_ADAPTER_PAGE_SHIFT;
 	*index = dev->mdev.priv.uuari.uars[0].index;
 
 	return 0;
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 5bcf579..7c6b4ba 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -551,7 +551,7 @@ static int create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	}
 	mlx5_ib_populate_pas(dev, qp->umem, page_shift, (*in)->pas, 0);
 	(*in)->ctx.log_pg_sz_remote_qpn =
-		cpu_to_be32((page_shift - 12) << 24);
+		cpu_to_be32((page_shift - MLX5_ADAPTER_PAGE_SHIFT) << 24);
 	(*in)->ctx.params2 = cpu_to_be32(offset << 6);
 
 	(*in)->ctx.qp_counter_set_usr_page = cpu_to_be32(uar_index);
@@ -648,7 +648,8 @@ static int create_kernel_qp(struct mlx5_ib_dev *dev,
 		goto err_buf;
 	}
 	(*in)->ctx.qp_counter_set_usr_page = cpu_to_be32(uar_index);
-	(*in)->ctx.log_pg_sz_remote_qpn = cpu_to_be32((qp->buf.page_shift - 12) << 24);
+	(*in)->ctx.log_pg_sz_remote_qpn =
+		cpu_to_be32((qp->buf.page_shift - MLX5_ADAPTER_PAGE_SHIFT) << 24);
 	/* Set "fast registration enabled" for all kernel QPs */
 	(*in)->ctx.params1 |= cpu_to_be32(1 << 11);
 	(*in)->ctx.sq_crq_size |= cpu_to_be16(1 << 4);
diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index dbc2c71..210b3ea 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -123,7 +123,7 @@ static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 		goto err_in;
 	}
 
-	(*in)->ctx.log_pg_sz = page_shift - 12;
+	(*in)->ctx.log_pg_sz = page_shift - MLX5_ADAPTER_PAGE_SHIFT;
 	(*in)->ctx.pgoff_cqn = cpu_to_be32(offset << 26);
 
 	return 0;
@@ -192,7 +192,7 @@ static int create_srq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_srq *srq,
 	}
 	srq->wq_sig = !!srq_signature;
 
-	(*in)->ctx.log_pg_sz = page_shift - 12;
+	(*in)->ctx.log_pg_sz = page_shift - MLX5_ADAPTER_PAGE_SHIFT;
 
 	return 0;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 6b4b436..64a61b2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -354,7 +354,7 @@ int mlx5_create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq, u8 vecidx,
 	in->hdr.opcode = cpu_to_be16(MLX5_CMD_OP_CREATE_EQ);
 	in->ctx.log_sz_usr_page = cpu_to_be32(ilog2(eq->nent) << 24 | uar->index);
 	in->ctx.intr = vecidx;
-	in->ctx.log_page_size = eq->buf.page_shift - 12;
+	in->ctx.log_page_size = eq->buf.page_shift - MLX5_ADAPTER_PAGE_SHIFT;
 	in->events_mask = cpu_to_be64(mask);
 
 	err = mlx5_cmd_exec(dev, in, inlen, &out, sizeof(out));
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 3d789f4..da78875 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -231,6 +231,10 @@ enum {
 };
 
 enum {
+	MLX5_ADAPTER_PAGE_SHIFT		= 12
+};
+
+enum {
 	MLX5_CAP_OFF_DCT		= 41,
 	MLX5_CAP_OFF_CMDIF_CSUM		= 46,
 };
-- 
1.8.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
