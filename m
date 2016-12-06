From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 3/5] mlx5: Avoid that sparse complains about dubious !x & y
 expressions
Date: Mon, 5 Dec 2016 17:19:09 -0800
Message-ID: <572c702f-589f-2d5a-9e13-45223191db85@sandisk.com>
References: <9ff07804-492c-c67a-e729-b31e0f863027@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9ff07804-492c-c67a-e729-b31e0f863027-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mr.c                 | 20 ++++++++++----------
 drivers/net/ethernet/mellanox/mlx5/core/srq.c   |  8 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/vport.c |  2 +-
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 4e9012463c37..3a5707e0d82a 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -687,10 +687,10 @@ struct ib_mr *mlx5_ib_get_dma_mr(struct ib_pd *pd, int acc)
 	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
 
 	MLX5_SET(mkc, mkc, access_mode, MLX5_MKC_ACCESS_MODE_PA);
-	MLX5_SET(mkc, mkc, a, !!(acc & IB_ACCESS_REMOTE_ATOMIC));
-	MLX5_SET(mkc, mkc, rw, !!(acc & IB_ACCESS_REMOTE_WRITE));
-	MLX5_SET(mkc, mkc, rr, !!(acc & IB_ACCESS_REMOTE_READ));
-	MLX5_SET(mkc, mkc, lw, !!(acc & IB_ACCESS_LOCAL_WRITE));
+	MLX5_SET(mkc, mkc, a, (acc & IB_ACCESS_REMOTE_ATOMIC) != 0);
+	MLX5_SET(mkc, mkc, rw, (acc & IB_ACCESS_REMOTE_WRITE) != 0);
+	MLX5_SET(mkc, mkc, rr, (acc & IB_ACCESS_REMOTE_READ) != 0);
+	MLX5_SET(mkc, mkc, lw, (acc & IB_ACCESS_LOCAL_WRITE) != 0);
 	MLX5_SET(mkc, mkc, lr, 1);
 
 	MLX5_SET(mkc, mkc, length64, 1);
@@ -1093,14 +1093,14 @@ static struct mlx5_ib_mr *reg_create(struct ib_mr *ibmr, struct ib_pd *pd,
 
 	/* The pg_access bit allows setting the access flags
 	 * in the page list submitted with the command. */
-	MLX5_SET(create_mkey_in, in, pg_access, !!(pg_cap));
+	MLX5_SET(create_mkey_in, in, pg_access, pg_cap != 0);
 
 	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
 	MLX5_SET(mkc, mkc, access_mode, MLX5_MKC_ACCESS_MODE_MTT);
-	MLX5_SET(mkc, mkc, a, !!(access_flags & IB_ACCESS_REMOTE_ATOMIC));
-	MLX5_SET(mkc, mkc, rw, !!(access_flags & IB_ACCESS_REMOTE_WRITE));
-	MLX5_SET(mkc, mkc, rr, !!(access_flags & IB_ACCESS_REMOTE_READ));
-	MLX5_SET(mkc, mkc, lw, !!(access_flags & IB_ACCESS_LOCAL_WRITE));
+	MLX5_SET(mkc, mkc, a, (access_flags & IB_ACCESS_REMOTE_ATOMIC) != 0);
+	MLX5_SET(mkc, mkc, rw, (access_flags & IB_ACCESS_REMOTE_WRITE) != 0);
+	MLX5_SET(mkc, mkc, rr, (access_flags & IB_ACCESS_REMOTE_READ) != 0);
+	MLX5_SET(mkc, mkc, lw, (access_flags & IB_ACCESS_LOCAL_WRITE) != 0);
 	MLX5_SET(mkc, mkc, lr, 1);
 
 	MLX5_SET64(mkc, mkc, start_addr, virt_addr);
@@ -1696,7 +1696,7 @@ struct ib_mw *mlx5_ib_alloc_mw(struct ib_pd *pd, enum ib_mw_type type,
 	MLX5_SET(mkc, mkc, umr_en, 1);
 	MLX5_SET(mkc, mkc, lr, 1);
 	MLX5_SET(mkc, mkc, access_mode, MLX5_MKC_ACCESS_MODE_KLMS);
-	MLX5_SET(mkc, mkc, en_rinval, !!((type == IB_MW_TYPE_2)));
+	MLX5_SET(mkc, mkc, en_rinval, type == IB_MW_TYPE_2);
 	MLX5_SET(mkc, mkc, qpn, 0xffffff);
 
 	err = mlx5_core_create_mkey(dev->mdev, &mw->mmkey, in, inlen);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/srq.c b/drivers/net/ethernet/mellanox/mlx5/core/srq.c
index 3099630015d7..2dee3129f1cd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/srq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/srq.c
@@ -80,8 +80,8 @@ static int get_pas_size(struct mlx5_srq_attr *in)
 
 static void set_wq(void *wq, struct mlx5_srq_attr *in)
 {
-	MLX5_SET(wq,   wq, wq_signature,  !!(in->flags
-		 & MLX5_SRQ_FLAG_WQ_SIG));
+	MLX5_SET(wq,   wq, wq_signature,
+		 (in->flags & MLX5_SRQ_FLAG_WQ_SIG) != 0);
 	MLX5_SET(wq,   wq, log_wq_pg_sz,  in->log_page_size);
 	MLX5_SET(wq,   wq, log_wq_stride, in->wqe_shift + 4);
 	MLX5_SET(wq,   wq, log_wq_sz,     in->log_size);
@@ -93,8 +93,8 @@ static void set_wq(void *wq, struct mlx5_srq_attr *in)
 
 static void set_srqc(void *srqc, struct mlx5_srq_attr *in)
 {
-	MLX5_SET(srqc,   srqc, wq_signature,  !!(in->flags
-		 & MLX5_SRQ_FLAG_WQ_SIG));
+	MLX5_SET(srqc,   srqc, wq_signature,
+		 (in->flags & MLX5_SRQ_FLAG_WQ_SIG) != 0);
 	MLX5_SET(srqc,   srqc, log_page_size, in->log_page_size);
 	MLX5_SET(srqc,   srqc, log_rq_stride, in->wqe_shift);
 	MLX5_SET(srqc,   srqc, log_srq_size,  in->log_size);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 525f17af108e..ea9076f61b6b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -539,7 +539,7 @@ int mlx5_modify_nic_vport_node_guid(struct mlx5_core_dev *mdev,
 	MLX5_SET(modify_nic_vport_context_in, in,
 		 field_select.node_guid, 1);
 	MLX5_SET(modify_nic_vport_context_in, in, vport_number, vport);
-	MLX5_SET(modify_nic_vport_context_in, in, other_vport, !!vport);
+	MLX5_SET(modify_nic_vport_context_in, in, other_vport, vport != 0);
 
 	nic_vport_context = MLX5_ADDR_OF(modify_nic_vport_context_in,
 					 in, nic_vport_context);
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
