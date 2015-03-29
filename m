From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 6/9] IB/mlx4: Request alias GUID on demand
Date: Sun, 29 Mar 2015 16:51:30 +0300
Message-ID: <1427637093-6711-7-git-send-email-ogerlitz@mellanox.com>
References: <1427637093-6711-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427637093-6711-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Request GIDs from the SM on demand, i.e., when a VF actually needs them,
and release them when the GIDs are no longer in use.

In cloud environments, this is useful for GID migrations, in which a
GID is assigned to a VF on the destination HCA, while the VF on the
source HCA is shutdown (but the GID was not administratively released).

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/alias_GUID.c |   51 +++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx4/main.c       |   22 +++++++++++++
 drivers/infiniband/hw/mlx4/mlx4_ib.h    |    2 +
 3 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/alias_GUID.c b/drivers/infiniband/hw/mlx4/alias_GUID.c
index cbadab0..f5935c5 100644
--- a/drivers/infiniband/hw/mlx4/alias_GUID.c
+++ b/drivers/infiniband/hw/mlx4/alias_GUID.c
@@ -123,6 +123,57 @@ ib_sa_comp_mask mlx4_ib_get_aguid_comp_mask_from_ix(int index)
 	return IB_SA_COMP_MASK(4 + index);
 }
 
+void mlx4_ib_slave_alias_guid_event(struct mlx4_ib_dev *dev, int slave,
+				    int port,  int slave_init)
+{
+	__be64 curr_guid, required_guid;
+	int record_num = slave / 8;
+	int index = slave % 8;
+	int port_index = port - 1;
+	unsigned long flags;
+	int do_work = 0;
+
+	spin_lock_irqsave(&dev->sriov.alias_guid.ag_work_lock, flags);
+	if (dev->sriov.alias_guid.ports_guid[port_index].state_flags &
+	    GUID_STATE_NEED_PORT_INIT)
+		goto unlock;
+	if (!slave_init) {
+		curr_guid = *(__be64 *)&dev->sriov.
+			alias_guid.ports_guid[port_index].
+			all_rec_per_port[record_num].
+			all_recs[GUID_REC_SIZE * index];
+		if (curr_guid == cpu_to_be64(MLX4_GUID_FOR_DELETE_VAL) ||
+		    !curr_guid)
+			goto unlock;
+		required_guid = cpu_to_be64(MLX4_GUID_FOR_DELETE_VAL);
+	} else {
+		required_guid = mlx4_get_admin_guid(dev->dev, slave, port);
+		if (required_guid == cpu_to_be64(MLX4_GUID_FOR_DELETE_VAL))
+			goto unlock;
+	}
+	*(__be64 *)&dev->sriov.alias_guid.ports_guid[port_index].
+		all_rec_per_port[record_num].
+		all_recs[GUID_REC_SIZE * index] = required_guid;
+	dev->sriov.alias_guid.ports_guid[port_index].
+		all_rec_per_port[record_num].guid_indexes
+		|= mlx4_ib_get_aguid_comp_mask_from_ix(index);
+	dev->sriov.alias_guid.ports_guid[port_index].
+		all_rec_per_port[record_num].status
+		= MLX4_GUID_INFO_STATUS_IDLE;
+	/* set to run immediately */
+	dev->sriov.alias_guid.ports_guid[port_index].
+		all_rec_per_port[record_num].time_to_run = 0;
+	dev->sriov.alias_guid.ports_guid[port_index].
+		all_rec_per_port[record_num].
+		guids_retry_schedule[index] = 0;
+	do_work = 1;
+unlock:
+	spin_unlock_irqrestore(&dev->sriov.alias_guid.ag_work_lock, flags);
+
+	if (do_work)
+		mlx4_ib_init_alias_guid_work(dev, port_index);
+}
+
 /*
  * Whenever new GUID is set/unset (guid table change) create event and
  * notify the relevant slave (master also should be notified).
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index b972c0b..35f00ae 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2790,9 +2790,31 @@ static void mlx4_ib_event(struct mlx4_dev *dev, void *ibdev_ptr,
 	case MLX4_DEV_EVENT_SLAVE_INIT:
 		/* here, p is the slave id */
 		do_slave_init(ibdev, p, 1);
+		if (mlx4_is_master(dev)) {
+			int i;
+
+			for (i = 1; i <= ibdev->num_ports; i++) {
+				if (rdma_port_get_link_layer(&ibdev->ib_dev, i)
+					== IB_LINK_LAYER_INFINIBAND)
+					mlx4_ib_slave_alias_guid_event(ibdev,
+								       p, i,
+								       1);
+			}
+		}
 		return;
 
 	case MLX4_DEV_EVENT_SLAVE_SHUTDOWN:
+		if (mlx4_is_master(dev)) {
+			int i;
+
+			for (i = 1; i <= ibdev->num_ports; i++) {
+				if (rdma_port_get_link_layer(&ibdev->ib_dev, i)
+					== IB_LINK_LAYER_INFINIBAND)
+					mlx4_ib_slave_alias_guid_event(ibdev,
+								       p, i,
+								       0);
+			}
+		}
 		/* here, p is the slave id */
 		do_slave_init(ibdev, p, 0);
 		return;
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 532a877..fce3934 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -798,6 +798,8 @@ int add_sysfs_port_mcg_attr(struct mlx4_ib_dev *device, int port_num,
 void del_sysfs_port_mcg_attr(struct mlx4_ib_dev *device, int port_num,
 			     struct attribute *attr);
 ib_sa_comp_mask mlx4_ib_get_aguid_comp_mask_from_ix(int index);
+void mlx4_ib_slave_alias_guid_event(struct mlx4_ib_dev *dev, int slave,
+				    int port, int slave_init);
 
 int mlx4_ib_device_register_sysfs(struct mlx4_ib_dev *device) ;
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
