From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: [PATCH net-next] net/mlx5: Make function mlx5_fpga_tls_send_teardown_cmd() static
Date: Thu, 31 May 2018 02:31:12 +0000
Message-ID: <1527733872-149077-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Boris Pismenny <borisp@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Ilya Lesokhin <ilyal@mellanox.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Fixes the following sparse warning:

drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c:199:6: warning:
 symbol 'mlx5_fpga_tls_send_teardown_cmd' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c
index 2104801..c973623 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c
@@ -196,8 +196,8 @@ static void mlx5_fpga_tls_flow_to_cmd(void *flow, void *cmd)
 		 MLX5_GET(tls_flow, flow, direction_sx));
 }
 
-void mlx5_fpga_tls_send_teardown_cmd(struct mlx5_core_dev *mdev, void *flow,
-				     u32 swid, gfp_t flags)
+static void mlx5_fpga_tls_send_teardown_cmd(struct mlx5_core_dev *mdev,
+					    void *flow, u32 swid, gfp_t flags)
 {
 	struct mlx5_teardown_stream_context *ctx;
 	struct mlx5_fpga_dma_buf *buf;
