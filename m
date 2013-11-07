From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCHv3] IB/srp: add change_queue_depth and change_queue_type support
Date: Thu, 07 Nov 2013 11:37:37 +0100
Message-ID: <527B6D71.3020805@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020201080405020504000106"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------020201080405020504000106
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Roland,

Could you include this patch? I update with tested-by from Bart and
acked-by from David.

>From e8d655fec4ac74a6af6a0b2471173c74e7c13f51 Mon Sep 17 00:00:00 2001
From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Date: Mon, 26 Aug 2013 15:50:03 +0200
Subject: [PATCH] IB/srp: add change_queue_depth/change_queue_type support

Currently, it's not possible to change queue depth for device
behind SRP host. Sometimes, we need to adjust queue_depth for
performance reason(eg storage busy, we need lower queue_depth
to avoid running into SCSI error handler), so this patch add
support for SRP driver.

Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Tested-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Acked-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   54
+++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c
b/drivers/infiniband/ulp/srp/ib_srp.c
index 06a3e4b..2713e02 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -47,6 +47,7 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_dbg.h>
+#include <scsi/scsi_tcq.h>
 #include <scsi/srp.h>
 #include <scsi/scsi_transport_srp.h>

@@ -1875,6 +1876,57 @@ static int srp_cm_handler(struct ib_cm_id *cm_id,
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
+	struct Scsi_Host *shost = sdev->host;
+	int max_depth;
+	if (reason == SCSI_QDEPTH_DEFAULT || reason == SCSI_QDEPTH_RAMP_UP) {
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
+
 static int srp_send_tsk_mgmt(struct srp_target_port *target,
 			     u64 req_tag, unsigned int lun, u8 func)
 {
@@ -2260,6 +2312,8 @@ static struct scsi_host_template srp_template = {
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

--------------020201080405020504000106
Content-Type: text/x-patch;
 name="0001-IB-srp-add-change_queue_depth-change_queue_type-supp.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-IB-srp-add-change_queue_depth-change_queue_type-supp.pa";
 filename*1="tch"

>From e8d655fec4ac74a6af6a0b2471173c74e7c13f51 Mon Sep 17 00:00:00 2001
From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Date: Mon, 26 Aug 2013 15:50:03 +0200
Subject: [PATCH] IB/srp: add change_queue_depth/change_queue_type support

Currently, it's not possible to change queue depth for device
behind SRP host. Sometimes, we need to adjust queue_depth for
performance reason(eg storage busy, we need lower queue_depth
to avoid running into SCSI error handler), so this patch add
support for SRP driver.

Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Tested-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Acked-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   54 +++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 06a3e4b..2713e02 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -47,6 +47,7 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_dbg.h>
+#include <scsi/scsi_tcq.h>
 #include <scsi/srp.h>
 #include <scsi/scsi_transport_srp.h>
 
@@ -1875,6 +1876,57 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
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
+	struct Scsi_Host *shost = sdev->host;
+	int max_depth;
+	if (reason == SCSI_QDEPTH_DEFAULT || reason == SCSI_QDEPTH_RAMP_UP) {
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
+
 static int srp_send_tsk_mgmt(struct srp_target_port *target,
 			     u64 req_tag, unsigned int lun, u8 func)
 {
@@ -2260,6 +2312,8 @@ static struct scsi_host_template srp_template = {
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


--------------020201080405020504000106--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
