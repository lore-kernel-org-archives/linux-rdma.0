From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 3/4] IB/mlx5: Verify that driver supports user flags
Date: Sun,  7 Oct 2018 12:03:36 +0300
Message-ID: <20181007090337.21037-4-leon@kernel.org>
References: <20181007090337.21037-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181007090337.21037-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Yonatan Cohen <yonatanc@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yonatan Cohen <yonatanc@mellanox.com>

Flags sent down from user might not be supported by
running driver.
This might lead to unwanted bugs.
To solve this, added macro to test for unsupported flags.

Signed-off-by: Yonatan Cohen <yonatanc@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index bae48bdf281c..17c4b6641933 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1728,6 +1728,15 @@ static void configure_requester_scat_cqe(struct mlx5_ib_dev *dev,
 		MLX5_SET(qpc, qpc, cs_req, MLX5_REQ_SCAT_DATA32_CQE);
 }
 
+#define MLX5_QP_CREATE_FLAGS_NOT_SUPPORTED(flags) \
+	 ((flags) & ~(                            \
+		MLX5_QP_FLAG_SIGNATURE		| \
+		MLX5_QP_FLAG_SCATTER_CQE	| \
+		MLX5_QP_FLAG_TUNNEL_OFFLOADS	| \
+		MLX5_QP_FLAG_BFREG_INDEX	| \
+		MLX5_QP_FLAG_TYPE_DCT		| \
+		MLX5_QP_FLAG_TYPE_DCI))
+
 static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 			    struct ib_qp_init_attr *init_attr,
 			    struct ib_udata *udata, struct mlx5_ib_qp *qp)
@@ -1825,6 +1834,9 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 			return -EFAULT;
 		}
 
+		if (MLX5_QP_CREATE_FLAGS_NOT_SUPPORTED(ucmd.flags))
+			return -EINVAL;
+
 		err = get_qp_user_index(to_mucontext(pd->uobject->context),
 					&ucmd, udata->inlen, &uidx);
 		if (err)
-- 
2.14.4
