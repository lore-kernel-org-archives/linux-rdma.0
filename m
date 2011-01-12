From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: mlx4 fix for 36-bit bus addresses on 32-bit arch (was: [PATCH 1/1 (resend)] mthca: Modify to support embedded PowerPC platforms)
Date: Wed, 12 Jan 2011 09:53:00 -0800
Message-ID: <adahbde57r7.fsf_-_@cisco.com>
References: <ig5vl1$j0$1@dough.gmane.org> <adafwt06puj.fsf@cisco.com>
	<4D2D5FAD.6030508@cadence.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D2D5FAD.6030508-vna1KIf7WgpBDgjK7y7TUQ@public.gmane.org> (J. L. Burr's message of "Wed, 12
	Jan 2011 03:00:45 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J.L. Burr" <jlburr-vna1KIf7WgpBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > I reviewed your change against the latest tree and it looks fine to me.
 > I've tried to get my e-mail / news client set-up properly and hope that I'm
 > now maintaining tab characters!  Thanks for shepherding this through for me.

Thanks, I'll get the mthca patch upstream.  I think the following is
also required -- any review is appreciated.

 - R.

8<--------------------------------------------------

mlx4_{core, ib, en}: Fix driver when sizeof (phys_addr_t) > sizeof (long)

Some systems have PCI addresses that don't fit in unsigned long (eg some
32-bit PowerPC 440 systems have 36-bit bus addresses).  Fix up mlx4 drivers
by using phys_addr_t where appropriate, so we don't truncate any PCI
resource addresses before ioremapping them.

Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |    3 ++-
 drivers/net/mlx4/catas.c          |    6 +++---
 drivers/net/mlx4/en_main.c        |    3 ++-
 drivers/net/mlx4/main.c           |    2 +-
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 4c85224..d68d849 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1005,7 +1005,8 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	if (mlx4_uar_alloc(dev, &ibdev->priv_uar))
 		goto err_pd;
 
-	ibdev->uar_map = ioremap(ibdev->priv_uar.pfn << PAGE_SHIFT, PAGE_SIZE);
+	ibdev->uar_map = ioremap((phys_addr_t) ibdev->priv_uar.pfn << PAGE_SHIFT,
+				 PAGE_SIZE);
 	if (!ibdev->uar_map)
 		goto err_uar;
 	MLX4_INIT_DOORBELL_LOCK(&ibdev->uar_lock);
diff --git a/drivers/net/mlx4/catas.c b/drivers/net/mlx4/catas.c
index 68aaa42..32f9471 100644
--- a/drivers/net/mlx4/catas.c
+++ b/drivers/net/mlx4/catas.c
@@ -113,7 +113,7 @@ static void catas_reset(struct work_struct *work)
 void mlx4_start_catas_poll(struct mlx4_dev *dev)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
-	unsigned long addr;
+	phys_addr_t addr;
 
 	INIT_LIST_HEAD(&priv->catas_err.list);
 	init_timer(&priv->catas_err.timer);
@@ -124,8 +124,8 @@ void mlx4_start_catas_poll(struct mlx4_dev *dev)
 
 	priv->catas_err.map = ioremap(addr, priv->fw.catas_size * 4);
 	if (!priv->catas_err.map) {
-		mlx4_warn(dev, "Failed to map internal error buffer at 0x%lx\n",
-			  addr);
+		mlx4_warn(dev, "Failed to map internal error buffer at 0x%llx\n",
+			  (unsigned long long) addr);
 		return;
 	}
 
diff --git a/drivers/net/mlx4/en_main.c b/drivers/net/mlx4/en_main.c
index f6e0d40..1ff6ca6 100644
--- a/drivers/net/mlx4/en_main.c
+++ b/drivers/net/mlx4/en_main.c
@@ -202,7 +202,8 @@ static void *mlx4_en_add(struct mlx4_dev *dev)
 	if (mlx4_uar_alloc(dev, &mdev->priv_uar))
 		goto err_pd;
 
-	mdev->uar_map = ioremap(mdev->priv_uar.pfn << PAGE_SHIFT, PAGE_SIZE);
+	mdev->uar_map = ioremap((phys_addr_t) mdev->priv_uar.pfn << PAGE_SHIFT,
+				PAGE_SIZE);
 	if (!mdev->uar_map)
 		goto err_uar;
 	spin_lock_init(&mdev->uar_lock);
diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index 782f11d..4ffdc18 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -829,7 +829,7 @@ static int mlx4_setup_hca(struct mlx4_dev *dev)
 		goto err_uar_table_free;
 	}
 
-	priv->kar = ioremap(priv->driver_uar.pfn << PAGE_SHIFT, PAGE_SIZE);
+	priv->kar = ioremap((phys_addr_t) priv->driver_uar.pfn << PAGE_SHIFT, PAGE_SIZE);
 	if (!priv->kar) {
 		mlx4_err(dev, "Couldn't map kernel access region, "
 			 "aborting.\n");
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
