From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 10/12] RDMA/mlx5: Reuse existed shift_overlow helper
Date: Sun, 24 Jun 2018 11:23:51 +0300
Message-ID: <20180624082353.16138-11-leon@kernel.org>
References: <20180624082353.16138-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180624082353.16138-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Hadar Hen Zion <hadarh@mellanox.com>, Matan Barak <matanb@mellanox.com>, Michael J Ruhl <michael.j.ruhl@intel.com>, Noa Osherovich <noaos@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Rewrite commit 002bf2282b2d ("RDMA/mlx5: Protect from shift operand
overflow") to reuse newly introduced shift_overflow() helper.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 8e40263fd40e..5471b57b873d 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -259,13 +259,17 @@ static int set_rq_size(struct mlx5_ib_dev *dev, struct ib_qp_cap *cap,
 		cap->max_recv_sge = 0;
 	} else {
 		if (ucmd) {
+			size_t s;
+
 			qp->rq.wqe_cnt = ucmd->rq_wqe_count;
-			if (ucmd->rq_wqe_shift > BITS_PER_BYTE * sizeof(ucmd->rq_wqe_shift))
+			s = shift_overflow(1, ucmd->rq_wqe_shift);
+			if (s == SIZE_MAX)
 				return -EINVAL;
 			qp->rq.wqe_shift = ucmd->rq_wqe_shift;
-			if ((1 << qp->rq.wqe_shift) / sizeof(struct mlx5_wqe_data_seg) < qp->wq_sig)
+			if (s / sizeof(struct mlx5_wqe_data_seg) < qp->wq_sig)
 				return -EINVAL;
-			qp->rq.max_gs = (1 << qp->rq.wqe_shift) / sizeof(struct mlx5_wqe_data_seg) - qp->wq_sig;
+			qp->rq.max_gs = s / sizeof(struct mlx5_wqe_data_seg) -
+					qp->wq_sig;
 			qp->rq.max_post = qp->rq.wqe_cnt;
 		} else {
 			wqe_size = qp->wq_sig ? sizeof(struct mlx5_wqe_signature_seg) : 0;
-- 
2.14.4
