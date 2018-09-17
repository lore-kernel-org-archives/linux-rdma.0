From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 14/25] IB/mlx5: Set uid as part of RQT commands
Date: Mon, 17 Sep 2018 14:04:07 +0300
Message-ID: <20180917110418.18937-15-leon@kernel.org>
References: <20180917110418.18937-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180917110418.18937-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Set uid as part of RQT commands so that the firmware can manage the
RQT object in a secured way.

That will enable using an RQT that was created by verbs application
to be used by the DEVX flow in case the uid is equal.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/cmd.c | 11 +++++++++++
 drivers/infiniband/hw/mlx5/cmd.h |  1 +
 drivers/infiniband/hw/mlx5/qp.c  | 11 +++++++++--
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cmd.c b/drivers/infiniband/hw/mlx5/cmd.c
index 8a3623bbca94..347e3912b4bb 100644
--- a/drivers/infiniband/hw/mlx5/cmd.c
+++ b/drivers/infiniband/hw/mlx5/cmd.c
@@ -220,3 +220,14 @@ void mlx5_cmd_destroy_tis(struct mlx5_core_dev *dev, u32 tisn, u16 uid)
 	mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 }
 
+void mlx5_cmd_destroy_rqt(struct mlx5_core_dev *dev, u32 rqtn, u16 uid)
+{
+	u32 in[MLX5_ST_SZ_DW(destroy_rqt_in)]   = {0};
+	u32 out[MLX5_ST_SZ_DW(destroy_rqt_out)] = {0};
+
+	MLX5_SET(destroy_rqt_in, in, opcode, MLX5_CMD_OP_DESTROY_RQT);
+	MLX5_SET(destroy_rqt_in, in, rqtn, rqtn);
+	MLX5_SET(destroy_rqt_in, in, uid, uid);
+	mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+}
+
diff --git a/drivers/infiniband/hw/mlx5/cmd.h b/drivers/infiniband/hw/mlx5/cmd.h
index a55e750591e5..0437190c1b35 100644
--- a/drivers/infiniband/hw/mlx5/cmd.h
+++ b/drivers/infiniband/hw/mlx5/cmd.h
@@ -49,4 +49,5 @@ int mlx5_cmd_alloc_memic(struct mlx5_memic *memic, phys_addr_t *addr,
 int mlx5_cmd_dealloc_memic(struct mlx5_memic *memic, u64 addr, u64 length);
 void mlx5_cmd_destroy_tir(struct mlx5_core_dev *dev, u32 tirn, u16 uid);
 void mlx5_cmd_destroy_tis(struct mlx5_core_dev *dev, u32 tisn, u16 uid);
+void mlx5_cmd_destroy_rqt(struct mlx5_core_dev *dev, u32 rqtn, u16 uid);
 #endif /* MLX5_IB_CMD_H */
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 5421857f195e..8fbf17a885b9 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -5702,6 +5702,7 @@ struct ib_rwq_ind_table *mlx5_ib_create_rwq_ind_table(struct ib_device *device,
 	int i;
 	u32 *in;
 	void *rqtc;
+	u16 uid;
 
 	if (udata->inlen > 0 &&
 	    !ib_is_udata_cleared(udata, 0,
@@ -5739,6 +5740,10 @@ struct ib_rwq_ind_table *mlx5_ib_create_rwq_ind_table(struct ib_device *device,
 	for (i = 0; i < sz; i++)
 		MLX5_SET(rqtc, rqtc, rq_num[i], init_attr->ind_tbl[i]->wq_num);
 
+	/* Use the uid from its internal WQ */
+	uid = to_mucontext(init_attr->ind_tbl[0]->uobject->context)->devx_uid;
+	MLX5_SET(create_rqt_in, in, uid, uid);
+
 	err = mlx5_core_create_rqt(dev->mdev, in, inlen, &rwq_ind_tbl->rqtn);
 	kvfree(in);
 
@@ -5757,7 +5762,7 @@ struct ib_rwq_ind_table *mlx5_ib_create_rwq_ind_table(struct ib_device *device,
 	return &rwq_ind_tbl->ib_rwq_ind_tbl;
 
 err_copy:
-	mlx5_core_destroy_rqt(dev->mdev, rwq_ind_tbl->rqtn);
+	mlx5_cmd_destroy_rqt(dev->mdev, rwq_ind_tbl->rqtn, uid);
 err:
 	kfree(rwq_ind_tbl);
 	return ERR_PTR(err);
@@ -5767,8 +5772,10 @@ int mlx5_ib_destroy_rwq_ind_table(struct ib_rwq_ind_table *ib_rwq_ind_tbl)
 {
 	struct mlx5_ib_rwq_ind_table *rwq_ind_tbl = to_mrwq_ind_table(ib_rwq_ind_tbl);
 	struct mlx5_ib_dev *dev = to_mdev(ib_rwq_ind_tbl->device);
+	u16 uid;
 
-	mlx5_core_destroy_rqt(dev->mdev, rwq_ind_tbl->rqtn);
+	uid = to_mucontext(ib_rwq_ind_tbl->uobject->context)->devx_uid;
+	mlx5_cmd_destroy_rqt(dev->mdev, rwq_ind_tbl->rqtn, uid);
 
 	kfree(rwq_ind_tbl);
 	return 0;
-- 
2.14.4
