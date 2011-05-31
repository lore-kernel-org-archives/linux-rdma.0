From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/qib: add sysfs interface to read free contexts
Date: Tue, 31 May 2011 16:20:43 -0400
Message-ID: <20110531202043.13877.90388.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Ram Vepa <ram.vepa-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

Indicate the number of free user contexts via the sysfs file
/sys/class/infiniband/qib0/nfreectxts as required for PSM.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_sysfs.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_sysfs.c b/drivers/infiniband/hw/qib/qib_sysfs.c
index d50a33f..14d129d 100644
--- a/drivers/infiniband/hw/qib/qib_sysfs.c
+++ b/drivers/infiniband/hw/qib/qib_sysfs.c
@@ -507,6 +507,18 @@ static ssize_t show_nctxts(struct device *device,
 		dd->first_user_ctxt);
 }
 
+static ssize_t show_nfreectxts(struct device *device,
+			   struct device_attribute *attr, char *buf)
+{
+	struct qib_ibdev *dev =
+		container_of(device, struct qib_ibdev, ibdev.dev);
+	struct qib_devdata *dd = dd_from_dev(dev);
+
+	/* Return the number of free user ports (contexts) available. */
+	return scnprintf(buf, PAGE_SIZE, "%u\n", dd->cfgctxts -
+		dd->first_user_ctxt - (u32)qib_stats.sps_ctxts);
+}
+
 static ssize_t show_serial(struct device *device,
 			   struct device_attribute *attr, char *buf)
 {
@@ -604,6 +616,7 @@ static DEVICE_ATTR(hca_type, S_IRUGO, show_hca, NULL);
 static DEVICE_ATTR(board_id, S_IRUGO, show_hca, NULL);
 static DEVICE_ATTR(version, S_IRUGO, show_version, NULL);
 static DEVICE_ATTR(nctxts, S_IRUGO, show_nctxts, NULL);
+static DEVICE_ATTR(nfreectxts, S_IRUGO, show_nfreectxts, NULL);
 static DEVICE_ATTR(serial, S_IRUGO, show_serial, NULL);
 static DEVICE_ATTR(boardversion, S_IRUGO, show_boardversion, NULL);
 static DEVICE_ATTR(logged_errors, S_IRUGO, show_logged_errs, NULL);
@@ -617,6 +630,7 @@ static struct device_attribute *qib_attributes[] = {
 	&dev_attr_board_id,
 	&dev_attr_version,
 	&dev_attr_nctxts,
+	&dev_attr_nfreectxts,
 	&dev_attr_serial,
 	&dev_attr_boardversion,
 	&dev_attr_logged_errors,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
