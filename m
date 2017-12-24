From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 09/15] IB/mlx5: Change debugfs to have per port contents
Date: Sun, 24 Dec 2017 14:57:35 +0200
Message-ID: <20171224125741.25464-10-leon@kernel.org>
References: <20171224125741.25464-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171224125741.25464-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When there are multiple ports for single IB(RoCE) device, support
debugfs entries to be available for each port.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/cong.c    | 83 +++++++++++++++++++++++++-----------
 drivers/infiniband/hw/mlx5/main.c    | 12 +++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  7 +--
 3 files changed, 73 insertions(+), 29 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cong.c b/drivers/infiniband/hw/mlx5/cong.c
index 2d32b519bb61..985fa2637390 100644
--- a/drivers/infiniband/hw/mlx5/cong.c
+++ b/drivers/infiniband/hw/mlx5/cong.c
@@ -247,21 +247,30 @@ static void mlx5_ib_set_cc_param_mask_val(void *field, int offset,
 	}
 }
 
-static int mlx5_ib_get_cc_params(struct mlx5_ib_dev *dev, int offset, u32 *var)
+static int mlx5_ib_get_cc_params(struct mlx5_ib_dev *dev, u8 port_num,
+				 int offset, u32 *var)
 {
 	int outlen = MLX5_ST_SZ_BYTES(query_cong_params_out);
 	void *out;
 	void *field;
 	int err;
 	enum mlx5_ib_cong_node_type node;
+	struct mlx5_core_dev *mdev;
+
+	/* Takes a 1-based port number */
+	mdev = mlx5_ib_get_native_port_mdev(dev, port_num + 1, NULL);
+	if (!mdev)
+		return -ENODEV;
 
 	out = kvzalloc(outlen, GFP_KERNEL);
-	if (!out)
-		return -ENOMEM;
+	if (!out) {
+		err = -ENOMEM;
+		goto alloc_err;
+	}
 
 	node = mlx5_ib_param_to_node(offset);
 
-	err = mlx5_cmd_query_cong_params(dev->mdev, node, out, outlen);
+	err = mlx5_cmd_query_cong_params(mdev, node, out, outlen);
 	if (err)
 		goto free;
 
@@ -270,21 +279,32 @@ static int mlx5_ib_get_cc_params(struct mlx5_ib_dev *dev, int offset, u32 *var)
 
 free:
 	kvfree(out);
+alloc_err:
+	mlx5_ib_put_native_port_mdev(dev, port_num + 1);
 	return err;
 }
 
-static int mlx5_ib_set_cc_params(struct mlx5_ib_dev *dev, int offset, u32 var)
+static int mlx5_ib_set_cc_params(struct mlx5_ib_dev *dev, u8 port_num,
+				 int offset, u32 var)
 {
 	int inlen = MLX5_ST_SZ_BYTES(modify_cong_params_in);
 	void *in;
 	void *field;
 	enum mlx5_ib_cong_node_type node;
+	struct mlx5_core_dev *mdev;
 	u32 attr_mask = 0;
 	int err;
 
+	/* Takes a 1-based port number */
+	mdev = mlx5_ib_get_native_port_mdev(dev, port_num + 1, NULL);
+	if (!mdev)
+		return -ENODEV;
+
 	in = kvzalloc(inlen, GFP_KERNEL);
-	if (!in)
-		return -ENOMEM;
+	if (!in) {
+		err = -ENOMEM;
+		goto alloc_err;
+	}
 
 	MLX5_SET(modify_cong_params_in, in, opcode,
 		 MLX5_CMD_OP_MODIFY_CONG_PARAMS);
@@ -299,8 +319,10 @@ static int mlx5_ib_set_cc_params(struct mlx5_ib_dev *dev, int offset, u32 var)
 	MLX5_SET(field_select_r_roce_rp, field, field_select_r_roce_rp,
 		 attr_mask);
 
-	err = mlx5_cmd_modify_cong_params(dev->mdev, in, inlen);
+	err = mlx5_cmd_modify_cong_params(mdev, in, inlen);
 	kvfree(in);
+alloc_err:
+	mlx5_ib_put_native_port_mdev(dev, port_num + 1);
 	return err;
 }
 
@@ -324,7 +346,7 @@ static ssize_t set_param(struct file *filp, const char __user *buf,
 	if (kstrtou32(lbuf, 0, &var))
 		return -EINVAL;
 
-	ret = mlx5_ib_set_cc_params(param->dev, offset, var);
+	ret = mlx5_ib_set_cc_params(param->dev, param->port_num, offset, var);
 	return ret ? ret : count;
 }
 
@@ -340,7 +362,7 @@ static ssize_t get_param(struct file *filp, char __user *buf, size_t count,
 	if (*pos)
 		return 0;
 
-	ret = mlx5_ib_get_cc_params(param->dev, offset, &var);
+	ret = mlx5_ib_get_cc_params(param->dev, param->port_num, offset, &var);
 	if (ret)
 		return ret;
 
@@ -362,44 +384,51 @@ static const struct file_operations dbg_cc_fops = {
 	.read	= get_param,
 };
 
-void mlx5_ib_cleanup_cong_debugfs(struct mlx5_ib_dev *dev)
+void mlx5_ib_cleanup_cong_debugfs(struct mlx5_ib_dev *dev, u8 port_num)
 {
 	if (!mlx5_debugfs_root ||
-	    !dev->dbg_cc_params ||
-	    !dev->dbg_cc_params->root)
+	    !dev->port[port_num].dbg_cc_params ||
+	    !dev->port[port_num].dbg_cc_params->root)
 		return;
 
-	debugfs_remove_recursive(dev->dbg_cc_params->root);
-	kfree(dev->dbg_cc_params);
-	dev->dbg_cc_params = NULL;
+	debugfs_remove_recursive(dev->port[port_num].dbg_cc_params->root);
+	kfree(dev->port[port_num].dbg_cc_params);
+	dev->port[port_num].dbg_cc_params = NULL;
 }
 
-int mlx5_ib_init_cong_debugfs(struct mlx5_ib_dev *dev)
+int mlx5_ib_init_cong_debugfs(struct mlx5_ib_dev *dev, u8 port_num)
 {
 	struct mlx5_ib_dbg_cc_params *dbg_cc_params;
+	struct mlx5_core_dev *mdev;
 	int i;
 
 	if (!mlx5_debugfs_root)
 		goto out;
 
-	if (!MLX5_CAP_GEN(dev->mdev, cc_query_allowed) ||
-	    !MLX5_CAP_GEN(dev->mdev, cc_modify_allowed))
+	/* Takes a 1-based port number */
+	mdev = mlx5_ib_get_native_port_mdev(dev, port_num + 1, NULL);
+	if (!mdev)
 		goto out;
 
+	if (!MLX5_CAP_GEN(mdev, cc_query_allowed) ||
+	    !MLX5_CAP_GEN(mdev, cc_modify_allowed))
+		goto put_mdev;
+
 	dbg_cc_params = kzalloc(sizeof(*dbg_cc_params), GFP_KERNEL);
 	if (!dbg_cc_params)
-		goto out;
+		goto err;
 
-	dev->dbg_cc_params = dbg_cc_params;
+	dev->port[port_num].dbg_cc_params = dbg_cc_params;
 
 	dbg_cc_params->root = debugfs_create_dir("cc_params",
-						 dev->mdev->priv.dbg_root);
+						 mdev->priv.dbg_root);
 	if (!dbg_cc_params->root)
 		goto err;
 
 	for (i = 0; i < MLX5_IB_DBG_CC_MAX; i++) {
 		dbg_cc_params->params[i].offset = i;
 		dbg_cc_params->params[i].dev = dev;
+		dbg_cc_params->params[i].port_num = port_num;
 		dbg_cc_params->params[i].dentry =
 			debugfs_create_file(mlx5_ib_dbg_cc_name[i],
 					    0600, dbg_cc_params->root,
@@ -408,11 +437,17 @@ int mlx5_ib_init_cong_debugfs(struct mlx5_ib_dev *dev)
 		if (!dbg_cc_params->params[i].dentry)
 			goto err;
 	}
-out:	return 0;
+
+put_mdev:
+	mlx5_ib_put_native_port_mdev(dev, port_num + 1);
+out:
+	return 0;
 
 err:
 	mlx5_ib_warn(dev, "cong debugfs failure\n");
-	mlx5_ib_cleanup_cong_debugfs(dev);
+	mlx5_ib_cleanup_cong_debugfs(dev, port_num);
+	mlx5_ib_put_native_port_mdev(dev, port_num + 1);
+
 	/*
 	 * We don't want to fail driver if debugfs failed to initialize,
 	 * so we are not forwarding error to the user.
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 969981896ae6..d2fd7695fbe0 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4157,6 +4157,8 @@ static void mlx5_ib_unbind_slave_port(struct mlx5_ib_dev *ibdev,
 	int err;
 	int i;
 
+	mlx5_ib_cleanup_cong_debugfs(ibdev, port_num);
+
 	spin_lock(&port->mp.mpi_lock);
 	if (!mpi->ibdev) {
 		spin_unlock(&port->mp.mpi_lock);
@@ -4234,6 +4236,10 @@ static bool mlx5_ib_bind_slave_port(struct mlx5_ib_dev *ibdev,
 		goto unbind;
 	}
 
+	err = mlx5_ib_init_cong_debugfs(ibdev, port_num);
+	if (err)
+		goto unbind;
+
 	return true;
 
 unbind:
@@ -4647,12 +4653,14 @@ static void mlx5_ib_stage_counters_cleanup(struct mlx5_ib_dev *dev)
 
 static int mlx5_ib_stage_cong_debugfs_init(struct mlx5_ib_dev *dev)
 {
-	return mlx5_ib_init_cong_debugfs(dev);
+	return mlx5_ib_init_cong_debugfs(dev,
+					 mlx5_core_native_port_num(dev->mdev) - 1);
 }
 
 static void mlx5_ib_stage_cong_debugfs_cleanup(struct mlx5_ib_dev *dev)
 {
-	mlx5_ib_cleanup_cong_debugfs(dev);
+	mlx5_ib_cleanup_cong_debugfs(dev,
+				     mlx5_core_native_port_num(dev->mdev) - 1);
 }
 
 static int mlx5_ib_stage_uar_init(struct mlx5_ib_dev *dev)
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 594f1a1d69c4..518bfba88b2b 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -645,6 +645,7 @@ struct mlx5_ib_multiport {
 struct mlx5_ib_port {
 	struct mlx5_ib_counters cnts;
 	struct mlx5_ib_multiport mp;
+	struct mlx5_ib_dbg_cc_params	*dbg_cc_params;
 };
 
 struct mlx5_roce {
@@ -664,6 +665,7 @@ struct mlx5_ib_dbg_param {
 	int			offset;
 	struct mlx5_ib_dev	*dev;
 	struct dentry		*dentry;
+	u8			port_num;
 };
 
 enum mlx5_ib_dbg_cc_types {
@@ -798,7 +800,6 @@ struct mlx5_ib_dev {
 	struct mlx5_sq_bfreg	bfreg;
 	struct mlx5_sq_bfreg	fp_bfreg;
 	struct mlx5_ib_delay_drop	delay_drop;
-	struct mlx5_ib_dbg_cc_params	*dbg_cc_params;
 	struct mlx5_ib_profile	*profile;
 
 	/* protect the user_td */
@@ -1056,8 +1057,8 @@ __be16 mlx5_get_roce_udp_sport(struct mlx5_ib_dev *dev, u8 port_num,
 int mlx5_get_roce_gid_type(struct mlx5_ib_dev *dev, u8 port_num,
 			   int index, enum ib_gid_type *gid_type);
 
-void mlx5_ib_cleanup_cong_debugfs(struct mlx5_ib_dev *dev);
-int mlx5_ib_init_cong_debugfs(struct mlx5_ib_dev *dev);
+void mlx5_ib_cleanup_cong_debugfs(struct mlx5_ib_dev *dev, u8 port_num);
+int mlx5_ib_init_cong_debugfs(struct mlx5_ib_dev *dev, u8 port_num);
 
 /* GSI QP helper functions */
 struct ib_qp *mlx5_ib_gsi_create_qp(struct ib_pd *pd,
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
