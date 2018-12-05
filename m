From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH V2 mlx5-next 2/4] net/mlx5: Use helper to get CQE opcode
Date: Wed,  5 Dec 2018 15:08:08 -0800
Message-ID: <20181205230810.1886-3-saeedm@mellanox.com>
References: <20181205230810.1886-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181205230810.1886-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, Tariq Toukan <tariqt@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Introduce and use a helper that extracts the opcode
from a CQE (completion queue entry) structure.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c     | 10 +++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c     |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c |  2 +-
 include/linux/mlx5/device.h                         |  5 +++++
 4 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 79638dcbae78..31956ddd394e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -554,9 +554,9 @@ static inline void mlx5e_poll_ico_single_cqe(struct mlx5e_cq *cq,
 
 	mlx5_cqwq_pop(&cq->wq);
 
-	if (unlikely((cqe->op_own >> 4) != MLX5_CQE_REQ)) {
+	if (unlikely(get_cqe_opcode(cqe) != MLX5_CQE_REQ)) {
 		netdev_WARN_ONCE(cq->channel->netdev,
-				 "Bad OP in ICOSQ CQE: 0x%x\n", cqe->op_own);
+				 "Bad OP in ICOSQ CQE: 0x%x\n", get_cqe_opcode(cqe));
 		return;
 	}
 
@@ -898,7 +898,7 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 	prefetchw(va); /* xdp_frame data area */
 	prefetch(data);
 
-	if (unlikely((cqe->op_own >> 4) != MLX5_CQE_RESP_SEND)) {
+	if (unlikely(get_cqe_opcode(cqe) != MLX5_CQE_RESP_SEND)) {
 		rq->stats->wqe_err++;
 		return NULL;
 	}
@@ -930,7 +930,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 	u16 byte_cnt     = cqe_bcnt - headlen;
 	struct sk_buff *skb;
 
-	if (unlikely((cqe->op_own >> 4) != MLX5_CQE_RESP_SEND)) {
+	if (unlikely(get_cqe_opcode(cqe) != MLX5_CQE_RESP_SEND)) {
 		rq->stats->wqe_err++;
 		return NULL;
 	}
@@ -1148,7 +1148,7 @@ void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 
 	wi->consumed_strides += cstrides;
 
-	if (unlikely((cqe->op_own >> 4) != MLX5_CQE_RESP_SEND)) {
+	if (unlikely(get_cqe_opcode(cqe) != MLX5_CQE_RESP_SEND)) {
 		rq->stats->wqe_err++;
 		goto mpwrq_cqe_out;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 6dacaeba2fbf..46b5a6914d71 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -507,7 +507,7 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
 
 		wqe_counter = be16_to_cpu(cqe->wqe_counter);
 
-		if (unlikely(cqe->op_own >> 4 == MLX5_CQE_REQ_ERR)) {
+		if (unlikely(get_cqe_opcode(cqe) == MLX5_CQE_REQ_ERR)) {
 			if (!test_and_set_bit(MLX5E_SQ_STATE_RECOVERING,
 					      &sq->state)) {
 				mlx5e_dump_error_cqe(sq,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
index 8ca1d1949d93..873541ef4c1b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
@@ -334,7 +334,7 @@ static void mlx5_fpga_conn_handle_cqe(struct mlx5_fpga_conn *conn,
 {
 	u8 opcode, status = 0;
 
-	opcode = cqe->op_own >> 4;
+	opcode = get_cqe_opcode(cqe);
 
 	switch (opcode) {
 	case MLX5_CQE_REQ_ERR:
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index f7c8bebfe472..c66867c8fc2f 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -781,6 +781,11 @@ static inline u8 mlx5_get_cqe_format(struct mlx5_cqe64 *cqe)
 	return (cqe->op_own >> 2) & 0x3;
 }
 
+static inline u8 get_cqe_opcode(struct mlx5_cqe64 *cqe)
+{
+	return cqe->op_own >> 4;
+}
+
 static inline u8 get_cqe_lro_tcppsh(struct mlx5_cqe64 *cqe)
 {
 	return (cqe->lro_tcppsh_abort_dupack >> 6) & 1;
-- 
2.19.2
