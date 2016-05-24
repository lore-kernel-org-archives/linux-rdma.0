From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI 4/8] IB/core: Add DIRECT ioctl call to vendor
Date: Tue, 24 May 2016 17:35:22 +0300
Message-ID: <1464100526-31730-5-git-send-email-leonro@mellanox.com>
References: <1464100526-31730-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464100526-31730-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Introduce a new RDMA IOCTL command, which will be visible to
consumers, which would like to execute commands straight on the
vendor's driver. It bypasses IB core logic and is intended for
vendor specific channel operations.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_main.c | 33 +++++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h               |  2 ++
 include/uapi/rdma/ib_user_ioctl.h     |  5 +++++
 3 files changed, 40 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 42fbb6d..68cf1fd 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -850,6 +850,37 @@ out:
 	return ret;
 }
 
+static long ib_uverbs_ioctl(struct file *filp, unsigned int cmd,
+			    unsigned long arg)
+{
+	struct ib_uverbs_file *file = filp->private_data;
+	struct ib_device *ib_dev;
+	int srcu_key;
+
+	if (WARN_ON_ONCE(!ib_safe_file_access(filp)))
+		return -EACCES;
+
+	if (cmd == IB_IOCTL_DIRECT) {
+		long ret = 0;
+
+		srcu_key = srcu_read_lock(&file->device->disassociate_srcu);
+		ib_dev = srcu_dereference(file->device->ib_dev,
+					  &file->device->disassociate_srcu);
+		if (!ib_dev) {
+			srcu_read_unlock(&file->device->disassociate_srcu, srcu_key);
+			return -EIO;
+		}
+
+		if (ib_dev->direct_fn)
+			ret = ib_dev->direct_fn(filp, arg);
+
+		srcu_read_unlock(&file->device->disassociate_srcu, srcu_key);
+		return ret;
+	}
+
+	return -ENOIOCTLCMD;
+}
+
 static int ib_uverbs_mmap(struct file *filp, struct vm_area_struct *vma)
 {
 	struct ib_uverbs_file *file = filp->private_data;
@@ -985,6 +1016,7 @@ static const struct file_operations uverbs_fops = {
 	.open	 = ib_uverbs_open,
 	.release = ib_uverbs_close,
 	.llseek	 = no_llseek,
+	.unlocked_ioctl = ib_uverbs_ioctl,
 };
 
 static const struct file_operations uverbs_mmap_fops = {
@@ -994,6 +1026,7 @@ static const struct file_operations uverbs_mmap_fops = {
 	.open	 = ib_uverbs_open,
 	.release = ib_uverbs_close,
 	.llseek	 = no_llseek,
+	.unlocked_ioctl = ib_uverbs_ioctl,
 };
 
 static struct ib_client uverbs_client = {
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index fc0320c..1904c02 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1707,6 +1707,8 @@ struct ib_device {
 
 	struct iw_cm_verbs	     *iwcm;
 
+	long		           (*direct_fn)(struct file *filp,
+						unsigned long arg);
 	int		           (*get_protocol_stats)(struct ib_device *device,
 							 union rdma_protocol_stats *stats);
 	int		           (*query_device)(struct ib_device *device,
diff --git a/include/uapi/rdma/ib_user_ioctl.h b/include/uapi/rdma/ib_user_ioctl.h
index d1928dea..f17e51a 100644
--- a/include/uapi/rdma/ib_user_ioctl.h
+++ b/include/uapi/rdma/ib_user_ioctl.h
@@ -38,6 +38,11 @@
 
 #define IB_IOCTL_MAGIC		0x1b
 
+#define IB_CMD_DIRECT		0x2
+
+#define IB_IOCTL_DIRECT \
+	_IOWR(IB_IOCTL_MAGIC, IB_CMD_DIRECT, unsigned long)
+
 /* Legacy part
  * !!!! NOTE: It uses the same command index as VERBS
  */
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
