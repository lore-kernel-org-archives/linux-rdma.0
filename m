From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 06/12] IB/mlx5: Add XRC initiator ODP support
Date: Tue, 22 Jan 2019 08:48:45 +0200
Message-ID: <20190122064851.6032-7-leon@kernel.org>
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

Skip XRC segment in the beginning of a send WQE and fetch ODP XRC
capabilities when QP type is IB_QPT_XRC_INI. The rest of the handling is
the same as in RC QP.

Signed-off-by: Moni Shoua <monis@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/odp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 71f543d3b70e..cc01d92490cc 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1020,6 +1020,10 @@ static int mlx5_ib_mr_initiator_pfault_handler(
 		 MLX5_WQE_CTRL_OPCODE_MASK;
 
 	switch (qp->ibqp.qp_type) {
+	case IB_QPT_XRC_INI:
+		*wqe += sizeof(struct mlx5_wqe_xrc_seg);
+		transport_caps = dev->odp_caps.per_transport_caps.xrc_odp_caps;
+		break;
 	case IB_QPT_RC:
 		transport_caps = dev->odp_caps.per_transport_caps.rc_odp_caps;
 		break;
@@ -1039,7 +1043,7 @@ static int mlx5_ib_mr_initiator_pfault_handler(
 		return -EFAULT;
 	}
 
-	if (qp->ibqp.qp_type != IB_QPT_RC) {
+	if (qp->ibqp.qp_type == IB_QPT_UD) {
 		av = *wqe;
 		if (av->dqp_dct & cpu_to_be32(MLX5_EXTENDED_UD_AV))
 			*wqe += sizeof(struct mlx5_av);
-- 
2.19.1
