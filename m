From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 05/17] IB/mlx5: Add function to read WQE from user-space
Date: Tue, 11 Nov 2014 18:36:11 +0200
Message-ID: <1415723783-2138-6-git-send-email-haggaie@mellanox.com>
References: <1415723783-2138-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415723783-2138-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add a helper function mlx5_ib_read_user_wqe to read information from
user-space owned work queues. The function will be used in a later patch by
the page-fault handling code in mlx5_ib.

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  2 +
 drivers/infiniband/hw/mlx5/qp.c      | 73 ++++++++++++++++++++++++++++++++++++
 include/linux/mlx5/qp.h              |  3 ++
 3 files changed, 78 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 53d19e6e69a4..14a0311eaa1c 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -503,6 +503,8 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 int mlx5_ib_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 		      struct ib_recv_wr **bad_wr);
 void *mlx5_get_send_wqe(struct mlx5_ib_qp *qp, int n);
+int mlx5_ib_read_user_wqe(struct mlx5_ib_qp *qp, int send, int wqe_index,
+			  void *buffer, u32 length);
 struct ib_cq *mlx5_ib_create_cq(struct ib_device *ibdev, int entries,
 				int vector, struct ib_ucontext *context,
 				struct ib_udata *udata);
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 7f362afa1a38..455d40779112 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -101,6 +101,79 @@ void *mlx5_get_send_wqe(struct mlx5_ib_qp *qp, int n)
 	return get_wqe(qp, qp->sq.offset + (n << MLX5_IB_SQ_STRIDE));
 }
 
+/**
+ * mlx5_ib_read_user_wqe() - Copy a user-space WQE to kernel space.
+ *
+ * @qp: QP to copy from.
+ * @send: copy from the send queue when non-zero, use the receive queue
+ *	  otherwise.
+ * @wqe_index:  index to start copying from. For send work queues, the
+ *		wqe_index is in units of MLX5_SEND_WQE_BB.
+ *		For receive work queue, it is the number of work queue
+ *		element in the queue.
+ * @buffer: destination buffer.
+ * @length: maximum number of bytes to copy.
+ *
+ * Copies at least a single WQE, but may copy more data.
+ *
+ * Return: the number of bytes copied, or an error code.
+ */
+int mlx5_ib_read_user_wqe(struct mlx5_ib_qp *qp, int send, int wqe_index,
+			  void *buffer, u32 length)
+{
+	struct ib_device *ibdev = qp->ibqp.device;
+	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	struct mlx5_ib_wq *wq = send ? &qp->sq : &qp->rq;
+	size_t offset;
+	size_t wq_end;
+	struct ib_umem *umem = qp->umem;
+	u32 first_copy_length;
+	int wqe_length;
+	int copied;
+	int ret;
+
+	if (wq->wqe_cnt == 0) {
+		mlx5_ib_dbg(dev, "mlx5_ib_read_user_wqe for a QP with wqe_cnt == 0. qp_type: 0x%x\n",
+			    qp->ibqp.qp_type);
+		return -EINVAL;
+	}
+
+	offset = wq->offset + ((wqe_index % wq->wqe_cnt) << wq->wqe_shift);
+	wq_end = wq->offset + (wq->wqe_cnt << wq->wqe_shift);
+
+	if (send && length < sizeof(struct mlx5_wqe_ctrl_seg))
+		return -EINVAL;
+
+	if (offset > umem->length ||
+	    (send && offset + sizeof(struct mlx5_wqe_ctrl_seg) > umem->length))
+		return -EINVAL;
+
+	first_copy_length = min_t(u32, offset + length, wq_end) - offset;
+	copied = ib_umem_copy_from(umem, offset, buffer, first_copy_length);
+	if (copied < first_copy_length)
+		return copied;
+
+	if (send) {
+		struct mlx5_wqe_ctrl_seg *ctrl = buffer;
+		int ds = be32_to_cpu(ctrl->qpn_ds) & MLX5_WQE_CTRL_DS_MASK;
+
+		wqe_length = ds * MLX5_WQE_DS_UNITS;
+	} else {
+		wqe_length = 1 << wq->wqe_shift;
+	}
+
+	if (wqe_length <= first_copy_length)
+		return first_copy_length;
+
+	ret = ib_umem_copy_from(umem, wq->offset, buffer + first_copy_length,
+				wqe_length - first_copy_length);
+	if (ret < 0)
+		return ret;
+	copied += ret;
+
+	return copied;
+}
+
 static void mlx5_ib_qp_event(struct mlx5_core_qp *qp, int type)
 {
 	struct ib_qp *ibqp = &to_mibqp(qp)->ibqp;
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index 3fa075daeb1d..67f4b9660b06 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -189,6 +189,9 @@ struct mlx5_wqe_ctrl_seg {
 	__be32			imm;
 };
 
+#define MLX5_WQE_CTRL_DS_MASK 0x3f
+#define MLX5_WQE_DS_UNITS 16
+
 struct mlx5_wqe_xrc_seg {
 	__be32			xrc_srqn;
 	u8			rsvd[12];
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
