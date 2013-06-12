From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH] IB/srp: Maintain a single connection per I_T nexus
Date: Wed, 12 Jun 2013 13:29:57 +0200
Message-ID: <1371036597-23483-1-git-send-email-sebastian.riemer@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The sysfs attribute 'add_target' may not be used for multiple logins to
the same target. If doing so with multipathing, this crashes the
multipath-tools. Furthermore, we want to prevent the possibility of data
corruption here. If manual reconnect is necessary, then the user can use
the 'delete' sysfs attribute of the remote port before connecting.

Note: The function srp_conn_unique() has been taken from Bart Van Assche.

Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   38 +++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 7ccf328..d14cc4b 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2219,6 +2219,36 @@ out:
 	return ret;
 }
 
+/**
+ * srp_conn_unique() - Check whether the connection to a target is unique.
+ *
+ * Consider targets in state SRP_TARGET_REMOVED as not unique because these
+ * may already have been removed from the target list.
+ */
+static bool srp_conn_unique(struct srp_host *host,
+			    struct srp_target_port *target)
+{
+	struct srp_target_port *t;
+	bool ret = true;
+
+	if (target->state == SRP_TARGET_REMOVED)
+		return false;
+
+	spin_lock(&host->target_lock);
+	list_for_each_entry(t, &host->target_list, list) {
+		if (t != target &&
+		    target->id_ext == t->id_ext &&
+		    target->ioc_guid == t->ioc_guid &&
+		    target->initiator_ext == t->initiator_ext) {
+			ret = false;
+			break;
+		}
+	}
+	spin_unlock(&host->target_lock);
+
+	return ret;
+}
+
 static ssize_t srp_create_target(struct device *dev,
 				 struct device_attribute *attr,
 				 const char *buf, size_t count)
@@ -2257,6 +2287,14 @@ static ssize_t srp_create_target(struct device *dev,
 	if (ret)
 		goto err;
 
+	/* Don't allow multiple logins to the same target port */
+	if (!srp_conn_unique(target->srp_host, target)) {
+		shost_printk(KERN_INFO, target->scsi_host,
+			     PFX "SRP target port is already connected\n");
+		ret = -EEXIST;
+		goto err;
+	}
+
 	if (!host->srp_dev->fmr_pool && !target->allow_ext_sg &&
 				target->cmd_sg_cnt < target->sg_tablesize) {
 		pr_warn("No FMR pool and no external indirect descriptors, limiting sg_tablesize to cmd_sg_cnt\n");
-- 
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
