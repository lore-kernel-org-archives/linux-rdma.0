From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 02/18] ib_srp: Consolidate repetitive sysfs code
Date: Sat, 14 Jan 2012 12:40:44 +0000
Message-ID: <1500127.hxDoVn5zlk@asus>
References: <3109536.qySrY1Ts3e@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3109536.qySrY1Ts3e@asus>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove sysfs attributes before removing a target instead of
testing the target state in every sysfs attribute callback
method. Note: it is safe to invoke a sysfs attribute removal
method like device_remove_file() twice on the same attribute.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   49 ++++++++++++----------------------
 1 files changed, 17 insertions(+), 32 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 895a9ff..bcbf22e 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -474,6 +474,21 @@ static void srp_free_req_data(struct srp_target_port *target)
 	}
 }
 
+/**
+ * srp_del_scsi_host_attr() - Remove attributes defined in the host template.
+ * @shost: SCSI host whose attributes to remove from sysfs.
+ *
+ * Note: Any attributes defined in the host template and that did not exist
+ * before invocation of this function will be ignored.
+ */
+static void srp_del_scsi_host_attr(struct Scsi_Host *shost)
+{
+	struct device_attribute **attr;
+
+	for (attr = shost->hostt->shost_attrs; attr && *attr; ++attr)
+		device_remove_file(&shost->shost_dev, *attr);
+}
+
 static void srp_remove_work(struct work_struct *work)
 {
 	struct srp_target_port *target =
@@ -486,6 +501,7 @@ static void srp_remove_work(struct work_struct *work)
 	list_del(&target->list);
 	spin_unlock(&target->srp_host->target_lock);
 
+	srp_del_scsi_host_attr(target->scsi_host);
 	srp_remove_host(target->scsi_host);
 	scsi_remove_host(target->scsi_host);
 	ib_destroy_cm_id(target->cm_id);
@@ -1678,10 +1694,6 @@ static ssize_t show_id_ext(struct device *dev, struct device_attribute *attr,
 {
 	struct srp_target_port *target = host_to_target(class_to_shost(dev));
 
-	if (target->state == SRP_TARGET_DEAD ||
-	    target->state == SRP_TARGET_REMOVED)
-		return -ENODEV;
-
 	return sprintf(buf, "0x%016llx\n",
 		       (unsigned long long) be64_to_cpu(target->id_ext));
 }
@@ -1691,10 +1703,6 @@ static ssize_t show_ioc_guid(struct device *dev, struct device_attribute *attr,
 {
 	struct srp_target_port *target = host_to_target(class_to_shost(dev));
 
-	if (target->state == SRP_TARGET_DEAD ||
-	    target->state == SRP_TARGET_REMOVED)
-		return -ENODEV;
-
 	return sprintf(buf, "0x%016llx\n",
 		       (unsigned long long) be64_to_cpu(target->ioc_guid));
 }
@@ -1704,10 +1712,6 @@ static ssize_t show_service_id(struct device *dev,
 {
 	struct srp_target_port *target = host_to_target(class_to_shost(dev));
 
-	if (target->state == SRP_TARGET_DEAD ||
-	    target->state == SRP_TARGET_REMOVED)
-		return -ENODEV;
-
 	return sprintf(buf, "0x%016llx\n",
 		       (unsigned long long) be64_to_cpu(target->service_id));
 }
@@ -1717,10 +1721,6 @@ static ssize_t show_pkey(struct device *dev, struct device_attribute *attr,
 {
 	struct srp_target_port *target = host_to_target(class_to_shost(dev));
 
-	if (target->state == SRP_TARGET_DEAD ||
-	    target->state == SRP_TARGET_REMOVED)
-		return -ENODEV;
-
 	return sprintf(buf, "0x%04x\n", be16_to_cpu(target->path.pkey));
 }
 
@@ -1729,10 +1729,6 @@ static ssize_t show_dgid(struct device *dev, struct device_attribute *attr,
 {
 	struct srp_target_port *target = host_to_target(class_to_shost(dev));
 
-	if (target->state == SRP_TARGET_DEAD ||
-	    target->state == SRP_TARGET_REMOVED)
-		return -ENODEV;
-
 	return sprintf(buf, "%pI6\n", target->path.dgid.raw);
 }
 
@@ -1741,10 +1737,6 @@ static ssize_t show_orig_dgid(struct device *dev,
 {
 	struct srp_target_port *target = host_to_target(class_to_shost(dev));
 
-	if (target->state == SRP_TARGET_DEAD ||
-	    target->state == SRP_TARGET_REMOVED)
-		return -ENODEV;
-
 	return sprintf(buf, "%pI6\n", target->orig_dgid);
 }
 
@@ -1753,10 +1745,6 @@ static ssize_t show_req_lim(struct device *dev,
 {
 	struct srp_target_port *target = host_to_target(class_to_shost(dev));
 
-	if (target->state == SRP_TARGET_DEAD ||
-	    target->state == SRP_TARGET_REMOVED)
-		return -ENODEV;
-
 	return sprintf(buf, "%d\n", target->req_lim);
 }
 
@@ -1765,10 +1753,6 @@ static ssize_t show_zero_req_lim(struct device *dev,
 {
 	struct srp_target_port *target = host_to_target(class_to_shost(dev));
 
-	if (target->state == SRP_TARGET_DEAD ||
-	    target->state == SRP_TARGET_REMOVED)
-		return -ENODEV;
-
 	return sprintf(buf, "%d\n", target->zero_req_lim);
 }
 
@@ -2432,6 +2416,7 @@ static void srp_remove_one(struct ib_device *device)
 
 		list_for_each_entry_safe(target, tmp_target,
 					 &host->target_list, list) {
+			srp_del_scsi_host_attr(target->scsi_host);
 			srp_remove_host(target->scsi_host);
 			scsi_remove_host(target->scsi_host);
 			srp_disconnect_target(target);
-- 
1.7.7


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
