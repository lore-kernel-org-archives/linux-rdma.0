From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 17/22] IB/srpt: Convert rch_list to RCU
Date: Fri, 29 Jan 2016 15:17:21 -0800
Message-ID: <56ABF301.8080105@sandisk.com>
References: <56ABF16E.7070006@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56ABF16E.7070006-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In a later patch a function that can block will be called while
iterating over the rch_list. Hence protect that list with a
mutex instead of a spinlock. And since it is not allowed to sleep
while the task state != TASK_RUNNING, protect the list access in
srpt_ch_list_empty() with rcu_read_lock() / rcu_read_unlock().

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 37 ++++++++++++++++++-----------------
 drivers/infiniband/ulp/srpt/ib_srpt.h |  5 +++--
 2 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 256b5bf..26aeb0b 100644
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
@@ -1954,15 +1953,15 @@ static void srpt_release_channel_work(struct work_struct *w)
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
 
-	kfree(ch);
+	kfree_rcu(ch, rcu);
 }
 
 /**
@@ -2038,7 +2037,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	if ((req->req_flags & SRP_MTCH_ACTION) == SRP_MULTICHAN_SINGLE) {
 		rsp->rsp_flags = SRP_LOGIN_RSP_MULTICHAN_NO_CHAN;
 
-		spin_lock_irq(&sdev->spinlock);
+		mutex_lock(&sdev->mutex);
 
 		list_for_each_entry_safe(ch, tmp_ch, &sdev->rch_list, list) {
 			if (!memcmp(ch->i_port_id, req->initiator_port_id, 16)
@@ -2062,7 +2061,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 			}
 		}
 
-		spin_unlock_irq(&sdev->spinlock);
+		mutex_unlock(&sdev->mutex);
 
 	} else
 		rsp->rsp_flags = SRP_LOGIN_RSP_MULTICHAN_MAINTAINED;
@@ -2203,9 +2202,9 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 		goto release_channel;
 	}
 
-	spin_lock_irq(&sdev->spinlock);
+	mutex_lock(&sdev->mutex);
 	list_add_tail(&ch->list, &sdev->rch_list);
-	spin_unlock_irq(&sdev->spinlock);
+	mutex_unlock(&sdev->mutex);
 
 	goto out;
 
@@ -2651,9 +2650,9 @@ static int srpt_ch_list_empty(struct srpt_device *sdev)
 {
 	int res;
 
-	spin_lock_irq(&sdev->spinlock);
+	rcu_read_lock();
 	res = list_empty(&sdev->rch_list);
-	spin_unlock_irq(&sdev->spinlock);
+	rcu_read_unlock();
 
 	return res;
 }
@@ -2670,10 +2669,10 @@ static int srpt_release_sdev(struct srpt_device *sdev)
 
 	BUG_ON(!sdev);
 
-	spin_lock_irq(&sdev->spinlock);
+	mutex_lock(&sdev->mutex);
 	list_for_each_entry_safe(ch, tmp_ch, &sdev->rch_list, list)
 		__srpt_close_ch(ch);
-	spin_unlock_irq(&sdev->spinlock);
+	mutex_unlock(&sdev->mutex);
 
 	res = wait_event_interruptible(sdev->ch_releaseQ,
 				       srpt_ch_list_empty(sdev));
@@ -2737,7 +2736,7 @@ static void srpt_add_one(struct ib_device *device)
 	sdev->device = device;
 	INIT_LIST_HEAD(&sdev->rch_list);
 	init_waitqueue_head(&sdev->ch_releaseQ);
-	spin_lock_init(&sdev->spinlock);
+	mutex_init(&sdev->mutex);
 
 	sdev->pd = ib_alloc_pd(device);
 	if (IS_ERR(sdev->pd))
@@ -2965,12 +2964,12 @@ static void srpt_close_session(struct se_session *se_sess)
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
@@ -3380,6 +3379,8 @@ out:
 
 static void __exit srpt_cleanup_module(void)
 {
+	rcu_barrier();
+
 	ib_unregister_client(&srpt_client);
 	target_unregister_template(&srpt_template);
 }
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 9c326c7..d1f2877 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -267,6 +267,7 @@ struct srpt_rdma_ch {
 	struct ib_cm_id		*cm_id;
 	struct ib_qp		*qp;
 	struct ib_cq		*cq;
+	struct rcu_head		rcu;
 	int			rq_size;
 	u32			rsp_size;
 	atomic_t		sq_wr_avail;
@@ -342,7 +343,7 @@ struct srpt_port {
  * @ioctx_ring:    Per-HCA SRQ.
  * @rch_list:      Per-device channel list -- see also srpt_rdma_ch.list.
  * @ch_releaseQ:   Enables waiting for removal from rch_list.
- * @spinlock:      Protects rch_list and tpg.
+ * @mutex:         Protects rch_list.
  * @port:          Information about the ports owned by this HCA.
  * @event_handler: Per-HCA asynchronous IB event handler.
  * @list:          Node in srpt_dev_list.
@@ -356,7 +357,7 @@ struct srpt_device {
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
