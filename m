From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V1 5/9] IB/mlx4: Change init flow to request alias GUIDs for active VFs
Date: Wed,  1 Apr 2015 14:14:11 +0300
Message-ID: <1427886855-16727-6-git-send-email-ogerlitz@mellanox.com>
References: <1427886855-16727-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427886855-16727-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Change the init flow to ask GUIDs only for active VFs. This is done for
both SM & HOST modes so that there is no need any more to maintain the
ownership record type.

In case SM mode is used, the initial value will be 0, ask the SM to assign,
for the HOST mode the initial value will be the HOST generated GUID.

This will enable out of the box experience for both probed and attached VFs.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/alias_GUID.c |  104 ++++++++++++++-----------------
 drivers/infiniband/hw/mlx4/mlx4_ib.h    |    8 +--
 drivers/infiniband/hw/mlx4/sysfs.c      |   17 -----
 3 files changed, 50 insertions(+), 79 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/alias_GUID.c b/drivers/infiniband/hw/mlx4/alias_GUID.c
index 2c476aa..47f501a 100644
--- a/drivers/infiniband/hw/mlx4/alias_GUID.c
+++ b/drivers/infiniband/hw/mlx4/alias_GUID.c
@@ -295,19 +295,17 @@ static void aliasguid_query_handler(int status,
 		 */
 		if (sm_response == MLX4_NOT_SET_GUID) {
 			if (rec->guids_retry_schedule[i] == 0)
-				mlx4_ib_warn(&dev->ib_dev, "%s:Record num %d in "
-					     "block_num: %d was declined by SM, "
-					     "ownership by %d (0 = driver, 1=sysAdmin,"
-					     " 2=None)\n", __func__, i,
-					     guid_rec->block_num,
-					     rec->ownership);
+				mlx4_ib_warn(&dev->ib_dev,
+					     "%s:Record num %d in  block_num: %d was declined by SM\n",
+					     __func__, i,
+					     guid_rec->block_num);
 			goto entry_declined;
 		} else {
 		       /* properly assigned record. */
 		       /* We save the GUID we just got from the SM in the
 			* admin_guid in order to be persistent, and in the
 			* request from the sm the process will ask for the same GUID */
-			if (rec->ownership == MLX4_GUID_SYSADMIN_ASSIGN &&
+			if (required_val &&
 			    sm_response != required_val) {
 				/* Warn only on first retry */
 				if (rec->guids_retry_schedule[i] == 0)
@@ -413,9 +411,7 @@ static void invalidate_guid_record(struct mlx4_ib_dev *dev, u8 port, int index)
 		need to assign GUIDs, then don't put it up for assignment.
 		*/
 		if (MLX4_GUID_FOR_DELETE_VAL == cur_admin_val ||
-		    (!index && !i) ||
-		    MLX4_GUID_NONE_ASSIGN == dev->sriov.alias_guid.
-		    ports_guid[port - 1].all_rec_per_port[index].ownership)
+		    (!index && !i))
 			continue;
 		comp_mask |= mlx4_ib_get_aguid_comp_mask_from_ix(i);
 	}
@@ -523,6 +519,30 @@ out:
 	return err;
 }
 
+static void mlx4_ib_guid_port_init(struct mlx4_ib_dev *dev, int port)
+{
+	int j, k, entry;
+	__be64 guid;
+
+	/*Check if the SM doesn't need to assign the GUIDs*/
+	for (j = 0; j < NUM_ALIAS_GUID_REC_IN_PORT; j++) {
+		for (k = 0; k < NUM_ALIAS_GUID_IN_REC; k++) {
+			entry = j * NUM_ALIAS_GUID_IN_REC + k;
+			/* no request for the 0 entry (hw guid) */
+			if (!entry || entry > dev->dev->persist->num_vfs ||
+			    !mlx4_is_slave_active(dev->dev, entry))
+				continue;
+			guid = mlx4_get_admin_guid(dev->dev, entry, port);
+			*(__be64 *)&dev->sriov.alias_guid.ports_guid[port - 1].
+				all_rec_per_port[j].all_recs
+				[GUID_REC_SIZE * k] = guid;
+			pr_debug("guid was set, entry=%d, val=0x%llx, port=%d\n",
+				 entry,
+				 be64_to_cpu(guid),
+				 port);
+		}
+	}
+}
 void mlx4_ib_invalidate_all_guid_record(struct mlx4_ib_dev *dev, int port)
 {
 	int i;
@@ -532,6 +552,13 @@ void mlx4_ib_invalidate_all_guid_record(struct mlx4_ib_dev *dev, int port)
 
 	spin_lock_irqsave(&dev->sriov.going_down_lock, flags);
 	spin_lock_irqsave(&dev->sriov.alias_guid.ag_work_lock, flags1);
+
+	if (dev->sriov.alias_guid.ports_guid[port - 1].state_flags &
+		GUID_STATE_NEED_PORT_INIT) {
+		mlx4_ib_guid_port_init(dev, port);
+		dev->sriov.alias_guid.ports_guid[port - 1].state_flags &=
+			(~GUID_STATE_NEED_PORT_INIT);
+	}
 	for (i = 0; i < NUM_ALIAS_GUID_REC_IN_PORT; i++)
 		invalidate_guid_record(dev, port, i);
 
@@ -654,33 +681,6 @@ out:
 	return ret;
 }
 
-static void set_administratively_guid_record(struct mlx4_ib_dev *dev, int port,
-					     int rec_index,
-					     struct mlx4_sriov_alias_guid_info_rec_det *rec_det)
-{
-	dev->sriov.alias_guid.ports_guid[port].all_rec_per_port[rec_index].guid_indexes =
-		rec_det->guid_indexes;
-	memcpy(dev->sriov.alias_guid.ports_guid[port].all_rec_per_port[rec_index].all_recs,
-	       rec_det->all_recs, NUM_ALIAS_GUID_IN_REC * GUID_REC_SIZE);
-}
-
-static void set_all_slaves_guids(struct mlx4_ib_dev *dev, int port)
-{
-	int j;
-	struct mlx4_sriov_alias_guid_info_rec_det rec_det ;
-
-	for (j = 0 ; j < NUM_ALIAS_GUID_REC_IN_PORT ; j++) {
-		memset(rec_det.all_recs, 0, NUM_ALIAS_GUID_IN_REC * GUID_REC_SIZE);
-		rec_det.guid_indexes = (!j ? 0 : IB_SA_GUIDINFO_REC_GID0) |
-			IB_SA_GUIDINFO_REC_GID1 | IB_SA_GUIDINFO_REC_GID2 |
-			IB_SA_GUIDINFO_REC_GID3 | IB_SA_GUIDINFO_REC_GID4 |
-			IB_SA_GUIDINFO_REC_GID5 | IB_SA_GUIDINFO_REC_GID6 |
-			IB_SA_GUIDINFO_REC_GID7;
-		rec_det.status = MLX4_GUID_INFO_STATUS_IDLE;
-		set_administratively_guid_record(dev, port, j, &rec_det);
-	}
-}
-
 static void alias_guid_work(struct work_struct *work)
 {
 	struct delayed_work *delay = to_delayed_work(work);
@@ -776,7 +776,7 @@ int mlx4_ib_init_alias_guid_service(struct mlx4_ib_dev *dev)
 {
 	char alias_wq_name[15];
 	int ret = 0;
-	int i, j, k;
+	int i, j;
 	union ib_gid gid;
 
 	if (!mlx4_is_master(dev->dev))
@@ -800,33 +800,25 @@ int mlx4_ib_init_alias_guid_service(struct mlx4_ib_dev *dev)
 	for (i = 0 ; i < dev->num_ports; i++) {
 		memset(&dev->sriov.alias_guid.ports_guid[i], 0,
 		       sizeof (struct mlx4_sriov_alias_guid_port_rec_det));
-		/*Check if the SM doesn't need to assign the GUIDs*/
+		dev->sriov.alias_guid.ports_guid[i].state_flags |=
+				GUID_STATE_NEED_PORT_INIT;
 		for (j = 0; j < NUM_ALIAS_GUID_REC_IN_PORT; j++) {
-			if (mlx4_ib_sm_guid_assign) {
-				dev->sriov.alias_guid.ports_guid[i].
-					all_rec_per_port[j].
-					ownership = MLX4_GUID_DRIVER_ASSIGN;
-				continue;
-			}
-			dev->sriov.alias_guid.ports_guid[i].all_rec_per_port[j].
-					ownership = MLX4_GUID_NONE_ASSIGN;
-			/*mark each val as it was deleted,
-			  till the sysAdmin will give it valid val*/
-			for (k = 0; k < NUM_ALIAS_GUID_IN_REC; k++) {
-				*(__be64 *)&dev->sriov.alias_guid.ports_guid[i].
-					all_rec_per_port[j].all_recs[GUID_REC_SIZE * k] =
-						cpu_to_be64(MLX4_GUID_FOR_DELETE_VAL);
-			}
+			/* mark each val as it was deleted */
+			memset(dev->sriov.alias_guid.ports_guid[i].
+				all_rec_per_port[j].all_recs, 0xFF,
+				sizeof(dev->sriov.alias_guid.ports_guid[i].
+				all_rec_per_port[j].all_recs));
 		}
 		INIT_LIST_HEAD(&dev->sriov.alias_guid.ports_guid[i].cb_list);
 		/*prepare the records, set them to be allocated by sm*/
+		if (mlx4_ib_sm_guid_assign)
+			for (j = 1; j < NUM_ALIAS_GUID_PER_PORT; j++)
+				mlx4_set_admin_guid(dev->dev, 0, j, i + 1);
 		for (j = 0 ; j < NUM_ALIAS_GUID_REC_IN_PORT; j++)
 			invalidate_guid_record(dev, i + 1, j);
 
 		dev->sriov.alias_guid.ports_guid[i].parent = &dev->sriov.alias_guid;
 		dev->sriov.alias_guid.ports_guid[i].port  = i;
-		if (mlx4_ib_sm_guid_assign)
-			set_all_slaves_guids(dev, i);
 
 		snprintf(alias_wq_name, sizeof alias_wq_name, "alias_guid%d", i);
 		dev->sriov.alias_guid.ports_guid[i].wq =
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 1cfc2bb..532a877 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -344,11 +344,7 @@ enum mlx4_guid_alias_rec_status {
 	MLX4_GUID_INFO_STATUS_SET,
 };
 
-enum mlx4_guid_alias_rec_ownership {
-	MLX4_GUID_DRIVER_ASSIGN,
-	MLX4_GUID_SYSADMIN_ASSIGN,
-	MLX4_GUID_NONE_ASSIGN, /*init state of each record*/
-};
+#define GUID_STATE_NEED_PORT_INIT 0x01
 
 enum mlx4_guid_alias_rec_method {
 	MLX4_GUID_INFO_RECORD_SET	= IB_MGMT_METHOD_SET,
@@ -359,7 +355,6 @@ struct mlx4_sriov_alias_guid_info_rec_det {
 	u8 all_recs[GUID_REC_SIZE * NUM_ALIAS_GUID_IN_REC];
 	ib_sa_comp_mask guid_indexes; /*indicates what from the 8 records are valid*/
 	enum mlx4_guid_alias_rec_status status; /*indicates the administraively status of the record.*/
-	enum mlx4_guid_alias_rec_ownership ownership; /*indicates who assign that alias_guid record*/
 	unsigned int guids_retry_schedule[NUM_ALIAS_GUID_IN_REC];
 	u64 time_to_run;
 };
@@ -369,6 +364,7 @@ struct mlx4_sriov_alias_guid_port_rec_det {
 	struct workqueue_struct *wq;
 	struct delayed_work alias_guid_work;
 	u8 port;
+	u32 state_flags;
 	struct mlx4_sriov_alias_guid *parent;
 	struct list_head cb_list;
 };
diff --git a/drivers/infiniband/hw/mlx4/sysfs.c b/drivers/infiniband/hw/mlx4/sysfs.c
index bb1c34a..6797108 100644
--- a/drivers/infiniband/hw/mlx4/sysfs.c
+++ b/drivers/infiniband/hw/mlx4/sysfs.c
@@ -98,23 +98,6 @@ static ssize_t store_admin_alias_guid(struct device *dev,
 			    mlx4_ib_iov_dentry->entry_num,
 			    port->num);
 
-	switch (sysadmin_ag_val) {
-	case MLX4_GUID_FOR_DELETE_VAL:
-		mdev->sriov.alias_guid.ports_guid[port->num - 1].all_rec_per_port[record_num].ownership
-			= MLX4_GUID_SYSADMIN_ASSIGN;
-		break;
-	/* The sysadmin requests the SM to re-assign */
-	case MLX4_NOT_SET_GUID:
-		mdev->sriov.alias_guid.ports_guid[port->num - 1].all_rec_per_port[record_num].ownership
-			= MLX4_GUID_DRIVER_ASSIGN;
-		break;
-	/* The sysadmin requests a specific value.*/
-	default:
-		mdev->sriov.alias_guid.ports_guid[port->num - 1].all_rec_per_port[record_num].ownership
-			= MLX4_GUID_SYSADMIN_ASSIGN;
-		break;
-	}
-
 	/* set the record index */
 	mdev->sriov.alias_guid.ports_guid[port->num - 1].all_rec_per_port[record_num].guid_indexes
 		|= mlx4_ib_get_aguid_comp_mask_from_ix(guid_index_in_rec);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
