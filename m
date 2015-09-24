From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-rc v2 4/4] IB/mlx5: Remove pa_lkey usages
Date: Thu, 24 Sep 2015 10:34:24 +0300
Message-ID: <1443080064-28760-5-git-send-email-sagig@mellanox.com>
References: <1443080064-28760-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443080064-28760-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Since mlx5 driver cannot rely on registration using the
reserved lkey (global_dma_lkey) it used to allocate a private
physical address lkey for each allocated pd.
Commit 96249d70dd70 ("IB/core: Guarantee that a local_dma_lkey
is available") just does it in the core layer so we can go ahead
and use that.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 57 ------------------------------------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  2 --
 drivers/infiniband/hw/mlx5/qp.c      |  4 +--
 3 files changed, 1 insertion(+), 62 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 0ab9625911a1..f1ccd40beae9 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -794,53 +794,6 @@ static int mlx5_ib_mmap(struct ib_ucontext *ibcontext, struct vm_area_struct *vm
 	return 0;
 }
 
-static int alloc_pa_mkey(struct mlx5_ib_dev *dev, u32 *key, u32 pdn)
-{
-	struct mlx5_create_mkey_mbox_in *in;
-	struct mlx5_mkey_seg *seg;
-	struct mlx5_core_mr mr;
-	int err;
-
-	in = kzalloc(sizeof(*in), GFP_KERNEL);
-	if (!in)
-		return -ENOMEM;
-
-	seg = &in->seg;
-	seg->flags = MLX5_PERM_LOCAL_READ | MLX5_ACCESS_MODE_PA;
-	seg->flags_pd = cpu_to_be32(pdn | MLX5_MKEY_LEN64);
-	seg->qpn_mkey7_0 = cpu_to_be32(0xffffff << 8);
-	seg->start_addr = 0;
-
-	err = mlx5_core_create_mkey(dev->mdev, &mr, in, sizeof(*in),
-				    NULL, NULL, NULL);
-	if (err) {
-		mlx5_ib_warn(dev, "failed to create mkey, %d\n", err);
-		goto err_in;
-	}
-
-	kfree(in);
-	*key = mr.key;
-
-	return 0;
-
-err_in:
-	kfree(in);
-
-	return err;
-}
-
-static void free_pa_mkey(struct mlx5_ib_dev *dev, u32 key)
-{
-	struct mlx5_core_mr mr;
-	int err;
-
-	memset(&mr, 0, sizeof(mr));
-	mr.key = key;
-	err = mlx5_core_destroy_mkey(dev->mdev, &mr);
-	if (err)
-		mlx5_ib_warn(dev, "failed to destroy mkey 0x%x\n", key);
-}
-
 static struct ib_pd *mlx5_ib_alloc_pd(struct ib_device *ibdev,
 				      struct ib_ucontext *context,
 				      struct ib_udata *udata)
@@ -866,13 +819,6 @@ static struct ib_pd *mlx5_ib_alloc_pd(struct ib_device *ibdev,
 			kfree(pd);
 			return ERR_PTR(-EFAULT);
 		}
-	} else {
-		err = alloc_pa_mkey(to_mdev(ibdev), &pd->pa_lkey, pd->pdn);
-		if (err) {
-			mlx5_core_dealloc_pd(to_mdev(ibdev)->mdev, pd->pdn);
-			kfree(pd);
-			return ERR_PTR(err);
-		}
 	}
 
 	return &pd->ibpd;
@@ -883,9 +829,6 @@ static int mlx5_ib_dealloc_pd(struct ib_pd *pd)
 	struct mlx5_ib_dev *mdev = to_mdev(pd->device);
 	struct mlx5_ib_pd *mpd = to_mpd(pd);
 
-	if (!pd->uobject)
-		free_pa_mkey(mdev, mpd->pa_lkey);
-
 	mlx5_core_dealloc_pd(mdev->mdev, mpd->pdn);
 	kfree(mpd);
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index a5fa0b9c7580..b0a22fea76f1 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -103,7 +103,6 @@ static inline struct mlx5_ib_ucontext *to_mucontext(struct ib_ucontext *ibuconte
 struct mlx5_ib_pd {
 	struct ib_pd		ibpd;
 	u32			pdn;
-	u32			pa_lkey;
 };
 
 /* Use macros here so that don't have to duplicate
@@ -213,7 +212,6 @@ struct mlx5_ib_qp {
 	int			uuarn;
 
 	int			create_type;
-	u32			pa_lkey;
 
 	/* Store signature errors */
 	bool			signature_en;
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 203c8a45e095..45722a4fa99d 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -930,8 +930,6 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 			err = create_kernel_qp(dev, init_attr, qp, &in, &inlen);
 			if (err)
 				mlx5_ib_dbg(dev, "err %d\n", err);
-			else
-				qp->pa_lkey = to_mpd(pd)->pa_lkey;
 		}
 
 		if (err)
@@ -2050,7 +2048,7 @@ static void set_frwr_pages(struct mlx5_wqe_data_seg *dseg,
 		mfrpl->mapped_page_list[i] = cpu_to_be64(page_list[i] | perm);
 	dseg->addr = cpu_to_be64(mfrpl->map);
 	dseg->byte_count = cpu_to_be32(ALIGN(sizeof(u64) * wr->wr.fast_reg.page_list_len, 64));
-	dseg->lkey = cpu_to_be32(pd->pa_lkey);
+	dseg->lkey = cpu_to_be32(pd->ibpd.local_dma_lkey);
 }
 
 static __be32 send_ieth(struct ib_send_wr *wr)
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
