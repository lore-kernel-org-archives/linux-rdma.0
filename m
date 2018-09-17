From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 15/25] IB/mlx5: Set uid as part of PD commands
Date: Mon, 17 Sep 2018 14:04:08 +0300
Message-ID: <20180917110418.18937-16-leon@kernel.org>
References: <20180917110418.18937-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180917110418.18937-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Set uid as part of PD commands so that the firmware can manage the
PD object in a secured way.

For example when a QP is created its uid must match the CQ uid which it
uses.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/cmd.c     | 10 ++++++++++
 drivers/infiniband/hw/mlx5/cmd.h     |  1 +
 drivers/infiniband/hw/mlx5/main.c    | 16 +++++++++++++---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 +
 4 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cmd.c b/drivers/infiniband/hw/mlx5/cmd.c
index 347e3912b4bb..5560346102bd 100644
--- a/drivers/infiniband/hw/mlx5/cmd.c
+++ b/drivers/infiniband/hw/mlx5/cmd.c
@@ -231,3 +231,13 @@ void mlx5_cmd_destroy_rqt(struct mlx5_core_dev *dev, u32 rqtn, u16 uid)
 	mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 }
 
+void mlx5_cmd_dealloc_pd(struct mlx5_core_dev *dev, u32 pdn, u16 uid)
+{
+	u32 out[MLX5_ST_SZ_DW(dealloc_pd_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(dealloc_pd_in)]   = {0};
+
+	MLX5_SET(dealloc_pd_in, in, opcode, MLX5_CMD_OP_DEALLOC_PD);
+	MLX5_SET(dealloc_pd_in, in, pd, pdn);
+	MLX5_SET(dealloc_pd_in, in, uid, uid);
+	mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+}
diff --git a/drivers/infiniband/hw/mlx5/cmd.h b/drivers/infiniband/hw/mlx5/cmd.h
index 0437190c1b35..b47e98b8a53a 100644
--- a/drivers/infiniband/hw/mlx5/cmd.h
+++ b/drivers/infiniband/hw/mlx5/cmd.h
@@ -50,4 +50,5 @@ int mlx5_cmd_dealloc_memic(struct mlx5_memic *memic, u64 addr, u64 length);
 void mlx5_cmd_destroy_tir(struct mlx5_core_dev *dev, u32 tirn, u16 uid);
 void mlx5_cmd_destroy_tis(struct mlx5_core_dev *dev, u32 tisn, u16 uid);
 void mlx5_cmd_destroy_rqt(struct mlx5_core_dev *dev, u32 rqtn, u16 uid);
+void mlx5_cmd_dealloc_pd(struct mlx5_core_dev *dev, u32 pdn, u16 uid);
 #endif /* MLX5_IB_CMD_H */
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 75851721d1dc..7e6fd5553ab3 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2355,21 +2355,31 @@ static struct ib_pd *mlx5_ib_alloc_pd(struct ib_device *ibdev,
 	struct mlx5_ib_alloc_pd_resp resp;
 	struct mlx5_ib_pd *pd;
 	int err;
+	u32 out[MLX5_ST_SZ_DW(alloc_pd_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(alloc_pd_in)]   = {0};
+	u16 uid;
+
+	uid = context ? to_mucontext(context)->devx_uid : 0;
 
 	pd = kmalloc(sizeof(*pd), GFP_KERNEL);
 	if (!pd)
 		return ERR_PTR(-ENOMEM);
 
-	err = mlx5_core_alloc_pd(to_mdev(ibdev)->mdev, &pd->pdn);
+	MLX5_SET(alloc_pd_in, in, opcode, MLX5_CMD_OP_ALLOC_PD);
+	MLX5_SET(alloc_pd_in, in, uid, uid);
+	err = mlx5_cmd_exec(to_mdev(ibdev)->mdev, in, sizeof(in),
+			    out, sizeof(out));
 	if (err) {
 		kfree(pd);
 		return ERR_PTR(err);
 	}
 
+	pd->pdn = MLX5_GET(alloc_pd_out, out, pd);
+	pd->uid = uid;
 	if (context) {
 		resp.pdn = pd->pdn;
 		if (ib_copy_to_udata(udata, &resp, sizeof(resp))) {
-			mlx5_core_dealloc_pd(to_mdev(ibdev)->mdev, pd->pdn);
+			mlx5_cmd_dealloc_pd(to_mdev(ibdev)->mdev, pd->pdn, uid);
 			kfree(pd);
 			return ERR_PTR(-EFAULT);
 		}
@@ -2383,7 +2393,7 @@ static int mlx5_ib_dealloc_pd(struct ib_pd *pd)
 	struct mlx5_ib_dev *mdev = to_mdev(pd->device);
 	struct mlx5_ib_pd *mpd = to_mpd(pd);
 
-	mlx5_core_dealloc_pd(mdev->mdev, mpd->pdn);
+	mlx5_cmd_dealloc_pd(mdev->mdev, mpd->pdn, mpd->uid);
 	kfree(mpd);
 
 	return 0;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 2508a401a7d9..88ea0df71d94 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -153,6 +153,7 @@ static inline struct mlx5_ib_ucontext *to_mucontext(struct ib_ucontext *ibuconte
 struct mlx5_ib_pd {
 	struct ib_pd		ibpd;
 	u32			pdn;
+	u16			uid;
 };
 
 enum {
-- 
2.14.4
