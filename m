From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 7/7] IB/mlx5: Fix NULL deference on mlx5_ib_update_xlt failure
Date: Sun, 24 Sep 2017 21:46:35 +0300
Message-ID: <20170924184635.31948-8-leon@kernel.org>
References: <20170924184635.31948-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170924184635.31948-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ilya Lesokhin <ilyal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ilya Lesokhin <ilyal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

mlx5_ib_reg_user_mr called mlx5_ib_dereg_mr in case of MR population
failure. This resulted in a NULL dereference as ibmr->device wasn't
initialized yet.

We address this by adding an internal dereg_mr function that can handle
partially initialized MRs, and fixing clean_mr to work on partially
initialized MRs.

Fixes: ff740aefecb9 ("IB/mlx5: Decouple MR allocation and population flows")
Signed-off-by: Ilya Lesokhin <ilyal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 0e2789d9bb4d..37bbc543847a 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -47,7 +47,8 @@ enum {
 
 #define MLX5_UMR_ALIGN 2048
 
-static int clean_mr(struct mlx5_ib_mr *mr);
+static int clean_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr);
+static int dereg_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr);
 static int mr_cache_max_order(struct mlx5_ib_dev *dev);
 static int unreg_umr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr);
 
@@ -1270,8 +1271,9 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 
 		err = mlx5_ib_update_xlt(mr, 0, ncont, page_shift,
 					 update_xlt_flags);
+
 		if (err) {
-			mlx5_ib_dereg_mr(&mr->ibmr);
+			dereg_mr(dev, mr);
 			return ERR_PTR(err);
 		}
 	}
@@ -1356,7 +1358,7 @@ int mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 		err = mr_umem_get(pd, addr, len, access_flags, &mr->umem,
 				  &npages, &page_shift, &ncont, &order);
 		if (err < 0) {
-			clean_mr(mr);
+			clean_mr(dev, mr);
 			return err;
 		}
 	}
@@ -1410,7 +1412,7 @@ int mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 		if (err) {
 			mlx5_ib_warn(dev, "Failed to rereg UMR\n");
 			ib_umem_release(mr->umem);
-			clean_mr(mr);
+			clean_mr(dev, mr);
 			return err;
 		}
 	}
@@ -1469,9 +1471,8 @@ mlx5_free_priv_descs(struct mlx5_ib_mr *mr)
 	}
 }
 
-static int clean_mr(struct mlx5_ib_mr *mr)
+static int clean_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 {
-	struct mlx5_ib_dev *dev = to_mdev(mr->ibmr.device);
 	int allocated_from_cache = mr->allocated_from_cache;
 	int err;
 
@@ -1507,10 +1508,8 @@ static int clean_mr(struct mlx5_ib_mr *mr)
 	return 0;
 }
 
-int mlx5_ib_dereg_mr(struct ib_mr *ibmr)
+static int dereg_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ibmr->device);
-	struct mlx5_ib_mr *mr = to_mmr(ibmr);
 	int npages = mr->npages;
 	struct ib_umem *umem = mr->umem;
 
@@ -1539,7 +1538,7 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr)
 	}
 #endif
 
-	clean_mr(mr);
+	clean_mr(dev, mr);
 
 	if (umem) {
 		ib_umem_release(umem);
@@ -1549,6 +1548,14 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr)
 	return 0;
 }
 
+int mlx5_ib_dereg_mr(struct ib_mr *ibmr)
+{
+	struct mlx5_ib_dev *dev = to_mdev(ibmr->device);
+	struct mlx5_ib_mr *mr = to_mmr(ibmr);
+
+	return dereg_mr(dev, mr);
+}
+
 struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd,
 			       enum ib_mr_type mr_type,
 			       u32 max_num_sg)
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
