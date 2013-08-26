From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH] IB/srp: add change_queue_depth and change_queue_type support
Date: Mon, 26 Aug 2013 15:53:25 +0200
Message-ID: <521B5DD5.3020804@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000302020102090501040607"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------000302020102090501040607
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Attached patch add change_queue_depth/change_queue_type function support
for srp driver, as what most modern scsi host driver does.

>From 10445c9fd9e24d03269e43680bcd2504c713b622 Mon Sep 17 00:00:00 2001
From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Date: Mon, 26 Aug 2013 15:50:03 +0200
Subject: [PATCH] IB/srp: add change_queue_depth/change_queue_type support

Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   53
+++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c
b/drivers/infiniband/ulp/srp/ib_srp.c
index f93baf8..e2c2781 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -46,6 +46,7 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_dbg.h>
+#include <scsi/scsi_tcq.h>
 #include <scsi/srp.h>
 #include <scsi/scsi_transport_srp.h>

@@ -1697,6 +1698,56 @@ static int srp_cm_handler(struct ib_cm_id *cm_id,
struct ib_cm_event *event)

 	return 0;
 }
+/**
+ * srp_change_queue_type - changing device queue tag type
+ * @sdev: scsi device struct
+ * @tag_type: requested tag type
+ *
+ * Returns queue tag type.
+ */
+static int
+srp_change_queue_type(struct scsi_device *sdev, int tag_type)
+{
+	if (sdev->tagged_supported) {
+		scsi_set_tag_type(sdev, tag_type);
+		if (tag_type)
+			scsi_activate_tcq(sdev, sdev->queue_depth);
+		else
+			scsi_deactivate_tcq(sdev, sdev->queue_depth);
+	} else
+		tag_type = 0;
+
+	return tag_type;
+}
+
+/**
+ * srp_change_queue_depth - setting device queue depth
+ * @sdev: scsi device struct
+ * @qdepth: requested queue depth
+ * @reason: SCSI_QDEPTH_DEFAULT/SCSI_QDEPTH_QFULL/SCSI_QDEPTH_RAMP_UP
+ * (see include/scsi/scsi_host.h for definition)
+ *
+ * Returns queue depth.
+ */
+static int
+srp_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
+{
+	if (reason == SCSI_QDEPTH_DEFAULT || reason == SCSI_QDEPTH_RAMP_UP) {
+		struct Scsi_Host *shost = sdev->host;
+		int max_depth;
+		max_depth = shost->can_queue;
+		if (!sdev->tagged_supported)
+			max_depth = 1;
+		if (qdepth > max_depth)
+			qdepth = max_depth;
+		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
+	} else if (reason == SCSI_QDEPTH_QFULL)
+		scsi_track_queue_full(sdev, qdepth);
+	else
+		return -EOPNOTSUPP;
+
+	return sdev->queue_depth;
+}

 static int srp_send_tsk_mgmt(struct srp_target_port *target,
 			     u64 req_tag, unsigned int lun, u8 func)
@@ -1961,6 +2012,8 @@ static struct scsi_host_template srp_template = {
 	.slave_configure		= srp_slave_configure,
 	.info				= srp_target_info,
 	.queuecommand			= srp_queuecommand,
+	.change_queue_depth             = srp_change_queue_depth,
+	.change_queue_type              = srp_change_queue_type,
 	.eh_abort_handler		= srp_abort,
 	.eh_device_reset_handler	= srp_reset_device,
 	.eh_host_reset_handler		= srp_reset_host,
-- 
1.7.10.4

--------------000302020102090501040607
Content-Type: text/x-patch;
 name="0001-IB-srp-add-change_queue_depth-change_queue_type-supp.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-IB-srp-add-change_queue_depth-change_queue_type-supp.pa";
 filename*1="tch"

>From 10445c9fd9e24d03269e43680bcd2504c713b622 Mon Sep 17 00:00:00 2001
From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Date: Mon, 26 Aug 2013 15:50:03 +0200
Subject: [PATCH] IB/srp: add change_queue_depth/change_queue_type support

Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   53 +++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index f93baf8..e2c2781 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -46,6 +46,7 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_dbg.h>
+#include <scsi/scsi_tcq.h>
 #include <scsi/srp.h>
 #include <scsi/scsi_transport_srp.h>
 
@@ -1697,6 +1698,56 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 
 	return 0;
 }
+/**
+ * srp_change_queue_type - changing device queue tag type
+ * @sdev: scsi device struct
+ * @tag_type: requested tag type
+ *
+ * Returns queue tag type.
+ */
+static int
+srp_change_queue_type(struct scsi_device *sdev, int tag_type)
+{
+	if (sdev->tagged_supported) {
+		scsi_set_tag_type(sdev, tag_type);
+		if (tag_type)
+			scsi_activate_tcq(sdev, sdev->queue_depth);
+		else
+			scsi_deactivate_tcq(sdev, sdev->queue_depth);
+	} else
+		tag_type = 0;
+
+	return tag_type;
+}
+
+/**
+ * srp_change_queue_depth - setting device queue depth
+ * @sdev: scsi device struct
+ * @qdepth: requested queue depth
+ * @reason: SCSI_QDEPTH_DEFAULT/SCSI_QDEPTH_QFULL/SCSI_QDEPTH_RAMP_UP
+ * (see include/scsi/scsi_host.h for definition)
+ *
+ * Returns queue depth.
+ */
+static int
+srp_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
+{
+	if (reason == SCSI_QDEPTH_DEFAULT || reason == SCSI_QDEPTH_RAMP_UP) {
+		struct Scsi_Host *shost = sdev->host;
+		int max_depth;
+		max_depth = shost->can_queue;
+		if (!sdev->tagged_supported)
+			max_depth = 1;
+		if (qdepth > max_depth)
+			qdepth = max_depth;
+		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
+	} else if (reason == SCSI_QDEPTH_QFULL)
+		scsi_track_queue_full(sdev, qdepth);
+	else
+		return -EOPNOTSUPP;
+
+	return sdev->queue_depth;
+}
 
 static int srp_send_tsk_mgmt(struct srp_target_port *target,
 			     u64 req_tag, unsigned int lun, u8 func)
@@ -1961,6 +2012,8 @@ static struct scsi_host_template srp_template = {
 	.slave_configure		= srp_slave_configure,
 	.info				= srp_target_info,
 	.queuecommand			= srp_queuecommand,
+	.change_queue_depth             = srp_change_queue_depth,
+	.change_queue_type              = srp_change_queue_type,
 	.eh_abort_handler		= srp_abort,
 	.eh_device_reset_handler	= srp_reset_device,
 	.eh_host_reset_handler		= srp_reset_host,
-- 
1.7.10.4


--------------000302020102090501040607--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
