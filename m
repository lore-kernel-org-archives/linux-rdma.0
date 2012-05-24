From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/3] IB/mlx4: Fix EQ deallocation under legacy mode
Date: Thu, 24 May 2012 16:08:07 +0300
Message-ID: <1337864889-20886-2-git-send-email-ogerlitz@mellanox.com>
References: <1337864889-20886-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337864889-20886-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Commit e605b743f "IB/mlx4: Increase the number of vectors (EQs) available
for ULPs" didn't handle correctly the case where there aren't enough MSIX
vectors to increase the number of EQs, such that only the legacy EQs are
allocated. This resulted in an attempt to memset to zero the eq table
which was never allocated, and a kernel crash. Fix that by checking in
the teardown flow  if the table of EQs was ever allocated. Also remove
some unneeded setting to zero of the EQ related fields in struct mlx4_ib_dev.

Signed-off-by: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index ee1c577..8afea12 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1084,12 +1084,9 @@ static void mlx4_ib_alloc_eqs(struct mlx4_dev *dev, struct mlx4_ib_dev *ibdev)
 	int total_eqs = 0;
 	int i, j, eq;
 
-	/* Init eq table */
-	ibdev->eq_table = NULL;
-	ibdev->eq_added = 0;
-
-	/* Legacy mode? */
-	if (dev->caps.comp_pool == 0)
+	/* Legacy mode or comp_pool is not large enough */
+	if (dev->caps.comp_pool == 0 ||
+	    dev->caps.num_ports > dev->caps.comp_pool)
 		return;
 
 	eq_per_port = rounddown_pow_of_two(dev->caps.comp_pool/
@@ -1135,7 +1132,10 @@ static void mlx4_ib_alloc_eqs(struct mlx4_dev *dev, struct mlx4_ib_dev *ibdev)
 static void mlx4_ib_free_eqs(struct mlx4_dev *dev, struct mlx4_ib_dev *ibdev)
 {
 	int i;
-	int total_eqs;
+
+	/* no additional eqs were added */
+	if (!ibdev->eq_table)
+		return;
 
 	/* Reset the advertised EQ number */
 	ibdev->ib_dev.num_comp_vectors = dev->caps.num_comp_vectors;
@@ -1148,12 +1148,7 @@ static void mlx4_ib_free_eqs(struct mlx4_dev *dev, struct mlx4_ib_dev *ibdev)
 		mlx4_release_eq(dev, ibdev->eq_table[i]);
 	}
 
-	total_eqs = dev->caps.num_comp_vectors + ibdev->eq_added;
-	memset(ibdev->eq_table, 0, total_eqs * sizeof(int));
 	kfree(ibdev->eq_table);
-
-	ibdev->eq_table = NULL;
-	ibdev->eq_added = 0;
 }
 
 static void *mlx4_ib_add(struct mlx4_dev *dev)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
