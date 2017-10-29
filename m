From: idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Subject: [PATCH 1/2] IB/mlx5: posting klm/mtt list inline in the send queue for reg_wr
Date: Sun, 29 Oct 2017 18:38:20 +0200
Message-ID: <1509295101-14081-2-git-send-email-idanb@mellanox.com>
References: <1509295101-14081-1-git-send-email-idanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1509295101-14081-1-git-send-email-idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

As most kernel RDMA ULPs, NVMe over Fabrics in its secure
"register_always" mode registers and invalidates user buffer
upon each IO.

Today the mlx5 driver is posting the registration work
request using scatter/gather entry for the MTT/KLM list.

The fetch of the MTT/KLM list becomes the bottleneck in
number of IO operation could be done by NVMe over Fabrics
host driver on a single adapter as shown below.

This patch is adding the support for inline registration
work request upon MTT/KLM list of size <=64B.

The result for NVMe over Fabrics is increase of x3.6 for small
IOs as shown below, I expect other ULPs (e.g iSER, NFS over RDMA)
performance to be enhanced as well.

The following results were taken against a single nvme over fabrics
subsystem with a single namespace backed by null_blk:

Block Size       s/g reg_wr            inline reg_wr
++++++++++     +++++++++++++++        ++++++++++++++++
512B            1446.6K/8.57%          5224.2K/76.21%
1KB             1390.6K/8.5%           4656.7K/71.69%
2KB             1343.8K/8.6%           3410.3K/38.96%
4KB             1254.8K/8.39%          2033.6K/15.86%
8KB             1079.5K/7.7%           1143.1K/7.27%
16KB            603.4K/3.64%           593.8K/3.4%
32KB            294.8K/2.04%           293.7K/1.98%
64KB            138.2K/1.32%           141.6K/1.26%

Reviewed-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 41 +++++++++++++++++++++++++++++++++++------
 1 file changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index acb79d3..b25b93d 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -53,6 +53,7 @@ enum {
 
 enum {
 	MLX5_IB_SQ_STRIDE	= 6,
+	MLX5_IB_SQ_UMR_INLINE_THRESHOLD = 64,
 };
 
 static const u32 mlx5_ib_opcode[] = {
@@ -295,7 +296,8 @@ static int sq_overhead(struct ib_qp_init_attr *attr)
 			max(sizeof(struct mlx5_wqe_atomic_seg) +
 			    sizeof(struct mlx5_wqe_raddr_seg),
 			    sizeof(struct mlx5_wqe_umr_ctrl_seg) +
-			    sizeof(struct mlx5_mkey_seg));
+			    sizeof(struct mlx5_mkey_seg) +
+			    MLX5_IB_SQ_UMR_INLINE_THRESHOLD / MLX5_IB_UMR_OCTOWORD);
 		break;
 
 	case IB_QPT_XRC_TGT:
@@ -3164,13 +3166,15 @@ static __be64 sig_mkey_mask(void)
 }
 
 static void set_reg_umr_seg(struct mlx5_wqe_umr_ctrl_seg *umr,
-			    struct mlx5_ib_mr *mr)
+			    struct mlx5_ib_mr *mr, bool umr_inline)
 {
 	int size = mr->ndescs * mr->desc_size;
 
 	memset(umr, 0, sizeof(*umr));
 
 	umr->flags = MLX5_UMR_CHECK_NOT_FREE;
+	if (umr_inline)
+		umr->flags |= MLX5_UMR_INLINE;
 	umr->xlt_octowords = cpu_to_be16(get_xlt_octo(size));
 	umr->mkey_mask = frwr_mkey_mask();
 }
@@ -3341,6 +3345,24 @@ static void set_reg_data_seg(struct mlx5_wqe_data_seg *dseg,
 	dseg->lkey = cpu_to_be32(pd->ibpd.local_dma_lkey);
 }
 
+static void set_reg_umr_inline_seg(void *seg, struct mlx5_ib_qp *qp,
+				   struct mlx5_ib_mr *mr, int mr_list_size)
+{
+	void *qend = qp->sq.qend;
+	void *addr = mr->descs;
+	int copy;
+
+        if (unlikely(seg + mr_list_size > qend)) {
+                copy = qend - seg;
+                memcpy(seg, addr, copy);
+                addr += copy;
+                mr_list_size -= copy;
+                seg = mlx5_get_send_wqe(qp, 0);
+        }
+        memcpy(seg, addr, mr_list_size);
+        seg += mr_list_size;
+}
+
 static __be32 send_ieth(struct ib_send_wr *wr)
 {
 	switch (wr->opcode) {
@@ -3735,6 +3757,8 @@ static int set_reg_wr(struct mlx5_ib_qp *qp,
 {
 	struct mlx5_ib_mr *mr = to_mmr(wr->mr);
 	struct mlx5_ib_pd *pd = to_mpd(qp->ibqp.pd);
+	int mr_list_size = mr->ndescs * mr->desc_size;
+	bool umr_inline = mr_list_size <= MLX5_IB_SQ_UMR_INLINE_THRESHOLD;
 
 	if (unlikely(wr->wr.send_flags & IB_SEND_INLINE)) {
 		mlx5_ib_warn(to_mdev(qp->ibqp.device),
@@ -3742,7 +3766,7 @@ static int set_reg_wr(struct mlx5_ib_qp *qp,
 		return -EINVAL;
 	}
 
-	set_reg_umr_seg(*seg, mr);
+	set_reg_umr_seg(*seg, mr, umr_inline);
 	*seg += sizeof(struct mlx5_wqe_umr_ctrl_seg);
 	*size += sizeof(struct mlx5_wqe_umr_ctrl_seg) / 16;
 	if (unlikely((*seg == qp->sq.qend)))
@@ -3754,9 +3778,14 @@ static int set_reg_wr(struct mlx5_ib_qp *qp,
 	if (unlikely((*seg == qp->sq.qend)))
 		*seg = mlx5_get_send_wqe(qp, 0);
 
-	set_reg_data_seg(*seg, mr, pd);
-	*seg += sizeof(struct mlx5_wqe_data_seg);
-	*size += (sizeof(struct mlx5_wqe_data_seg) / 16);
+	if (umr_inline) {
+		set_reg_umr_inline_seg(*seg, qp, mr, mr_list_size);
+		*size += get_xlt_octo(mr_list_size);
+	} else {
+                set_reg_data_seg(*seg, mr, pd);
+                *seg += sizeof(struct mlx5_wqe_data_seg);
+                *size += (sizeof(struct mlx5_wqe_data_seg) / 16);
+	}
 
 	return 0;
 }
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
