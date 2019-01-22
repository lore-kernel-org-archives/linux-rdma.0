From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 07/12] IB/mlx5: Let read user wqe also from SRQ buffer
Date: Tue, 22 Jan 2019 08:48:46 +0200
Message-ID: <20190122064851.6032-8-leon@kernel.org>
References: <20190122064851.6032-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190122064851.6032-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis@mellanox.com>

Reading a WQE from SRQ is almost identical to reading from regular RQ.
The differences are the size of the queue, the size of a WQE and buffer
location.

Make necessary changes to mlx5_ib_read_user_wqe() to let it read a WQE
from a SRQ or RQ by caller choice.

Signed-off-by: Moni Shoua <monis@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |   9 +-
 drivers/infiniband/hw/mlx5/odp.c     |  20 ++-
 drivers/infiniband/hw/mlx5/qp.c      | 192 ++++++++++++++++++++-------
 3 files changed, 166 insertions(+), 55 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 1f1dd19c9d85..c4f74c425c12 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1076,9 +1076,12 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, const struct ib_send_wr *wr,
 		      const struct ib_send_wr **bad_wr);
 int mlx5_ib_post_recv(struct ib_qp *ibqp, const struct ib_recv_wr *wr,
 		      const struct ib_recv_wr **bad_wr);
-int mlx5_ib_read_user_wqe(struct mlx5_ib_qp *qp, int send, int wqe_index,
-			  void *buffer, u32 length,
-			  struct mlx5_ib_qp_base *base);
+int mlx5_ib_read_user_wqe_sq(struct mlx5_ib_qp *qp, int wqe_index, void *buffer,
+			     int buflen, size_t *bc);
+int mlx5_ib_read_user_wqe_rq(struct mlx5_ib_qp *qp, int wqe_index, void *buffer,
+			     int buflen, size_t *bc);
+int mlx5_ib_read_user_wqe_srq(struct mlx5_ib_srq *srq, int wqe_index,
+			      void *buffer, int buflen, size_t *bc);
 struct ib_cq *mlx5_ib_create_cq(struct ib_device *ibdev,
 				const struct ib_cq_init_attr *attr,
 				struct ib_ucontext *context,
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index cc01d92490cc..cc690aa915de 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1154,6 +1154,7 @@ static void mlx5_ib_mr_wqe_pfault_handler(struct mlx5_ib_dev *dev,
 	int requestor = pfault->type & MLX5_PFAULT_REQUESTOR;
 	struct mlx5_core_rsc_common *res;
 	struct mlx5_ib_qp *qp;
+	size_t bytes_copied;
 
 	res = odp_get_rsc(dev, pfault->wqe.wq_num, pfault->type);
 	if (!res) {
@@ -1176,9 +1177,16 @@ static void mlx5_ib_mr_wqe_pfault_handler(struct mlx5_ib_dev *dev,
 		goto resolve_page_fault;
 	}
 
-	ret = mlx5_ib_read_user_wqe(qp, requestor, wqe_index, buffer,
-				    PAGE_SIZE, &qp->trans_qp.base);
-	if (ret < 0) {
+	if (requestor)
+		ret = mlx5_ib_read_user_wqe_sq(qp, wqe_index,
+					       buffer, PAGE_SIZE,
+					       &bytes_copied);
+	else
+		ret = mlx5_ib_read_user_wqe_rq(qp, wqe_index,
+					       buffer, PAGE_SIZE,
+					       &bytes_copied);
+
+	if (ret) {
 		mlx5_ib_err(dev, "Failed reading a WQE following page fault, error=%d, wqe_index=%x, qpn=%x\n",
 			    ret, wqe_index, pfault->token);
 		goto resolve_page_fault;
@@ -1187,10 +1195,12 @@ static void mlx5_ib_mr_wqe_pfault_handler(struct mlx5_ib_dev *dev,
 	wqe = buffer;
 	if (requestor)
 		ret = mlx5_ib_mr_initiator_pfault_handler(dev, pfault, qp, &wqe,
-							  &wqe_end, ret);
+							  &wqe_end,
+							  bytes_copied);
 	else
 		ret = mlx5_ib_mr_responder_pfault_handler(dev, qp, wqe,
-							  &wqe_end, ret);
+							  &wqe_end,
+							  bytes_copied);
 	if (ret < 0)
 		goto resolve_page_fault;
 
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index dba75b96f971..9f41e114fc20 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -109,75 +109,173 @@ static int is_sqp(enum ib_qp_type qp_type)
 }
 
 /**
- * mlx5_ib_read_user_wqe() - Copy a user-space WQE to kernel space.
+ * mlx5_ib_read_user_wqe_common() - Copy a WQE (or part of) from user WQ
+ * to kernel buffer
  *
- * @qp: QP to copy from.
- * @send: copy from the send queue when non-zero, use the receive queue
- *	  otherwise.
- * @wqe_index:  index to start copying from. For send work queues, the
- *		wqe_index is in units of MLX5_SEND_WQE_BB.
- *		For receive work queue, it is the number of work queue
- *		element in the queue.
- * @buffer: destination buffer.
- * @length: maximum number of bytes to copy.
+ * @umem: User space memory where the WQ is
+ * @buffer: buffer to copy to
+ * @buflen: buffer length
+ * @wqe_index: index of WQE to copy from
+ * @wq_offset: offset to start of WQ
+ * @wq_wqe_cnt: number of WQEs in WQ
+ * @wq_wqe_shift: log2 of WQE size
+ * @bcnt: number of bytes to copy
+ * @bytes_copied: number of bytes to copy (return value)
  *
- * Copies at least a single WQE, but may copy more data.
+ * Copies from start of WQE bcnt or less bytes.
+ * Does not gurantee to copy the entire WQE.
  *
- * Return: the number of bytes copied, or an error code.
+ * Return: zero on success, or an error code.
  */
-int mlx5_ib_read_user_wqe(struct mlx5_ib_qp *qp, int send, int wqe_index,
-			  void *buffer, u32 length,
-			  struct mlx5_ib_qp_base *base)
+static int mlx5_ib_read_user_wqe_common(struct ib_umem *umem,
+					void *buffer,
+					u32 buflen,
+					int wqe_index,
+					int wq_offset,
+					int wq_wqe_cnt,
+					int wq_wqe_shift,
+					int bcnt,
+					size_t *bytes_copied)
+{
+	size_t offset = wq_offset + ((wqe_index % wq_wqe_cnt) << wq_wqe_shift);
+	size_t wq_end = wq_offset + (wq_wqe_cnt << wq_wqe_shift);
+	size_t copy_length;
+	int ret;
+
+	/* don't copy more than requested, more than buffer length or
+	 * beyond WQ end
+	 */
+	copy_length = min_t(u32, buflen, wq_end - offset);
+	copy_length = min_t(u32, copy_length, bcnt);
+
+	ret = ib_umem_copy_from(buffer, umem, offset, copy_length);
+	if (ret)
+		return ret;
+
+	if (!ret && bytes_copied)
+		*bytes_copied = copy_length;
+
+	return 0;
+}
+
+int mlx5_ib_read_user_wqe_sq(struct mlx5_ib_qp *qp,
+			     int wqe_index,
+			     void *buffer,
+			     int buflen,
+			     size_t *bc)
 {
-	struct ib_device *ibdev = qp->ibqp.device;
-	struct mlx5_ib_dev *dev = to_mdev(ibdev);
-	struct mlx5_ib_wq *wq = send ? &qp->sq : &qp->rq;
-	size_t offset;
-	size_t wq_end;
+	struct mlx5_ib_qp_base *base = &qp->trans_qp.base;
 	struct ib_umem *umem = base->ubuffer.umem;
-	u32 first_copy_length;
-	int wqe_length;
+	struct mlx5_ib_wq *wq = &qp->sq;
+	struct mlx5_wqe_ctrl_seg *ctrl;
+	size_t bytes_copied;
+	size_t bytes_copied2;
+	size_t wqe_length;
 	int ret;
+	int ds;
 
-	if (wq->wqe_cnt == 0) {
-		mlx5_ib_dbg(dev, "mlx5_ib_read_user_wqe for a QP with wqe_cnt == 0. qp_type: 0x%x\n",
-			    qp->ibqp.qp_type);
+	if (buflen < sizeof(*ctrl))
 		return -EINVAL;
-	}
 
-	offset = wq->offset + ((wqe_index % wq->wqe_cnt) << wq->wqe_shift);
-	wq_end = wq->offset + (wq->wqe_cnt << wq->wqe_shift);
+	/* at first read as much as possible */
+	ret = mlx5_ib_read_user_wqe_common(umem,
+					   buffer,
+					   buflen,
+					   wqe_index,
+					   wq->offset,
+					   wq->wqe_cnt,
+					   wq->wqe_shift,
+					   buflen,
+					   &bytes_copied);
+	if (ret)
+		return ret;
 
-	if (send && length < sizeof(struct mlx5_wqe_ctrl_seg))
+	/* we need at least control segment size to proceed */
+	if (bytes_copied < sizeof(*ctrl))
 		return -EINVAL;
 
-	if (offset > umem->length ||
-	    (send && offset + sizeof(struct mlx5_wqe_ctrl_seg) > umem->length))
-		return -EINVAL;
+	ctrl = buffer;
+	ds = be32_to_cpu(ctrl->qpn_ds) & MLX5_WQE_CTRL_DS_MASK;
+	wqe_length = ds * MLX5_WQE_DS_UNITS;
+
+	/* if we copied enough then we are done */
+	if (bytes_copied >= wqe_length) {
+		*bc = bytes_copied;
+		return 0;
+	}
+
+	/* otherwise this a wrapped around wqe
+	 * so read the remaining bytes starting
+	 * from  wqe_index 0
+	 */
+	ret = mlx5_ib_read_user_wqe_common(umem,
+					   buffer + bytes_copied,
+					   buflen - bytes_copied,
+					   0,
+					   wq->offset,
+					   wq->wqe_cnt,
+					   wq->wqe_shift,
+					   wqe_length - bytes_copied,
+					   &bytes_copied2);
 
-	first_copy_length = min_t(u32, offset + length, wq_end) - offset;
-	ret = ib_umem_copy_from(buffer, umem, offset, first_copy_length);
 	if (ret)
 		return ret;
+	*bc = bytes_copied + bytes_copied2;
+	return 0;
+}
 
-	if (send) {
-		struct mlx5_wqe_ctrl_seg *ctrl = buffer;
-		int ds = be32_to_cpu(ctrl->qpn_ds) & MLX5_WQE_CTRL_DS_MASK;
-
-		wqe_length = ds * MLX5_WQE_DS_UNITS;
-	} else {
-		wqe_length = 1 << wq->wqe_shift;
-	}
+int mlx5_ib_read_user_wqe_rq(struct mlx5_ib_qp *qp,
+			     int wqe_index,
+			     void *buffer,
+			     int buflen,
+			     size_t *bc)
+{
+	struct mlx5_ib_qp_base *base = &qp->trans_qp.base;
+	struct ib_umem *umem = base->ubuffer.umem;
+	struct mlx5_ib_wq *wq = &qp->rq;
+	size_t bytes_copied;
+	int ret;
 
-	if (wqe_length <= first_copy_length)
-		return first_copy_length;
+	ret = mlx5_ib_read_user_wqe_common(umem,
+					   buffer,
+					   buflen,
+					   wqe_index,
+					   wq->offset,
+					   wq->wqe_cnt,
+					   wq->wqe_shift,
+					   buflen,
+					   &bytes_copied);
 
-	ret = ib_umem_copy_from(buffer + first_copy_length, umem, wq->offset,
-				wqe_length - first_copy_length);
 	if (ret)
 		return ret;
+	*bc = bytes_copied;
+	return 0;
+}
+
+int mlx5_ib_read_user_wqe_srq(struct mlx5_ib_srq *srq,
+			      int wqe_index,
+			      void *buffer,
+			      int buflen,
+			      size_t *bc)
+{
+	struct ib_umem *umem = srq->umem;
+	size_t bytes_copied;
+	int ret;
+
+	ret = mlx5_ib_read_user_wqe_common(umem,
+					   buffer,
+					   buflen,
+					   wqe_index,
+					   0,
+					   srq->msrq.max,
+					   srq->msrq.wqe_shift,
+					   buflen,
+					   &bytes_copied);
 
-	return wqe_length;
+	if (ret)
+		return ret;
+	*bc = bytes_copied;
+	return 0;
 }
 
 static void mlx5_ib_qp_event(struct mlx5_core_qp *qp, int type)
-- 
2.19.1
