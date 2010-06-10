From: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH 17/19 V4] mlx4: Using mcg tables for Ethernet Unicast
	steering.
Date: Thu, 10 Jun 2010 22:08:11 +0300
Message-ID: <4C11381B.90101@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When there are multiple interfaces on the same physical port, the old steering
model (Mac steering) would not work. The reason is in the old model there could be
only one promiscuous QP per port.
With the new mechanism each interface can have promisc entries both for unicast and
multicast. A promisc QP is registered to all entries that belong to the same port and
also for the default entry.
In fw where this feature is not supported, using the Mac table steering.

Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/net/mlx4/cmd.c       |   10 +-
 drivers/net/mlx4/en_netdev.c |   55 ++++-
 drivers/net/mlx4/fw.c        |    3 +
 drivers/net/mlx4/main.c      |   67 +++++-
 drivers/net/mlx4/mcg.c       |  611 ++++++++++++++++++++++++++++++++++++++----
 drivers/net/mlx4/mlx4.h      |   30 ++
 drivers/net/mlx4/mlx4_en.h   |    1 +
 drivers/net/mlx4/port.c      |   91 ++++++-
 include/linux/mlx4/cmd.h     |    1 +
 include/linux/mlx4/device.h  |   12 +-
 10 files changed, 821 insertions(+), 60 deletions(-)

diff --git a/drivers/net/mlx4/cmd.c b/drivers/net/mlx4/cmd.c
index 660d001..7efa85f 100644
--- a/drivers/net/mlx4/cmd.c
+++ b/drivers/net/mlx4/cmd.c
@@ -514,7 +514,7 @@ static int mlx4_RESOURCE_wrapper(struct mlx4_dev *dev, int slave, struct mlx4_vh
 		switch (vhcr->op) {
 		case MLX4_CMD_ALLOC_RES:
 			ret = mlx4_register_mac(dev, vhcr->op_modifier,
-						vhcr->in_param, (int *) &vhcr->out_param);
+						vhcr->in_param, (int *) &vhcr->out_param, 1);
 			vhcr->errno = ret;
 			break;
 		case MLX4_CMD_FREE_RES:
@@ -937,6 +937,14 @@ static struct mlx4_cmd_info {
 		.wrapper = mlx4_MCAST_wrapper
 	},
 	{
+		.opcode = MLX4_CMD_PROMISC,
+		.has_inbox = false,
+		.has_outbox = false,
+		.out_is_imm = false,
+		.verify = NULL,
+		.wrapper = mlx4_PROMISC_wrapper
+	},
+	{
 		.opcode = MLX4_CMD_DIAG_RPRT,
 		.has_inbox = false,
 		.has_outbox = true,
diff --git a/drivers/net/mlx4/en_netdev.c b/drivers/net/mlx4/en_netdev.c
index d171945..6dd47e8 100644
--- a/drivers/net/mlx4/en_netdev.c
+++ b/drivers/net/mlx4/en_netdev.c
@@ -240,8 +240,12 @@ static void mlx4_en_do_set_multicast(struct work_struct *work)
 			priv->flags |= MLX4_EN_FLAG_PROMISC;
 
 			/* Enable promiscouos mode */
-			err = mlx4_SET_PORT_qpn_calc(mdev->dev, priv->port,
-						     priv->base_qpn, 1);
+			if (!mdev->dev->caps.vep_uc_steering)
+				err = mlx4_SET_PORT_qpn_calc(mdev->dev, priv->port,
+							     priv->base_qpn, 1);
+			else
+				err = mlx4_unicast_promisc_add(mdev->dev, priv->base_qpn,
+							       priv->port - 1);
 			if (err)
 				en_err(priv, "Failed enabling "
 					     "promiscous mode\n");
@@ -253,6 +257,15 @@ static void mlx4_en_do_set_multicast(struct work_struct *work)
 				en_err(priv, "Failed disabling "
 					     "multicast filter\n");
 
+			/* Add the default qp number as multicast promisc */
+			if (!(priv->flags & MLX4_EN_FLAG_MC_PROMISC)) {
+				err = mlx4_multicast_promisc_add(mdev->dev, priv->base_qpn,
+								 priv->port - 1);
+				if (err)
+					en_err(priv, "Failed entering multicast promisc mode\n");
+				priv->flags |= MLX4_EN_FLAG_MC_PROMISC;
+			}
+
 			/* Disable port VLAN filter */
 			err = mlx4_SET_VLAN_FLTR(mdev->dev, priv->port, NULL);
 			if (err)
@@ -271,11 +284,24 @@ static void mlx4_en_do_set_multicast(struct work_struct *work)
 		priv->flags &= ~MLX4_EN_FLAG_PROMISC;
 
 		/* Disable promiscouos mode */
-		err = mlx4_SET_PORT_qpn_calc(mdev->dev, priv->port,
-					     priv->base_qpn, 0);
+		if (!mdev->dev->caps.vep_uc_steering)
+			err = mlx4_SET_PORT_qpn_calc(mdev->dev, priv->port,
+						     priv->base_qpn, 0);
+		else
+			err = mlx4_unicast_promisc_remove(mdev->dev, priv->base_qpn,
+							  priv->port - 1);
 		if (err)
 			en_err(priv, "Failed disabling promiscous mode\n");
 
+		/* Disable Multicast promisc */
+		if (priv->flags & MLX4_EN_FLAG_MC_PROMISC) {
+			err = mlx4_multicast_promisc_remove(mdev->dev, priv->base_qpn,
+							    priv->port - 1);
+			if (err)
+				en_err(priv, "Failed disabling multicast promiscous mode\n");
+			priv->flags &= ~MLX4_EN_FLAG_MC_PROMISC;
+		}
+
 		/* Enable port VLAN filter */
 		err = mlx4_SET_VLAN_FLTR(mdev->dev, priv->port, priv->vlgrp);
 		if (err)
@@ -288,9 +314,27 @@ static void mlx4_en_do_set_multicast(struct work_struct *work)
 					  0, MLX4_MCAST_DISABLE);
 		if (err)
 			en_err(priv, "Failed disabling multicast filter\n");
+
+		/* Add the default qp number as multicast promisc */
+		if (!(priv->flags & MLX4_EN_FLAG_MC_PROMISC)) {
+			err = mlx4_multicast_promisc_add(mdev->dev, priv->base_qpn,
+							 priv->port - 1);
+			if (err)
+				en_err(priv, "Failed entering multicast promisc mode\n");
+			priv->flags |= MLX4_EN_FLAG_MC_PROMISC;
+		}
 	} else {
 		int i;
 
+		/* Disable Multicast promisc */
+		if (priv->flags & MLX4_EN_FLAG_MC_PROMISC) {
+			err = mlx4_multicast_promisc_remove(mdev->dev, priv->base_qpn,
+							    priv->port - 1);
+			if (err)
+				en_err(priv, "Failed disabling multicast promiscous mode\n");
+			priv->flags &= ~MLX4_EN_FLAG_MC_PROMISC;
+		}
+
 		err = mlx4_SET_MCAST_FLTR(mdev->dev, priv->port, 0,
 					  0, MLX4_MCAST_DISABLE);
 		if (err)
@@ -328,6 +372,7 @@ static void mlx4_en_do_set_multicast(struct work_struct *work)
 					  0, MLX4_MCAST_ENABLE);
 		if (err)
 			en_err(priv, "Failed enabling multicast filter\n");
+
 	}
 out:
 	mutex_unlock(&mdev->state_lock);
@@ -615,7 +660,7 @@ int mlx4_en_start_port(struct net_device *dev)
 	/* Set port mac number */
 	en_dbg(DRV, priv, "Setting mac for port %d\n", priv->port);
 	err = mlx4_register_mac(mdev->dev, priv->port,
-				priv->mac, &priv->base_qpn);
+				priv->mac, &priv->base_qpn, 0);
 	if (err) {
 		en_err(priv, "Failed setting port mac\n");
 		goto cq_err;
diff --git a/drivers/net/mlx4/fw.c b/drivers/net/mlx4/fw.c
index 773de63..92b2132 100644
--- a/drivers/net/mlx4/fw.c
+++ b/drivers/net/mlx4/fw.c
@@ -854,6 +854,7 @@ int mlx4_INIT_HCA(struct mlx4_dev *dev, struct mlx4_init_hca_param *param)
 #define	 INIT_HCA_MC_BASE_OFFSET	 (INIT_HCA_MCAST_OFFSET + 0x00)
 #define	 INIT_HCA_LOG_MC_ENTRY_SZ_OFFSET (INIT_HCA_MCAST_OFFSET + 0x12)
 #define	 INIT_HCA_LOG_MC_HASH_SZ_OFFSET	 (INIT_HCA_MCAST_OFFSET + 0x16)
+#define  INIT_HCA_UC_STEERING_OFFSET	 (INIT_HCA_MCAST_OFFSET + 0x18)
 #define	 INIT_HCA_LOG_MC_TABLE_SZ_OFFSET (INIT_HCA_MCAST_OFFSET + 0x1b)
 #define INIT_HCA_TPT_OFFSET		 0x0f0
 #define	 INIT_HCA_DMPT_BASE_OFFSET	 (INIT_HCA_TPT_OFFSET + 0x00)
@@ -914,6 +915,8 @@ int mlx4_INIT_HCA(struct mlx4_dev *dev, struct mlx4_init_hca_param *param)
 	MLX4_PUT(inbox, param->mc_base,		INIT_HCA_MC_BASE_OFFSET);
 	MLX4_PUT(inbox, param->log_mc_entry_sz, INIT_HCA_LOG_MC_ENTRY_SZ_OFFSET);
 	MLX4_PUT(inbox, param->log_mc_hash_sz,  INIT_HCA_LOG_MC_HASH_SZ_OFFSET);
+	if (dev->caps.vep_mc_steering)
+		MLX4_PUT(inbox, (u8) (1 << 3),	INIT_HCA_UC_STEERING_OFFSET);
 	MLX4_PUT(inbox, param->log_mc_table_sz, INIT_HCA_LOG_MC_TABLE_SZ_OFFSET);
 
 	/* TPT attributes */
diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index b1eb69e..f7fed9a 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -1180,6 +1180,7 @@ static int mlx4_init_port_info(struct mlx4_dev *dev, int port)
 	info->dev = dev;
 	info->port = port;
 	if (!mlx4_is_slave(dev)) {
+		INIT_RADIX_TREE(&info->mac_tree, GFP_KERNEL);
 		mlx4_init_mac_table(dev, &info->mac_table);
 		mlx4_init_vlan_table(dev, &info->vlan_table);
 		info->base_qpn = dev->caps.reserved_qps_base[MLX4_QP_REGION_ETH_ADDR] +
@@ -1209,6 +1210,58 @@ static void mlx4_cleanup_port_info(struct mlx4_port_info *info)
 	device_remove_file(&info->dev->pdev->dev, &info->port_attr);
 }
 
+static int mlx4_init_steering(struct mlx4_dev *dev)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	int num_entries = max(dev->caps.num_ports, dev->caps.pf_num);
+	int i, j;
+
+	priv->steer = kzalloc(sizeof(struct mlx4_steer) * num_entries, GFP_KERNEL);
+	if (!priv->steer)
+		return -ENOMEM;
+
+	for (i = 0; i < num_entries; i++) {
+		for (j = 0; j < MLX4_NUM_STEERS; j++) {
+			INIT_LIST_HEAD(&priv->steer[i].promisc_qps[j]);
+			INIT_LIST_HEAD(&priv->steer[i].steer_entries[j]);
+		}
+	}
+	return 0;
+}
+
+static void mlx4_clear_steering(struct mlx4_dev *dev)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	struct mlx4_steer_index *entry, *tmp_entry;
+	struct mlx4_promisc_qp *pqp, *tmp_pqp;
+	int num_entries = max(dev->caps.num_ports, dev->caps.pf_num);
+	int i, j;
+
+	for (i = 0; i < num_entries; i++) {
+		for (j = 0; j < MLX4_NUM_STEERS; j++) {
+			list_for_each_entry_safe(pqp, tmp_pqp,
+						 &priv->steer[i].promisc_qps[j],
+						 list) {
+				list_del(&pqp->list);
+				kfree(pqp);
+			}
+			list_for_each_entry_safe(entry, tmp_entry,
+						 &priv->steer[i].steer_entries[j],
+						 list) {
+				list_del(&entry->list);
+				list_for_each_entry_safe(pqp, tmp_pqp,
+							 &entry->duplicates,
+							 list) {
+					list_del(&pqp->list);
+					kfree(pqp);
+				}
+				kfree(entry);
+			}
+		}
+	}
+	kfree(priv->steer);
+}
+
 static int __mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct mlx4_priv *priv;
@@ -1386,6 +1439,12 @@ slave_start:
 		goto err_free_eq;
 	}
 
+	if (!mlx4_is_slave(dev)) {
+		err = mlx4_init_steering(dev);
+		if (err)
+			goto err_free_eq;
+	}
+
 	err = mlx4_setup_hca(dev);
 	if (err == -EBUSY && (dev->flags & MLX4_FLAG_MSI_X) && !mlx4_is_slave(dev)) {
 		dev->flags &= ~MLX4_FLAG_MSI_X;
@@ -1394,7 +1453,7 @@ slave_start:
 	}
 
 	if (err)
-		goto err_free_eq;
+		goto err_steer;
 
 	for (port = 1; port <= dev->caps.num_ports; port++) {
 		err = mlx4_init_port_info(dev, port);
@@ -1434,6 +1493,10 @@ err_port:
 	mlx4_cleanup_pd_table(dev);
 	mlx4_cleanup_uar_table(dev);
 
+err_steer:
+	if (!mlx4_is_slave(dev))
+		mlx4_clear_steering(dev);
+
 err_free_eq:
 	mlx4_free_eq_table(dev);
 
@@ -1510,6 +1573,8 @@ static void mlx4_remove_one(struct pci_dev *pdev)
 		iounmap(priv->kar);
 		mlx4_uar_free(dev, &priv->driver_uar);
 		mlx4_cleanup_uar_table(dev);
+		if (!mlx4_is_slave(dev))
+			mlx4_clear_steering(dev);
 		mlx4_free_eq_table(dev);
 		mlx4_close_hca(dev);
 		if (mlx4_is_mfunc(dev))
diff --git a/drivers/net/mlx4/mcg.c b/drivers/net/mlx4/mcg.c
index e3dc486..e1dcd86 100644
--- a/drivers/net/mlx4/mcg.c
+++ b/drivers/net/mlx4/mcg.c
@@ -50,28 +50,35 @@ struct mlx4_mgm {
 
 static const u8 zero_gid[16];	/* automatically initialized to 0 */
 
-static int mlx4_READ_MCG(struct mlx4_dev *dev, int index,
-			 struct mlx4_cmd_mailbox *mailbox)
+static int mlx4_READ_ENTRY(struct mlx4_dev *dev, int index,
+			   struct mlx4_cmd_mailbox *mailbox)
 {
-	return mlx4_cmd_box(dev, 0, mailbox->dma, index, 0, MLX4_CMD_READ_MCG,
-			    MLX4_CMD_TIME_CLASS_A);
+	return mlx4_cmd_box(dev, 0, mailbox->dma, index, 0,
+			    MLX4_CMD_READ_MCG, MLX4_CMD_TIME_CLASS_A);
 }
 
-static int mlx4_WRITE_MCG(struct mlx4_dev *dev, int index,
-			  struct mlx4_cmd_mailbox *mailbox)
+static int mlx4_WRITE_ENTRY(struct mlx4_dev *dev, int index,
+			    struct mlx4_cmd_mailbox *mailbox)
 {
-	return mlx4_cmd(dev, mailbox->dma, index, 0, MLX4_CMD_WRITE_MCG,
-			MLX4_CMD_TIME_CLASS_A);
+	return mlx4_cmd(dev, mailbox->dma, index, 0,
+			MLX4_CMD_WRITE_MCG, MLX4_CMD_TIME_CLASS_A);
 }
 
-static int mlx4_MGID_HASH(struct mlx4_dev *dev, struct mlx4_cmd_mailbox *mailbox,
-			  u16 *hash, u8 op_mod)
+static int mlx4_WRITE_PROMISC(struct mlx4_dev *dev,
+			      struct mlx4_cmd_mailbox *mailbox)
+{
+	return mlx4_cmd(dev, mailbox->dma, 0, 0x2,
+			MLX4_CMD_WRITE_MCG, MLX4_CMD_TIME_CLASS_A);
+}
+
+static int mlx4_GID_HASH(struct mlx4_dev *dev, struct mlx4_cmd_mailbox *mailbox,
+			 u16 *hash, u8 op_mod)
 {
 	u64 imm;
 	int err;
 
-	err = mlx4_cmd_imm(dev, mailbox->dma, &imm, 0, op_mod, MLX4_CMD_MGID_HASH,
-			   MLX4_CMD_TIME_CLASS_A);
+	err = mlx4_cmd_imm(dev, mailbox->dma, &imm, 0, op_mod,
+			   MLX4_CMD_MGID_HASH, MLX4_CMD_TIME_CLASS_A);
 
 	if (!err)
 		*hash = imm;
@@ -80,6 +87,425 @@ static int mlx4_MGID_HASH(struct mlx4_dev *dev, struct mlx4_cmd_mailbox *mailbox
 }
 
 /*
+ * Helper functions to manage multifunction steering data structures.
+ * Used only for Ethernet steering.
+ */
+
+static struct mlx4_promisc_qp *get_promisc_qp(struct mlx4_dev *dev, u8 pf_num,
+					      enum mlx4_steer_type steer,
+					      u32 qpn)
+{
+	struct mlx4_steer *s_steer = &mlx4_priv(dev)->steer[pf_num];
+	struct mlx4_promisc_qp *pqp;
+
+	list_for_each_entry(pqp, &s_steer->promisc_qps[steer], list) {
+		if (pqp->qpn == qpn)
+			return pqp;
+	}
+	/* not found */
+	return NULL;
+}
+
+/*
+ * Add new entry to steering data structure.
+ * All promisc QPs should be added as well
+ */
+static int new_steering_entry(struct mlx4_dev *dev, u8 pf_num,
+			      enum mlx4_steer_type steer,
+			      unsigned int index, u32 qpn)
+{
+	struct mlx4_steer *s_steer = &mlx4_priv(dev)->steer[pf_num];
+	struct mlx4_cmd_mailbox *mailbox;
+	struct mlx4_mgm *mgm;
+	u32 members_count;
+	struct mlx4_steer_index *new_entry;
+	struct mlx4_promisc_qp *pqp;
+	struct mlx4_promisc_qp *dqp;
+	u32 prot;
+	int err;
+
+	new_entry = kzalloc(sizeof *new_entry, GFP_KERNEL);
+	if (!new_entry)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&new_entry->duplicates);
+	new_entry->index = index;
+	list_add_tail(&new_entry->list, &s_steer->steer_entries[steer]);
+
+	/* If the given qpn is also a promisc qp,
+	 * it should be inserted to duplicates list
+	 */
+	pqp = get_promisc_qp(dev, pf_num, steer, qpn);
+	if (pqp) {
+		dqp = kmalloc(sizeof *dqp, GFP_KERNEL);
+		if (!dqp) {
+			err = -ENOMEM;
+			goto out_alloc;
+		}
+		dqp->qpn = qpn;
+		list_add_tail(&pqp->list, &new_entry->duplicates);
+	}
+
+	/* if no promisc qps for this vep, we are done */
+	if (list_empty(&s_steer->promisc_qps[steer]))
+		return 0;
+
+	/* now need to add all the promisc qps to the new
+	 * steering entry, as they should also receive the packets
+	 * destined to this address */
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox)) {
+		err = -ENOMEM;
+		goto out_alloc;
+	}
+	mgm = mailbox->buf;
+
+	err = mlx4_READ_ENTRY(dev, index, mailbox);
+	if (err)
+		goto out_mailbox;
+
+	members_count = be32_to_cpu(mgm->members_count) & 0xffffff;
+	prot = be32_to_cpu(mgm->members_count) >> 30;
+	list_for_each_entry(pqp, &s_steer->promisc_qps[steer], list) {
+		/* don't add already existing qpn */
+		if (pqp->qpn == qpn)
+			continue;
+		if (members_count == MLX4_QP_PER_MGM) {
+			/* out of space */
+			err = -ENOMEM;
+			goto out_mailbox;
+		}
+
+		/* add the qpn */
+		mgm->qp[members_count++] = cpu_to_be32(pqp->qpn & MGM_QPN_MASK);
+	}
+	/* update the qps count and update the entry with all the promisc qps*/
+	mgm->members_count = cpu_to_be32(members_count | (prot << 30));
+	err = mlx4_WRITE_ENTRY(dev, index, mailbox);
+
+out_mailbox:
+	mlx4_free_cmd_mailbox(dev, mailbox);
+	if (!err)
+		return 0;
+out_alloc:
+	if (dqp) {
+		list_del(&dqp->list);
+		kfree(&dqp);
+	}
+	list_del(&new_entry->list);
+	kfree(new_entry);
+	return err;
+}
+
+/* update the data structures with existing steering entry */
+static int existing_steering_entry(struct mlx4_dev *dev, u8 pf_num,
+				   enum mlx4_steer_type steer,
+				   unsigned int index, u32 qpn)
+{
+	struct mlx4_steer *s_steer = &mlx4_priv(dev)->steer[pf_num];
+	struct mlx4_steer_index *tmp_entry, *entry = NULL;
+	struct mlx4_promisc_qp *pqp;
+	struct mlx4_promisc_qp *dqp;
+
+	pqp = get_promisc_qp(dev, pf_num, steer, qpn);
+	if (!pqp)
+		return 0; /* nothing to do */
+
+	list_for_each_entry(tmp_entry, &s_steer->steer_entries[steer], list) {
+		if (tmp_entry->index == entry->index) {
+			entry = tmp_entry;
+			break;
+		}
+	}
+	if (unlikely(!entry)) {
+		mlx4_warn(dev, "Steering entry at index %x is not registered\n", index);
+		return -EINVAL;
+	}
+
+	/* the given qpn is listed as a promisc qpn
+	 * we need to add it as a duplicate to this entry
+	 * for future refernce */
+	list_for_each_entry(dqp, &entry->duplicates, list) {
+		if (dqp->qpn == pqp->qpn)
+			return 0; /* qp is already duplicated */
+	}
+
+	/* add the qp as a duplicate on this index */
+	dqp = kmalloc(sizeof *dqp, GFP_KERNEL);
+	if (!dqp)
+		return -ENOMEM;
+	dqp->qpn = qpn;
+	list_add_tail(&pqp->list, &entry->duplicates);
+
+	return 0;
+}
+
+/* Check whether a qpn is a duplicate on steering entry
+ * If so, it should not be removed from mgm */
+static bool check_duplicate_entry(struct mlx4_dev *dev, u8 pf_num,
+				  enum mlx4_steer_type steer,
+				  unsigned int index, u32 qpn)
+{
+	struct mlx4_steer *s_steer = &mlx4_priv(dev)->steer[pf_num];
+	struct mlx4_steer_index *tmp_entry, *entry = NULL;
+	struct mlx4_promisc_qp *dqp, *tmp_dqp;
+
+	/* if qp is not promisc, it cannot be duplicated */
+	if (!get_promisc_qp(dev, pf_num, steer, qpn))
+		return false;
+
+	/* The qp is promisc qp so it is a duplicate on this index
+	 * Find the index entry, and remove the duplicate */
+	list_for_each_entry(tmp_entry, &s_steer->steer_entries[steer], list) {
+		if (tmp_entry->index == index) {
+			entry = tmp_entry;
+			break;
+		}
+	}
+	if (unlikely(!entry)) {
+		mlx4_warn(dev, "Steering entry for index %x is not registered\n", index);
+		return false;
+	}
+	list_for_each_entry_safe(dqp, tmp_dqp, &entry->duplicates, list) {
+		if (dqp->qpn == qpn) {
+			list_del(&dqp->list);
+			kfree(dqp);
+		}
+	}
+	return true;
+}
+
+/* I a steering entry contains only promisc QPs, it can be removed. */
+static bool can_remove_steering_entry(struct mlx4_dev *dev, u8 pf_num,
+				      enum mlx4_steer_type steer,
+				      unsigned int index, u32 tqpn)
+{
+	struct mlx4_steer *s_steer = &mlx4_priv(dev)->steer[pf_num];
+	struct mlx4_cmd_mailbox *mailbox;
+	struct mlx4_mgm *mgm;
+	struct mlx4_steer_index *entry = NULL, *tmp_entry;
+	u32 qpn;
+	u32 members_count;
+	bool ret = false;
+	int i;
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox))
+		return false;
+	mgm = mailbox->buf;
+
+	if (mlx4_READ_ENTRY(dev, index, mailbox))
+		goto out;
+	members_count = be32_to_cpu(mgm->members_count) & 0xffffff;
+	for (i = 0;  i < members_count; i++) {
+		qpn = be32_to_cpu(mgm->qp[i]) & MGM_QPN_MASK;
+		if (!get_promisc_qp(dev, pf_num, steer, qpn) && qpn != tqpn) {
+			/* the qp is not promisc, the entry can't be removed */
+			goto out;
+		}
+	}
+	 /* All the qps currently registered for this entry are promiscuous,
+	  * it can be removed */
+	ret = true;
+	list_for_each_entry_safe(entry, tmp_entry, &s_steer->steer_entries[steer], list) {
+		if (entry->index == index) {
+			list_del(&entry->list);
+			kfree(entry);
+		}
+	}
+
+out:
+	mlx4_free_cmd_mailbox(dev, mailbox);
+	return ret;
+}
+
+
+static int add_promisc_qp(struct mlx4_dev *dev, u8 pf_num,
+			  enum mlx4_steer_type steer, u32 qpn)
+{
+	struct mlx4_steer *s_steer = &mlx4_priv(dev)->steer[pf_num];
+	struct mlx4_cmd_mailbox *mailbox;
+	struct mlx4_mgm *mgm;
+	struct mlx4_steer_index *entry;
+	struct mlx4_promisc_qp *pqp;
+	struct mlx4_promisc_qp *dqp;
+	u32 members_count;
+	u32 prot;
+	int i;
+	bool found;
+	int last_index;
+	int err;
+
+	if (get_promisc_qp(dev, pf_num, steer, qpn))
+		return 0; /* Noting to do, already exists */
+
+	pqp = kmalloc(sizeof *pqp, GFP_KERNEL);
+	if (!pqp)
+		return -ENOMEM;
+	pqp->qpn = qpn;
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox)) {
+		err = -ENOMEM;
+		goto out_alloc;
+	}
+	mgm = mailbox->buf;
+
+	/* the promisc qp needs to be added for each one of the steering
+	 * entries, if it already exists, needs to be added as a duplicate
+	 * for this entry */
+	list_for_each_entry(entry, &s_steer->steer_entries[steer], list) {
+		err = mlx4_READ_ENTRY(dev, entry->index, mailbox);
+		if (err)
+			goto out_mailbox;
+
+		members_count = be32_to_cpu(mgm->members_count) & 0xffffff;
+		prot = be32_to_cpu(mgm->members_count) >> 30;
+		found = false;
+		for (i = 0; i < members_count; i++) {
+			if ((be32_to_cpu(mgm->qp[i]) & MGM_QPN_MASK) == qpn) {
+				/* Entry already exists, add to duplicates */
+				dqp = kmalloc(sizeof *dqp, GFP_KERNEL);
+				if (!dqp)
+					goto out_mailbox;
+				dqp->qpn = qpn;
+				list_add_tail(&dqp->list, &entry->duplicates);
+				found = true;
+			}
+		}
+		if (!found) {
+			/* Need to add the qpn to mgm */
+			if (members_count == MLX4_QP_PER_MGM) {
+				/* entry is full */
+				err = -ENOMEM;
+				goto out_mailbox;
+			}
+			mgm->qp[members_count++] = cpu_to_be32(qpn & MGM_QPN_MASK);
+			mgm->members_count = cpu_to_be32(members_count | (prot << 30));
+			err = mlx4_WRITE_ENTRY(dev, entry->index, mailbox);
+			if (err)
+				goto out_mailbox;
+		}
+		last_index = entry->index;
+	}
+
+	/* add the new qpn to list of promisc qps */
+	list_add_tail(&pqp->list, &s_steer->promisc_qps[steer]);
+	/* now need to add all the promisc qps to default entry */
+	memset(mgm, 0, sizeof *mgm);
+	mgm->gid[7] = pf_num << 4;
+	mgm->next_gid_index = cpu_to_be32(1 << 4);
+	members_count = 0;
+	list_for_each_entry(dqp, &s_steer->promisc_qps[steer], list)
+		mgm->qp[members_count++] = cpu_to_be32(dqp->qpn & MGM_QPN_MASK);
+	mgm->members_count = cpu_to_be32(members_count | MLX4_PROT_ETH << 30);
+
+	err = mlx4_WRITE_PROMISC(dev, mailbox);
+	if (err)
+		goto out_list;
+
+	mlx4_free_cmd_mailbox(dev, mailbox);
+	return 0;
+
+out_list:
+	list_del(&pqp->list);
+out_mailbox:
+	/* TODO: undo partial addition of promisc qps */
+	mlx4_free_cmd_mailbox(dev, mailbox);
+out_alloc:
+	kfree(pqp);
+	return err;
+}
+
+static int remove_promisc_qp(struct mlx4_dev *dev, u8 pf_num,
+			     enum mlx4_steer_type steer, u32 qpn)
+{
+	struct mlx4_steer *s_steer = &mlx4_priv(dev)->steer[pf_num];
+	struct mlx4_cmd_mailbox *mailbox;
+	struct mlx4_mgm *mgm;
+	struct mlx4_steer_index *entry;
+	struct mlx4_promisc_qp *pqp;
+	struct mlx4_promisc_qp *dqp;
+	u32 members_count;
+	bool found;
+	bool back_to_list = false;
+	int loc, i;
+	int err;
+
+	pqp = get_promisc_qp(dev, pf_num, steer, qpn);
+	if (unlikely(!pqp)) {
+		mlx4_warn(dev, "QP %x is not promiscuous QP\n", qpn);
+		/* nothing to do */
+		return 0;
+	}
+
+	/*remove from list of promisc qps */
+	list_del(&pqp->list);
+	kfree(pqp);
+
+	/* set the default entry not to include the removed one */
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox)) {
+		err = -ENOMEM;
+		back_to_list = true;
+		goto out_list;
+	}
+	mgm = mailbox->buf;
+	mgm->gid[7] = pf_num << 4;
+	mgm->next_gid_index = cpu_to_be32(1 << 4);
+	members_count = 0;
+	list_for_each_entry(dqp, &s_steer->promisc_qps[steer], list)
+		mgm->qp[members_count++] = cpu_to_be32(dqp->qpn & MGM_QPN_MASK);
+	mgm->members_count = cpu_to_be32(members_count | MLX4_PROT_ETH << 30);
+
+	err = mlx4_WRITE_PROMISC(dev,mailbox);
+	if (err)
+		goto out_mailbox;
+
+	/* remove the qp from all the steering entries*/
+	list_for_each_entry(entry, &s_steer->steer_entries[steer], list) {
+		found = false;
+		list_for_each_entry(dqp, &entry->duplicates, list) {
+			if (dqp->qpn == qpn) {
+				found = true;
+				break;
+			}
+		}
+		if (found) {
+			/* a duplicate, no need to change the mgm,
+			 * only update the duplicates list */
+			list_del(&dqp->list);
+			kfree(dqp);
+		} else {
+			err = mlx4_READ_ENTRY(dev, entry->index, mailbox);
+				if (err)
+					goto out_mailbox;
+			members_count = be32_to_cpu(mgm->members_count) & 0xffffff;
+			for (loc = -1, i = 0; i < members_count; ++i)
+				if ((be32_to_cpu(mgm->qp[i]) & MGM_QPN_MASK) == qpn)
+					loc = i;
+
+			mgm->members_count = cpu_to_be32(--members_count |
+							 (MLX4_PROT_ETH << 30));
+			mgm->qp[loc] = mgm->qp[i - 1];
+			mgm->qp[i - 1] = 0;
+
+			err = mlx4_WRITE_ENTRY(dev, entry->index, mailbox);
+				if (err)
+					goto out_mailbox;
+		}
+
+	}
+
+out_mailbox:
+	mlx4_free_cmd_mailbox(dev, mailbox);
+out_list:
+	if (back_to_list)
+		list_add_tail(&pqp->list, &s_steer->promisc_qps[steer]);
+	return err;
+}
+
+/*
  * Caller must hold MCG table semaphore.  gid and mgm parameters must
  * be properly aligned for command interface.
  *
@@ -94,10 +520,11 @@ static int mlx4_MGID_HASH(struct mlx4_dev *dev, struct mlx4_cmd_mailbox *mailbox
  * If no AMGM exists for given gid, *index = -1, *prev = index of last
  * entry in hash chain and *mgm holds end of hash chain.
  */
-static int find_mgm(struct mlx4_dev *dev,
-		    u8 *gid, enum mlx4_protocol prot,
-		    struct mlx4_cmd_mailbox *mgm_mailbox,
-		    u16 *hash, int *prev, int *index)
+static int find_entry(struct mlx4_dev *dev,
+		      u8 *gid, enum mlx4_protocol prot,
+		      enum mlx4_steer_type steer,
+		      struct mlx4_cmd_mailbox *mgm_mailbox,
+		      u16 *hash, int *prev, int *index)
 {
 	struct mlx4_cmd_mailbox *mailbox;
 	struct mlx4_mgm *mgm = mgm_mailbox->buf;
@@ -112,7 +539,7 @@ static int find_mgm(struct mlx4_dev *dev,
 
 	memcpy(mgid, gid, 16);
 
-	err = mlx4_MGID_HASH(dev, mailbox, hash, op_mod);
+	err = mlx4_GID_HASH(dev, mailbox, hash, op_mod);
 	mlx4_free_cmd_mailbox(dev, mailbox);
 	if (err)
 		return err;
@@ -124,7 +551,7 @@ static int find_mgm(struct mlx4_dev *dev,
 	*prev  = -1;
 
 	do {
-		err = mlx4_READ_MCG(dev, *index, mgm_mailbox);
+		err = mlx4_READ_ENTRY(dev, *index, mgm_mailbox);
 		if (err)
 			return err;
 
@@ -148,10 +575,9 @@ static int find_mgm(struct mlx4_dev *dev,
 	return err;
 }
 
-static int mlx4_multicast_attach_common(struct mlx4_dev *dev,
-					struct mlx4_qp *qp, u8 gid[16],
-					int block_mcast_loopback,
-					enum mlx4_protocol prot)
+int mlx4_qp_attach_common(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
+			  int block_mcast_loopback, enum mlx4_protocol prot,
+			  enum mlx4_steer_type steer)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	struct mlx4_cmd_mailbox *mailbox;
@@ -162,6 +588,8 @@ static int mlx4_multicast_attach_common(struct mlx4_dev *dev,
 	int link = 0;
 	int i;
 	int err;
+	u8 pf_num = gid[7] >> 4;
+	u8 new_entry = 0;
 
 	mailbox = mlx4_alloc_cmd_mailbox(dev);
 	if (IS_ERR(mailbox))
@@ -170,13 +598,15 @@ static int mlx4_multicast_attach_common(struct mlx4_dev *dev,
 
 	mutex_lock(&priv->mcg_table.mutex);
 
-	err = find_mgm(dev, gid, prot, mailbox, &hash, &prev, &index);
+	err = find_entry(dev, gid, prot, steer, mailbox, &hash, &prev, &index);
 	if (err)
 		goto out;
 
 	if (index != -1) {
-		if (!memcmp(mgm->gid, zero_gid, 16))
+		if (!memcmp(mgm->gid, zero_gid, 16)) {
+			new_entry = 1;
 			memcpy(mgm->gid, gid, 16);
+		}
 	} else {
 		link = 1;
 
@@ -215,25 +645,32 @@ static int mlx4_multicast_attach_common(struct mlx4_dev *dev,
 	mgm->members_count       = cpu_to_be32(members_count | ((u32) prot << 30));
 	mgm->next_gid_index	 = cpu_to_be32(!!(dev->caps.vep_mc_steering) << 4);
 
-	err = mlx4_WRITE_MCG(dev, index, mailbox);
+	err = mlx4_WRITE_ENTRY(dev, index, mailbox);
 	if (err)
 		goto out;
 
 	if (!link)
 		goto out;
 
-	err = mlx4_READ_MCG(dev, prev, mailbox);
+	err = mlx4_READ_ENTRY(dev, prev, mailbox);
 	if (err)
 		goto out;
 
 	mgm->next_gid_index = cpu_to_be32((index << 6) |
 					  (!!(dev->caps.vep_mc_steering) << 4));
 
-	err = mlx4_WRITE_MCG(dev, prev, mailbox);
+	err = mlx4_WRITE_ENTRY(dev, prev, mailbox);
 	if (err)
 		goto out;
 
 out:
+	if (!err && prot == MLX4_PROT_ETH) {
+		/* manage the steering entry for promisc mode */
+		if (new_entry)
+			new_steering_entry(dev, pf_num, steer, index, qp->qpn);
+		else
+			existing_steering_entry(dev, pf_num, steer, index, qp->qpn);
+	}
 	if (err && link && index != -1) {
 		if (index < dev->caps.num_mgms)
 			mlx4_warn(dev, "Got AMGM index %d < %d",
@@ -248,9 +685,9 @@ out:
 	return err;
 }
 
-static int mlx4_multicast_detach_common(struct mlx4_dev *dev,
-					struct mlx4_qp *qp, u8 gid[16],
-					enum mlx4_protocol prot)
+int mlx4_qp_detach_common(struct mlx4_dev *dev, struct mlx4_qp *qp,
+				 u8 gid[16], enum mlx4_protocol prot,
+				 enum mlx4_steer_type steer)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	struct mlx4_cmd_mailbox *mailbox;
@@ -269,7 +706,7 @@ static int mlx4_multicast_detach_common(struct mlx4_dev *dev,
 
 	mutex_lock(&priv->mcg_table.mutex);
 
-	err = find_mgm(dev, gid, prot, mailbox, &hash, &prev, &index);
+	err = find_entry(dev, gid, prot, steer, mailbox, &hash, &prev, &index);
 	if (err)
 		goto out;
 
@@ -279,6 +716,11 @@ static int mlx4_multicast_detach_common(struct mlx4_dev *dev,
 		goto out;
 	}
 
+	/* if this qp is also a promisc qp, it shouldn't be removed */
+	if (prot == MLX4_PROT_ETH &&
+	    check_duplicate_entry(dev, pf_num, steer, index, qp->qpn))
+		goto out;
+
 	members_count = be32_to_cpu(mgm->members_count);
 	for (loc = -1, i = 0; i < members_count; ++i)
 		if ((be32_to_cpu(mgm->qp[i]) & MGM_QPN_MASK) == qp->qpn)
@@ -295,8 +737,8 @@ static int mlx4_multicast_detach_common(struct mlx4_dev *dev,
 	mgm->qp[loc]       = mgm->qp[i - 1];
 	mgm->qp[i - 1]     = 0;
 
-	if (i != 1) {
-		err = mlx4_WRITE_MCG(dev, index, mailbox);
+	if (!can_remove_steering_entry(dev, pf_num, steer, index, qp->qpn) && i != 1) {
+		err = mlx4_WRITE_ENTRY(dev, index, mailbox);
 		goto out;
 	}
 
@@ -304,16 +746,13 @@ static int mlx4_multicast_detach_common(struct mlx4_dev *dev,
 		/* Remove entry from MGM */
 		int amgm_index = be32_to_cpu(mgm->next_gid_index) >> 6;
 		if (amgm_index) {
-			err = mlx4_READ_MCG(dev, amgm_index, mailbox);
+			err = mlx4_READ_ENTRY(dev, amgm_index, mailbox);
 			if (err)
 				goto out;
-		} else {
+		} else
 			memset(mgm->gid, 0, 16);
-			if (prot == MLX4_PROT_ETH)
-				mgm->gid[7] = pf_num << 4;
-		}
 
-		err = mlx4_WRITE_MCG(dev, index, mailbox);
+		err = mlx4_WRITE_ENTRY(dev, index, mailbox);
 		if (err)
 			goto out;
 
@@ -328,13 +767,13 @@ static int mlx4_multicast_detach_common(struct mlx4_dev *dev,
 	} else {
 		/* Remove entry from AMGM */
 		int cur_next_index = be32_to_cpu(mgm->next_gid_index);
-		err = mlx4_READ_MCG(dev, prev, mailbox);
+		err = mlx4_READ_ENTRY(dev, prev, mailbox);
 		if (err)
 			goto out;
 
 		mgm->next_gid_index = cpu_to_be32(cur_next_index);
 
-		err = mlx4_WRITE_MCG(dev, prev, mailbox);
+		err = mlx4_WRITE_ENTRY(dev, prev, mailbox);
 		if (err)
 			goto out;
 
@@ -360,16 +799,17 @@ int mlx4_MCAST_wrapper(struct mlx4_dev *dev, int slave, struct mlx4_vhcr *vhcr,
 	struct mlx4_qp qp; /* dummy for calling attach/detach */
 	u8 *gid = inbox->buf;
 	enum mlx4_protocol prot = (vhcr->in_modifier >> 28) & 0x7;
+	u8 pf_num = mlx4_priv(dev)->mfunc.master.slave_state[slave].pf_num;
 
 	if (prot == MLX4_PROT_ETH)
-		gid[7] |= slave << 4;
+		gid[7] |= (pf_num << 4 | MLX4_MC_STEER << 1);
 
 	qp.qpn = vhcr->in_modifier & 0xffffff;
 	if (vhcr->op_modifier)
-		return mlx4_multicast_attach_common(dev, &qp, gid,
-					     vhcr->in_modifier >> 31, prot);
+		return mlx4_qp_attach_common(dev, &qp, gid, vhcr->in_modifier >> 31,
+					     prot, MLX4_MC_STEER);
 	else
-		return mlx4_multicast_detach_common(dev, &qp, gid, prot);
+		return mlx4_qp_detach_common(dev, &qp, gid, prot, MLX4_MC_STEER);
 }
 
 static int mlx4_MCAST(struct mlx4_dev *dev, struct mlx4_qp *qp,
@@ -410,10 +850,11 @@ int mlx4_multicast_attach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
 		return mlx4_MCAST(dev, qp, gid, 1, block_mcast_loopback, prot);
 
 	if (mlx4_is_master(dev) && prot == MLX4_PROT_ETH)
-		gid[7] |= dev->caps.function << 4;
+		gid[7] |= (dev->caps.function << 4 | MLX4_MC_STEER << 1);
 
-	return mlx4_multicast_attach_common(dev, qp, gid,
-					    block_mcast_loopback, prot);
+	return mlx4_qp_attach_common(dev, qp, gid,
+				     block_mcast_loopback, prot,
+				     MLX4_MC_STEER);
 }
 EXPORT_SYMBOL_GPL(mlx4_multicast_attach);
 
@@ -427,12 +868,82 @@ int mlx4_multicast_detach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
 		return mlx4_MCAST(dev, qp, gid, 0, 0, prot);
 
 	if (mlx4_is_master(dev) && prot == MLX4_PROT_ETH)
-		gid[7] |= dev->caps.function << 4;
+		gid[7] |= (dev->caps.function << 4 | MLX4_MC_STEER << 1);
 
-	return mlx4_multicast_detach_common(dev, qp, gid, prot);
+	return mlx4_qp_detach_common(dev, qp, gid, prot, MLX4_MC_STEER);
 }
 EXPORT_SYMBOL_GPL(mlx4_multicast_detach);
 
+int mlx4_PROMISC_wrapper(struct mlx4_dev *dev, int slave,
+			 struct mlx4_vhcr *vhcr,
+			 struct mlx4_cmd_mailbox *inbox,
+			 struct mlx4_cmd_mailbox *outbox)
+{
+	u8 pf_num = mlx4_priv(dev)->mfunc.master.slave_state[slave].pf_num;
+	u32 qpn = (u32) vhcr->in_param & 0xffffffff;
+	u8 port = vhcr->in_param >> 63;
+	enum mlx4_steer_type steer = vhcr->in_modifier;
+	if (vhcr->op_modifier)
+		return add_promisc_qp(dev, pf_num | port, steer, qpn);
+	else
+		return remove_promisc_qp(dev, pf_num | port, steer, qpn);
+}
+
+static int mlx4_PROMISC(struct mlx4_dev *dev, u32 qpn,
+			enum mlx4_steer_type steer, u8 add, u8 port)
+{
+	return mlx4_cmd(dev, (u64) qpn | (u64) port << 63, (u32) steer, add,
+			MLX4_CMD_PROMISC, MLX4_CMD_TIME_CLASS_A);
+}
+
+int mlx4_multicast_promisc_add(struct mlx4_dev *dev, u32 qpn, u8 port)
+{
+	if (!dev->caps.vep_mc_steering)
+		return 0;
+
+	if (mlx4_is_slave(dev))
+		return mlx4_PROMISC(dev, qpn, MLX4_MC_STEER, 1, port);
+
+	return add_promisc_qp(dev, dev->caps.function | port, MLX4_MC_STEER, qpn);
+}
+EXPORT_SYMBOL_GPL(mlx4_multicast_promisc_add);
+
+int mlx4_multicast_promisc_remove(struct mlx4_dev *dev, u32 qpn, u8 port)
+{
+	if (!dev->caps.vep_mc_steering)
+		return 0;
+
+	if (mlx4_is_slave(dev))
+		return mlx4_PROMISC(dev, qpn, MLX4_MC_STEER, 0, port);
+
+	return remove_promisc_qp(dev, dev->caps.function | port, MLX4_MC_STEER, qpn);
+}
+EXPORT_SYMBOL_GPL(mlx4_multicast_promisc_remove);
+
+int mlx4_unicast_promisc_add(struct mlx4_dev *dev, u32 qpn, u8 port)
+{
+	if (!dev->caps.vep_mc_steering)
+		return 0;
+
+	if (mlx4_is_slave(dev))
+		return mlx4_PROMISC(dev, qpn, MLX4_UC_STEER, 1, port);
+
+	return add_promisc_qp(dev, dev->caps.function | port, MLX4_UC_STEER, qpn);
+}
+EXPORT_SYMBOL_GPL(mlx4_unicast_promisc_add);
+
+int mlx4_unicast_promisc_remove(struct mlx4_dev *dev, u32 qpn, u8 port)
+{
+	if (!dev->caps.vep_mc_steering)
+		return 0;
+
+	if (mlx4_is_slave(dev))
+		return mlx4_PROMISC(dev, qpn, MLX4_UC_STEER, 0, port);
+
+	return remove_promisc_qp(dev, dev->caps.function | port, MLX4_UC_STEER, qpn);
+}
+EXPORT_SYMBOL_GPL(mlx4_unicast_promisc_remove);
+
 int mlx4_init_mcg_table(struct mlx4_dev *dev)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
diff --git a/drivers/net/mlx4/mlx4.h b/drivers/net/mlx4/mlx4.h
index d722467..8530032 100644
--- a/drivers/net/mlx4/mlx4.h
+++ b/drivers/net/mlx4/mlx4.h
@@ -234,6 +234,17 @@ struct mlx4_vlan_fltr {
 	__be32 entry[VLAN_FLTR_SIZE];
 };
 
+struct mlx4_promisc_qp {
+	struct list_head list;
+	u32 qpn;
+};
+
+struct mlx4_steer_index {
+	struct list_head list;
+	unsigned int index;
+	struct list_head duplicates;
+};
+
 struct mlx4_slave_state {
 	u8 comm_toggle;
 	u8 last_cmd;
@@ -425,6 +436,9 @@ struct mlx4_set_port_rqp_calc_context {
 	__be32 mcast;
 };
 
+struct mlx4_mac_entry {
+	u64 mac;
+};
 
 struct mlx4_port_info {
 	struct mlx4_dev	       *dev;
@@ -433,6 +447,7 @@ struct mlx4_port_info {
 	struct device_attribute port_attr;
 	enum mlx4_port_type	tmp_type;
 	struct mlx4_mac_table	mac_table;
+	struct radix_tree_root	mac_tree;
 	struct mlx4_vlan_table	vlan_table;
 	int			base_qpn;
 };
@@ -444,6 +459,11 @@ struct mlx4_sense {
 	struct delayed_work	sense_poll;
 };
 
+struct mlx4_steer {
+	struct list_head promisc_qps[MLX4_NUM_STEERS];
+	struct list_head steer_entries[MLX4_NUM_STEERS];
+};
+
 struct mlx4_priv {
 	struct mlx4_dev		dev;
 
@@ -476,6 +496,7 @@ struct mlx4_priv {
 	struct mlx4_port_info	port[MLX4_MAX_PORTS + 1];
 	struct mlx4_sense       sense;
 	struct mutex		port_mutex;
+	struct mlx4_steer	*steer;
 };
 
 static inline struct mlx4_priv *mlx4_priv(struct mlx4_dev *dev)
@@ -610,6 +631,15 @@ int mlx4_get_port_ib_caps(struct mlx4_dev *dev, u8 port, __be32 *caps);
 int mlx4_MCAST_wrapper(struct mlx4_dev *dev, int slave, struct mlx4_vhcr *vhcr,
 						     struct mlx4_cmd_mailbox *inbox,
 						     struct mlx4_cmd_mailbox *outbox);
+int mlx4_PROMISC_wrapper(struct mlx4_dev *dev, int slave,
+			 struct mlx4_vhcr *vhcr,
+			 struct mlx4_cmd_mailbox *inbox,
+			 struct mlx4_cmd_mailbox *outbox);
+int mlx4_qp_detach_common(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
+			  enum mlx4_protocol prot, enum mlx4_steer_type steer);
+int mlx4_qp_attach_common(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
+			  int block_mcast_loopback, enum mlx4_protocol prot,
+			  enum mlx4_steer_type steer);
 int mlx4_SET_MCAST_FLTR_wrapper(struct mlx4_dev *dev, int slave, struct mlx4_vhcr *vhcr,
 				struct mlx4_cmd_mailbox *inbox,
 				struct mlx4_cmd_mailbox *outbox);
diff --git a/drivers/net/mlx4/mlx4_en.h b/drivers/net/mlx4/mlx4_en.h
index e0ce6c5..cc1a6f0 100644
--- a/drivers/net/mlx4/mlx4_en.h
+++ b/drivers/net/mlx4/mlx4_en.h
@@ -480,6 +480,7 @@ struct mlx4_en_priv {
 	struct mlx4_en_rss_map rss_map;
 	u32 flags;
 #define MLX4_EN_FLAG_PROMISC	0x1
+#define MLX4_EN_FLAG_MC_PROMISC	0x2
 	u32 tx_ring_num;
 	u32 rx_ring_num;
 	u32 rx_skb_size;
diff --git a/drivers/net/mlx4/port.c b/drivers/net/mlx4/port.c
index 2437720..939efef 100644
--- a/drivers/net/mlx4/port.c
+++ b/drivers/net/mlx4/port.c
@@ -90,11 +90,62 @@ static int mlx4_set_port_mac_table(struct mlx4_dev *dev, u8 port,
 	return err;
 }
 
-int mlx4_register_mac(struct mlx4_dev *dev, u8 port, u64 mac, int *qpn)
+static int mlx4_uc_steer_add(struct mlx4_dev *dev, u8 port,
+			     u64 mac, int *qpn, u8 reserve)
+{
+	struct mlx4_qp qp;
+	u8 pf_num;
+	u8 gid[16] = {0};
+	int err;
+
+	if (reserve) {
+		err = mlx4_qp_reserve_range(dev, 1, 1, qpn);
+		if (err) {
+			mlx4_err(dev, "Failed to reserve qp for mac registration\n");
+			return err;
+		}
+	}
+	qp.qpn = *qpn;
+
+	pf_num = ((u8) (mac >> 48)) | (port - 1);
+	mac &= 0xffffffffffffULL;
+	mac = cpu_to_be64(mac << 16);
+	memcpy(&gid[10], &mac, ETH_ALEN);
+	gid[7] = pf_num << 4 | MLX4_UC_STEER << 1;
+
+	err = mlx4_qp_attach_common(dev, &qp, gid, 0,
+				    MLX4_PROT_ETH, MLX4_UC_STEER);
+	if (err && reserve)
+		mlx4_qp_release_range(dev, *qpn, 1);
+
+	return err;
+}
+
+static void mlx4_uc_steer_release(struct mlx4_dev *dev, u8 port,
+				  u64 mac, int qpn, u8 free)
+{
+	struct mlx4_qp qp;
+	u8 pf_num;
+	u8 gid[16] = {0};
+
+	qp.qpn = qpn;
+	pf_num = ((u8) (mac >> 48)) | (port - 1);
+	mac &= 0xffffffffffffULL;
+	mac = cpu_to_be64(mac << 16);
+	memcpy(&gid[10], &mac, ETH_ALEN);
+	gid[7] = pf_num << 4 | MLX4_UC_STEER << 1;
+
+	mlx4_qp_detach_common(dev, &qp, gid, MLX4_PROT_ETH, MLX4_UC_STEER);
+	if (free)
+		mlx4_qp_release_range(dev, qpn, 1);
+}
+
+int mlx4_register_mac(struct mlx4_dev *dev, u8 port, u64 mac, int *qpn, u8 wrap)
 {
 	struct mlx4_port_info *info = &mlx4_priv(dev)->port[port];
 	struct mlx4_mac_table *table = &info->mac_table;
 	u64 out_param;
+	struct mlx4_mac_entry *entry;
 	int i, err = 0;
 	int free = -1;
 
@@ -104,9 +155,25 @@ int mlx4_register_mac(struct mlx4_dev *dev, u8 port, u64 mac, int *qpn)
 		if (!err)
 			*qpn = out_param;
 		return err;
-	} else
+	} else if (!wrap)
 		mac |= (u64) (dev->caps.function) << 48;
 
+	if (dev->caps.vep_uc_steering) {
+		err = mlx4_uc_steer_add(dev, port, mac, qpn, 1);
+		if (!err) {
+			entry = kmalloc(sizeof *entry, GFP_KERNEL);
+			if (!entry) {
+				mlx4_uc_steer_release(dev, port, mac, *qpn, 1);
+				return -ENOMEM;
+			}
+			entry->mac = mac;
+			err = radix_tree_insert(&info->mac_tree, *qpn, entry);
+			if (err)
+				mlx4_uc_steer_release(dev, port, mac, *qpn, 1);
+		}
+		return err;
+	}
+
 	mlx4_dbg(dev, "Registering MAC: 0x%llx\n", (unsigned long long) mac);
 	mutex_lock(&table->mutex);
 	for (i = 0; i < MLX4_MAX_MAC_NUM; i++) {
@@ -121,6 +188,7 @@ int mlx4_register_mac(struct mlx4_dev *dev, u8 port, u64 mac, int *qpn)
 			goto out;
 		}
 	}
+
 	mlx4_dbg(dev, "Free MAC index is %d\n", free);
 
 	if (table->total == table->max) {
@@ -164,12 +232,22 @@ void mlx4_unregister_mac(struct mlx4_dev *dev, u8 port, int qpn)
 	struct mlx4_port_info *info = &mlx4_priv(dev)->port[port];
 	struct mlx4_mac_table *table = &info->mac_table;
 	int index = qpn - info->base_qpn;
+	struct mlx4_mac_entry *entry;
 
 	if (mlx4_is_slave(dev)) {
 		mlx4_cmd(dev, qpn, RES_MAC, port,
 			 MLX4_CMD_FREE_RES, MLX4_CMD_TIME_CLASS_A);
 		return;
 	}
+	if (dev->caps.vep_uc_steering) {
+		entry = radix_tree_lookup(&info->mac_tree, qpn);
+		if (entry) {
+			mlx4_uc_steer_release(dev, port, entry->mac, qpn, 1);
+			radix_tree_delete(&info->mac_tree, qpn);
+			kfree(entry);
+		}
+		return;
+	}
 
 	mutex_lock(&table->mutex);
 
@@ -189,6 +267,7 @@ int mlx4_replace_mac(struct mlx4_dev *dev, u8 port, int qpn, u64 new_mac)
 	struct mlx4_port_info *info = &mlx4_priv(dev)->port[port];
 	struct mlx4_mac_table *table = &info->mac_table;
 	int index = qpn - info->base_qpn;
+	struct mlx4_mac_entry *entry;
 	int err;
 
 	if (mlx4_is_slave(dev)) {
@@ -197,6 +276,14 @@ int mlx4_replace_mac(struct mlx4_dev *dev, u8 port, int qpn, u64 new_mac)
 		return err;
 	}
 
+	if (dev->caps.vep_uc_steering) {
+		entry = radix_tree_lookup(&info->mac_tree, qpn);
+		if (!entry)
+			return -EINVAL;
+		mlx4_uc_steer_release(dev, port, entry->mac, qpn, 0);
+		return mlx4_uc_steer_add(dev, port, entry->mac, &qpn, 0);
+	}
+
 	mutex_lock(&table->mutex);
 
 	err = validate_index(dev, table, index);
diff --git a/include/linux/mlx4/cmd.h b/include/linux/mlx4/cmd.h
index 236e03f..9225791 100644
--- a/include/linux/mlx4/cmd.h
+++ b/include/linux/mlx4/cmd.h
@@ -132,6 +132,7 @@ enum {
 	MLX4_CMD_GET_EVENT	 = 0xf03,
 	MLX4_CMD_QUERY_SLAVE_CAP = 0xf04,
 	MLX4_CMD_MCAST_ATTACH    = 0xf05,
+	MLX4_CMD_PROMISC         = 0xf07,
 
 	/* debug commands */
 	MLX4_CMD_QUERY_DEBUG_MSG = 0x2a,
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index b999e39..c03a176 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -179,6 +179,12 @@ enum mlx4_special_vlan_idx {
 	MLX4_VLAN_REGULAR
 };
 
+enum mlx4_steer_type {
+	MLX4_UC_STEER = 0,
+	MLX4_MC_STEER,
+	MLX4_NUM_STEERS
+};
+
 enum {
 	MLX4_NUM_FEXCH          = 64 * 1024,
 };
@@ -505,9 +511,13 @@ int mlx4_multicast_attach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
 			  int block_mcast_loopback, enum mlx4_protocol prot);
 int mlx4_multicast_detach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
 			  enum mlx4_protocol prot);
+int mlx4_multicast_promisc_add(struct mlx4_dev *dev, u32 qpn, u8 port);
+int mlx4_multicast_promisc_remove(struct mlx4_dev *dev, u32 qpn, u8 port);
+int mlx4_unicast_promisc_add(struct mlx4_dev *dev, u32 qpn, u8 port);
+int mlx4_unicast_promisc_remove(struct mlx4_dev *dev, u32 qpn, u8 port);
 int mlx4_SET_MCAST_FLTR(struct mlx4_dev *dev, u8 port, u64 mac, u64 clear, u8 mode);
 
-int mlx4_register_mac(struct mlx4_dev *dev, u8 port, u64 mac, int *qpn);
+int mlx4_register_mac(struct mlx4_dev *dev, u8 port, u64 mac, int *qpn, u8 wrap);
 void mlx4_unregister_mac(struct mlx4_dev *dev, u8 port, int qpn);
 int mlx4_replace_mac(struct mlx4_dev *dev, u8 port, int qpn, u64 new_mac);
 
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
