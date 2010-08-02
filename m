From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 4/4] IB/srp: export req_lim via sysfs
Date: Mon, 2 Aug 2010 17:32:49 +0200
Message-ID: <201008021732.49878.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Exports req_lim via sysfs, which is convenient for debugging purposes.

Signed-off-by: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>

---
 drivers/infiniband/ulp/srp/ib_srp.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index c810e52..bf546ac 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1732,6 +1732,18 @@ static ssize_t show_orig_dgid(struct device *dev,
 	return sprintf(buf, "%pI6\n", target->orig_dgid);
 }
 
+static ssize_t show_req_lim(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	struct srp_target_port *target = host_to_target(class_to_shost(dev));
+
+	if (target->state == SRP_TARGET_DEAD ||
+	    target->state == SRP_TARGET_REMOVED)
+		return -ENODEV;
+
+	return sprintf(buf, "%d\n", target->req_lim);
+}
+
 static ssize_t show_zero_req_lim(struct device *dev,
 				 struct device_attribute *attr, char *buf)
 {
@@ -1766,6 +1778,7 @@ static DEVICE_ATTR(service_id,	    S_IRUGO, show_service_id,	   NULL);
 static DEVICE_ATTR(pkey,	    S_IRUGO, show_pkey,		   NULL);
 static DEVICE_ATTR(dgid,	    S_IRUGO, show_dgid,		   NULL);
 static DEVICE_ATTR(orig_dgid,	    S_IRUGO, show_orig_dgid,	   NULL);
+static DEVICE_ATTR(req_lim,         S_IRUGO, show_req_lim,         NULL);
 static DEVICE_ATTR(zero_req_lim,    S_IRUGO, show_zero_req_lim,	   NULL);
 static DEVICE_ATTR(local_ib_port,   S_IRUGO, show_local_ib_port,   NULL);
 static DEVICE_ATTR(local_ib_device, S_IRUGO, show_local_ib_device, NULL);
@@ -1777,6 +1790,7 @@ static struct device_attribute *srp_host_attrs[] = {
 	&dev_attr_pkey,
 	&dev_attr_dgid,
 	&dev_attr_orig_dgid,
+	&dev_attr_req_lim,
 	&dev_attr_zero_req_lim,
 	&dev_attr_local_ib_port,
 	&dev_attr_local_ib_device,
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
