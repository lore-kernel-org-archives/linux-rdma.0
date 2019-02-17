From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH net-next 2/2] net/mlx5: Delete unused FPGA QPN variable
Date: Sun, 17 Feb 2019 15:21:28 +0200
Message-ID: <20190217132128.9709-3-leon@kernel.org>
References: <20190217132128.9709-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190217132128.9709-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, "David S . Miller" <davem@davemloft.net>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Eyal Davidovich <eyald@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

fpga_qpn was assigned but never used and compilation with W=1
produced the following warning:

drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c: In function _mlx5_fpga_event_:
drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c:320:6: warning:
variable _fpga_qpn_ set but not used [-Wunused-but-set-variable]
  u32 fpga_qpn;
      ^~~~~~~~

Fixes: 98db16bab59f ("net/mlx5: FPGA, Handle QP error event")
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c
index 27c5f6c7d36a..d046d1ec2a86 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c
@@ -317,7 +317,6 @@ static int mlx5_fpga_event(struct mlx5_fpga_device *fdev,
 	const char *event_name;
 	bool teardown = false;
 	unsigned long flags;
-	u32 fpga_qpn;
 	u8 syndrome;

 	switch (event) {
@@ -328,7 +327,6 @@ static int mlx5_fpga_event(struct mlx5_fpga_device *fdev,
 	case MLX5_EVENT_TYPE_FPGA_QP_ERROR:
 		syndrome = MLX5_GET(fpga_qp_error_event, data, syndrome);
 		event_name = mlx5_fpga_qp_syndrome_to_string(syndrome);
-		fpga_qpn = MLX5_GET(fpga_qp_error_event, data, fpga_qpn);
 		break;
 	default:
 		return NOTIFY_DONE;
