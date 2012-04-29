From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 7/7] IB/mlx4: increase the number of vectors (EQs) available for ULPs
Date: Sun, 29 Apr 2012 17:04:27 +0300
Message-ID: <1335708267-30284-8-git-send-email-ogerlitz@mellanox.com>
References: <1335708267-30284-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335708267-30284-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Enable IB ULPs to use a larger portion of the device EQs (which map
to IRQs). The mlx4_ib driver follows the mlx4_core framework of the
EQs to be divided among the device ports. In this scheme, for each IB
port, the number of allocated EQs follows the number of cores, subject
to other system constraints, such as number available MSI-X vectors.

Signed-off-by: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/cq.c      |    3 +
 drivers/infiniband/hw/mlx4/main.c    |   85 ++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx4/mlx4_ib.h |    2 +
 3 files changed, 90 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 34ac0e2..6d4ef71 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -222,6 +222,9 @@ struct ib_cq *mlx4_ib_create_cq(struct ib_device *ibdev, int entries, int vector
 		uar = &dev->priv_uar;
 	}
 
+	if (dev->eq_table)
+		vector = dev->eq_table[vector % ibdev->num_comp_vectors];
+
 	err = mlx4_cq_alloc(dev->dev, entries, &cq->buf.mtt, uar,
 			    cq->db.dma, &cq->mcq, vector, 0);
 	if (err)
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 1a11475..8aa06da 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1071,6 +1071,87 @@ static int mlx4_ib_netdev_event(struct notifier_block *this, unsigned long event
 	return NOTIFY_DONE;
 }
 
+static void mlx4_ib_alloc_eqs(struct mlx4_dev *dev, struct mlx4_ib_dev *ibdev)
+{
+	char name[32];
+	int eq_per_port = 0;
+	int added_eqs = 0;
+	int total_eqs = 0;
+	int i, j, eq;
+
+	/* Init eq table */
+	ibdev->eq_table = NULL;
+	ibdev->eq_added = 0;
+
+	/* Legacy mode ? */
+	if (dev->caps.comp_pool == 0)
+		return;
+
+	eq_per_port = rounddown_pow_of_two(dev->caps.comp_pool/
+					dev->caps.num_ports);
+
+	/* Init eq table */
+	added_eqs = 0;
+	mlx4_foreach_port(i, dev, MLX4_PORT_TYPE_IB)
+		added_eqs += eq_per_port;
+
+	total_eqs = dev->caps.num_comp_vectors + added_eqs;
+
+	ibdev->eq_table = kzalloc(total_eqs * sizeof(int), GFP_KERNEL);
+	if (!ibdev->eq_table)
+		return;
+
+	ibdev->eq_added = added_eqs;
+
+	eq = 0;
+	mlx4_foreach_port(i, dev, MLX4_PORT_TYPE_IB) {
+		for (j = 0; j < eq_per_port; j++) {
+			sprintf(name , "mlx4-ib-%d-%d@%s",
+				i , j, dev->pdev->bus->name);
+			/* Set IRQ for specific name (per ring) */
+			if (mlx4_assign_eq(dev, name, &ibdev->eq_table[eq])) {
+				/* Use legacy (same as mlx4_en driver) */
+				printk(KERN_WARNING
+					"Can't allocate eq revert to legacy\n");
+				ibdev->eq_table[eq] =
+					(eq % dev->caps.num_comp_vectors);
+			}
+			eq++;
+		}
+	}
+
+	/* Fill the reset of the vector with legacy EQ */
+	for (i = 0, eq = added_eqs; i < dev->caps.num_comp_vectors; i++)
+		ibdev->eq_table[eq++] = i;
+
+	/* Adevrtize the new EQ number to clients */
+	ibdev->ib_dev.num_comp_vectors = total_eqs;
+}
+
+static void mlx4_ib_free_eqs(struct mlx4_dev *dev, struct mlx4_ib_dev *ibdev)
+{
+	int i;
+	int total_eqs;
+
+	/* Reset the advertizes EQ number */
+	ibdev->ib_dev.num_comp_vectors = dev->caps.num_comp_vectors;
+
+	/* Free only the added eqs */
+	for (i = 0; i < ibdev->eq_added; i++) {
+		/* Don't free legacy eqs if used */
+		if (ibdev->eq_table[i] <= dev->caps.num_comp_vectors)
+			continue;
+		mlx4_release_eq(dev , ibdev->eq_table[i]);
+	}
+
+	total_eqs = dev->caps.num_comp_vectors + ibdev->eq_added;
+	memset(ibdev->eq_table, 0, total_eqs * sizeof(int));
+	kfree(ibdev->eq_table);
+
+	ibdev->eq_table = NULL;
+	ibdev->eq_added = 0;
+}
+
 static void *mlx4_ib_add(struct mlx4_dev *dev)
 {
 	struct mlx4_ib_dev *ibdev;
@@ -1205,6 +1286,8 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 			(1ull << IB_USER_VERBS_CMD_CLOSE_XRCD);
 	}
 
+	mlx4_ib_alloc_eqs(dev, ibdev);
+
 	spin_lock_init(&iboe->lock);
 
 	if (init_node_data(ibdev))
@@ -1293,6 +1376,8 @@ static void mlx4_ib_remove(struct mlx4_dev *dev, void *ibdev_ptr)
 	mlx4_foreach_port(p, dev, MLX4_PORT_TYPE_IB)
 		mlx4_CLOSE_PORT(dev, p);
 
+	mlx4_ib_free_eqs(dev, ibdev);
+
 	mlx4_uar_free(dev, &ibdev->priv_uar);
 	mlx4_pd_free(dev, ibdev->priv_pdn);
 	ib_dealloc_device(&ibdev->ib_dev);
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index ed80345..9060771 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -202,6 +202,8 @@ struct mlx4_ib_dev {
 	bool			ib_active;
 	struct mlx4_ib_iboe	iboe;
 	int			counters[MLX4_MAX_PORTS];
+	int			*eq_table;
+	int			eq_added;
 };
 
 static inline struct mlx4_ib_dev *to_mdev(struct ib_device *ibdev)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
