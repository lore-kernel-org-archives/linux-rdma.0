From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: ib_qib: Allow writes to the diag_counters to be able to clear them
Date: Wed, 7 Jul 2010 17:33:13 -0700
Message-ID: <20100707173313.675cd665.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From 80eecc4046455999254fb312c4ba229b3a52d4c6 Mon Sep 17 00:00:00 2001
From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Wed, 7 Jul 2010 17:35:34 -0700
Subject: [PATCH] ib_qib: Allow writes to the diag_counters to be able to clear them


Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_sysfs.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_sysfs.c b/drivers/infiniband/hw/qib/qib_sysfs.c
index dab4d9f..91cd1b8 100644
--- a/drivers/infiniband/hw/qib/qib_sysfs.c
+++ b/drivers/infiniband/hw/qib/qib_sysfs.c
@@ -347,7 +347,7 @@ static struct kobj_type qib_sl2vl_ktype = {
 
 #define QIB_DIAGC_ATTR(N) \
 	static struct qib_diagc_attr qib_diagc_attr_##N = { \
-		.attr = { .name = __stringify(N), .mode = 0444 }, \
+		.attr = { .name = __stringify(N), .mode = 0664 }, \
 		.counter = offsetof(struct qib_ibport, n_##N) \
 	}
 
@@ -403,8 +403,22 @@ static ssize_t diagc_attr_show(struct kobject *kobj, struct attribute *attr,
 	return sprintf(buf, "%u\n", *(u32 *)((char *)qibp + dattr->counter));
 }
 
+static ssize_t diagc_attr_store(struct kobject *kobj, struct attribute *attr,
+				const char *buf, size_t size)
+{
+	struct qib_diagc_attr *dattr =
+		container_of(attr, struct qib_diagc_attr, attr);
+	struct qib_pportdata *ppd =
+		container_of(kobj, struct qib_pportdata, diagc_kobj);
+	struct qib_ibport *qibp = &ppd->ibport_data;
+
+	*(u32 *)((char *)qibp + dattr->counter) = simple_strtol(buf, NULL, 0);
+	return 4;
+}
+
 static const struct sysfs_ops qib_diagc_ops = {
 	.show = diagc_attr_show,
+	.store = diagc_attr_store,
 };
 
 static struct kobj_type qib_diagc_ktype = {
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
