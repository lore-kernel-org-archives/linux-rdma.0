From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC 2/3] IB/mlx4: Refactor Alias GUID storing
Date: Thu, 21 May 2015 19:24:06 +0300
Message-ID: <1432225447-6536-3-git-send-email-ogerlitz@mellanox.com>
References: <1432225447-6536-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432225447-6536-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Move the code that actually set the alias GUID provided by the admin
into a function which isn't tied to the mlx4 SRIOV sysfs constructs.

So we can use for the verbs which deal with guid setting too.

This commit does not change any functionality.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mlx4_ib.h |    4 ++
 drivers/infiniband/hw/mlx4/sysfs.c   |   54 ++++++++++++++++++++++------------
 2 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index fce3934..a13a814 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -807,6 +807,10 @@ void mlx4_ib_device_unregister_sysfs(struct mlx4_ib_dev *device);
 
 __be64 mlx4_ib_gen_node_guid(void);
 
+
+void mlx4_store_admin_alias_guid(struct mlx4_ib_dev *mdev, int port, int slave,
+				 __be64 guid);
+
 int mlx4_ib_steer_qp_alloc(struct mlx4_ib_dev *dev, int count, int *qpn);
 void mlx4_ib_steer_qp_free(struct mlx4_ib_dev *dev, u32 qpn, int count);
 int mlx4_ib_steer_qp_reg(struct mlx4_ib_dev *mdev, struct mlx4_ib_qp *mqp,
diff --git a/drivers/infiniband/hw/mlx4/sysfs.c b/drivers/infiniband/hw/mlx4/sysfs.c
index 6797108..705e3b8 100644
--- a/drivers/infiniband/hw/mlx4/sysfs.c
+++ b/drivers/infiniband/hw/mlx4/sysfs.c
@@ -59,6 +59,38 @@ static ssize_t show_admin_alias_guid(struct device *dev,
 	return sprintf(buf, "%llx\n", be64_to_cpu(sysadmin_ag_val));
 }
 
+
+void mlx4_store_admin_alias_guid(struct mlx4_ib_dev *mdev, int port, int slave,
+				 __be64 guid)
+{
+	unsigned long flags;
+	int record_num;/*0-15*/
+	int guid_index_in_rec; /*0 - 7*/
+
+	record_num        = slave / 8;
+	guid_index_in_rec = slave % 8;
+
+	spin_lock_irqsave(&mdev->sriov.alias_guid.ag_work_lock, flags);
+
+	*(__be64 *)&mdev->sriov.alias_guid.ports_guid[port - 1].
+		all_rec_per_port[record_num].
+		all_recs[GUID_REC_SIZE * guid_index_in_rec] = guid;
+
+	/* Change the state to be pending for update */
+	mdev->sriov.alias_guid.ports_guid[port - 1].all_rec_per_port[record_num].status
+		= MLX4_GUID_INFO_STATUS_IDLE ;
+
+	mlx4_set_admin_guid(mdev->dev, guid, slave, port);
+
+	/* set the record index */
+	mdev->sriov.alias_guid.ports_guid[port - 1].all_rec_per_port[record_num].guid_indexes
+		|= mlx4_ib_get_aguid_comp_mask_from_ix(guid_index_in_rec);
+
+	spin_unlock_irqrestore(&mdev->sriov.alias_guid.ag_work_lock, flags);
+
+	mlx4_ib_init_alias_guid_work(mdev, port - 1);
+}
+
 /* store_admin_alias_guid stores the (new) administratively assigned value of that GUID.
  * Values in buf parameter string:
  *	0			- requests opensm to assign a value.
@@ -76,7 +108,6 @@ static ssize_t store_admin_alias_guid(struct device *dev,
 	struct mlx4_ib_iov_port *port = mlx4_ib_iov_dentry->ctx;
 	struct mlx4_ib_dev *mdev = port->dev;
 	u64 sysadmin_ag_val;
-	unsigned long flags;
 
 	record_num = mlx4_ib_iov_dentry->entry_num / 8;
 	guid_index_in_rec = mlx4_ib_iov_dentry->entry_num % 8;
@@ -84,26 +115,11 @@ static ssize_t store_admin_alias_guid(struct device *dev,
 		pr_err("GUID 0 block 0 is RO\n");
 		return count;
 	}
-	spin_lock_irqsave(&mdev->sriov.alias_guid.ag_work_lock, flags);
 	sscanf(buf, "%llx", &sysadmin_ag_val);
-	*(__be64 *)&mdev->sriov.alias_guid.ports_guid[port->num - 1].
-		all_rec_per_port[record_num].
-		all_recs[GUID_REC_SIZE * guid_index_in_rec] =
-			cpu_to_be64(sysadmin_ag_val);
-
-	/* Change the state to be pending for update */
-	mdev->sriov.alias_guid.ports_guid[port->num - 1].all_rec_per_port[record_num].status
-		= MLX4_GUID_INFO_STATUS_IDLE ;
-	mlx4_set_admin_guid(mdev->dev, cpu_to_be64(sysadmin_ag_val),
-			    mlx4_ib_iov_dentry->entry_num,
-			    port->num);
 
-	/* set the record index */
-	mdev->sriov.alias_guid.ports_guid[port->num - 1].all_rec_per_port[record_num].guid_indexes
-		|= mlx4_ib_get_aguid_comp_mask_from_ix(guid_index_in_rec);
-
-	spin_unlock_irqrestore(&mdev->sriov.alias_guid.ag_work_lock, flags);
-	mlx4_ib_init_alias_guid_work(mdev, port->num - 1);
+	mlx4_store_admin_alias_guid(mdev, port->num,
+				    mlx4_ib_iov_dentry->entry_num,
+				    cpu_to_be64(sysadmin_ag_val));
 
 	return count;
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
