From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 08/10] IB/mlx5: Call PAGE_FAULT_RESUME command asynchronously
Date: Thu,  8 Nov 2018 21:10:15 +0200
Message-ID: <20181108191017.21891-9-leon@kernel.org>
References: <20181108191017.21891-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181108191017.21891-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Majd Dibbiny <majd@mellanox.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis@mellanox.com>

Telling the HCA that page fault handling is done and QP can resume
its flow is done in the context of the page fault handler. This blocks
the handling of the next work in queue without a need.
Call the PAGE_FAULT_RESUME command in an asynchronous manner and free
the workqueue to pick the next work item for handling. All tasks that
were executed after PAGE_FAULT_RESUME need to be done now
in the callback of the asynchronous command mechanism.

Signed-off-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/odp.c | 110 +++++++++++++++++++++++++------
 include/linux/mlx5/driver.h      |   3 +
 2 files changed, 94 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index abce55b8b9ba..0c4f469cdd5b 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -298,20 +298,78 @@ void mlx5_ib_internal_fill_odp_caps(struct mlx5_ib_dev *dev)
 	return;
 }
 
+struct pfault_resume_cb_ctx {
+	struct mlx5_ib_dev *dev;
+	struct mlx5_core_rsc_common *res;
+	struct mlx5_pagefault *pfault;
+};
+
+static void page_fault_resume_callback(int status, void *context)
+{
+	struct pfault_resume_cb_ctx *ctx = context;
+	struct mlx5_pagefault *pfault = ctx->pfault;
+
+	if (status)
+		mlx5_ib_err(ctx->dev, "Resolve the page fault failed with status %d\n",
+			    status);
+
+	if (ctx->res)
+		mlx5_core_res_put(ctx->res);
+	kfree(pfault);
+	kfree(ctx);
+}
+
 static void mlx5_ib_page_fault_resume(struct mlx5_ib_dev *dev,
+				      struct mlx5_core_rsc_common *res,
 				      struct mlx5_pagefault *pfault,
-				      int error)
+				      int error,
+				      bool async)
 {
+	int ret = 0;
+	u32 *out = pfault->out_pf_resume;
+	u32 *in = pfault->in_pf_resume;
+	u32 token = pfault->token;
 	int wq_num = pfault->event_subtype == MLX5_PFAULT_SUBTYPE_WQE ?
-		     pfault->wqe.wq_num : pfault->token;
-	int ret = mlx5_core_page_fault_resume(dev->mdev,
-					      pfault->token,
-					      wq_num,
-					      pfault->type,
-					      error);
-	if (ret)
-		mlx5_ib_err(dev, "Failed to resolve the page fault on WQ 0x%x\n",
-			    wq_num);
+		pfault->wqe.wq_num : pfault->token;
+	u8 type = pfault->type;
+	struct pfault_resume_cb_ctx *ctx = NULL;
+
+	if (async)
+		ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
+
+	if (ctx) {
+		ctx->dev = dev;
+		ctx->res = res;
+		ctx->pfault = pfault;
+	}
+
+	memset(out, 0, MLX5_ST_SZ_BYTES(page_fault_resume_out));
+	memset(in, 0, MLX5_ST_SZ_BYTES(page_fault_resume_in));
+
+	MLX5_SET(page_fault_resume_in, in, opcode, MLX5_CMD_OP_PAGE_FAULT_RESUME);
+	MLX5_SET(page_fault_resume_in, in, error, !!error);
+	MLX5_SET(page_fault_resume_in, in, page_fault_type, type);
+	MLX5_SET(page_fault_resume_in, in, wq_number, wq_num);
+	MLX5_SET(page_fault_resume_in, in, token, token);
+
+	if (ctx)
+		ret = mlx5_cmd_exec_cb(dev->mdev,
+				       in, MLX5_ST_SZ_BYTES(page_fault_resume_in),
+				       out, MLX5_ST_SZ_BYTES(page_fault_resume_out),
+				       page_fault_resume_callback, ctx);
+	else
+		ret = mlx5_cmd_exec(dev->mdev,
+				    in, MLX5_ST_SZ_BYTES(page_fault_resume_in),
+				    out, MLX5_ST_SZ_BYTES(page_fault_resume_out));
+	if (ret || !ctx) {
+		if (ret)
+			mlx5_ib_err(dev, "Failed to resume the page fault (%d)\n", ret);
+		if (res)
+			mlx5_core_res_put(res);
+		if (async)
+			kfree(pfault);
+		kfree(ctx);
+	}
 }
 
 static struct mlx5_ib_mr *implicit_mr_alloc(struct ib_pd *pd,
@@ -1045,7 +1103,8 @@ static inline struct mlx5_ib_qp *res_to_qp(struct mlx5_core_rsc_common *res)
 }
 
 static void mlx5_ib_mr_wqe_pfault_handler(struct mlx5_ib_dev *dev,
-					  struct mlx5_pagefault *pfault)
+					  struct mlx5_pagefault *pfault,
+					  bool async_resume)
 {
 	int ret;
 	void *wqe, *wqe_end;
@@ -1113,11 +1172,10 @@ static void mlx5_ib_mr_wqe_pfault_handler(struct mlx5_ib_dev *dev,
 
 	resume_with_error = 0;
 resolve_page_fault:
-	mlx5_ib_page_fault_resume(dev, pfault, resume_with_error);
+	mlx5_ib_page_fault_resume(dev, res, pfault, resume_with_error, async_resume);
 	mlx5_ib_dbg(dev, "PAGE FAULT completed. QP 0x%x resume_with_error=%d, type: 0x%x\n",
 		    pfault->wqe.wq_num, resume_with_error,
 		    pfault->type);
-	mlx5_core_res_put(res);
 	free_page((unsigned long)buffer);
 }
 
@@ -1128,7 +1186,8 @@ static int pages_in_range(u64 address, u32 length)
 }
 
 static void mlx5_ib_mr_rdma_pfault_handler(struct mlx5_ib_dev *dev,
-					   struct mlx5_pagefault *pfault)
+					   struct mlx5_pagefault *pfault,
+					   bool async_resume)
 {
 	u64 address;
 	u32 length;
@@ -1166,14 +1225,14 @@ static void mlx5_ib_mr_rdma_pfault_handler(struct mlx5_ib_dev *dev,
 		/* We're racing with an invalidation, don't prefetch */
 		prefetch_activated = 0;
 	} else if (ret < 0 || pages_in_range(address, length) > ret) {
-		mlx5_ib_page_fault_resume(dev, pfault, 1);
+		mlx5_ib_page_fault_resume(dev, NULL, pfault, 1, async_resume);
 		if (ret != -ENOENT)
 			mlx5_ib_dbg(dev, "PAGE FAULT error %d. QP 0x%x, type: 0x%x\n",
 				    ret, pfault->token, pfault->type);
 		return;
 	}
 
-	mlx5_ib_page_fault_resume(dev, pfault, 0);
+	mlx5_ib_page_fault_resume(dev, NULL, pfault, 0, async_resume);
 	mlx5_ib_dbg(dev, "PAGE FAULT completed. QP 0x%x, type: 0x%x, prefetch_activated: %d\n",
 		    pfault->token, pfault->type,
 		    prefetch_activated);
@@ -1201,18 +1260,31 @@ void mlx5_ib_pfault(struct mlx5_core_dev *mdev, void *context,
 {
 	struct mlx5_ib_dev *dev = context;
 	u8 event_subtype = pfault->event_subtype;
+	struct mlx5_pagefault *pfault_copy;
+	struct mlx5_pagefault *pfault_arg;
+	bool async_resume;
+
+	pfault_copy = kmalloc(sizeof(*pfault_copy), GFP_KERNEL);
+	if (pfault_copy) {
+		memcpy(pfault_copy, pfault, sizeof(*pfault_copy));
+		async_resume = true;
+		pfault_arg = pfault_copy;
+	} else {
+		async_resume = false;
+		pfault_arg = pfault;
+	}
 
 	switch (event_subtype) {
 	case MLX5_PFAULT_SUBTYPE_WQE:
-		mlx5_ib_mr_wqe_pfault_handler(dev, pfault);
+		mlx5_ib_mr_wqe_pfault_handler(dev, pfault_arg, async_resume);
 		break;
 	case MLX5_PFAULT_SUBTYPE_RDMA:
-		mlx5_ib_mr_rdma_pfault_handler(dev, pfault);
+		mlx5_ib_mr_rdma_pfault_handler(dev, pfault_arg, async_resume);
 		break;
 	default:
 		mlx5_ib_err(dev, "Invalid page fault event subtype: 0x%x\n",
 			    event_subtype);
-		mlx5_ib_page_fault_resume(dev, pfault, 1);
+		mlx5_ib_page_fault_resume(dev, NULL, pfault, 1, false);
 	}
 }
 
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index aa5963b5d38e..85275612a473 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -738,6 +738,9 @@ enum mlx5_pagefault_type_flags {
 
 /* Contains the details of a pagefault. */
 struct mlx5_pagefault {
+	u32 out_pf_resume[MLX5_ST_SZ_DW(page_fault_resume_out)];
+	u32 in_pf_resume[MLX5_ST_SZ_DW(page_fault_resume_in)];
+
 	u32			bytes_committed;
 	u32			token;
 	u8			event_subtype;
-- 
2.19.1
