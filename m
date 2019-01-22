From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 04/12] IB/mlx5: Remove useless check in ODP handler
Date: Tue, 22 Jan 2019 08:48:43 +0200
Message-ID: <20190122064851.6032-5-leon@kernel.org>
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

When handling an ODP event for a revive WQE in SRQ the target QP
is unknown. Therefore, it is wrong to ask if QP has a SRQ in
the page-fault handler.

Signed-off-by: Moni Shoua <monis@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/odp.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index beff8c8908b5..d2e8e74e24c9 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -869,7 +869,6 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev, u32 key,
 /**
  * Parse a series of data segments for page fault handling.
  *
- * @qp the QP on which the fault occurred.
  * @pfault contains page fault information.
  * @wqe points at the first data segment in the WQE.
  * @wqe_end points after the end of the WQE.
@@ -886,7 +885,7 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev, u32 key,
  */
 static int pagefault_data_segments(struct mlx5_ib_dev *dev,
 				   struct mlx5_pagefault *pfault,
-				   struct mlx5_ib_qp *qp, void *wqe,
+				   void *wqe,
 				   void *wqe_end, u32 *bytes_mapped,
 				   u32 *total_wqe_bytes, int receive_queue)
 {
@@ -897,10 +896,6 @@ static int pagefault_data_segments(struct mlx5_ib_dev *dev,
 	size_t bcnt;
 	int inline_segment;
 
-	/* Skip SRQ next-WQE segment. */
-	if (receive_queue && qp->ibqp.srq)
-		wqe += sizeof(struct mlx5_wqe_srq_next_seg);
-
 	if (bytes_mapped)
 		*bytes_mapped = 0;
 	if (total_wqe_bytes)
@@ -1200,7 +1195,7 @@ static void mlx5_ib_mr_wqe_pfault_handler(struct mlx5_ib_dev *dev,
 		goto resolve_page_fault;
 	}
 
-	ret = pagefault_data_segments(dev, pfault, qp, wqe, wqe_end,
+	ret = pagefault_data_segments(dev, pfault, wqe, wqe_end,
 				      &bytes_mapped, &total_wqe_bytes,
 				      !requestor);
 	if (ret == -EAGAIN) {
-- 
2.19.1
