From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [ofa-general][PATCH 3/4] SRP fail-over faster
Date: Mon, 12 Oct 2009 15:57:23 -0700
Message-ID: <4AD3B453.3030109@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010602060305020904060708"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------010602060305020904060708
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------010602060305020904060708
Content-Type: message/rfc822;
 name="[ofa-general][PATCH 3/4] SRP fail-over faster,.eml"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="[ofa-general][PATCH 3/4] SRP fail-over faster,.eml"

Message-ID: <4AD3B1E0.5040305-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Mon, 12 Oct 2009 15:46:56 -0700
From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: OF General <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
CC: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [ofa-general][PATCH 3/4] SRP fail-over faster,
Content-Type: multipart/mixed;
 boundary="------------000702090402010801080709"

This is a multi-part message in MIME format.
--------------000702090402010801080709
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Introducing srp_dev_loss_tmo module parameter. Creating a timer to clean 
up connection after srp_dev_loss_tmo expired. During srp_dev_loss_tmo, 
the qp is in error state, srp will return DID_RESET for outstanding I/O 
and return FAILED for abort_cmd, reset_lun, and return SUCCESS (without 
trying reconnect) on reset_host.

Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>



--------------000702090402010801080709
Content-Type: text/plain;
 name="srp_3_dev_loss_tmo.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="srp_3_dev_loss_tmo.patch"

Index: ofed_kernel/drivers/infiniband/ulp/srp/ib_srp.c
===================================================================
--- ofed_kernel.orig/drivers/infiniband/ulp/srp/ib_srp.c
+++ ofed_kernel/drivers/infiniband/ulp/srp/ib_srp.c
@@ -78,6 +77,13 @@
 MODULE_PARM_DESC(mellanox_workarounds,
 		 "Enable workarounds for Mellanox SRP target bugs if != 0");
 
+static int srp_dev_loss_tmo = 60;
+
+module_param(srp_dev_loss_tmo, int, 0444);
+MODULE_PARM_DESC(srp_dev_loss_tmo,
+		 "Default number of seconds that srp transport should \
+		  insulate the lost of a remote port (default is 60 secs");
+
 static void srp_add_one(struct ib_device *device);
 static void srp_remove_one(struct ib_device *device);
 static void srp_completion(struct ib_cq *cq, void *target_ptr);
@@ -898,6 +926,48 @@
 				      DMA_FROM_DEVICE);
 }
 
+static void srp_reconnect_work(struct work_struct *work)
+{
+	struct srp_target_port *target =
+		container_of(work, struct srp_target_port, work);
+
+	srp_reconnect_target(target);
+	target->work_in_progress = 0;
+}
+
+static void srp_qp_in_err_timer(unsigned long data)
+{
+	struct srp_target_port *target = (struct srp_target_port *)data;
+	struct srp_request *req, *tmp;
+
+	if (target->state != SRP_TARGET_LIVE)
+		return;
+
+	spin_lock_irq(target->scsi_host->host_lock);
+	list_for_each_entry_safe(req, tmp, &target->req_queue, list)
+		srp_reset_req(target, req);
+	spin_unlock_irq(target->scsi_host->host_lock);
+
+	spin_lock_irq(target->scsi_host->host_lock);
+	if (!target->work_in_progress) {
+		target->work_in_progress = 1;
+		INIT_WORK(&target->work, srp_reconnect_work);
+		schedule_work(&target->work);
+	}
+	spin_unlock_irq(target->scsi_host->host_lock);
+}
+
+static void srp_qp_err_add_timer(struct srp_target_port *target, int time)
+{
+	if (!timer_pending(&target->qp_err_timer)) {
+		setup_timer(&target->qp_err_timer,
+			    srp_qp_in_err_timer,
+			    (unsigned long)target);
+		target->qp_err_timer.expires = time * HZ + jiffies;
+		add_timer(&target->qp_err_timer);
+	}
+}
+
 static void srp_completion(struct ib_cq *cq, void *target_ptr)
 {
 	struct srp_target_port *target = target_ptr;
@@ -960,11 +980,20 @@
 	ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
 	while (ib_poll_cq(cq, 1, &wc) > 0) {
 		if (wc.status) {
+			unsigned long flags;
+
 			shost_printk(KERN_ERR, target->scsi_host,
 				     PFX "failed %s status %d\n",
 				     wc.wr_id & SRP_OP_RECV ? "receive" : "send",
 				     wc.status);
-			target->qp_in_error = 1;
+			spin_lock_irqsave(target->scsi_host->host_lock, flags);
+			if (!target->qp_in_error &&
+			    target->state == SRP_TARGET_LIVE) {
+				target->qp_in_error = 1;
+				srp_qp_err_add_timer(target,
+						     srp_dev_loss_tmo - 55);
+			}
+			spin_unlock_irqrestore(target->scsi_host->host_lock, flags);
 			break;
 		}
 
@@ -1274,5 +1299,6 @@
 	int attr_mask = 0;
 	int comp = 0;
 	int opcode = 0;
+	unsigned long flags;
 
 	switch (event->event) {
@@ -1301,6 +1381,14 @@
 		shost_printk(KERN_ERR, target->scsi_host,
 			     PFX "connection closed\n");
 
+		spin_lock_irqsave(target->scsi_host->host_lock, flags);
+		if (!target->qp_in_error &&
+		    target->state == SRP_TARGET_LIVE) {
+			target->qp_in_error = 1;
+			srp_qp_err_add_timer(target,
+					     srp_dev_loss_tmo - 55);
+		}
+		spin_unlock_irqrestore(target->scsi_host->host_lock, flags);
 		target->status = 0;
 		break;
 
@@ -1443,9 +1529,22 @@
 static int srp_reset_host(struct scsi_cmnd *scmnd)
 {
 	struct srp_target_port *target = host_to_target(scmnd->device->host);
+	struct srp_request *req, *tmp;
 	int ret = FAILED;
 
-	shost_printk(KERN_ERR, target->scsi_host, PFX "SRP reset_host called\n");
+	shost_printk(KERN_ERR, target->scsi_host,
+		     PFX "SRP reset_host called state %d qp_err %d\n",
+		     target->state, target->qp_in_error);
+
+	spin_lock_irq(target->scsi_host->host_lock);
+	if (timer_pending(&target->qp_err_timer) || target->qp_in_error ||
+	    target->state != SRP_TARGET_LIVE) {
+		list_for_each_entry_safe(req, tmp, &target->req_queue, list)
+			srp_reset_req(target, req);
+		spin_unlock_irq(target->scsi_host->host_lock);
+		return SUCCESS;
+	}
+	spin_unlock_irq(target->scsi_host->host_lock);
 
 	if (!srp_reconnect_target(target))
 		ret = SUCCESS;
@@ -2150,6 +2342,9 @@
 			  sizeof (struct srp_indirect_buf) +
 			  srp_sg_tablesize * 16);
 
+	if (srp_dev_loss_tmo < 60)
+		srp_dev_loss_tmo = 60;
+
 	ret = class_register(&srp_class);
 	if (ret) {
 		printk(KERN_ERR PFX "couldn't register class infiniband_srp\n");
Index: ofed_kernel/drivers/infiniband/ulp/srp/ib_srp.h
===================================================================
--- ofed_kernel.orig/drivers/infiniband/ulp/srp/ib_srp.h
+++ ofed_kernel/drivers/infiniband/ulp/srp/ib_srp.h
@@ -153,12 +159,14 @@
 	struct srp_request	req_ring[SRP_SQ_SIZE];
 
 	struct work_struct	work;
+	int			work_in_progress;
 
 	struct list_head	list;
 	struct completion	done;
 	int			status;
 	enum srp_target_state	state;
 	int			qp_in_error;
+	struct timer_list	qp_err_timer;
 };
 
 struct srp_iu {

--------------000702090402010801080709--


--------------010602060305020904060708--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
