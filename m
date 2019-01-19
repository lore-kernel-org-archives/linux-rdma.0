From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 1/4] net/mlx5: Make mlx5_cmd_exec_cb() a safe API
Date: Fri, 18 Jan 2019 16:33:10 -0800
Message-ID: <20190119003313.16711-2-saeedm@mellanox.com>
References: <20190119003313.16711-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190119003313.16711-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

APIs that have deferred callbacks should have some kind of cleanup
function that callers can use to fence the callbacks. Otherwise things
like module unloading can lead to dangling function pointers, or worse.

The IB MR code is the only place that calls this function and had a
really poor attempt at creating this fence. Provide a good version in
the core code as future patches will add more places that need this
fence.

Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  2 +
 drivers/infiniband/hw/mlx5/mr.c               | 39 +++----------
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 55 +++++++++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/mr.c  | 11 ++--
 include/linux/mlx5/driver.h                   | 32 +++++++++--
 5 files changed, 91 insertions(+), 48 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index efe383c0ac86..eedba0d2ec4b 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -587,6 +587,7 @@ struct mlx5_ib_mr {
 	struct mlx5_ib_mr      *parent;
 	atomic_t		num_leaf_free;
 	wait_queue_head_t       q_leaf_free;
+	struct mlx5_async_work  cb_work;
 };
 
 struct mlx5_ib_mw {
@@ -944,6 +945,7 @@ struct mlx5_ib_dev {
 	struct mlx5_memic	memic;
 	u16			devx_whitelist_uid;
 	struct mlx5_srq_table   srq_table;
+	struct mlx5_async_ctx   async_ctx;
 };
 
 static inline struct mlx5_ib_cq *to_mibcq(struct mlx5_core_cq *mcq)
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index fd6ea1f75085..bf2b6ea23851 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -123,9 +123,10 @@ static void update_odp_mr(struct mlx5_ib_mr *mr)
 }
 #endif
 
-static void reg_mr_callback(int status, void *context)
+static void reg_mr_callback(int status, struct mlx5_async_work *context)
 {
-	struct mlx5_ib_mr *mr = context;
+	struct mlx5_ib_mr *mr =
+		container_of(context, struct mlx5_ib_mr, cb_work);
 	struct mlx5_ib_dev *dev = mr->dev;
 	struct mlx5_mr_cache *cache = &dev->cache;
 	int c = order2idx(dev, mr->order);
@@ -216,9 +217,9 @@ static int add_keys(struct mlx5_ib_dev *dev, int c, int num)
 		ent->pending++;
 		spin_unlock_irq(&ent->lock);
 		err = mlx5_core_create_mkey_cb(dev->mdev, &mr->mmkey,
-					       in, inlen,
+					       &dev->async_ctx, in, inlen,
 					       mr->out, sizeof(mr->out),
-					       reg_mr_callback, mr);
+					       reg_mr_callback, &mr->cb_work);
 		if (err) {
 			spin_lock_irq(&ent->lock);
 			ent->pending--;
@@ -679,6 +680,7 @@ int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
 		return -ENOMEM;
 	}
 
+	mlx5_cmd_init_async_ctx(dev->mdev, &dev->async_ctx);
 	timer_setup(&dev->delay_timer, delay_time_func, 0);
 	for (i = 0; i < MAX_MR_CACHE_ENTRIES; i++) {
 		ent = &cache->ent[i];
@@ -725,33 +727,6 @@ int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
 	return 0;
 }
 
-static void wait_for_async_commands(struct mlx5_ib_dev *dev)
-{
-	struct mlx5_mr_cache *cache = &dev->cache;
-	struct mlx5_cache_ent *ent;
-	int total = 0;
-	int i;
-	int j;
-
-	for (i = 0; i < MAX_MR_CACHE_ENTRIES; i++) {
-		ent = &cache->ent[i];
-		for (j = 0 ; j < 1000; j++) {
-			if (!ent->pending)
-				break;
-			msleep(50);
-		}
-	}
-	for (i = 0; i < MAX_MR_CACHE_ENTRIES; i++) {
-		ent = &cache->ent[i];
-		total += ent->pending;
-	}
-
-	if (total)
-		mlx5_ib_warn(dev, "aborted while there are %d pending mr requests\n", total);
-	else
-		mlx5_ib_warn(dev, "done with all pending requests\n");
-}
-
 int mlx5_mr_cache_cleanup(struct mlx5_ib_dev *dev)
 {
 	int i;
@@ -763,12 +738,12 @@ int mlx5_mr_cache_cleanup(struct mlx5_ib_dev *dev)
 	flush_workqueue(dev->cache.wq);
 
 	mlx5_mr_cache_debugfs_cleanup(dev);
+	mlx5_cmd_cleanup_async_ctx(&dev->async_ctx);
 
 	for (i = 0; i < MAX_MR_CACHE_ENTRIES; i++)
 		clean_keys(dev, i);
 
 	destroy_workqueue(dev->cache.wq);
-	wait_for_async_commands(dev);
 	del_timer_sync(&dev->delay_timer);
 
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 3e0fa8a8077b..a25a8c6f938e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1711,12 +1711,57 @@ int mlx5_cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 }
 EXPORT_SYMBOL(mlx5_cmd_exec);
 
-int mlx5_cmd_exec_cb(struct mlx5_core_dev *dev, void *in, int in_size,
-		     void *out, int out_size, mlx5_cmd_cbk_t callback,
-		     void *context)
+void mlx5_cmd_init_async_ctx(struct mlx5_core_dev *dev,
+			     struct mlx5_async_ctx *ctx)
 {
-	return cmd_exec(dev, in, in_size, out, out_size, callback, context,
-			false);
+	ctx->dev = dev;
+	/* Starts at 1 to avoid doing wake_up if we are not cleaning up */
+	atomic_set(&ctx->num_inflight, 1);
+	init_waitqueue_head(&ctx->wait);
+}
+EXPORT_SYMBOL(mlx5_cmd_init_async_ctx);
+
+/**
+ * mlx5_cmd_cleanup_async_ctx - Clean up an async_ctx
+ * @ctx: The ctx to clean
+ *
+ * Upon return all callbacks given to mlx5_cmd_exec_cb() have been called. The
+ * caller must ensure that mlx5_cmd_exec_cb() is not called during or after
+ * the call mlx5_cleanup_async_ctx().
+ */
+void mlx5_cmd_cleanup_async_ctx(struct mlx5_async_ctx *ctx)
+{
+	atomic_dec(&ctx->num_inflight);
+	wait_event(ctx->wait, atomic_read(&ctx->num_inflight) == 0);
+}
+EXPORT_SYMBOL(mlx5_cmd_cleanup_async_ctx);
+
+static void mlx5_cmd_exec_cb_handler(int status, void *_work)
+{
+	struct mlx5_async_work *work = _work;
+	struct mlx5_async_ctx *ctx = work->ctx;
+
+	work->user_callback(status, work);
+	if (atomic_dec_and_test(&ctx->num_inflight))
+		wake_up(&ctx->wait);
+}
+
+int mlx5_cmd_exec_cb(struct mlx5_async_ctx *ctx, void *in, int in_size,
+		     void *out, int out_size, mlx5_async_cbk_t callback,
+		     struct mlx5_async_work *work)
+{
+	int ret;
+
+	work->ctx = ctx;
+	work->user_callback = callback;
+	if (WARN_ON(!atomic_inc_not_zero(&ctx->num_inflight)))
+		return -EIO;
+	ret = cmd_exec(ctx->dev, in, in_size, out, out_size,
+		       mlx5_cmd_exec_cb_handler, work, false);
+	if (ret && atomic_dec_and_test(&ctx->num_inflight))
+		wake_up(&ctx->wait);
+
+	return ret;
 }
 EXPORT_SYMBOL(mlx5_cmd_exec_cb);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
index 0670165afd5f..ea744d8466ea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
@@ -51,9 +51,10 @@ void mlx5_cleanup_mkey_table(struct mlx5_core_dev *dev)
 
 int mlx5_core_create_mkey_cb(struct mlx5_core_dev *dev,
 			     struct mlx5_core_mkey *mkey,
-			     u32 *in, int inlen,
-			     u32 *out, int outlen,
-			     mlx5_cmd_cbk_t callback, void *context)
+			     struct mlx5_async_ctx *async_ctx, u32 *in,
+			     int inlen, u32 *out, int outlen,
+			     mlx5_async_cbk_t callback,
+			     struct mlx5_async_work *context)
 {
 	struct mlx5_mkey_table *table = &dev->priv.mkey_table;
 	u32 lout[MLX5_ST_SZ_DW(create_mkey_out)] = {0};
@@ -71,7 +72,7 @@ int mlx5_core_create_mkey_cb(struct mlx5_core_dev *dev,
 	MLX5_SET(mkc, mkc, mkey_7_0, key);
 
 	if (callback)
-		return mlx5_cmd_exec_cb(dev, in, inlen, out, outlen,
+		return mlx5_cmd_exec_cb(async_ctx, in, inlen, out, outlen,
 					callback, context);
 
 	err = mlx5_cmd_exec(dev, in, inlen, lout, sizeof(lout));
@@ -105,7 +106,7 @@ int mlx5_core_create_mkey(struct mlx5_core_dev *dev,
 			  struct mlx5_core_mkey *mkey,
 			  u32 *in, int inlen)
 {
-	return mlx5_core_create_mkey_cb(dev, mkey, in, inlen,
+	return mlx5_core_create_mkey_cb(dev, mkey, NULL, in, inlen,
 					NULL, 0, NULL, NULL);
 }
 EXPORT_SYMBOL(mlx5_core_create_mkey);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 4e444863054a..039c9398614c 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -850,11 +850,30 @@ void mlx5_cmd_cleanup(struct mlx5_core_dev *dev);
 void mlx5_cmd_use_events(struct mlx5_core_dev *dev);
 void mlx5_cmd_use_polling(struct mlx5_core_dev *dev);
 
+struct mlx5_async_ctx {
+	struct mlx5_core_dev *dev;
+	atomic_t num_inflight;
+	struct wait_queue_head wait;
+};
+
+struct mlx5_async_work;
+
+typedef void (*mlx5_async_cbk_t)(int status, struct mlx5_async_work *context);
+
+struct mlx5_async_work {
+	struct mlx5_async_ctx *ctx;
+	mlx5_async_cbk_t user_callback;
+};
+
+void mlx5_cmd_init_async_ctx(struct mlx5_core_dev *dev,
+			     struct mlx5_async_ctx *ctx);
+void mlx5_cmd_cleanup_async_ctx(struct mlx5_async_ctx *ctx);
+int mlx5_cmd_exec_cb(struct mlx5_async_ctx *ctx, void *in, int in_size,
+		     void *out, int out_size, mlx5_async_cbk_t callback,
+		     struct mlx5_async_work *work);
+
 int mlx5_cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 		  int out_size);
-int mlx5_cmd_exec_cb(struct mlx5_core_dev *dev, void *in, int in_size,
-		     void *out, int out_size, mlx5_cmd_cbk_t callback,
-		     void *context);
 int mlx5_cmd_exec_polling(struct mlx5_core_dev *dev, void *in, int in_size,
 			  void *out, int out_size);
 void mlx5_cmd_mbox_status(void *out, u8 *status, u32 *syndrome);
@@ -885,9 +904,10 @@ void mlx5_init_mkey_table(struct mlx5_core_dev *dev);
 void mlx5_cleanup_mkey_table(struct mlx5_core_dev *dev);
 int mlx5_core_create_mkey_cb(struct mlx5_core_dev *dev,
 			     struct mlx5_core_mkey *mkey,
-			     u32 *in, int inlen,
-			     u32 *out, int outlen,
-			     mlx5_cmd_cbk_t callback, void *context);
+			     struct mlx5_async_ctx *async_ctx, u32 *in,
+			     int inlen, u32 *out, int outlen,
+			     mlx5_async_cbk_t callback,
+			     struct mlx5_async_work *context);
 int mlx5_core_create_mkey(struct mlx5_core_dev *dev,
 			  struct mlx5_core_mkey *mkey,
 			  u32 *in, int inlen);
-- 
2.20.1
