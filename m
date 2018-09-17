From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 17/25] IB/mlx5: Set uid as part of SRQ commands
Date: Mon, 17 Sep 2018 14:04:10 +0300
Message-ID: <20180917110418.18937-18-leon@kernel.org>
References: <20180917110418.18937-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180917110418.18937-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Set uid as part of SRQ create command so that the firmware can manage
the SRQ object in a secured way.

The uid for the destroy and modify commands are set by mlx5_core.

That will enable using a SRQ that was created by verbs application
to be used by the DEVX flow in case the uid is equal.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/srq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index d359fecf7a5b..6b1cd9ef4e2a 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -144,6 +144,7 @@ static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 
 	in->log_page_size = page_shift - MLX5_ADAPTER_PAGE_SHIFT;
 	in->page_offset = offset;
+	in->uid = to_mucontext(pd->uobject->context)->devx_uid;
 	if (MLX5_CAP_GEN(dev->mdev, cqe_version) == MLX5_CQE_VERSION_V1 &&
 	    in->type != IB_SRQT_BASIC)
 		in->user_index = uidx;
-- 
2.14.4
