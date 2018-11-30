From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 3/3] IB/mlx5: Report packet based credit mode device capability
Date: Fri, 30 Nov 2018 13:22:06 +0200
Message-ID: <20181130112206.19870-4-leon@kernel.org>
References: <20181130112206.19870-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181130112206.19870-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Danit Goldberg <danitg@mellanox.com>, Majd Dibbiny <majd@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Danit Goldberg <danitg@mellanox.com>

Report packet based credit mode capability via the mlx5 DV interface.

Signed-off-by: Danit Goldberg <danitg@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 3 +++
 include/uapi/rdma/mlx5-abi.h      | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 0acf6a4d8f4b..1ad5e35663af 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1018,6 +1018,9 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 
 		if (MLX5_CAP_GEN(mdev, cqe_128_always))
 			resp.flags |= MLX5_IB_QUERY_DEV_RESP_FLAGS_CQE_128B_PAD;
+		if (MLX5_CAP_GEN(mdev, qp_packet_based))
+			resp.flags |=
+				MLX5_IB_QUERY_DEV_RESP_PACKET_BASED_CREDIT_MODE;
 	}
 
 	if (field_avail(typeof(resp), sw_parsing_caps,
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index 4af581170f62..87b3198f4b5d 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -237,6 +237,7 @@ enum mlx5_ib_query_dev_resp_flags {
 	/* Support 128B CQE compression */
 	MLX5_IB_QUERY_DEV_RESP_FLAGS_CQE_128B_COMP = 1 << 0,
 	MLX5_IB_QUERY_DEV_RESP_FLAGS_CQE_128B_PAD  = 1 << 1,
+	MLX5_IB_QUERY_DEV_RESP_PACKET_BASED_CREDIT_MODE = 1 << 2,
 };
 
 enum mlx5_ib_tunnel_offloads {
-- 
2.19.1
