From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC 18/20] IB/mlx5: Handle page faults
Date: Sun,  2 Mar 2014 12:49:36 +0200
Message-ID: <1393757378-16412-19-git-send-email-haggaie@mellanox.com>
References: <1393757378-16412-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393757378-16412-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch implement a page fault handler (leaving the pages pinned as
of time being). The page fault handler handles initiator and responder
page faults for UD/RC transports, and for send/receive operations.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/odp.c | 396 +++++++++++++++++++++++++++++++++++++++
 include/linux/mlx5/qp.h          |   7 +
 2 files changed, 403 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index f297f14..c6da238 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -30,6 +30,9 @@
  * SOFTWARE.
  */
 
+#include <rdma/ib_umem.h>
+#include <rdma/ib_umem_odp.h>
+
 #include "mlx5_ib.h"
 
 struct workqueue_struct *mlx5_ib_page_fault_wq;
@@ -94,12 +97,405 @@ static void mlx5_ib_page_fault_resume(struct mlx5_ib_qp *qp,
 		       qp->mqp.qpn);
 }
 
+/*
+ * Handle a single data segment in a page-fault WQE.
+ *
+ * Returns number of pages retrieved on success. The caller will continue to
+ * the next data segment.
+ * Can return the following error codes:
+ * -EAGAIN to designate a temporary error. The caller will abort handling the
+ *  page fault and resolve it.
+ * -EFAULT when there's an error mapping the requested pages. The caller will
+ *  abort the page fault handling and possibly move the QP to an error state.
+ * On other errors the QP should also be closed with an error.
+ */
+static int pagefault_single_data_segment(struct mlx5_ib_qp *qp,
+		struct mlx5_ib_pfault *pfault, u32 key, u64 io_virt,
+		size_t bcnt, u32 *bytes_mapped)
+{
+	struct mlx5_ib_dev *mib_dev = to_mdev(qp->ibqp.pd->device);
+	int srcu_key;
+	u64 start_idx;
+	int npages = 0, ret = 0;
+	struct mlx5_ib_mr *mr;
+	srcu_key = srcu_read_lock(&mib_dev->mr_srcu);
+	mr = mlx5_ib_odp_find_mr_lkey(mib_dev, key);
+	/*
+	 * If we didn't find the MR, it means the MR was closed while we were
+	 * handling the ODP event. In this case we return -EFAULT so that the
+	 * QP will be closed.
+	 */
+	if (!mr || !mr->ibmr.pd) {
+		pr_err("Failed to find relevant mr for lkey=0x%06x, probably the MR was destroyed\n",
+		       key);
+		ret = -EFAULT;
+		goto srcu_unlock;
+	}
+	if (!mr->umem->odp_data) {
+		pr_debug("skipping non ODP MR (lkey=0x%06x) in page fault handler.\n",
+			 key);
+		if (bytes_mapped)
+			*bytes_mapped +=
+				(bcnt - pfault->mpfault.bytes_committed);
+		goto srcu_unlock;
+	}
+	if (mr->ibmr.pd != qp->ibqp.pd) {
+		pr_err("Page-fault with different PDs for QP and MR.\n");
+		ret = -EFAULT;
+		goto srcu_unlock;
+	}
+
+	/*
+	 * Avoid branches - this code will perform correctly
+	 * in all iterations (in iteration 2 and above,
+	 * gather_commit == 0).
+	 */
+	io_virt += pfault->mpfault.bytes_committed;
+	bcnt -= pfault->mpfault.bytes_committed;
+
+	start_idx = (io_virt - (mr->mmr.iova & PAGE_MASK)) >> PAGE_SHIFT;
+
+	npages = ib_umem_odp_map_dma_pages(mr->umem, io_virt, bcnt,
+			mr->umem->writable ?
+				(ODP_READ_ALLOWED_BIT | ODP_WRITE_ALLOWED_BIT) :
+				ODP_READ_ALLOWED_BIT,
+			atomic_read(&mr->umem->odp_data->notifiers_seq));
+	if (npages < 0) {
+		ret = npages;
+		goto srcu_unlock;
+	}
+
+	if (npages > 0) {
+		mutex_lock(&mr->umem->odp_data->umem_mutex);
+		/*
+		 * No need to check whether the MTTs really belong to
+		 * this MR, since ib_umem_odp_map_dma_pages already
+		 * checks this.
+		 */
+		ret = mlx5_ib_update_mtt(mr, start_idx, npages, 0);
+		mutex_unlock(&mr->umem->odp_data->umem_mutex);
+
+		if (bytes_mapped) {
+			u32 new_mappings = npages * PAGE_SIZE -
+				(io_virt - round_down(io_virt, PAGE_SIZE));
+			*bytes_mapped += min_t(u32, new_mappings, bcnt);
+		}
+	}
+	if (ret) {
+		pr_err("Failed to update mkey page tables\n");
+		ret = -EAGAIN;
+		goto srcu_unlock;
+	}
+
+srcu_unlock:
+	srcu_read_unlock(&mib_dev->mr_srcu, srcu_key);
+	pfault->mpfault.bytes_committed = 0;
+	return ret ? ret : npages;
+}
+
+/**
+ * Parse a series of data segments for page fault handling.
+ *
+ * @qp the QP on which the fault occurred.
+ * @pfault contains page fault information.
+ * @wqe points at the first data segment in the WQE.
+ * @wqe_end points after the end of the WQE.
+ * @bytes_mapped receives the number of bytes that the function was able to
+ *               map. This allows the caller to decide intelligently whether
+ *               enough memory was mapped to resolve the page fault
+ *               successfully (e.g. enough for the next MTU, or the entire
+ *               WQE).
+ * @total_wqe_bytes receives the total data size of this WQE in bytes (minus
+ *                  the committed bytes).
+ *
+ * Returns the number of pages loaded if positive, zero for an empty WQE, or a
+ * negative error code.
+ */
+static int pagefault_data_segments(struct mlx5_ib_qp *qp,
+		struct mlx5_ib_pfault *pfault, void *wqe, void *wqe_end,
+		u32 *bytes_mapped, u32 *total_wqe_bytes, int receive_queue)
+{
+	int ret = 0, npages = 0;
+	u64 io_virt;
+	u32 key;
+	u32 byte_count;
+	size_t bcnt;
+	int inline_segment;
+
+	/* Skip SRQ next-WQE segment. */
+	if (receive_queue && qp->ibqp.srq)
+		wqe += sizeof(struct mlx5_wqe_srq_next_seg);
+
+	if (bytes_mapped)
+		*bytes_mapped = 0;
+	if (total_wqe_bytes)
+		*total_wqe_bytes = 0;
+
+	while (wqe < wqe_end) {
+		struct mlx5_wqe_data_seg *dseg = wqe;
+		io_virt = be64_to_cpu(dseg->addr);
+		key = be32_to_cpu(dseg->lkey);
+		byte_count = be32_to_cpu(dseg->byte_count);
+		inline_segment = !!(byte_count &  MLX5_INLINE_SEG);
+		bcnt	       = byte_count & ~MLX5_INLINE_SEG;
+
+		if (inline_segment) {
+			bcnt = bcnt & MLX5_WQE_INLINE_SEG_BYTE_COUNT_MASK;
+			wqe += ALIGN(sizeof(struct mlx5_wqe_inline_seg) + bcnt,
+				     16);
+		} else {
+			wqe += sizeof(*dseg);
+		}
+
+		/* receive WQE end of sg list. */
+		if (receive_queue && bcnt == 0 && key == MLX5_INVALID_LKEY &&
+		    io_virt == 0)
+			break;
+
+		if (!inline_segment && total_wqe_bytes) {
+			*total_wqe_bytes += bcnt - min_t(size_t, bcnt,
+					pfault->mpfault.bytes_committed);
+		}
+
+		/* A zero length data segment designates a length of 2GB. */
+		if (bcnt == 0)
+			bcnt = 1U << 31;
+
+		if (inline_segment || bcnt <= pfault->mpfault.bytes_committed) {
+			pfault->mpfault.bytes_committed -=
+				min_t(size_t, bcnt,
+				      pfault->mpfault.bytes_committed);
+			continue;
+		}
+
+		ret = pagefault_single_data_segment(qp, pfault,
+				key, io_virt, bcnt, bytes_mapped);
+		if (ret < 0)
+			break;
+		npages += ret;
+	}
+
+	return ret < 0 ? ret : npages;
+}
+
+/*
+ * Parse initiator WQE. Advances the wqe pointer to point at the
+ * scatter-gather list, and set wqe_end to the end of the WQE.
+ */
+static int mlx5_ib_mr_initiator_pfault_handler(
+	struct mlx5_ib_qp *qp, struct mlx5_ib_pfault *pfault,
+	void **wqe, void **wqe_end, int wqe_length)
+{
+	struct mlx5_ib_dev *dev = to_mdev(qp->ibqp.pd->device);
+	struct mlx5_wqe_ctrl_seg *ctrl = *wqe;
+	u16 wqe_index = pfault->mpfault.wqe.wqe_index;
+	unsigned ds, opcode;
+#if defined(DEBUG)
+	u32 ctrl_wqe_index, ctrl_qpn;
+#endif
+
+	ds = be32_to_cpu(ctrl->qpn_ds) & MLX5_WQE_CTRL_DS_MASK;
+	if (ds * MLX5_WQE_DS_UNITS > wqe_length) {
+		mlx5_ib_err(dev, "Unable to read the complete WQE. ds = 0x%x, ret = 0x%x\n",
+			    ds, wqe_length);
+		return -EFAULT;
+	}
+
+	if (ds == 0) {
+		mlx5_ib_err(dev, "Got WQE with zero DS. wqe_index=%x, qpn=%x\n",
+			    wqe_index, qp->mqp.qpn);
+		return -EFAULT;
+	}
+
+#if defined(DEBUG)
+	ctrl_wqe_index = (be32_to_cpu(ctrl->opmod_idx_opcode) &
+			MLX5_WQE_CTRL_WQE_INDEX_MASK) >>
+			MLX5_WQE_CTRL_WQE_INDEX_SHIFT;
+	if (wqe_index != ctrl_wqe_index) {
+		mlx5_ib_err(dev, "Got WQE with invalid wqe_index. wqe_index=0x%x, qpn=0x%x ctrl->wqe_index=0x%x\n",
+			    wqe_index, qp->mqp.qpn,
+			    ctrl_wqe_index);
+		return -EFAULT;
+	}
+
+	ctrl_qpn = (be32_to_cpu(ctrl->qpn_ds) & MLX5_WQE_CTRL_QPN_MASK) >>
+		MLX5_WQE_CTRL_QPN_SHIFT;
+	if (qp->mqp.qpn != ctrl_qpn) {
+		mlx5_ib_err(dev, "Got WQE with incorrect QP number. wqe_index=0x%x, qpn=0x%x ctrl->qpn=0x%x\n",
+			    wqe_index, qp->mqp.qpn,
+			    ctrl_qpn);
+		return -EFAULT;
+	}
+#endif /* DEBUG */
+
+	*wqe_end = *wqe + ds * MLX5_WQE_DS_UNITS;
+	*wqe += sizeof(*ctrl);
+
+	opcode = be32_to_cpu(ctrl->opmod_idx_opcode) &
+		 MLX5_WQE_CTRL_OPCODE_MASK;
+	switch (qp->ibqp.qp_type) {
+	case IB_QPT_RC:
+		switch (opcode) {
+		case MLX5_OPCODE_SEND:
+		case MLX5_OPCODE_SEND_IMM:
+		case MLX5_OPCODE_SEND_INVAL:
+			if (!(dev->odp_caps.per_transport_caps.rc_odp_caps &
+			      IB_ODP_SUPPORT_SEND))
+				goto invalid_transport_or_opcode;
+			break;
+		case MLX5_OPCODE_RDMA_WRITE:
+		case MLX5_OPCODE_RDMA_WRITE_IMM:
+			if (!(dev->odp_caps.per_transport_caps.rc_odp_caps &
+			      IB_ODP_SUPPORT_WRITE))
+				goto invalid_transport_or_opcode;
+			*wqe += sizeof(struct mlx5_wqe_raddr_seg);
+			break;
+		default:
+			goto invalid_transport_or_opcode;
+		}
+		break;
+	case IB_QPT_UD:
+		switch (opcode) {
+		case MLX5_OPCODE_SEND:
+		case MLX5_OPCODE_SEND_IMM:
+			if (!(dev->odp_caps.per_transport_caps.ud_odp_caps &
+			      IB_ODP_SUPPORT_SEND))
+				goto invalid_transport_or_opcode;
+			*wqe += sizeof(struct mlx5_wqe_datagram_seg);
+			break;
+		default:
+			goto invalid_transport_or_opcode;
+		}
+		break;
+	default:
+invalid_transport_or_opcode:
+		mlx5_ib_err(dev, "ODP fault on QP of an unsupported opcode or transport. transport: 0x%x opcode: 0x%x.\n",
+			    qp->ibqp.qp_type, opcode);
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+/*
+ * Parse responder WQE. Advances the wqe pointer to point at the
+ * scatter-gather list, and set wqe_end to the end of the WQE.
+ */
+static int mlx5_ib_mr_responder_pfault_handler(
+	struct mlx5_ib_qp *qp, struct mlx5_ib_pfault *pfault,
+	void **wqe, void **wqe_end, int wqe_length)
+{
+	struct mlx5_ib_dev *dev = to_mdev(qp->ibqp.pd->device);
+	struct mlx5_ib_wq *wq = &qp->rq;
+	int wqe_size = 1 << wq->wqe_shift;
+
+	if (qp->ibqp.srq) {
+		mlx5_ib_err(dev, "ODP fault on SRQ is not supported\n");
+		return -EFAULT;
+	}
+
+	if (qp->wq_sig) {
+		mlx5_ib_err(dev, "ODP fault with WQE signatures is not supported\n");
+		return -EFAULT;
+	}
+
+	if (wqe_size > wqe_length) {
+		mlx5_ib_err(dev, "Couldn't read all of the receive WQE's content\n");
+		return -EFAULT;
+	}
+
+	switch (qp->ibqp.qp_type) {
+	case IB_QPT_RC:
+		if (!(dev->odp_caps.per_transport_caps.rc_odp_caps &
+		      IB_ODP_SUPPORT_RECV))
+			goto invalid_transport_or_opcode;
+		break;
+	default:
+invalid_transport_or_opcode:
+		mlx5_ib_err(dev, "ODP fault on QP of an unsupported transport. transport: 0x%x\n",
+			    qp->ibqp.qp_type);
+		return -EFAULT;
+	}
+
+	*wqe_end = *wqe + wqe_size;
+
+	return 0;
+}
+
+static void mlx5_ib_mr_wqe_pfault_handler(struct mlx5_ib_qp *qp,
+					  struct mlx5_ib_pfault *pfault)
+{
+	struct mlx5_ib_dev *dev = to_mdev(qp->ibqp.pd->device);
+	int ret;
+	void *wqe, *wqe_end;
+	u32 bytes_mapped, total_wqe_bytes;
+	char *buffer = NULL;
+	int resume_with_error = 0;
+	u16 wqe_index = pfault->mpfault.wqe.wqe_index;
+	int requestor = pfault->mpfault.flags & MLX5_PFAULT_REQUESTOR;
+
+	buffer = (char *)__get_free_page(GFP_KERNEL);
+	if (!buffer) {
+		mlx5_ib_err(dev, "Error allocating memory for IO page fault handling.\n");
+		resume_with_error = 1;
+		goto resolve_page_fault;
+	}
+
+	ret = mlx5_ib_read_user_wqe(qp, requestor, wqe_index, buffer,
+				    PAGE_SIZE);
+	if (ret < 0) {
+		mlx5_ib_err(dev, "Failed reading a WQE following page fault, error=%x, wqe_index=%x, qpn=%x\n",
+			    -ret, wqe_index, qp->mqp.qpn);
+		resume_with_error = 1;
+		goto resolve_page_fault;
+	}
+
+	wqe = buffer;
+	if (requestor)
+		ret = mlx5_ib_mr_initiator_pfault_handler(qp, pfault, &wqe,
+				&wqe_end, ret);
+	else
+		ret = mlx5_ib_mr_responder_pfault_handler(qp, pfault, &wqe,
+				&wqe_end, ret);
+	if (ret < 0) {
+		resume_with_error = 1;
+		goto resolve_page_fault;
+	}
+
+	if (wqe >= wqe_end) {
+		mlx5_ib_err(dev, "ODP fault on invalid WQE.\n");
+		resume_with_error = 1;
+		goto resolve_page_fault;
+	}
+
+	ret = pagefault_data_segments(qp, pfault, wqe, wqe_end, &bytes_mapped,
+			&total_wqe_bytes, !requestor);
+	if (ret == -EAGAIN) {
+		goto resolve_page_fault;
+	} else if (ret < 0 || total_wqe_bytes > bytes_mapped) {
+		mlx5_ib_err(dev, "Error getting user pages for page fault. Error: 0x%x\n",
+			    -ret);
+		resume_with_error = 1;
+		goto resolve_page_fault;
+	}
+
+resolve_page_fault:
+	mlx5_ib_page_fault_resume(qp, pfault, resume_with_error);
+	mlx5_ib_dbg(dev, "PAGE FAULT completed. QP 0x%x resume_with_error=%d, flags: 0x%x\n",
+		    qp->mqp.qpn, resume_with_error, pfault->mpfault.flags);
+
+	free_page((unsigned long)buffer);
+}
+
 void mlx5_ib_mr_pfault_handler(struct mlx5_ib_qp *qp,
 			       struct mlx5_ib_pfault *pfault)
 {
 	u8 event_subtype = pfault->mpfault.event_subtype;
 
 	switch (event_subtype) {
+	case MLX5_PFAULT_SUBTYPE_WQE:
+		mlx5_ib_mr_wqe_pfault_handler(qp, pfault);
+		break;
 	default:
 		pr_warn("Invalid page fault event subtype: 0x%x\n",
 			event_subtype);
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index 52a2ea8..cbf544b1 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -183,7 +183,12 @@ struct mlx5_wqe_ctrl_seg {
 };
 
 #define MLX5_WQE_CTRL_DS_MASK 0x3f
+#define MLX5_WQE_CTRL_QPN_MASK 0xffffff00
+#define MLX5_WQE_CTRL_QPN_SHIFT 8
 #define MLX5_WQE_DS_UNITS 16
+#define MLX5_WQE_CTRL_OPCODE_MASK 0xff
+#define MLX5_WQE_CTRL_WQE_INDEX_MASK 0x00ffff00
+#define MLX5_WQE_CTRL_WQE_INDEX_SHIFT 8
 
 struct mlx5_wqe_xrc_seg {
 	__be32			xrc_srqn;
@@ -288,6 +293,8 @@ struct mlx5_wqe_signature_seg {
 	u8	rsvd1[11];
 };
 
+#define MLX5_WQE_INLINE_SEG_BYTE_COUNT_MASK 0x3ff
+
 struct mlx5_wqe_inline_seg {
 	__be32	byte_count;
 };
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
