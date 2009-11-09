From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 4/6]  SRP setup timer to propagate errors and
 clean up connection resources
Date: Mon, 09 Nov 2009 13:33:43 -0800
Message-ID: <4AF88AB7.30108@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030709060508010306050905"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------030709060508010306050905
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Creating a timer to propagate I/O errors up and clean up connection
after a timeout (normally target->device_loss_timeout) expired.
During this timeout while the qp is in error state, srp will return
DID_RESET for outstanding I/Os, return FAILED for abort_cmd, reset_lun,
and return SUCCESS (without retrying reconnect) on reset_host

Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>


--------------030709060508010306050905
Content-Type: text/plain;
 name="srp_4_qp_in_error_timer.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="srp_4_qp_in_error_timer.patch"

 drivers/infiniband/ulp/srp/ib_srp.c |   61 ++++++++++++++++++++++++++++++++++-
 drivers/infiniband/ulp/srp/ib_srp.h |    2 +
 2 files changed, 62 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 047d488..3475a8b 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -435,6 +435,8 @@ static void srp_remove_work(struct work_struct *work)
 	target->state = SRP_TARGET_REMOVED;
 	spin_unlock_irq(target->scsi_host->host_lock);
 
+	del_timer_sync(&target->qp_err_timer);
+
 	spin_lock(&target->srp_host->target_lock);
 	list_del(&target->list);
 	spin_unlock(&target->srp_host->target_lock);
@@ -896,6 +898,50 @@ static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 				      DMA_FROM_DEVICE);
 }
 
+static void srp_reconnect_work(struct work_struct *work)
+{
+	struct srp_target_port *target =
+		container_of(work, struct srp_target_port, work);
+
+	srp_reconnect_target(target);
+	spin_lock_irq(target->scsi_host->host_lock);
+	target->work_in_progress = 0;
+	spin_unlock_irq(target->scsi_host->host_lock);
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
+		target->qp_err_timer.expires = round_jiffies(time*HZ + jiffies);
+		add_timer(&target->qp_err_timer);
+	}
+}
+
 static void srp_completion(struct ib_cq *cq, void *target_ptr)
 {
 	struct srp_target_port *target = target_ptr;
@@ -1440,9 +1486,22 @@ static int srp_reset_device(struct scsi_cmnd *scmnd)
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
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 92db025..daa4bf7 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -153,12 +153,14 @@ struct srp_target_port {
 	struct srp_request	req_ring[SRP_SQ_SIZE];
 
 	struct work_struct	work;
+	int			work_in_progress;
 
 	struct list_head	list;
 	struct completion	done;
 	int			status;
 	enum srp_target_state	state;
 	int			qp_in_error;
+	struct timer_list	qp_err_timer;
 	int			device_loss_timeout;
 };
 

--------------030709060508010306050905--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
