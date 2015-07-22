From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 02/43] IB/mlx4: Support ib_alloc_mr verb
Date: Wed, 22 Jul 2015 09:55:02 +0300
Message-ID: <1437548143-24893-3-git-send-email-sagig@mellanox.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c    |  1 +
 drivers/infiniband/hw/mlx4/mlx4_ib.h |  4 ++++
 drivers/infiniband/hw/mlx4/mr.c      | 38 ++++++++++++++++++++++++++++++++++++
 3 files changed, 43 insertions(+)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index a6f44ee..54671c7 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2298,6 +2298,7 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	ibdev->ib_dev.rereg_user_mr	= mlx4_ib_rereg_user_mr;
 	ibdev->ib_dev.dereg_mr		= mlx4_ib_dereg_mr;
 	ibdev->ib_dev.alloc_fast_reg_mr = mlx4_ib_alloc_fast_reg_mr;
+	ibdev->ib_dev.alloc_mr		= mlx4_ib_alloc_mr;
 	ibdev->ib_dev.alloc_fast_reg_page_list = mlx4_ib_alloc_fast_reg_page_list;
 	ibdev->ib_dev.free_fast_reg_page_list  = mlx4_ib_free_fast_reg_page_list;
 	ibdev->ib_dev.attach_mcast	= mlx4_ib_mcg_attach;
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 334387f..c8b5679 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -680,6 +680,10 @@ struct ib_mw *mlx4_ib_alloc_mw(struct ib_pd *pd, enum ib_mw_type type);
 int mlx4_ib_bind_mw(struct ib_qp *qp, struct ib_mw *mw,
 		    struct ib_mw_bind *mw_bind);
 int mlx4_ib_dealloc_mw(struct ib_mw *mw);
+struct ib_mr *mlx4_ib_alloc_mr(struct ib_pd *pd,
+			       enum ib_mr_type mr_type,
+			       u32 max_entries,
+			       u32 flags);
 struct ib_mr *mlx4_ib_alloc_fast_reg_mr(struct ib_pd *pd,
 					int max_page_list_len);
 struct ib_fast_reg_page_list *mlx4_ib_alloc_fast_reg_page_list(struct ib_device *ibdev,
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index e0d2717..3cba374 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -350,6 +350,44 @@ int mlx4_ib_dealloc_mw(struct ib_mw *ibmw)
 	return 0;
 }
 
+struct ib_mr *mlx4_ib_alloc_mr(struct ib_pd *pd,
+			       enum ib_mr_type mr_type,
+			       u32 max_entries,
+			       u32 flags)
+{
+	struct mlx4_ib_dev *dev = to_mdev(pd->device);
+	struct mlx4_ib_mr *mr;
+	int err;
+
+	if (mr_type != IB_MR_TYPE_FAST_REG || flags)
+		return ERR_PTR(-EINVAL);
+
+	mr = kmalloc(sizeof *mr, GFP_KERNEL);
+	if (!mr)
+		return ERR_PTR(-ENOMEM);
+
+	err = mlx4_mr_alloc(dev->dev, to_mpd(pd)->pdn, 0, 0, 0,
+			    max_entries, 0, &mr->mmr);
+	if (err)
+		goto err_free;
+
+	err = mlx4_mr_enable(dev->dev, &mr->mmr);
+	if (err)
+		goto err_mr;
+
+	mr->ibmr.rkey = mr->ibmr.lkey = mr->mmr.key;
+	mr->umem = NULL;
+
+	return &mr->ibmr;
+
+err_mr:
+	(void) mlx4_mr_free(dev->dev, &mr->mmr);
+
+err_free:
+	kfree(mr);
+	return ERR_PTR(err);
+}
+
 struct ib_mr *mlx4_ib_alloc_fast_reg_mr(struct ib_pd *pd,
 					int max_page_list_len)
 {
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
