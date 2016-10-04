From: Gioh Kim <gi-oh.kim@profitbricks.com>
Subject: [RFC] IB/srp: export reset-host via sysfs
Date: Tue,  4 Oct 2016 16:00:09 +0200
Message-ID: <1475589609-26451-1-git-send-email-gi-oh.kim@profitbricks.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: bart.vanassche@sandisk.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Gioh Kim <gi-oh.kim@profitbricks.com>
List-Id: linux-rdma@vger.kernel.org

Standard SCSI device has host_reset sysfs interface.
This patch exports the host_reset interface for upper layer.

Signed-off-by: Gioh Kim <gi-oh.kim@profitbricks.com>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 3322ed7..92e6c3f 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2628,6 +2628,15 @@ static int srp_reset_device(struct scsi_cmnd *scmnd)
 	return SUCCESS;
 }
 
+static int srp_scsi_host_reset(struct Scsi_Host *shost, int reset_type)
+{
+	struct srp_target_port *target = host_to_target(shost);
+
+	shost_printk(KERN_EMERG, target->scsi_host, PFX "SRP reset_host called\n");
+
+	return srp_reconnect_rport(target->rport);
+}
+
 static int srp_reset_host(struct scsi_cmnd *scmnd)
 {
 	struct srp_target_port *target = host_to_target(scmnd->device->host);
@@ -2858,6 +2867,7 @@ static struct scsi_host_template srp_template = {
 	.use_clustering			= ENABLE_CLUSTERING,
 	.shost_attrs			= srp_host_attrs,
 	.track_queue_depth		= 1,
+	.host_reset			= srp_scsi_host_reset,
 };
 
 static int srp_sdev_count(struct Scsi_Host *host)
-- 
2.5.0
