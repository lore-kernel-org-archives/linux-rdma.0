From: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH V4 2/2] mlx4/IB: Add support for enhanced atomic operations
Date: Wed, 14 Apr 2010 17:23:39 +0300
Message-ID: <20100414142339.GC16346@vlad-laptop>
Reply-To: vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Added support for masked atomic operations:
 - Masked Compare and Swap
 - Masked Fetch and Add

Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/cq.c   |    8 ++++++++
 drivers/infiniband/hw/mlx4/main.c |    1 +
 drivers/infiniband/hw/mlx4/qp.c   |   27 +++++++++++++++++++++++++++
 include/linux/mlx4/device.h       |    4 ++--
 include/linux/mlx4/qp.h           |    7 +++++++
 5 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index de5263b..783eae7 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -660,6 +660,14 @@ repoll:
 			wc->opcode    = IB_WC_FETCH_ADD;
 			wc->byte_len  = 8;
 			break;
+		case MLX4_OPCODE_MASKED_ATOMIC_CS:
+			wc->opcode    = IB_WC_MASKED_COMP_SWAP;
+			wc->byte_len  = 8;
+			break;
+		case MLX4_OPCODE_MASKED_ATOMIC_FA:
+			wc->opcode    = IB_WC_MASKED_FETCH_ADD;
+			wc->byte_len  = 8;
+			break;
 		case MLX4_OPCODE_BIND_MW:
 			wc->opcode    = IB_WC_BIND_MW;
 			break;
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index e596537..9b2a526 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -138,6 +138,7 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 	props->local_ca_ack_delay  = dev->dev->caps.local_ca_ack_delay;
 	props->atomic_cap	   = dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_ATOMIC ?
 		IB_ATOMIC_HCA : IB_ATOMIC_NONE;
+	props->masked_atomic_cap   = IB_ATOMIC_HCA;
 	props->max_pkeys	   = dev->dev->caps.pkey_table_len[1];
 	props->max_mcast_grp	   = dev->dev->caps.num_mgms + dev->dev->caps.num_amgms;
 	props->max_mcast_qp_attach = dev->dev->caps.num_qp_per_mgm;
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 2a97c96..2ae8c81 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -84,6 +84,8 @@ static const __be32 mlx4_ib_opcode[] = {
 	[IB_WR_SEND_WITH_INV]		= cpu_to_be32(MLX4_OPCODE_SEND_INVAL),
 	[IB_WR_LOCAL_INV]		= cpu_to_be32(MLX4_OPCODE_LOCAL_INVAL),
 	[IB_WR_FAST_REG_MR]		= cpu_to_be32(MLX4_OPCODE_FMR),
+	[IB_WR_MASKED_ATOMIC_CMP_AND_SWP]	= cpu_to_be32(MLX4_OPCODE_MASKED_ATOMIC_CS),
+	[IB_WR_MASKED_ATOMIC_FETCH_AND_ADD]	= cpu_to_be32(MLX4_OPCODE_MASKED_ATOMIC_FA),
 };
 
 static struct mlx4_ib_sqp *to_msqp(struct mlx4_ib_qp *mqp)
@@ -1406,6 +1408,9 @@ static void set_atomic_seg(struct mlx4_wqe_atomic_seg *aseg, struct ib_send_wr *
 	if (wr->opcode == IB_WR_ATOMIC_CMP_AND_SWP) {
 		aseg->swap_add = cpu_to_be64(wr->wr.atomic.swap);
 		aseg->compare  = cpu_to_be64(wr->wr.atomic.compare_add);
+	} else if (wr->opcode == IB_WR_MASKED_ATOMIC_FETCH_AND_ADD) {
+		aseg->swap_add = cpu_to_be64(wr->wr.atomic.compare_add);
+		aseg->compare  = cpu_to_be64(wr->wr.atomic.compare_add_mask);
 	} else {
 		aseg->swap_add = cpu_to_be64(wr->wr.atomic.compare_add);
 		aseg->compare  = 0;
@@ -1413,6 +1418,14 @@ static void set_atomic_seg(struct mlx4_wqe_atomic_seg *aseg, struct ib_send_wr *
 
 }
 
+static void set_mask_atomic_seg(struct mlx4_wqe_mask_atomic_seg *aseg, struct ib_send_wr *wr)
+{
+	aseg->swap_add = cpu_to_be64(wr->wr.atomic.swap);
+	aseg->swap_add_mask = cpu_to_be64(wr->wr.atomic.swap_mask);
+	aseg->compare  = cpu_to_be64(wr->wr.atomic.compare_add);
+	aseg->compare_mask = cpu_to_be64(wr->wr.atomic.compare_add_mask);
+}
+
 static void set_datagram_seg(struct mlx4_wqe_datagram_seg *dseg,
 			     struct ib_send_wr *wr)
 {
@@ -1566,6 +1579,7 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			switch (wr->opcode) {
 			case IB_WR_ATOMIC_CMP_AND_SWP:
 			case IB_WR_ATOMIC_FETCH_AND_ADD:
+			case IB_WR_MASKED_ATOMIC_FETCH_AND_ADD:
 				set_raddr_seg(wqe, wr->wr.atomic.remote_addr,
 					      wr->wr.atomic.rkey);
 				wqe  += sizeof (struct mlx4_wqe_raddr_seg);
@@ -1578,6 +1592,19 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 
 				break;
 
+			case IB_WR_MASKED_ATOMIC_CMP_AND_SWP:
+				set_raddr_seg(wqe, wr->wr.atomic.remote_addr,
+					      wr->wr.atomic.rkey);
+				wqe  += sizeof (struct mlx4_wqe_raddr_seg);
+
+				set_mask_atomic_seg(wqe, wr);
+				wqe  += sizeof (struct mlx4_wqe_mask_atomic_seg);
+
+				size += (sizeof (struct mlx4_wqe_raddr_seg) +
+					 sizeof (struct mlx4_wqe_mask_atomic_seg)) / 16;
+
+				break;
+
 			case IB_WR_RDMA_READ:
 			case IB_WR_RDMA_WRITE:
 			case IB_WR_RDMA_WRITE_WITH_IMM:
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index e92d1bf..7a7f9c1 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -123,8 +123,8 @@ enum {
 	MLX4_OPCODE_RDMA_READ		= 0x10,
 	MLX4_OPCODE_ATOMIC_CS		= 0x11,
 	MLX4_OPCODE_ATOMIC_FA		= 0x12,
-	MLX4_OPCODE_ATOMIC_MASK_CS	= 0x14,
-	MLX4_OPCODE_ATOMIC_MASK_FA	= 0x15,
+	MLX4_OPCODE_MASKED_ATOMIC_CS	= 0x14,
+	MLX4_OPCODE_MASKED_ATOMIC_FA	= 0x15,
 	MLX4_OPCODE_BIND_MW		= 0x18,
 	MLX4_OPCODE_FMR			= 0x19,
 	MLX4_OPCODE_LOCAL_INVAL		= 0x1b,
diff --git a/include/linux/mlx4/qp.h b/include/linux/mlx4/qp.h
index 9f29d86..1a48413 100644
--- a/include/linux/mlx4/qp.h
+++ b/include/linux/mlx4/qp.h
@@ -285,6 +285,13 @@ struct mlx4_wqe_atomic_seg {
 	__be64			compare;
 };
 
+struct mlx4_wqe_mask_atomic_seg {
+	__be64			swap_add;
+	__be64			compare;
+	__be64			swap_add_mask;
+	__be64			compare_mask;
+};
+
 struct mlx4_wqe_data_seg {
 	__be32			byte_count;
 	__be32			lkey;
-- 
1.7.0.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
