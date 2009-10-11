From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCHv2] mlx4: remove limitation on LSO header size
Date: Sun, 11 Oct 2009 15:20:13 +0200
Message-ID: <20091011132013.GA24725@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Current code has a limitation as for the size of an LSO header not allowed to
cross a 64 byte boundary. This patch removes this limitation by setting the WQE
RR for large headers thus allowing LSO headers of any size. The extra buffer
reserved for MLX4_IB_QP_LSO QPs has been doubled, from 64 to 128 bytes,
assuming this is reasonable upper limit to header length.
Also, this patch will cause IB_DEVICE_UD_TSO to be set only of FW versions that
set MLX4_DEV_CAP_FLAG_BLH; e.g. FW version 2.6.000 and higher.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
Changes from previous version:
Use enums to describe cache line size and header spare buffer.
Pass to build_lso_seg() a be32 pointer to get the flags value and OR
it directly on ctrl->owner_opcode.
build_lso_seg() touches blh only if it sets the BLH flag. This OK
since is set to zero by the caller.


 drivers/infiniband/hw/mlx4/main.c |    2 +-
 drivers/infiniband/hw/mlx4/qp.c   |   23 +++++++++++------------
 include/linux/mlx4/device.h       |    1 +
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 3cb3f47..e596537 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -103,7 +103,7 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 		props->device_cap_flags |= IB_DEVICE_UD_AV_PORT_ENFORCE;
 	if (dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_IPOIB_CSUM)
 		props->device_cap_flags |= IB_DEVICE_UD_IP_CSUM;
-	if (dev->dev->caps.max_gso_sz)
+	if (dev->dev->caps.max_gso_sz && dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_BLH)
 		props->device_cap_flags |= IB_DEVICE_UD_TSO;
 	if (dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_RESERVED_LKEY)
 		props->device_cap_flags |= IB_DEVICE_LOCAL_DMA_LKEY;
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 219b103..cde2bdc 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -54,7 +54,8 @@ enum {
 	/*
 	 * Largest possible UD header: send with GRH and immediate data.
 	 */
-	MLX4_IB_UD_HEADER_SIZE		= 72
+	MLX4_IB_UD_HEADER_SIZE		= 72,
+	LSO_HEADER_SPARE		= 128,
 };
 
 struct mlx4_ib_sqp {
@@ -67,7 +68,8 @@ struct mlx4_ib_sqp {
 };
 
 enum {
-	MLX4_IB_MIN_SQ_STRIDE = 6
+	MLX4_IB_MIN_SQ_STRIDE = 6,
+	MLX4_CACHE_LINE_SIZE = 64,
 };
 
 static const __be32 mlx4_ib_opcode[] = {
@@ -261,7 +263,7 @@ static int send_wqe_overhead(enum ib_qp_type type, u32 flags)
 	case IB_QPT_UD:
 		return sizeof (struct mlx4_wqe_ctrl_seg) +
 			sizeof (struct mlx4_wqe_datagram_seg) +
-			((flags & MLX4_IB_QP_LSO) ? 64 : 0);
+			((flags & MLX4_IB_QP_LSO) ? LSO_HEADER_SPARE : 0);
 	case IB_QPT_UC:
 		return sizeof (struct mlx4_wqe_ctrl_seg) +
 			sizeof (struct mlx4_wqe_raddr_seg);
@@ -1467,16 +1469,12 @@ static void __set_data_seg(struct mlx4_wqe_data_seg *dseg, struct ib_sge *sg)
 
 static int build_lso_seg(struct mlx4_wqe_lso_seg *wqe, struct ib_send_wr *wr,
 			 struct mlx4_ib_qp *qp, unsigned *lso_seg_len,
-			 __be32 *lso_hdr_sz)
+			 __be32 *lso_hdr_sz, __be32 *blh)
 {
 	unsigned halign = ALIGN(sizeof *wqe + wr->wr.ud.hlen, 16);
 
-	/*
-	 * This is a temporary limitation and will be removed in
-	 * a forthcoming FW release:
-	 */
-	if (unlikely(halign > 64))
-		return -EINVAL;
+	if (unlikely(halign > MLX4_CACHE_LINE_SIZE))
+		*blh = cpu_to_be32(1 << 6);
 
 	if (unlikely(!(qp->flags & MLX4_IB_QP_LSO) &&
 		     wr->num_sge > qp->sq.max_gs - (halign >> 4)))
@@ -1523,6 +1521,7 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	__be32 *lso_wqe;
 	__be32 uninitialized_var(lso_hdr_sz);
 	int i;
+	__be32 blh = 0;
 
 	spin_lock_irqsave(&qp->sq.lock, flags);
 
@@ -1616,7 +1615,7 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			size += sizeof (struct mlx4_wqe_datagram_seg) / 16;
 
 			if (wr->opcode == IB_WR_LSO) {
-				err = build_lso_seg(wqe, wr, qp, &seglen, &lso_hdr_sz);
+				err = build_lso_seg(wqe, wr, qp, &seglen, &lso_hdr_sz, &blh);
 				if (unlikely(err)) {
 					*bad_wr = wr;
 					goto out;
@@ -1687,7 +1686,7 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		}
 
 		ctrl->owner_opcode = mlx4_ib_opcode[wr->opcode] |
-			(ind & qp->sq.wqe_cnt ? cpu_to_be32(1 << 31) : 0);
+			(ind & qp->sq.wqe_cnt ? cpu_to_be32(1 << 31) : 0) | blh;
 
 		stamp = ind + qp->sq_spare_wqes;
 		ind += DIV_ROUND_UP(size * 16, 1U << qp->sq.wqe_shift);
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index ce7cc6c..e92d1bf 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -61,6 +61,7 @@ enum {
 	MLX4_DEV_CAP_FLAG_BAD_PKEY_CNTR	= 1 <<  8,
 	MLX4_DEV_CAP_FLAG_BAD_QKEY_CNTR	= 1 <<  9,
 	MLX4_DEV_CAP_FLAG_DPDP		= 1 << 12,
+	MLX4_DEV_CAP_FLAG_BLH		= 1 << 15,
 	MLX4_DEV_CAP_FLAG_MEM_WINDOW	= 1 << 16,
 	MLX4_DEV_CAP_FLAG_APM		= 1 << 17,
 	MLX4_DEV_CAP_FLAG_ATOMIC	= 1 << 18,
-- 
1.6.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
