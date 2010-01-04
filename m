From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: [RFC PATCH 3/3] IB/srp: export req_limit via sysfs
Date: Sun,  3 Jan 2010 20:43:37 -0500
Message-ID: <1262569417-20341-3-git-send-email-dave@thedillows.org>
References: <1262568846.13289.4.camel@obelisk.thedillows.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1262568846.13289.4.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
In-Reply-To: <1262568846.13289.4.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
References: <1262568846.13289.4.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Export the target's current request limit, in case it is useful for
debugging.
---
I don't feel strongly that this should go in, only that it should be
a separate patch if it does.

 drivers/infiniband/ulp/srp/ib_srp.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index c0a5ccb..c68d8d6 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1620,6 +1620,18 @@ static ssize_t show_zero_req_lim(struct device *dev,
 	return sprintf(buf, "%d\n", target->zero_req_lim);
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
 static ssize_t show_local_ib_port(struct device *dev,
 				  struct device_attribute *attr, char *buf)
 {
@@ -1642,6 +1654,7 @@ static DEVICE_ATTR(service_id,	    S_IRUGO, show_service_id,	   NULL);
 static DEVICE_ATTR(pkey,	    S_IRUGO, show_pkey,		   NULL);
 static DEVICE_ATTR(dgid,	    S_IRUGO, show_dgid,		   NULL);
 static DEVICE_ATTR(orig_dgid,	    S_IRUGO, show_orig_dgid,	   NULL);
+static DEVICE_ATTR(req_lim,	    S_IRUGO, show_req_lim,	   NULL);
 static DEVICE_ATTR(zero_req_lim,    S_IRUGO, show_zero_req_lim,	   NULL);
 static DEVICE_ATTR(local_ib_port,   S_IRUGO, show_local_ib_port,   NULL);
 static DEVICE_ATTR(local_ib_device, S_IRUGO, show_local_ib_device, NULL);
@@ -1653,6 +1666,7 @@ static struct device_attribute *srp_host_attrs[] = {
 	&dev_attr_pkey,
 	&dev_attr_dgid,
 	&dev_attr_orig_dgid,
+	&dev_attr_req_lim,
 	&dev_attr_zero_req_lim,
 	&dev_attr_local_ib_port,
 	&dev_attr_local_ib_device,
-- 
1.6.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
