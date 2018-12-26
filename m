From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 10/97] IB/mlx5: Block DEVX umem from the non applicable cases
Date: Wed, 26 Dec 2018 17:34:30 -0500
Message-ID: <20181226223557.149329-10-sashal@kernel.org>
References: <20181226223557.149329-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181226223557.149329-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Yishai Hadas <yishaih@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Doug Ledford <dledford@redhat.com>, Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

[ Upstream commit 47f07f03b5ee436fe074c4fb1fb28d013c36a0d8 ]

Blocks creating a DEVX UMEM with the non applicable access flags
as of ODP, MW_BIND, etc.

Specifically when an ODP flag is used below WARN call trace is issued.

[ 2510.404131] RIP: 0010:__mlx5_ib_populate_pas+0x207/0x220 [mlx5_ib]
...
[ 2510.404143] Call Trace:
[ 2510.404150]  ? __kmalloc_node+0x1b3/0x280
[ 2510.404156]  ? _uverbs_alloc+0x63/0x90 [ib_uverbs]
[ 2510.404158]  ? _uverbs_alloc+0x63/0x90 [ib_uverbs]
[ 2510.404162]  mlx5_ib_populate_pas+0x53/0x60 [mlx5_ib]
[ 2510.404167]  mlx5_ib_handler_MLX5_IB_METHOD_DEVX_UMEM_REG+0x273/0x3f0 [mlx5_ib]

Fixes: aeae94579caf ("IB/mlx5: Add DEVX support for memory registration")
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/devx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index f2f11e652dcd..02f36ab72ad4 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -857,7 +857,9 @@ static int devx_umem_get(struct mlx5_ib_dev *dev, struct ib_ucontext *ucontext,
 
 	err = uverbs_get_flags32(&access, attrs,
 				 MLX5_IB_ATTR_DEVX_UMEM_REG_ACCESS,
-				 IB_ACCESS_SUPPORTED);
+				 IB_ACCESS_LOCAL_WRITE |
+				 IB_ACCESS_REMOTE_WRITE |
+				 IB_ACCESS_REMOTE_READ);
 	if (err)
 		return err;
 
-- 
2.19.1
