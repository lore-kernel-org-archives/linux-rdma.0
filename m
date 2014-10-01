From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 7/9] IB/mlx4: Invalidation support for MR over peer memory
Date: Wed,  1 Oct 2014 18:18:35 +0300
Message-ID: <1412176717-11979-8-git-send-email-yishaih@mellanox.com>
References: <1412176717-11979-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412176717-11979-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Adds the required functionality to work with peer memory
clients which require invalidation support.

It includes:

- umem invalidation callback - once called should free any HW
  resources assigned to that umem, then free peer resources
  corresponding to that umem.
- The MR object relates to that umem is stay alive till dereg_mr is
  called.
- synchronizing support between dereg_mr to invalidate callback.
- advertises the P2P device capability.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c    |    3 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h |    5 ++
 drivers/infiniband/hw/mlx4/mr.c      |   81 +++++++++++++++++++++++++++++++---
 3 files changed, 81 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index c7586a1..2f349a2 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -162,7 +162,8 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 		IB_DEVICE_PORT_ACTIVE_EVENT		|
 		IB_DEVICE_SYS_IMAGE_GUID		|
 		IB_DEVICE_RC_RNR_NAK_GEN		|
-		IB_DEVICE_BLOCK_MULTICAST_LOOPBACK;
+		IB_DEVICE_BLOCK_MULTICAST_LOOPBACK	|
+		IB_DEVICE_PEER_MEMORY;
 	if (dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_BAD_PKEY_CNTR)
 		props->device_cap_flags |= IB_DEVICE_BAD_PKEY_CNTR;
 	if (dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_BAD_QKEY_CNTR)
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 6eb743f..4b3dc70 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -116,6 +116,11 @@ struct mlx4_ib_mr {
 	struct ib_mr		ibmr;
 	struct mlx4_mr		mmr;
 	struct ib_umem	       *umem;
+	atomic_t      invalidated;
+	struct completion invalidation_comp;
+	/* lock protects the live indication */
+	struct mutex lock;
+	int    live;
 };
 
 struct mlx4_ib_mw {
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index ad4cdfd..ddc9530 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -59,7 +59,7 @@ struct ib_mr *mlx4_ib_get_dma_mr(struct ib_pd *pd, int acc)
 	struct mlx4_ib_mr *mr;
 	int err;
 
-	mr = kmalloc(sizeof *mr, GFP_KERNEL);
+	mr = kzalloc(sizeof *mr, GFP_KERNEL);
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
@@ -130,6 +130,31 @@ out:
 	return err;
 }
 
+static void mlx4_invalidate_umem(void *invalidation_cookie,
+				 struct ib_umem *umem,
+				 unsigned long addr, size_t size)
+{
+	struct mlx4_ib_mr *mr = (struct mlx4_ib_mr *)invalidation_cookie;
+
+	mutex_lock(&mr->lock);
+	/* This function is called under client peer lock so its resources are race protected */
+	if (atomic_inc_return(&mr->invalidated) > 1) {
+		umem->invalidation_ctx->inflight_invalidation = 1;
+		mutex_unlock(&mr->lock);
+		return;
+	}
+	if (!mr->live) {
+		mutex_unlock(&mr->lock);
+		return;
+	}
+
+	mutex_unlock(&mr->lock);
+	umem->invalidation_ctx->peer_callback = 1;
+	mlx4_mr_free(to_mdev(mr->ibmr.device)->dev, &mr->mmr);
+	ib_umem_release(umem);
+	complete(&mr->invalidation_comp);
+}
+
 struct ib_mr *mlx4_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 				  u64 virt_addr, int access_flags,
 				  struct ib_udata *udata)
@@ -139,28 +164,54 @@ struct ib_mr *mlx4_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	int shift;
 	int err;
 	int n;
+	struct ib_peer_memory_client *ib_peer_mem;
 
-	mr = kmalloc(sizeof *mr, GFP_KERNEL);
+	mr = kzalloc(sizeof *mr, GFP_KERNEL);
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
+	mutex_init(&mr->lock);
 	/* Force registering the memory as writable. */
 	/* Used for memory re-registeration. HCA protects the access */
 	mr->umem = ib_umem_get(pd->uobject->context, start, length,
 			       access_flags | IB_ACCESS_LOCAL_WRITE, 0,
-			       IB_PEER_MEM_ALLOW);
+			       IB_PEER_MEM_ALLOW | IB_PEER_MEM_INVAL_SUPP);
 	if (IS_ERR(mr->umem)) {
 		err = PTR_ERR(mr->umem);
 		goto err_free;
 	}
 
+	ib_peer_mem = mr->umem->ib_peer_mem;
+	if (ib_peer_mem) {
+		err = ib_umem_activate_invalidation_notifier(mr->umem, mlx4_invalidate_umem, mr);
+		if (err)
+			goto err_umem;
+	}
+
+	mutex_lock(&mr->lock);
+	if (atomic_read(&mr->invalidated))
+		goto err_locked_umem;
+
+	if (ib_peer_mem) {
+		if (access_flags & IB_ACCESS_MW_BIND) {
+			/* Prevent binding MW on peer clients, mlx4_invalidate_umem is a void
+			 * function and must succeed, however, mlx4_mr_free might fail when MW
+			 * are used.
+			*/
+			err = -ENOSYS;
+			pr_err("MW is not supported with peer memory client");
+			goto err_locked_umem;
+		}
+		init_completion(&mr->invalidation_comp);
+	}
+
 	n = ib_umem_page_count(mr->umem);
 	shift = ilog2(mr->umem->page_size);
 
 	err = mlx4_mr_alloc(dev->dev, to_mpd(pd)->pdn, virt_addr, length,
 			    convert_access(access_flags), n, shift, &mr->mmr);
 	if (err)
-		goto err_umem;
+		goto err_locked_umem;
 
 	err = mlx4_ib_umem_write_mtt(dev, &mr->mmr.mtt, mr->umem);
 	if (err)
@@ -171,12 +222,16 @@ struct ib_mr *mlx4_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 		goto err_mr;
 
 	mr->ibmr.rkey = mr->ibmr.lkey = mr->mmr.key;
-
+	mr->live = 1;
+	mutex_unlock(&mr->lock);
 	return &mr->ibmr;
 
 err_mr:
 	(void) mlx4_mr_free(to_mdev(pd->device)->dev, &mr->mmr);
 
+err_locked_umem:
+	mutex_unlock(&mr->lock);
+
 err_umem:
 	ib_umem_release(mr->umem);
 
@@ -284,11 +339,23 @@ int mlx4_ib_dereg_mr(struct ib_mr *ibmr)
 	struct mlx4_ib_mr *mr = to_mmr(ibmr);
 	int ret;
 
+	if (atomic_inc_return(&mr->invalidated) > 1) {
+		wait_for_completion(&mr->invalidation_comp);
+		goto end;
+	}
+
 	ret = mlx4_mr_free(to_mdev(ibmr->device)->dev, &mr->mmr);
-	if (ret)
+	if (ret) {
+		/* Error is not expected here, except when memory windows
+		 * are bound to MR which is not supported with
+		 * peer memory clients.
+		*/
+		atomic_set(&mr->invalidated, 0);
 		return ret;
+	}
 	if (mr->umem)
 		ib_umem_release(mr->umem);
+end:
 	kfree(mr);
 
 	return 0;
@@ -365,7 +432,7 @@ struct ib_mr *mlx4_ib_alloc_fast_reg_mr(struct ib_pd *pd,
 	struct mlx4_ib_mr *mr;
 	int err;
 
-	mr = kmalloc(sizeof *mr, GFP_KERNEL);
+	mr = kzalloc(sizeof *mr, GFP_KERNEL);
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
