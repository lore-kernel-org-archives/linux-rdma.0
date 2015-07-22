From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 22/43] mlx4: Allocate a private page list in ib_alloc_mr
Date: Wed, 22 Jul 2015 09:55:22 +0300
Message-ID: <1437548143-24893-23-git-send-email-sagig@mellanox.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mlx4_ib.h |  5 ++++
 drivers/infiniband/hw/mlx4/mr.c      | 52 +++++++++++++++++++++++++++++++++---
 2 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 9220faf..a9a4a7f 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -120,6 +120,11 @@ struct mlx4_ib_mr {
 	struct ib_mr		ibmr;
 	struct mlx4_mr		mmr;
 	struct ib_umem	       *umem;
+	u64		        *pl;
+	__be64			*mpl;
+	dma_addr_t		pl_map;
+	u32			npages;
+	u32			max_pages;
 };
 
 struct mlx4_ib_mw {
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index 121ee7f..01e16bc 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -271,11 +271,50 @@ release_mpt_entry:
 	return err;
 }
 
+static int
+mlx4_alloc_page_list(struct ib_device *device,
+		     struct mlx4_ib_mr *mr,
+		      int max_entries)
+{
+	int size = max_entries * sizeof (u64);
+
+	mr->pl = kcalloc(max_entries, sizeof(u64), GFP_KERNEL);
+	if (!mr->pl)
+		return -ENOMEM;
+
+	mr->mpl = dma_alloc_coherent(device->dma_device, size,
+				     &mr->pl_map, GFP_KERNEL);
+	if (!mr->mpl)
+		goto err;
+
+	return 0;
+err:
+	kfree(mr->pl);
+
+	return -ENOMEM;
+}
+
+static void
+mlx4_free_page_list(struct mlx4_ib_mr *mr)
+{
+	struct ib_device *device = mr->ibmr.device;
+	int size = mr->max_pages * sizeof(u64);
+
+	kfree(mr->pl);
+	if (mr->mpl)
+		dma_free_coherent(device->dma_device, size,
+				  mr->mpl, mr->pl_map);
+	mr->pl = NULL;
+	mr->mpl = NULL;
+}
+
 int mlx4_ib_dereg_mr(struct ib_mr *ibmr)
 {
 	struct mlx4_ib_mr *mr = to_mmr(ibmr);
 	int ret;
 
+	mlx4_free_page_list(mr);
+
 	ret = mlx4_mr_free(to_mdev(ibmr->device)->dev, &mr->mmr);
 	if (ret)
 		return ret;
@@ -371,18 +410,25 @@ struct ib_mr *mlx4_ib_alloc_mr(struct ib_pd *pd,
 	if (err)
 		goto err_free;
 
+	err = mlx4_alloc_page_list(pd->device, mr, max_entries);
+	if (err)
+		goto err_free_mr;
+
+	mr->max_pages = max_entries;
+
 	err = mlx4_mr_enable(dev->dev, &mr->mmr);
 	if (err)
-		goto err_mr;
+		goto err_free_pl;
 
 	mr->ibmr.rkey = mr->ibmr.lkey = mr->mmr.key;
 	mr->umem = NULL;
 
 	return &mr->ibmr;
 
-err_mr:
+err_free_pl:
+	mlx4_free_page_list(mr);
+err_free_mr:
 	(void) mlx4_mr_free(dev->dev, &mr->mmr);
-
 err_free:
 	kfree(mr);
 	return ERR_PTR(err);
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
