From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH V2] ib_qib: Allow writes to the diag_counters to be able to
 clear them
Date: Thu, 8 Jul 2010 13:11:05 -0700
Message-ID: <20100708131105.4103a6e3.weiny2@llnl.gov>
References: <20100707173313.675cd665.weiny2@llnl.gov>
	<AANLkTin_OHC8r__FDXPY6QhCaXDYgNFDY9SeE8ffdc35@mail.gmail.com>
	<20100708110446.97317098.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100708110446.97317098.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Wed, 7 Jul 2010 17:35:34 -0700
Subject: [PATCH] ib_qib: Allow writes to the diag_counters to be able to clear them

Changes in V2:
	Add check for negative values
	Return proper length

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_sysfs.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_sysfs.c b/drivers/infiniband/hw/qib/qib_sysfs.c
index dab4d9f..e4ec50e 100644
--- a/drivers/infiniband/hw/qib/qib_sysfs.c
+++ b/drivers/infiniband/hw/qib/qib_sysfs.c
@@ -347,7 +347,7 @@ static struct kobj_type qib_sl2vl_ktype = {
 
 #define QIB_DIAGC_ATTR(N) \
 	static struct qib_diagc_attr qib_diagc_attr_##N = { \
-		.attr = { .name = __stringify(N), .mode = 0444 }, \
+		.attr = { .name = __stringify(N), .mode = 0664 }, \
 		.counter = offsetof(struct qib_ibport, n_##N) \
 	}
 
@@ -403,8 +403,26 @@ static ssize_t diagc_attr_show(struct kobject *kobj, struct attribute *attr,
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
+	long val = simple_strtol(buf, NULL, 0);
+
+	if (val < 0)
+		return -EINVAL;
+
+	*(u32 *)((char *)qibp + dattr->counter) = (u32)val;
+	return strnlen(buf, PAGE_SIZE);
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
