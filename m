From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC 08/20] mlx5: Store MR attributes in mlx5_mr_core during creation and after UMR
Date: Sun,  2 Mar 2014 12:49:26 +0200
Message-ID: <1393757378-16412-9-git-send-email-haggaie@mellanox.com>
References: <1393757378-16412-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393757378-16412-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The patch stores iova, pd and size during mr creation and after UMRs that
modify them. It removes the unused access flags field.

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mr.c              | 4 ++++
 drivers/net/ethernet/mellanox/mlx5/core/mr.c | 4 ++++
 include/linux/mlx5/driver.h                  | 1 -
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index f447257..66b7290 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -794,6 +794,10 @@ static struct mlx5_ib_mr *reg_umr(struct ib_pd *pd, struct ib_umem *umem,
 		err = -EFAULT;
 	}
 
+	mr->mmr.iova = virt_addr;
+	mr->mmr.size = len;
+	mr->mmr.pd = to_mpd(pd)->pdn;
+
 unmap_dma:
 	up(&umrc->sem);
 	dma_unmap_single(ddev, mr->dma, size, DMA_TO_DEVICE);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
index 4cc9276..ac52a0f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
@@ -82,7 +82,11 @@ int mlx5_core_create_mkey(struct mlx5_core_dev *dev, struct mlx5_core_mr *mr,
 		return mlx5_cmd_status_to_err(&lout.hdr);
 	}
 
+	mr->iova = be64_to_cpu(in->seg.start_addr);
+	mr->size = be64_to_cpu(in->seg.len);
 	mr->key = mlx5_idx_to_mkey(be32_to_cpu(lout.mkey) & 0xffffff) | key;
+	mr->pd = be32_to_cpu(in->seg.flags_pd) & 0xffffff;
+
 	mlx5_core_dbg(dev, "out 0x%x, key 0x%x, mkey 0x%x\n",
 		      be32_to_cpu(lout.mkey), key, mr->key);
 
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 93cef63..2bce4aa 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -427,7 +427,6 @@ struct mlx5_core_mr {
 	u64			size;
 	u32			key;
 	u32			pd;
-	u32			access;
 };
 
 struct mlx5_core_srq {
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
