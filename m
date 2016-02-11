From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 16/21] IB/srpt: Use a mutex to protect the channel list
Date: Thu, 11 Feb 2016 11:08:34 -0800
Message-ID: <56BCDC32.6000209@sandisk.com>
References: <56BCDAAD.7030906@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56BCDAAD.7030906-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In a later patch a function that can block will be called while
iterating over the rch_list. Hence protect that list with a
mutex instead of a spinlock. And since it is not allowed to sleep
while the task state != TASK_RUNNING, convert the list test in
srpt_ch_list_empty() into a lockless test.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 42 +++++++++++++----------------------
 drivers/infiniband/ulp/srpt/ib_srpt.h |  4 ++--
 2 files changed, 17 insertions(+), 29 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index d9bac93..c96e139 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1862,12 +1862,11 @@ static void __srpt_close_ch(struct srpt_rdma_ch *ch)
  */
 static void srpt_close_ch(struct srpt_rdma_ch *ch)
 {
-	struct srpt_device *sdev;
+	struct srpt_device *sdev = ch->sport->sdev;
 
-	sdev = ch->sport->sdev;
-	spin_lock_irq(&sdev->spinlock);
+	mutex_lock(&sdev->mutex);
 	__srpt_close_ch(ch);
-	spin_unlock_irq(&sdev->spinlock);
+	mutex_unlock(&sdev->mutex);
 }
 
 /**
@@ -1954,11 +1953,11 @@ static void srpt_release_channel_work(struct work_struct *w)
 			     ch->sport->sdev, ch->rq_size,
 			     ch->rsp_size, DMA_TO_DEVICE);
 
-	spin_lock_irq(&sdev->spinlock);
+	mutex_lock(&sdev->mutex);
 	list_del_init(&ch->list);
 	if (ch->release_done)
 		complete(ch->release_done);
-	spin_unlock_irq(&sdev->spinlock);
+	mutex_unlock(&sdev->mutex);
 
 	wake_up(&sdev->ch_releaseQ);
 
@@ -2039,7 +2038,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	if ((req->req_flags & SRP_MTCH_ACTION) == SRP_MULTICHAN_SINGLE) {
 		rsp->rsp_flags = SRP_LOGIN_RSP_MULTICHAN_NO_CHAN;
 
-		spin_lock_irq(&sdev->spinlock);
+		mutex_lock(&sdev->mutex);
 
 		list_for_each_entry_safe(ch, tmp_ch, &sdev->rch_list, list) {
 			if (!memcmp(ch->i_port_id, req->initiator_port_id, 16)
@@ -2063,7 +2062,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 			}
 		}
 
-		spin_unlock_irq(&sdev->spinlock);
+		mutex_unlock(&sdev->mutex);
 
 	} else
 		rsp->rsp_flags = SRP_LOGIN_RSP_MULTICHAN_MAINTAINED;
@@ -2208,9 +2207,9 @@ try_again:
 		goto release_channel;
 	}
 
-	spin_lock_irq(&sdev->spinlock);
+	mutex_lock(&sdev->mutex);
 	list_add_tail(&ch->list, &sdev->rch_list);
-	spin_unlock_irq(&sdev->spinlock);
+	mutex_unlock(&sdev->mutex);
 
 	goto out;
 
@@ -2652,17 +2651,6 @@ static void srpt_refresh_port_work(struct work_struct *work)
 	srpt_refresh_port(sport);
 }
 
-static int srpt_ch_list_empty(struct srpt_device *sdev)
-{
-	int res;
-
-	spin_lock_irq(&sdev->spinlock);
-	res = list_empty(&sdev->rch_list);
-	spin_unlock_irq(&sdev->spinlock);
-
-	return res;
-}
-
 /**
  * srpt_release_sdev() - Free the channel resources associated with a target.
  */
@@ -2675,13 +2663,13 @@ static int srpt_release_sdev(struct srpt_device *sdev)
 
 	BUG_ON(!sdev);
 
-	spin_lock_irq(&sdev->spinlock);
+	mutex_lock(&sdev->mutex);
 	list_for_each_entry_safe(ch, tmp_ch, &sdev->rch_list, list)
 		__srpt_close_ch(ch);
-	spin_unlock_irq(&sdev->spinlock);
+	mutex_unlock(&sdev->mutex);
 
 	res = wait_event_interruptible(sdev->ch_releaseQ,
-				       srpt_ch_list_empty(sdev));
+				       list_empty_careful(&sdev->rch_list));
 	if (res)
 		pr_err("%s: interrupted.\n", __func__);
 
@@ -2742,7 +2730,7 @@ static void srpt_add_one(struct ib_device *device)
 	sdev->device = device;
 	INIT_LIST_HEAD(&sdev->rch_list);
 	init_waitqueue_head(&sdev->ch_releaseQ);
-	spin_lock_init(&sdev->spinlock);
+	mutex_init(&sdev->mutex);
 
 	sdev->pd = ib_alloc_pd(device);
 	if (IS_ERR(sdev->pd))
@@ -2970,12 +2958,12 @@ static void srpt_close_session(struct se_session *se_sess)
 	pr_debug("ch %s-%d state %d\n", ch->sess_name, ch->qp->qp_num,
 		 ch->state);
 
-	spin_lock_irq(&sdev->spinlock);
+	mutex_lock(&sdev->mutex);
 	BUG_ON(ch->release_done);
 	ch->release_done = &release_done;
 	wait = !list_empty(&ch->list);
 	__srpt_close_ch(ch);
-	spin_unlock_irq(&sdev->spinlock);
+	mutex_unlock(&sdev->mutex);
 
 	if (!wait)
 		return;
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 9c326c7..5883295 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -342,7 +342,7 @@ struct srpt_port {
  * @ioctx_ring:    Per-HCA SRQ.
  * @rch_list:      Per-device channel list -- see also srpt_rdma_ch.list.
  * @ch_releaseQ:   Enables waiting for removal from rch_list.
- * @spinlock:      Protects rch_list and tpg.
+ * @mutex:         Protects rch_list.
  * @port:          Information about the ports owned by this HCA.
  * @event_handler: Per-HCA asynchronous IB event handler.
  * @list:          Node in srpt_dev_list.
@@ -356,7 +356,7 @@ struct srpt_device {
 	struct srpt_recv_ioctx	**ioctx_ring;
 	struct list_head	rch_list;
 	wait_queue_head_t	ch_releaseQ;
-	spinlock_t		spinlock;
+	struct mutex		mutex;
 	struct srpt_port	port[2];
 	struct ib_event_handler	event_handler;
 	struct list_head	list;
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
