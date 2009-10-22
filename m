From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [ofa-general][PATCH 3/4] SRP fail-over faster
Date: Thu, 22 Oct 2009 16:13:34 -0700
Message-ID: <4AE0E71E.20309@mellanox.com>
References: <4AD3B453.3030109@mellanox.com> <ada1vl5alqh.fsf@cisco.com> <4AD63681.6080901@mellanox.com> <adaljjd8zrj.fsf@cisco.com> <4AD63DB1.3060906@mellanox.com> <adahbu18uf5.fsf@cisco.com> <1255570760.13845.4.camel@obelisk.thedillows.org> <4AD74C88.8030604@mellanox.com> <1255634715.29829.9.camel@lap75545.ornl.gov> <20091015213512.GW5191@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050203040503010704060205"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091015213512.GW5191-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------050203040503010704060205
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Jason Gunthorpe wrote:
> On Thu, Oct 15, 2009 at 03:25:15PM -0400, David Dillow wrote:
>   
>> On Thu, 2009-10-15 at 09:23 -0700, Vu Pham wrote:
>>     
>>> David Dillow wrote:
>>>       
>>>> And if I want to disable this completely?
>>>>   
>>>>         
>>> Unless these patches are bad and affect the stability of the driver, why 
>>> do you want to disable it? If you don't use multipath/device-mapper and 
>>> use /dev/sd**, everything will be  same
>>>       
>> I use multipath with ALUA, and I don't mind if the link flaps a bit. 60
>> seconds is near my SCSI timeout of 77 seconds, so it doesn't buy me
>> much. I'd rather multipath be delivering traffic to the backup path than
>> sitting on its thumbs for 60 seconds doing nothing.
>>     
>
> I've been left with a similar impression for several multipath things
> I've seen in the past. True active/active multipath setups should have
> a shorter timeout - there is no penalty for directing more traffic to
> the 2nd path (the paths should be load balancing existing traffic in
> the standard case anyhow).
>
> An active/passive configuration might be different...
>
> Certainly an enforced lower limit in the kernel is silly, and a
> per-device setting does make some sense.
>
> Jason
>   
Here is the updated patch which implement the device_loss_timeout for 
each target instead of module parameter. It also reflects changes from 
previous feedbacks. Please review



--------------050203040503010704060205
Content-Type: text/plain;
 name="srp_3_device_loss_timeout.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="srp_3_device_loss_timeout.patch"

Introducing device_loss_timeout per target granuality. Creating a timer to
clean up connection after device_loss_timeout expired. During
device_loss_timeout, the QP is in error state, srp will return DID_RESET
for outstanding I/Os and return FAILED for abort_cmd, reset_lun, and return
SUCCESS (without retrying reconnect) on reset_host
    
Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

-----------------------------------------------------------------------

drivers/infiniband/ulp/srp/ib_srp.c |   94 ++++++++++++++++++++++++++++++++++-
 drivers/infiniband/ulp/srp/ib_srp.h |    3 +
 2 files changed, 95 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index e44939a..12404d5 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -433,6 +433,10 @@ static void srp_remove_work(struct work_struct *work)
 		return;
 	}
 	target->state = SRP_TARGET_REMOVED;
+
+	if (timer_pending(&target->qp_err_timer))
+		del_timer_sync(&target->qp_err_timer);
+
 	spin_unlock_irq(target->scsi_host->host_lock);
 
 	spin_lock(&target->srp_host->target_lock);
@@ -896,6 +900,50 @@ static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
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
@@ -904,11 +952,19 @@ static void srp_completion(struct ib_cq *cq, void *target_ptr)
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
+				srp_qp_err_add_timer(target, 5);
+			}
+			spin_unlock_irqrestore(target->scsi_host->host_lock, flags);
 			break;
 		}
 
@@ -1212,6 +1268,7 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 	int attr_mask = 0;
 	int comp = 0;
 	int opcode = 0;
+	unsigned long flags;
 
 	switch (event->event) {
 	case IB_CM_REQ_ERROR:
@@ -1299,6 +1356,13 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 		shost_printk(KERN_ERR, target->scsi_host,
 			     PFX "connection closed\n");
 
+		spin_lock_irqsave(target->scsi_host->host_lock, flags);
+		if (!target->qp_in_error &&
+		    target->state == SRP_TARGET_LIVE) {
+			target->qp_in_error = 1;
+			srp_qp_err_add_timer(target, 5);
+		}
+		spin_unlock_irqrestore(target->scsi_host->host_lock, flags);
 		target->status = 0;
 		break;
 
@@ -1441,9 +1505,22 @@ static int srp_reset_device(struct scsi_cmnd *scmnd)
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
@@ -1657,6 +1734,7 @@ enum {
 	SRP_OPT_MAX_CMD_PER_LUN	= 1 << 6,
 	SRP_OPT_IO_CLASS	= 1 << 7,
 	SRP_OPT_INITIATOR_EXT	= 1 << 8,
+	SRP_OPT_DEVICE_LOSS_TMO	= 1 << 9,
 	SRP_OPT_ALL		= (SRP_OPT_ID_EXT	|
 				   SRP_OPT_IOC_GUID	|
 				   SRP_OPT_DGID		|
@@ -1674,6 +1752,7 @@ static const match_table_t srp_opt_tokens = {
 	{ SRP_OPT_MAX_CMD_PER_LUN,	"max_cmd_per_lun=%d" 	},
 	{ SRP_OPT_IO_CLASS,		"io_class=%x"		},
 	{ SRP_OPT_INITIATOR_EXT,	"initiator_ext=%s"	},
+	{ SRP_OPT_DEVICE_LOSS_TMO,	"device_loss_timeout=%d"},
 	{ SRP_OPT_ERR,			NULL 			}
 };
 
@@ -1801,6 +1880,14 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 			kfree(p);
 			break;
 
+		case SRP_OPT_DEVICE_LOSS_TMO:
+			if (match_int(args, &token)) {
+				printk(KERN_WARNING PFX "bad device loss timeout '%s'\n", p);
+				goto out;
+			}
+			target->device_loss_timeout = token;
+			break;
+
 		default:
 			printk(KERN_WARNING PFX "unknown parameter or missing value "
 			       "'%s' in target creation request\n", p);
@@ -1860,6 +1947,9 @@ static ssize_t srp_create_target(struct device *dev,
 	if (ret)
 		goto err;
 
+	if (target->device_loss_timeout <= 0)
+		target->device_loss_timeout = 30;
+
 	ib_query_gid(host->srp_dev->dev, host->port, 0, &target->path.sgid);
 
 	shost_printk(KERN_DEBUG, target->scsi_host, PFX
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index e185b90..daa4bf7 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -153,12 +153,15 @@ struct srp_target_port {
 	struct srp_request	req_ring[SRP_SQ_SIZE];
 
 	struct work_struct	work;
+	int			work_in_progress;
 
 	struct list_head	list;
 	struct completion	done;
 	int			status;
 	enum srp_target_state	state;
 	int			qp_in_error;
+	struct timer_list	qp_err_timer;
+	int			device_loss_timeout;
 };
 
 struct srp_iu {

--------------050203040503010704060205--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
