From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5/8] infiniband: mlx5: no need to check return value of debugfs_create functions
Date: Tue, 22 Jan 2019 16:17:57 +0100
Message-ID: <20190122151800.15092-6-gregkh@linuxfoundation.org>
References: <20190122151800.15092-1-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190122151800.15092-1-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Leon Romanovsky <leon@kernel.org>
List-Id: linux-rdma@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Cc: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mlx5/cong.c    | 15 +++-----
 drivers/infiniband/hw/mlx5/main.c    |  8 ++---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  8 +----
 drivers/infiniband/hw/mlx5/mr.c      | 51 +++++-----------------------
 4 files changed, 18 insertions(+), 64 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cong.c b/drivers/infiniband/hw/mlx5/cong.c
index 7e4e358a4fd8..8ba439fabf7f 100644
--- a/drivers/infiniband/hw/mlx5/cong.c
+++ b/drivers/infiniband/hw/mlx5/cong.c
@@ -389,19 +389,19 @@ void mlx5_ib_cleanup_cong_debugfs(struct mlx5_ib_dev *dev, u8 port_num)
 	dev->port[port_num].dbg_cc_params = NULL;
 }
 
-int mlx5_ib_init_cong_debugfs(struct mlx5_ib_dev *dev, u8 port_num)
+void mlx5_ib_init_cong_debugfs(struct mlx5_ib_dev *dev, u8 port_num)
 {
 	struct mlx5_ib_dbg_cc_params *dbg_cc_params;
 	struct mlx5_core_dev *mdev;
 	int i;
 
 	if (!mlx5_debugfs_root)
-		goto out;
+		return;
 
 	/* Takes a 1-based port number */
 	mdev = mlx5_ib_get_native_port_mdev(dev, port_num + 1, NULL);
 	if (!mdev)
-		goto out;
+		return;
 
 	if (!MLX5_CAP_GEN(mdev, cc_query_allowed) ||
 	    !MLX5_CAP_GEN(mdev, cc_modify_allowed))
@@ -415,8 +415,6 @@ int mlx5_ib_init_cong_debugfs(struct mlx5_ib_dev *dev, u8 port_num)
 
 	dbg_cc_params->root = debugfs_create_dir("cc_params",
 						 mdev->priv.dbg_root);
-	if (!dbg_cc_params->root)
-		goto err;
 
 	for (i = 0; i < MLX5_IB_DBG_CC_MAX; i++) {
 		dbg_cc_params->params[i].offset = i;
@@ -427,14 +425,11 @@ int mlx5_ib_init_cong_debugfs(struct mlx5_ib_dev *dev, u8 port_num)
 					    0600, dbg_cc_params->root,
 					    &dbg_cc_params->params[i],
 					    &dbg_cc_fops);
-		if (!dbg_cc_params->params[i].dentry)
-			goto err;
 	}
 
 put_mdev:
 	mlx5_ib_put_native_port_mdev(dev, port_num + 1);
-out:
-	return 0;
+	return;
 
 err:
 	mlx5_ib_warn(dev, "cong debugfs failure\n");
@@ -445,5 +440,5 @@ int mlx5_ib_init_cong_debugfs(struct mlx5_ib_dev *dev, u8 port_num)
 	 * We don't want to fail driver if debugfs failed to initialize,
 	 * so we are not forwarding error to the user.
 	 */
-	return 0;
+	return;
 }
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 94fe253d4956..58e9adc94984 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5508,9 +5508,7 @@ static bool mlx5_ib_bind_slave_port(struct mlx5_ib_dev *ibdev,
 	mpi->mdev_events.notifier_call = mlx5_ib_event_slave_port;
 	mlx5_notifier_register(mpi->mdev, &mpi->mdev_events);
 
-	err = mlx5_ib_init_cong_debugfs(ibdev, port_num);
-	if (err)
-		goto unbind;
+	mlx5_ib_init_cong_debugfs(ibdev, port_num);
 
 	return true;
 
@@ -6183,8 +6181,8 @@ void mlx5_ib_stage_counters_cleanup(struct mlx5_ib_dev *dev)
 
 static int mlx5_ib_stage_cong_debugfs_init(struct mlx5_ib_dev *dev)
 {
-	return mlx5_ib_init_cong_debugfs(dev,
-					 mlx5_core_native_port_num(dev->mdev) - 1);
+	mlx5_ib_init_cong_debugfs(dev, mlx5_core_native_port_num(dev->mdev) - 1);
+	return 0;
 }
 
 static void mlx5_ib_stage_cong_debugfs_cleanup(struct mlx5_ib_dev *dev)
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index b06d3b1efea8..b75afc4dd5f6 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -623,7 +623,6 @@ struct mlx5_cache_ent {
 	spinlock_t		lock;
 
 
-	struct dentry	       *dir;
 	char                    name[4];
 	u32                     order;
 	u32			xlt;
@@ -635,11 +634,6 @@ struct mlx5_cache_ent {
 	u32                     miss;
 	u32			limit;
 
-	struct dentry          *fsize;
-	struct dentry          *fcur;
-	struct dentry          *fmiss;
-	struct dentry          *flimit;
-
 	struct mlx5_ib_dev     *dev;
 	struct work_struct	work;
 	struct delayed_work	dwork;
@@ -1254,7 +1248,7 @@ __be16 mlx5_get_roce_udp_sport(struct mlx5_ib_dev *dev,
 			       const struct ib_gid_attr *attr);
 
 void mlx5_ib_cleanup_cong_debugfs(struct mlx5_ib_dev *dev, u8 port_num);
-int mlx5_ib_init_cong_debugfs(struct mlx5_ib_dev *dev, u8 port_num);
+void mlx5_ib_init_cong_debugfs(struct mlx5_ib_dev *dev, u8 port_num);
 
 /* GSI QP helper functions */
 struct ib_qp *mlx5_ib_gsi_create_qp(struct ib_pd *pd,
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index fd6ea1f75085..7832da4971b0 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -610,52 +610,27 @@ static void mlx5_mr_cache_debugfs_cleanup(struct mlx5_ib_dev *dev)
 	dev->cache.root = NULL;
 }
 
-static int mlx5_mr_cache_debugfs_init(struct mlx5_ib_dev *dev)
+static void mlx5_mr_cache_debugfs_init(struct mlx5_ib_dev *dev)
 {
 	struct mlx5_mr_cache *cache = &dev->cache;
 	struct mlx5_cache_ent *ent;
+	struct dentry *dir;
 	int i;
 
 	if (!mlx5_debugfs_root || dev->rep)
-		return 0;
+		return;
 
 	cache->root = debugfs_create_dir("mr_cache", dev->mdev->priv.dbg_root);
-	if (!cache->root)
-		return -ENOMEM;
 
 	for (i = 0; i < MAX_MR_CACHE_ENTRIES; i++) {
 		ent = &cache->ent[i];
 		sprintf(ent->name, "%d", ent->order);
-		ent->dir = debugfs_create_dir(ent->name,  cache->root);
-		if (!ent->dir)
-			goto err;
-
-		ent->fsize = debugfs_create_file("size", 0600, ent->dir, ent,
-						 &size_fops);
-		if (!ent->fsize)
-			goto err;
-
-		ent->flimit = debugfs_create_file("limit", 0600, ent->dir, ent,
-						  &limit_fops);
-		if (!ent->flimit)
-			goto err;
-
-		ent->fcur = debugfs_create_u32("cur", 0400, ent->dir,
-					       &ent->cur);
-		if (!ent->fcur)
-			goto err;
-
-		ent->fmiss = debugfs_create_u32("miss", 0600, ent->dir,
-						&ent->miss);
-		if (!ent->fmiss)
-			goto err;
+		dir = debugfs_create_dir(ent->name, cache->root);
+		debugfs_create_file("size", 0600, dir, ent, &size_fops);
+		debugfs_create_file("limit", 0600, dir, ent, &limit_fops);
+		debugfs_create_u32("cur", 0400, dir, &ent->cur);
+		debugfs_create_u32("miss", 0600, dir, &ent->miss);
 	}
-
-	return 0;
-err:
-	mlx5_mr_cache_debugfs_cleanup(dev);
-
-	return -ENOMEM;
 }
 
 static void delay_time_func(struct timer_list *t)
@@ -669,7 +644,6 @@ int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
 {
 	struct mlx5_mr_cache *cache = &dev->cache;
 	struct mlx5_cache_ent *ent;
-	int err;
 	int i;
 
 	mutex_init(&dev->slow_path_mutex);
@@ -713,14 +687,7 @@ int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
 		queue_work(cache->wq, &ent->work);
 	}
 
-	err = mlx5_mr_cache_debugfs_init(dev);
-	if (err)
-		mlx5_ib_warn(dev, "cache debugfs failure\n");
-
-	/*
-	 * We don't want to fail driver if debugfs failed to initialize,
-	 * so we are not forwarding error to the user.
-	 */
+	mlx5_mr_cache_debugfs_init(dev);
 
 	return 0;
 }
-- 
2.20.1
