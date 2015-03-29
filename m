From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 4/9] IB/mlx4: Manage admin alias GUID upon admin request
Date: Sun, 29 Mar 2015 16:51:28 +0300
Message-ID: <1427637093-6711-5-git-send-email-ogerlitz@mellanox.com>
References: <1427637093-6711-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427637093-6711-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Set the admin alias GUID per the administrator's request via the sysfs
mechanism into the core layer.

The "get" request returns the current value. However, if the administrator
requests the SM to assign a new value by requesting 0, the SM assigned
GUID is returned.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/alias_GUID.c |    6 ++++++
 drivers/infiniband/hw/mlx4/sysfs.c      |   18 +++++++++---------
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/alias_GUID.c b/drivers/infiniband/hw/mlx4/alias_GUID.c
index 2ca8984..c20ce09 100644
--- a/drivers/infiniband/hw/mlx4/alias_GUID.c
+++ b/drivers/infiniband/hw/mlx4/alias_GUID.c
@@ -333,6 +333,12 @@ static void aliasguid_query_handler(int status,
 			} else {
 				*(__be64 *)&rec->all_recs[i * GUID_REC_SIZE] =
 					sm_response;
+				if (required_val == 0)
+					mlx4_set_admin_guid(dev->dev,
+							    sm_response,
+							    (guid_rec->block_num
+							    * NUM_ALIAS_GUID_IN_REC) + i,
+							    cb_ctx->port);
 				goto next_entry;
 			}
 		}
diff --git a/drivers/infiniband/hw/mlx4/sysfs.c b/drivers/infiniband/hw/mlx4/sysfs.c
index 7423d7e..bb1c34a 100644
--- a/drivers/infiniband/hw/mlx4/sysfs.c
+++ b/drivers/infiniband/hw/mlx4/sysfs.c
@@ -46,21 +46,17 @@
 static ssize_t show_admin_alias_guid(struct device *dev,
 			      struct device_attribute *attr, char *buf)
 {
-	int record_num;/*0-15*/
-	int guid_index_in_rec; /*0 - 7*/
 	struct mlx4_ib_iov_sysfs_attr *mlx4_ib_iov_dentry =
 		container_of(attr, struct mlx4_ib_iov_sysfs_attr, dentry);
 	struct mlx4_ib_iov_port *port = mlx4_ib_iov_dentry->ctx;
 	struct mlx4_ib_dev *mdev = port->dev;
+	__be64 sysadmin_ag_val;
 
-	record_num = mlx4_ib_iov_dentry->entry_num / 8 ;
-	guid_index_in_rec = mlx4_ib_iov_dentry->entry_num % 8 ;
+	sysadmin_ag_val = mlx4_get_admin_guid(mdev->dev,
+					      mlx4_ib_iov_dentry->entry_num,
+					      port->num);
 
-	return sprintf(buf, "%llx\n",
-		       be64_to_cpu(*(__be64 *)&mdev->sriov.alias_guid.
-				   ports_guid[port->num - 1].
-				   all_rec_per_port[record_num].
-				   all_recs[8 * guid_index_in_rec]));
+	return sprintf(buf, "%llx\n", be64_to_cpu(sysadmin_ag_val));
 }
 
 /* store_admin_alias_guid stores the (new) administratively assigned value of that GUID.
@@ -98,6 +94,10 @@ static ssize_t store_admin_alias_guid(struct device *dev,
 	/* Change the state to be pending for update */
 	mdev->sriov.alias_guid.ports_guid[port->num - 1].all_rec_per_port[record_num].status
 		= MLX4_GUID_INFO_STATUS_IDLE ;
+	mlx4_set_admin_guid(mdev->dev, cpu_to_be64(sysadmin_ag_val),
+			    mlx4_ib_iov_dentry->entry_num,
+			    port->num);
+
 	switch (sysadmin_ag_val) {
 	case MLX4_GUID_FOR_DELETE_VAL:
 		mdev->sriov.alias_guid.ports_guid[port->num - 1].all_rec_per_port[record_num].ownership
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
