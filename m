From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.0 67/99] IB/mlx5: Fix scatter to CQE in DCT QP creation
Date: Tue,  7 May 2019 01:32:01 -0400
Message-ID: <20190507053235.29900-67-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Guy Levi <guyle@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Jason Gunthorpe <jgg@mellanox.com>, Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Guy Levi <guyle@mellanox.com>

[ Upstream commit 7249c8ea227a582c14f63e9e8853eb7369122f10 ]

When scatter to CQE is enabled on a DCT QP it corrupts the mailbox command
since it tried to treat it as as QP create mailbox command instead of a
DCT create command.

The corrupted mailbox command causes userspace to malfunction as the
device doesn't create the QP as expected.

A new mlx5 capability is exposed to user-space which ensures that it will
not enable the feature on DCT without this fix in the kernel.

Fixes: 5d6ff1babe78 ("IB/mlx5: Support scatter to CQE for DC transport type")
Signed-off-by: Guy Levi <guyle@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c |  2 ++
 drivers/infiniband/hw/mlx5/qp.c   | 11 +++++++----
 include/uapi/rdma/mlx5-abi.h      |  1 +
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 497181f5ba09..c6bdd0d16c4b 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1025,6 +1025,8 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		if (MLX5_CAP_GEN(mdev, qp_packet_based))
 			resp.flags |=
 				MLX5_IB_QUERY_DEV_RESP_PACKET_BASED_CREDIT_MODE;
+
+		resp.flags |= MLX5_IB_QUERY_DEV_RESP_FLAGS_SCAT2CQE_DCT;
 	}
 
 	if (field_avail(typeof(resp), sw_parsing_caps,
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 7db778d96ef5..afc88e6e172e 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1724,13 +1724,16 @@ static void configure_responder_scat_cqe(struct ib_qp_init_attr *init_attr,
 
 	rcqe_sz = mlx5_ib_get_cqe_size(init_attr->recv_cq);
 
-	if (rcqe_sz == 128) {
-		MLX5_SET(qpc, qpc, cs_res, MLX5_RES_SCAT_DATA64_CQE);
+	if (init_attr->qp_type == MLX5_IB_QPT_DCT) {
+		if (rcqe_sz == 128)
+			MLX5_SET(dctc, qpc, cs_res, MLX5_RES_SCAT_DATA64_CQE);
+
 		return;
 	}
 
-	if (init_attr->qp_type != MLX5_IB_QPT_DCT)
-		MLX5_SET(qpc, qpc, cs_res, MLX5_RES_SCAT_DATA32_CQE);
+	MLX5_SET(qpc, qpc, cs_res,
+		 rcqe_sz == 128 ? MLX5_RES_SCAT_DATA64_CQE :
+				  MLX5_RES_SCAT_DATA32_CQE);
 }
 
 static void configure_requester_scat_cqe(struct mlx5_ib_dev *dev,
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index 87b3198f4b5d..f4d4010b7e3e 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -238,6 +238,7 @@ enum mlx5_ib_query_dev_resp_flags {
 	MLX5_IB_QUERY_DEV_RESP_FLAGS_CQE_128B_COMP = 1 << 0,
 	MLX5_IB_QUERY_DEV_RESP_FLAGS_CQE_128B_PAD  = 1 << 1,
 	MLX5_IB_QUERY_DEV_RESP_PACKET_BASED_CREDIT_MODE = 1 << 2,
+	MLX5_IB_QUERY_DEV_RESP_FLAGS_SCAT2CQE_DCT = 1 << 3,
 };
 
 enum mlx5_ib_tunnel_offloads {
-- 
2.20.1
