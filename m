From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 05/12] IB/mlx5: Clean mlx5_ib_mr_responder_pfault_handler() signature
Date: Tue, 22 Jan 2019 08:48:44 +0200
Message-ID: <20190122064851.6032-6-leon@kernel.org>
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

In the function mlx5_ib_mr_responder_pfault_handler()

1. The parameter wqe is used as read-only so there
   is no need to pass it by reference.
2. Remove the unused argument pfault from  list of arguments.

Signed-off-by: Moni Shoua <monis@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/odp.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index d2e8e74e24c9..71f543d3b70e 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1064,12 +1064,12 @@ static int mlx5_ib_mr_initiator_pfault_handler(
 }
 
 /*
- * Parse responder WQE. Advances the wqe pointer to point at the
- * scatter-gather list, and set wqe_end to the end of the WQE.
+ * Parse responder WQE and set wqe_end to the end of the WQE.
  */
-static int mlx5_ib_mr_responder_pfault_handler(
-	struct mlx5_ib_dev *dev, struct mlx5_pagefault *pfault,
-	struct mlx5_ib_qp *qp, void **wqe, void **wqe_end, int wqe_length)
+static int mlx5_ib_mr_responder_pfault_handler(struct mlx5_ib_dev *dev,
+					       struct mlx5_ib_qp *qp, void *wqe,
+					       void **wqe_end,
+					       int wqe_length)
 {
 	struct mlx5_ib_wq *wq = &qp->rq;
 	int wqe_size = 1 << wq->wqe_shift;
@@ -1102,7 +1102,7 @@ static int mlx5_ib_mr_responder_pfault_handler(
 		return -EFAULT;
 	}
 
-	*wqe_end = *wqe + wqe_size;
+	*wqe_end = wqe + wqe_size;
 
 	return 0;
 }
@@ -1185,7 +1185,7 @@ static void mlx5_ib_mr_wqe_pfault_handler(struct mlx5_ib_dev *dev,
 		ret = mlx5_ib_mr_initiator_pfault_handler(dev, pfault, qp, &wqe,
 							  &wqe_end, ret);
 	else
-		ret = mlx5_ib_mr_responder_pfault_handler(dev, pfault, qp, &wqe,
+		ret = mlx5_ib_mr_responder_pfault_handler(dev, qp, wqe,
 							  &wqe_end, ret);
 	if (ret < 0)
 		goto resolve_page_fault;
-- 
2.19.1
