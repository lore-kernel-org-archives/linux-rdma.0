From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 25/25] IB/mlx5: Enable DEVX on IB
Date: Mon, 17 Sep 2018 14:04:18 +0300
Message-ID: <20180917110418.18937-26-leon@kernel.org>
References: <20180917110418.18937-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180917110418.18937-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

IB has additional protections with SELinux that cannot be extended to
the DEVX domain. SELinux can restrict access to pkeys. The first version
of DEVX blocked IB entirely until this could be understood.

Since DEVX requires CAP_NET_RAW, it supersedes the SELinux restriction
and allows userspace to form arbitrary packets with arbitrary pkeys.

Thus we enable IB for DEVX when CAP_NET_RAW is given.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 8cc285c4da8e..c31e57bead8e 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1759,12 +1759,6 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 #endif
 
 	if (req.flags & MLX5_IB_ALLOC_UCTX_DEVX) {
-		/* Block DEVX on Infiniband as of SELinux */
-		if (mlx5_ib_port_link_layer(ibdev, 1) != IB_LINK_LAYER_ETHERNET) {
-			err = -EPERM;
-			goto out_uars;
-		}
-
 		err = mlx5_ib_devx_create(dev);
 		if (err < 0)
 			goto out_uars;
-- 
2.14.4
