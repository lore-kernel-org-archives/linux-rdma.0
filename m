From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 08/25] IB/mlx5: Set uid as part of CQ creation
Date: Mon, 17 Sep 2018 14:04:01 +0300
Message-ID: <20180917110418.18937-9-leon@kernel.org>
References: <20180917110418.18937-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180917110418.18937-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Set uid as part of CQ creation so that the firmware can manage the
CQ object in a secured way.

The uid for the destroy and the modify commands is set by mlx5_core.

This will enable using a CQ that was created by verbs application to
be used by the DEVX flow in case the uid is equal.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/cq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 495fa6e651ea..a41519dc8d3a 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -877,6 +877,7 @@ static int create_cq_user(struct mlx5_ib_dev *dev, struct ib_udata *udata,
 		cq->private_flags |= MLX5_IB_CQ_PR_FLAGS_CQE_128_PAD;
 	}
 
+	MLX5_SET(create_cq_in, *cqb, uid, to_mucontext(context)->devx_uid);
 	return 0;
 
 err_cqb:
-- 
2.14.4
