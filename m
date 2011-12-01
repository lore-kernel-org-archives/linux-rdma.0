From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 03/14] ib_srp: Disallow duplicate logins
Date: Thu, 1 Dec 2011 19:58:17 +0100
Message-ID: <201112011958.17339.bvanassche@acm.org>
References: <201112011954.25811.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201112011954.25811.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Currently the ib_srp driver allows to log in multiple times to the
same target via its sysfs interface. This leads to each target LUN
being imported multiple times at the initiator side, something that
should not be allowed.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 868e7f8..2e0169b 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2095,6 +2095,34 @@ out:
 	return ret;
 }
 
+/**
+ * srp_target_exists() - Check whether a given target already exists.
+ *
+ * Returns -EEXIST if the target already exists and 0 if not.
+ */
+static int srp_target_exists(struct srp_host *host,
+			     struct srp_target_port *target)
+{
+	struct srp_target_port *t;
+	int ret = 0;
+
+	spin_lock(&host->target_lock);
+	list_for_each_entry(t, &host->target_list, list) {
+		WARN_ON(t == target);
+		if (target->id_ext == t->id_ext &&
+		    target->ioc_guid == t->ioc_guid &&
+		    memcmp(target->orig_dgid, t->orig_dgid, 16) == 0 &&
+		    target->path.pkey == t->path.pkey &&
+		    target->service_id == t->service_id) {
+			ret = -EEXIST;
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
@@ -2133,6 +2161,10 @@ static ssize_t srp_create_target(struct device *dev,
 	if (ret)
 		goto err;
 
+	ret = srp_target_exists(host, target);
+	if (ret)
+		goto err;
+
 	if (!host->srp_dev->fmr_pool && !target->allow_ext_sg &&
 				target->cmd_sg_cnt < target->sg_tablesize) {
 		pr_warn("No FMR pool and no external indirect descriptors, limiting sg_tablesize to cmd_sg_cnt\n");
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
