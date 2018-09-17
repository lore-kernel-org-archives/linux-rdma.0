From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 18/25] IB/mlx5: Set uid as part of DCT commands
Date: Mon, 17 Sep 2018 14:04:11 +0300
Message-ID: <20180917110418.18937-19-leon@kernel.org>
References: <20180917110418.18937-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180917110418.18937-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Set uid as part of DCT create command so that the firmware can
manage the DCT object in a secured way.

The uid for the destroy and drain commands are set by mlx5_core.

That will enable using a DCT that was created by verbs application
to be used by the DEVX flow in case the uid is equal.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 8fbf17a885b9..1a3b79405260 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2311,6 +2311,8 @@ static struct ib_qp *mlx5_ib_create_dct(struct ib_pd *pd,
 		goto err_free;
 	}
 
+	MLX5_SET(create_dct_in, qp->dct.in, uid,
+		 to_mucontext(pd->uobject->context)->devx_uid);
 	dctc = MLX5_ADDR_OF(create_dct_in, qp->dct.in, dct_context_entry);
 	qp->qp_sub_type = MLX5_IB_QPT_DCT;
 	MLX5_SET(dctc, dctc, pd, to_mpd(pd)->pdn);
-- 
2.14.4
