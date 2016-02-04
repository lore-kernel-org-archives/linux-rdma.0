From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 10/21] IB/srpt: Fix srpt_close_session()
Date: Thu, 4 Feb 2016 14:50:21 -0800
Message-ID: <56B3D5AD.2030803@sandisk.com>
References: <56B3D453.7030409@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56B3D453.7030409-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that srpt_close_session() waits if it doesn't have to wait.
Additionally, increase the time during which srpt_close_session()
waits until closing a session has finished. This makes it easier
to detect session shutdown bugs.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 55118da..88013ca 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1986,8 +1986,8 @@ static void srpt_release_channel_work(struct work_struct *w)
 	struct se_session *se_sess;
 
 	ch = container_of(w, struct srpt_rdma_ch, release_work);
-	pr_debug("ch = %p; ch->sess = %p; release_done = %p\n", ch, ch->sess,
-		 ch->release_done);
+	pr_debug("%s: %s-%d; release_done = %p\n", __func__, ch->sess_name,
+		 ch->qp->qp_num, ch->release_done);
 
 	sdev = ch->sport->sdev;
 	BUG_ON(!sdev);
@@ -2011,11 +2011,10 @@ static void srpt_release_channel_work(struct work_struct *w)
 			     ch->rsp_size, DMA_TO_DEVICE);
 
 	spin_lock_irq(&sdev->spinlock);
-	list_del(&ch->list);
-	spin_unlock_irq(&sdev->spinlock);
-
+	list_del_init(&ch->list);
 	if (ch->release_done)
 		complete(ch->release_done);
+	spin_unlock_irq(&sdev->spinlock);
 
 	wake_up(&sdev->ch_releaseQ);
 
@@ -3025,24 +3024,26 @@ static void srpt_release_cmd(struct se_cmd *se_cmd)
 static void srpt_close_session(struct se_session *se_sess)
 {
 	DECLARE_COMPLETION_ONSTACK(release_done);
-	struct srpt_rdma_ch *ch;
-	struct srpt_device *sdev;
-	unsigned long res;
-
-	ch = se_sess->fabric_sess_ptr;
-	WARN_ON(ch->sess != se_sess);
+	struct srpt_rdma_ch *ch = se_sess->fabric_sess_ptr;
+	struct srpt_device *sdev = ch->sport->sdev;
+	bool wait;
 
-	pr_debug("ch %p state %d\n", ch, ch->state);
+	pr_debug("ch %s-%d state %d\n", ch->sess_name, ch->qp->qp_num,
+		 ch->state);
 
-	sdev = ch->sport->sdev;
 	spin_lock_irq(&sdev->spinlock);
 	BUG_ON(ch->release_done);
 	ch->release_done = &release_done;
+	wait = !list_empty(&ch->list);
 	__srpt_close_ch(ch);
 	spin_unlock_irq(&sdev->spinlock);
 
-	res = wait_for_completion_timeout(&release_done, 60 * HZ);
-	WARN_ON(res == 0);
+	if (!wait)
+		return;
+
+	while (wait_for_completion_timeout(&release_done, 180 * HZ) == 0)
+		pr_info("%s(%s-%d state %d): still waiting ...\n", __func__,
+			ch->sess_name, ch->qp->qp_num, ch->state);
 }
 
 /**
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
