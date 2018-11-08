From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 05/10] IB/mlx5: Lock QP during page fault handling
Date: Thu,  8 Nov 2018 21:10:12 +0200
Message-ID: <20181108191017.21891-6-leon@kernel.org>
References: <20181108191017.21891-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181108191017.21891-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Majd Dibbiny <majd@mellanox.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis@mellanox.com>

When page fault event for a WQE arrives, the event data contains the
resource (e.g. QP) number which will later be used by the page fault
handler to retrieve the resource. Meanwhile, another context can destroy
the resource and cause use-after-free. To avoid that, take a reference on the
resource when handler starts and release it when it ends.

Page fault events for RDMA operations don't need to be protected because
the driver doesn't need to access the QP in the page fault handler.

Fixes: d9aaed838765 ("{net,IB}/mlx5: Refactor page fault handling")
Signed-off-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/odp.c | 46 +++++++++++++++++++++++++-------
 1 file changed, 37 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index b04eb6775326..abce55b8b9ba 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1016,16 +1016,31 @@ static int mlx5_ib_mr_responder_pfault_handler(
 	return 0;
 }

-static struct mlx5_ib_qp *mlx5_ib_odp_find_qp(struct mlx5_ib_dev *dev,
-					      u32 wq_num)
+static inline struct mlx5_core_rsc_common *odp_get_rsc(struct mlx5_ib_dev *dev,
+						       u32 wq_num, int pf_type)
 {
-	struct mlx5_core_qp *mqp = __mlx5_qp_lookup(dev->mdev, wq_num);
+	enum mlx5_res_type res_type;

-	if (!mqp) {
-		mlx5_ib_err(dev, "QPN 0x%6x not found\n", wq_num);
+	switch (pf_type) {
+	case MLX5_WQE_PF_TYPE_RMP:
+		res_type = MLX5_RES_SRQ;
+		break;
+	case MLX5_WQE_PF_TYPE_REQ_SEND_OR_WRITE:
+	case MLX5_WQE_PF_TYPE_RESP:
+	case MLX5_WQE_PF_TYPE_REQ_READ_OR_ATOMIC:
+		res_type = MLX5_RES_QP;
+		break;
+	default:
 		return NULL;
 	}

+	return mlx5_core_res_hold(dev->mdev, wq_num, res_type);
+}
+
+static inline struct mlx5_ib_qp *res_to_qp(struct mlx5_core_rsc_common *res)
+{
+	struct mlx5_core_qp *mqp = (struct mlx5_core_qp *)res;
+
 	return to_mibqp(mqp);
 }

@@ -1039,18 +1054,30 @@ static void mlx5_ib_mr_wqe_pfault_handler(struct mlx5_ib_dev *dev,
 	int resume_with_error = 1;
 	u16 wqe_index = pfault->wqe.wqe_index;
 	int requestor = pfault->type & MLX5_PFAULT_REQUESTOR;
+	struct mlx5_core_rsc_common *res;
 	struct mlx5_ib_qp *qp;

+	res = odp_get_rsc(dev, pfault->wqe.wq_num, pfault->type);
+	if (!res) {
+		mlx5_ib_dbg(dev, "wqe page fault for missing resource %d\n", pfault->wqe.wq_num);
+		return;
+	}
+
+	switch (res->res) {
+	case MLX5_RES_QP:
+		qp = res_to_qp(res);
+		break;
+	default:
+		mlx5_ib_err(dev, "wqe page fault for unsupported type %d\n", pfault->type);
+		goto resolve_page_fault;
+	}
+
 	buffer = (char *)__get_free_page(GFP_KERNEL);
 	if (!buffer) {
 		mlx5_ib_err(dev, "Error allocating memory for IO page fault handling.\n");
 		goto resolve_page_fault;
 	}

-	qp = mlx5_ib_odp_find_qp(dev, pfault->wqe.wq_num);
-	if (!qp)
-		goto resolve_page_fault;
-
 	ret = mlx5_ib_read_user_wqe(qp, requestor, wqe_index, buffer,
 				    PAGE_SIZE, &qp->trans_qp.base);
 	if (ret < 0) {
@@ -1090,6 +1117,7 @@ static void mlx5_ib_mr_wqe_pfault_handler(struct mlx5_ib_dev *dev,
 	mlx5_ib_dbg(dev, "PAGE FAULT completed. QP 0x%x resume_with_error=%d, type: 0x%x\n",
 		    pfault->wqe.wq_num, resume_with_error,
 		    pfault->type);
+	mlx5_core_res_put(res);
 	free_page((unsigned long)buffer);
 }
