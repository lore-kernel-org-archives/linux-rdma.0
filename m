From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 3/4] IB/mlx5: Use helper to get CQE opcode
Date: Tue,  4 Dec 2018 18:03:02 -0800
Message-ID: <20181205020303.16318-4-saeedm@mellanox.com>
References: <20181205020303.16318-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181205020303.16318-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, Tariq Toukan <tariqt@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Use the new helper that extracts the opcode
from a CQE (completion queue entry) structure.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/infiniband/hw/mlx5/cq.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 0b99f7d0630d..26ab9041f94a 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -82,7 +82,7 @@ static void *get_sw_cqe(struct mlx5_ib_cq *cq, int n)
 
 	cqe64 = (cq->mcq.cqe_sz == 64) ? cqe : cqe + 64;
 
-	if (likely((cqe64->op_own) >> 4 != MLX5_CQE_INVALID) &&
+	if (likely(get_cqe_opcode(cqe64) != MLX5_CQE_INVALID) &&
 	    !((cqe64->op_own & MLX5_CQE_OWNER_MASK) ^ !!(n & (cq->ibcq.cqe + 1)))) {
 		return cqe;
 	} else {
@@ -197,7 +197,7 @@ static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
 	}
 	wc->byte_len = be32_to_cpu(cqe->byte_cnt);
 
-	switch (cqe->op_own >> 4) {
+	switch (get_cqe_opcode(cqe)) {
 	case MLX5_CQE_RESP_WR_IMM:
 		wc->opcode	= IB_WC_RECV_RDMA_WITH_IMM;
 		wc->wc_flags	= IB_WC_WITH_IMM;
@@ -537,7 +537,7 @@ static int mlx5_poll_one(struct mlx5_ib_cq *cq,
 	 */
 	rmb();
 
-	opcode = cqe64->op_own >> 4;
+	opcode = get_cqe_opcode(cqe64);
 	if (unlikely(opcode == MLX5_CQE_RESIZE_CQ)) {
 		if (likely(cq->resize_buf)) {
 			free_cq_buf(dev, &cq->buf);
@@ -1295,7 +1295,7 @@ static int copy_resize_cqes(struct mlx5_ib_cq *cq)
 		return -EINVAL;
 	}
 
-	while ((scqe64->op_own >> 4) != MLX5_CQE_RESIZE_CQ) {
+	while (get_cqe_opcode(scqe64) != MLX5_CQE_RESIZE_CQ) {
 		dcqe = mlx5_frag_buf_get_wqe(&cq->resize_buf->fbc,
 					     (i + 1) & cq->resize_buf->nent);
 		dcqe64 = dsize == 64 ? dcqe : dcqe + 64;
-- 
2.19.2
