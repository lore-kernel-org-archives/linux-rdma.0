From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 for-next 8/9] IB/mlx5: Invalidation support for MR over peer memory
Date: Mon,  6 Oct 2014 16:26:58 +0300
Message-ID: <1412602019-30659-9-git-send-email-yishaih@mellanox.com>
References: <1412602019-30659-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412602019-30659-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
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
 drivers/infiniband/hw/mlx5/main.c    |    3 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h |   10 ++++
 drivers/infiniband/hw/mlx5/mr.c      |   84 ++++++++++++++++++++++++++++++++--
 3 files changed, 91 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index d8907b2..4185531 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -182,7 +182,8 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	props->device_cap_flags    = IB_DEVICE_CHANGE_PHY_PORT |
 		IB_DEVICE_PORT_ACTIVE_EVENT		|
 		IB_DEVICE_SYS_IMAGE_GUID		|
-		IB_DEVICE_RC_RNR_NAK_GEN;
+		IB_DEVICE_RC_RNR_NAK_GEN		|
+		IB_DEVICE_PEER_MEMORY;
 	flags = dev->mdev->caps.flags;
 	if (flags & MLX5_DEV_CAP_FLAG_BAD_PKEY_CNTR)
 		props->device_cap_flags |= IB_DEVICE_BAD_PKEY_CNTR;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 386780f..bae7338 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -85,6 +85,8 @@ enum mlx5_ib_mad_ifc_flags {
 	MLX5_MAD_IFC_NET_VIEW		= 4,
 };
 
+struct mlx5_ib_peer_id;
+
 struct mlx5_ib_ucontext {
 	struct ib_ucontext	ibucontext;
 	struct list_head	db_page_list;
@@ -267,6 +269,14 @@ struct mlx5_ib_mr {
 	struct mlx5_ib_dev     *dev;
 	struct mlx5_create_mkey_mbox_out out;
 	struct mlx5_core_sig_ctx    *sig;
+	struct mlx5_ib_peer_id *peer_id;
+	atomic_t      invalidated;
+	struct completion invalidation_comp;
+};
+
+struct mlx5_ib_peer_id {
+	struct completion comp;
+	struct mlx5_ib_mr *mr;
 };
 
 struct mlx5_ib_fast_reg_page_list {
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 55c6649..390b149 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -38,6 +38,9 @@
 #include <linux/delay.h>
 #include <rdma/ib_umem.h>
 #include "mlx5_ib.h"
+static void mlx5_invalidate_umem(void *invalidation_cookie,
+				 struct ib_umem *umem,
+				 unsigned long addr, size_t size);
 
 enum {
 	MAX_PENDING_REG_MR = 8,
@@ -880,16 +883,32 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	int ncont;
 	int order;
 	int err;
+	struct ib_peer_memory_client *ib_peer_mem;
+	struct mlx5_ib_peer_id *mlx5_ib_peer_id = NULL;
 
 	mlx5_ib_dbg(dev, "start 0x%llx, virt_addr 0x%llx, length 0x%llx\n",
 		    start, virt_addr, length);
 	umem = ib_umem_get(pd->uobject->context, start, length, access_flags,
-			   0, IB_PEER_MEM_ALLOW);
+			   0, IB_PEER_MEM_ALLOW | IB_PEER_MEM_INVAL_SUPP);
 	if (IS_ERR(umem)) {
 		mlx5_ib_dbg(dev, "umem get failed\n");
 		return (void *)umem;
 	}
 
+	ib_peer_mem = umem->ib_peer_mem;
+	if (ib_peer_mem) {
+		mlx5_ib_peer_id = kzalloc(sizeof(*mlx5_ib_peer_id), GFP_KERNEL);
+		if (!mlx5_ib_peer_id) {
+			err = -ENOMEM;
+			goto error;
+		}
+		init_completion(&mlx5_ib_peer_id->comp);
+		err = ib_umem_activate_invalidation_notifier(umem, mlx5_invalidate_umem,
+							     mlx5_ib_peer_id);
+		if (err)
+			goto error;
+	}
+
 	mlx5_ib_cont_pages(umem, start, &npages, &page_shift, &ncont, &order);
 	if (!npages) {
 		mlx5_ib_warn(dev, "avoid zero region\n");
@@ -927,11 +946,21 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	spin_unlock(&dev->mr_lock);
 	mr->ibmr.lkey = mr->mmr.key;
 	mr->ibmr.rkey = mr->mmr.key;
+	atomic_set(&mr->invalidated, 0);
+	if (ib_peer_mem) {
+		init_completion(&mr->invalidation_comp);
+		mlx5_ib_peer_id->mr = mr;
+		mr->peer_id = mlx5_ib_peer_id;
+		complete(&mlx5_ib_peer_id->comp);
+	}
 
 	return &mr->ibmr;
 
 error:
+	if (mlx5_ib_peer_id)
+		complete(&mlx5_ib_peer_id->comp);
 	ib_umem_release(umem);
+	kfree(mlx5_ib_peer_id);
 	return ERR_PTR(err);
 }
 
@@ -968,7 +997,7 @@ error:
 	return err;
 }
 
-int mlx5_ib_dereg_mr(struct ib_mr *ibmr)
+static int mlx5_ib_invalidate_mr(struct ib_mr *ibmr)
 {
 	struct mlx5_ib_dev *dev = to_mdev(ibmr->device);
 	struct mlx5_ib_mr *mr = to_mmr(ibmr);
@@ -990,7 +1019,6 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr)
 			mlx5_ib_warn(dev, "failed unregister\n");
 			return err;
 		}
-		free_cached_mr(dev, mr);
 	}
 
 	if (umem) {
@@ -1000,9 +1028,32 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr)
 		spin_unlock(&dev->mr_lock);
 	}
 
-	if (!umred)
-		kfree(mr);
+	return 0;
+}
+
+int mlx5_ib_dereg_mr(struct ib_mr *ibmr)
+{
+	struct mlx5_ib_dev *dev = to_mdev(ibmr->device);
+	struct mlx5_ib_mr *mr = to_mmr(ibmr);
+	int ret = 0;
+	int umred = mr->umred;
 
+	if (atomic_inc_return(&mr->invalidated) > 1) {
+		/* In case there is inflight invalidation call pending for its termination */
+		wait_for_completion(&mr->invalidation_comp);
+	} else {
+		ret = mlx5_ib_invalidate_mr(ibmr);
+		if (ret)
+			return ret;
+	}
+	kfree(mr->peer_id);
+	mr->peer_id = NULL;
+	if (umred) {
+		atomic_set(&mr->invalidated, 0);
+		free_cached_mr(dev, mr);
+	} else {
+		kfree(mr);
+	}
 	return 0;
 }
 
@@ -1122,6 +1173,29 @@ int mlx5_ib_destroy_mr(struct ib_mr *ibmr)
 	return err;
 }
 
+static void mlx5_invalidate_umem(void *invalidation_cookie,
+				 struct ib_umem *umem,
+				 unsigned long addr, size_t size)
+{
+	struct mlx5_ib_mr *mr;
+	struct mlx5_ib_peer_id *peer_id = (struct mlx5_ib_peer_id *)invalidation_cookie;
+
+	wait_for_completion(&peer_id->comp);
+	if (peer_id->mr == NULL)
+		return;
+
+	mr = peer_id->mr;
+	/* This function is called under client peer lock so its resources are race protected */
+	if (atomic_inc_return(&mr->invalidated) > 1) {
+		umem->invalidation_ctx->inflight_invalidation = 1;
+		return;
+	}
+
+	umem->invalidation_ctx->peer_callback = 1;
+	mlx5_ib_invalidate_mr(&mr->ibmr);
+	complete(&mr->invalidation_comp);
+}
+
 struct ib_mr *mlx5_ib_alloc_fast_reg_mr(struct ib_pd *pd,
 					int max_page_list_len)
 {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
