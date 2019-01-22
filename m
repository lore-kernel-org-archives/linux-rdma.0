From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 08/12] IB/mlx5: Add ODP SRQ support
Date: Tue, 22 Jan 2019 08:48:47 +0200
Message-ID: <20190122064851.6032-9-leon@kernel.org>
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

Add changes to the WQE page-fault handler to

1. Identify that the event is for a SRQ WQE
2. Pass SRQ object instead of a QP to the function that reads the WQE
3. Parse the SRQ WQE with respect to its structure

The rest is handled as for regular RQ WQE.

Signed-off-by: Moni Shoua <monis@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/odp.c | 84 +++++++++++++++++++++++---------
 1 file changed, 61 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index cc690aa915de..4ddb22e0059d 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1070,19 +1070,32 @@ static int mlx5_ib_mr_initiator_pfault_handler(
 /*
  * Parse responder WQE and set wqe_end to the end of the WQE.
  */
-static int mlx5_ib_mr_responder_pfault_handler(struct mlx5_ib_dev *dev,
-					       struct mlx5_ib_qp *qp, void *wqe,
-					       void **wqe_end,
-					       int wqe_length)
+static int mlx5_ib_mr_responder_pfault_handler_srq(struct mlx5_ib_dev *dev,
+						   struct mlx5_ib_srq *srq,
+						   void **wqe, void **wqe_end,
+						   int wqe_length)
 {
-	struct mlx5_ib_wq *wq = &qp->rq;
-	int wqe_size = 1 << wq->wqe_shift;
+	int wqe_size = 1 << srq->msrq.wqe_shift;
 
-	if (qp->ibqp.srq) {
-		mlx5_ib_err(dev, "ODP fault on SRQ is not supported\n");
+	if (wqe_size > wqe_length) {
+		mlx5_ib_err(dev, "Couldn't read all of the receive WQE's content\n");
 		return -EFAULT;
 	}
 
+	*wqe_end = *wqe + wqe_size;
+	*wqe += sizeof(struct mlx5_wqe_srq_next_seg);
+
+	return 0;
+}
+
+static int mlx5_ib_mr_responder_pfault_handler_rq(struct mlx5_ib_dev *dev,
+						  struct mlx5_ib_qp *qp,
+						  void *wqe, void **wqe_end,
+						  int wqe_length)
+{
+	struct mlx5_ib_wq *wq = &qp->rq;
+	int wqe_size = 1 << wq->wqe_shift;
+
 	if (qp->wq_sig) {
 		mlx5_ib_err(dev, "ODP fault with WQE signatures is not supported\n");
 		return -EFAULT;
@@ -1142,6 +1155,14 @@ static inline struct mlx5_ib_qp *res_to_qp(struct mlx5_core_rsc_common *res)
 	return to_mibqp(mqp);
 }
 
+static inline struct mlx5_ib_srq *res_to_srq(struct mlx5_core_rsc_common *res)
+{
+	struct mlx5_core_srq *msrq =
+		container_of(res, struct mlx5_core_srq, common);
+
+	return to_mibsrq(msrq);
+}
+
 static void mlx5_ib_mr_wqe_pfault_handler(struct mlx5_ib_dev *dev,
 					  struct mlx5_pagefault *pfault)
 {
@@ -1152,8 +1173,9 @@ static void mlx5_ib_mr_wqe_pfault_handler(struct mlx5_ib_dev *dev,
 	int resume_with_error = 1;
 	u16 wqe_index = pfault->wqe.wqe_index;
 	int requestor = pfault->type & MLX5_PFAULT_REQUESTOR;
-	struct mlx5_core_rsc_common *res;
-	struct mlx5_ib_qp *qp;
+	struct mlx5_core_rsc_common *res = NULL;
+	struct mlx5_ib_qp *qp = NULL;
+	struct mlx5_ib_srq *srq = NULL;
 	size_t bytes_copied;
 
 	res = odp_get_rsc(dev, pfault->wqe.wq_num, pfault->type);
@@ -1166,6 +1188,10 @@ static void mlx5_ib_mr_wqe_pfault_handler(struct mlx5_ib_dev *dev,
 	case MLX5_RES_QP:
 		qp = res_to_qp(res);
 		break;
+	case MLX5_RES_SRQ:
+	case MLX5_RES_XSRQ:
+		srq = res_to_srq(res);
+		break;
 	default:
 		mlx5_ib_err(dev, "wqe page fault for unsupported type %d\n", pfault->type);
 		goto resolve_page_fault;
@@ -1177,14 +1203,21 @@ static void mlx5_ib_mr_wqe_pfault_handler(struct mlx5_ib_dev *dev,
 		goto resolve_page_fault;
 	}
 
-	if (requestor)
-		ret = mlx5_ib_read_user_wqe_sq(qp, wqe_index,
-					       buffer, PAGE_SIZE,
-					       &bytes_copied);
-	else
-		ret = mlx5_ib_read_user_wqe_rq(qp, wqe_index,
-					       buffer, PAGE_SIZE,
-					       &bytes_copied);
+	if (qp) {
+		if (requestor) {
+			ret = mlx5_ib_read_user_wqe_sq(qp, wqe_index,
+					buffer, PAGE_SIZE,
+					&bytes_copied);
+		} else {
+			ret = mlx5_ib_read_user_wqe_rq(qp, wqe_index,
+					buffer, PAGE_SIZE,
+					&bytes_copied);
+		}
+	} else {
+		ret = mlx5_ib_read_user_wqe_srq(srq, wqe_index,
+						buffer, PAGE_SIZE,
+						&bytes_copied);
+	}
 
 	if (ret) {
 		mlx5_ib_err(dev, "Failed reading a WQE following page fault, error=%d, wqe_index=%x, qpn=%x\n",
@@ -1194,13 +1227,18 @@ static void mlx5_ib_mr_wqe_pfault_handler(struct mlx5_ib_dev *dev,
 
 	wqe = buffer;
 	if (requestor)
-		ret = mlx5_ib_mr_initiator_pfault_handler(dev, pfault, qp, &wqe,
-							  &wqe_end,
+		ret = mlx5_ib_mr_initiator_pfault_handler(dev, pfault, qp,
+							  &wqe,  &wqe_end,
 							  bytes_copied);
+	else if (qp)
+		ret = mlx5_ib_mr_responder_pfault_handler_rq(dev, qp,
+							     wqe, &wqe_end,
+							     bytes_copied);
 	else
-		ret = mlx5_ib_mr_responder_pfault_handler(dev, qp, wqe,
-							  &wqe_end,
-							  bytes_copied);
+		ret = mlx5_ib_mr_responder_pfault_handler_srq(dev, srq,
+							      &wqe, &wqe_end,
+							      bytes_copied);
+
 	if (ret < 0)
 		goto resolve_page_fault;
 
-- 
2.19.1
