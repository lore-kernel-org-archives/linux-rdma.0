From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 19/19] scsi_transport_srp: Fail I/O faster
Date: Fri, 26 Oct 2012 14:58:42 +0200
Message-ID: <508A8902.4010804@acm.org>
References: <508A85BB.1000505@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <508A85BB.1000505-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Start the transport layer failure timer if a SCSI timeout occurs.

Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 drivers/scsi/scsi_transport_srp.c |   95 ++++++++++++++++++++++++++-----------
 include/scsi/scsi_transport_srp.h |    1 -
 2 files changed, 68 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 8b452c6..a96647a 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -29,12 +29,15 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
+#include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_transport_srp.h>
 #include "scsi_priv.h"
 #include "scsi_transport_srp_internal.h"
 
 struct srp_host_attrs {
-	atomic_t next_port_id;
+	atomic_t	 next_port_id;
+	spinlock_t	 lock; /* protects rport */
+	struct srp_rport *rport;
 };
 #define to_srp_host_attrs(host)	((struct srp_host_attrs *)(host)->shost_data)
 
@@ -67,6 +70,9 @@ static int srp_host_setup(struct transport_container *tc, struct device *dev,
 	struct srp_host_attrs *srp_host = to_srp_host_attrs(shost);
 
 	atomic_set(&srp_host->next_port_id, 0);
+	spin_lock_init(&srp_host->lock);
+	srp_host->rport = NULL;
+
 	return 0;
 }
 
@@ -308,6 +314,45 @@ void srp_stop_tl_fail_timers(struct srp_rport *rport)
 }
 EXPORT_SYMBOL(srp_stop_tl_fail_timers);
 
+/**
+ * srp_timed_out - SRP transport intercept of the SCSI timeout EH
+ *
+ * If a timeout occurs while an rport is in the blocked state, ask the SCSI
+ * EH to continue waiting (BLK_EH_RESET_TIMER). Otherwise let the SCSI core
+ * handle the timeout (BLK_EH_NOT_HANDLED). Also, if the rport is still
+ * present, start the SRP transport layer failure timers taking the time that
+ * has already elapsed into account.
+ *
+ * Note: This function is called from soft-IRQ context and with the request
+ * queue lock held.
+ */
+static enum blk_eh_timer_return srp_timed_out(struct scsi_cmnd *scmd)
+{
+	struct scsi_device *sdev = scmd->device;
+	struct srp_host_attrs *srp_host = to_srp_host_attrs(sdev->host);
+	struct srp_rport *rport;
+	struct request *req = scmd->request;
+	unsigned long flags;
+	enum blk_eh_timer_return rtn;
+
+	spin_lock_irqsave(&srp_host->lock, flags);
+	rport = srp_host->rport;
+	pr_err("%s() called for shost %s / rport %s\n", __func__,
+	       dev_name(&sdev->host->shost_gendev),
+	       rport ? dev_name(&rport->dev) : "(deleted)");
+	if (!rport) {
+		rtn = BLK_EH_NOT_HANDLED;
+	} else if (scsi_device_blocked(sdev)) {
+		rtn = BLK_EH_RESET_TIMER;
+	} else {
+		srp_start_tl_fail_timers(rport, req->timeout);
+		rtn = BLK_EH_NOT_HANDLED;
+	}
+	spin_unlock_irqrestore(&srp_host->lock, flags);
+
+	return rtn;
+}
+
 static void srp_rport_release(struct device *dev)
 {
 	struct srp_rport *rport = dev_to_rport(dev);
@@ -370,6 +415,7 @@ struct srp_rport *srp_rport_add(struct Scsi_Host *shost,
 {
 	struct srp_rport *rport;
 	struct device *parent = &shost->shost_gendev;
+	struct srp_host_attrs *srp_host = to_srp_host_attrs(shost);
 	int id, ret;
 
 	rport = kzalloc(sizeof(*rport), GFP_KERNEL);
@@ -395,6 +441,10 @@ struct srp_rport *srp_rport_add(struct Scsi_Host *shost,
 
 	transport_setup_device(&rport->dev);
 
+	spin_lock_irq(&srp_host->lock);
+	srp_host->rport = rport;
+	spin_unlock_irq(&srp_host->lock);
+
 	ret = device_add(&rport->dev);
 	if (ret) {
 		transport_destroy_device(&rport->dev);
@@ -422,50 +472,39 @@ struct srp_rport *srp_rport_add(struct Scsi_Host *shost,
 EXPORT_SYMBOL_GPL(srp_rport_add);
 
 /**
- * srp_rport_del  -  remove a SRP remote port
- * @rport:	SRP remote port to remove
+ * srp_remove_host  -  tear down a Scsi_Host's SRP data structures
+ * @shost:	Scsi Host that is torn down
  *
- * Removes the specified SRP remote port.
+ * Removes all SRP remote ports for a given Scsi_Host.
+ * Must be called just before scsi_remove_host for SRP HBAs.
  */
-void srp_rport_del(struct srp_rport *rport)
+void srp_remove_host(struct Scsi_Host *shost)
 {
+	struct srp_host_attrs *srp_host = to_srp_host_attrs(shost);
+	struct srp_rport *rport = srp_host->rport;
 	struct device *dev = &rport->dev;
-	struct Scsi_Host *shost = dev_to_shost(dev->parent);
+
+	BUG_ON(!rport);
 
 	device_remove_file(dev, &dev_attr_fast_io_fail_tmo);
 	device_remove_file(dev, &dev_attr_dev_loss_tmo);
-	srp_stop_tl_fail_timers(rport);
 	scsi_target_unblock(rport->dev.parent, SDEV_RUNNING);
 
 	if (shost->active_mode & MODE_TARGET &&
 	    rport->roles == SRP_RPORT_ROLE_INITIATOR)
 		srp_tgt_it_nexus_destroy(shost, (unsigned long)rport);
 
+	spin_lock_irq(&srp_host->lock);
+	srp_host->rport = NULL;
+	spin_unlock_irq(&srp_host->lock);
+
+	srp_stop_tl_fail_timers(rport);
+
 	transport_remove_device(dev);
 	device_del(dev);
 	transport_destroy_device(dev);
 	put_device(dev);
 }
-EXPORT_SYMBOL_GPL(srp_rport_del);
-
-static int do_srp_rport_del(struct device *dev, void *data)
-{
-	if (scsi_is_srp_rport(dev))
-		srp_rport_del(dev_to_rport(dev));
-	return 0;
-}
-
-/**
- * srp_remove_host  -  tear down a Scsi_Host's SRP data structures
- * @shost:	Scsi Host that is torn down
- *
- * Removes all SRP remote ports for a given Scsi_Host.
- * Must be called just before scsi_remove_host for SRP HBAs.
- */
-void srp_remove_host(struct Scsi_Host *shost)
-{
-	device_for_each_child(&shost->shost_gendev, NULL, do_srp_rport_del);
-}
 EXPORT_SYMBOL_GPL(srp_remove_host);
 
 static int srp_tsk_mgmt_response(struct Scsi_Host *shost, u64 nexus, u64 tm_id,
@@ -495,6 +534,8 @@ srp_attach_transport(struct srp_function_template *ft)
 	if (!i)
 		return NULL;
 
+	i->t.eh_timed_out = srp_timed_out;
+
 	i->t.tsk_mgmt_response = srp_tsk_mgmt_response;
 	i->t.it_nexus_response = srp_it_nexus_response;
 
diff --git a/include/scsi/scsi_transport_srp.h b/include/scsi/scsi_transport_srp.h
index eb996db..c019e93 100644
--- a/include/scsi/scsi_transport_srp.h
+++ b/include/scsi/scsi_transport_srp.h
@@ -46,7 +46,6 @@ extern void srp_release_transport(struct scsi_transport_template *);
 
 extern struct srp_rport *srp_rport_add(struct Scsi_Host *,
 				       struct srp_rport_identifiers *);
-extern void srp_rport_del(struct srp_rport *);
 extern void srp_start_tl_fail_timers(struct srp_rport *rport, int elapsed);
 extern void srp_stop_tl_fail_timers(struct srp_rport *rport);
 
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
