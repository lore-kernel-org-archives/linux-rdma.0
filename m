From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 09/25] IB/mlx5: Set uid as part of QP creation
Date: Mon, 17 Sep 2018 14:04:02 +0300
Message-ID: <20180917110418.18937-10-leon@kernel.org>
References: <20180917110418.18937-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180917110418.18937-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Set uid as part of QP creation so that the firmware can manage the
QP object in a secured way.

The uid for the destroy and the modify commands is set by mlx5_core.

This will enable using a QP that was created by verbs application to
be used by the DEVX flow in case the uid is equal.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index e7ebe50ffdb5..786db05dfb91 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -850,6 +850,7 @@ static int create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 		goto err_umem;
 	}
 
+	MLX5_SET(create_qp_in, *in, uid, context->devx_uid);
 	pas = (__be64 *)MLX5_ADDR_OF(create_qp_in, *in, pas);
 	if (ubuffer->umem)
 		mlx5_ib_populate_pas(dev, ubuffer->umem, page_shift, pas, 0);
-- 
2.14.4
