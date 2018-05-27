From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 2/3] IB/mlx5: Refactor CQE compression response
Date: Sun, 27 May 2018 13:42:33 +0300
Message-ID: <20180527104234.17261-3-leon@kernel.org>
References: <20180527104234.17261-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180527104234.17261-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Yonatan Cohen <yonatanc@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yonatan Cohen <yonatanc@mellanox.com>

Refactor CQE compression response to be fully set only
when it`s really supported. There is no change from user
perspective because anyway resp.cqe_comp_caps.max_num was
set to zero.

Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Yonatan Cohen <yonatanc@mellanox.com>W
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 59e080da32aa..95e67a85078c 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -982,13 +982,17 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	}
 
 	if (field_avail(typeof(resp), cqe_comp_caps, uhw->outlen)) {
-		resp.cqe_comp_caps.max_num =
-			MLX5_CAP_GEN(dev->mdev, cqe_compression) ?
-			MLX5_CAP_GEN(dev->mdev, cqe_compression_max_num) : 0;
-		resp.cqe_comp_caps.supported_format =
-			MLX5_IB_CQE_RES_FORMAT_HASH |
-			MLX5_IB_CQE_RES_FORMAT_CSUM;
 		resp.response_length += sizeof(resp.cqe_comp_caps);
+
+		if (MLX5_CAP_GEN(dev->mdev, cqe_compression)) {
+			resp.cqe_comp_caps.max_num =
+				MLX5_CAP_GEN(dev->mdev,
+					     cqe_compression_max_num);
+
+			resp.cqe_comp_caps.supported_format =
+				MLX5_IB_CQE_RES_FORMAT_HASH |
+				MLX5_IB_CQE_RES_FORMAT_CSUM;
+		}
 	}
 
 	if (field_avail(typeof(resp), packet_pacing_caps, uhw->outlen) &&
-- 
2.14.3
