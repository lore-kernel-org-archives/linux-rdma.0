From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 10/28] IB/srpt: Rework srpt_disconnect_ch_sync()
Date: Wed,  3 Jan 2018 13:39:20 -0800
Message-ID: <20180103213938.11664-11-bart.vanassche@wdc.com>
References: <20180103213938.11664-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180103213938.11664-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch fixes a use-after-free issue for ch->release_done when
running the SRP protocol on top of the rdma_rxe driver.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 40 +++++++++++++++++++++--------------
 drivers/infiniband/ulp/srpt/ib_srpt.h |  2 --
 2 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index d7143cf6a882..943fec0d0548 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1787,6 +1787,24 @@ static int srpt_disconnect_ch(struct srpt_rdma_ch *ch)
 	return ret;
 }
 
+static bool srpt_ch_closed(struct srpt_device *sdev, struct srpt_rdma_ch *ch)
+{
+	struct srpt_rdma_ch *ch2;
+	bool res = true;
+
+	rcu_read_lock();
+	list_for_each_entry(ch2, &sdev->rch_list, list) {
+		if (ch2 == ch) {
+			res = false;
+			goto done;
+		}
+	}
+done:
+	rcu_read_unlock();
+
+	return res;
+}
+
 /*
  * Send DREQ and wait for DREP. Return true if and only if this function
  * changed the state of @ch.
@@ -1794,31 +1812,24 @@ static int srpt_disconnect_ch(struct srpt_rdma_ch *ch)
 static bool srpt_disconnect_ch_sync(struct srpt_rdma_ch *ch)
 	__must_hold(&sdev->mutex)
 {
-	DECLARE_COMPLETION_ONSTACK(release_done);
 	struct srpt_device *sdev = ch->sport->sdev;
-	bool wait;
+	int ret;
 
 	lockdep_assert_held(&sdev->mutex);
 
 	pr_debug("ch %s-%d state %d\n", ch->sess_name, ch->qp->qp_num,
 		 ch->state);
 
-	WARN_ON(ch->release_done);
-	ch->release_done = &release_done;
-	wait = !list_empty(&ch->list);
-	srpt_disconnect_ch(ch);
+	ret = srpt_disconnect_ch(ch);
 	mutex_unlock(&sdev->mutex);
 
-	if (!wait)
-		goto out;
-
-	while (wait_for_completion_timeout(&release_done, 180 * HZ) == 0)
+	while (wait_event_timeout(sdev->ch_releaseQ, srpt_ch_closed(sdev, ch),
+				  5 * HZ) == 0)
 		pr_info("%s(%s-%d state %d): still waiting ...\n", __func__,
 			ch->sess_name, ch->qp->qp_num, ch->state);
 
-out:
 	mutex_lock(&sdev->mutex);
-	return wait;
+	return ret == 0;
 }
 
 static void srpt_set_enabled(struct srpt_port *sport, bool enabled)
@@ -1862,8 +1873,7 @@ static void srpt_release_channel_work(struct work_struct *w)
 	struct se_session *se_sess;
 
 	ch = container_of(w, struct srpt_rdma_ch, release_work);
-	pr_debug("%s: %s-%d; release_done = %p\n", __func__, ch->sess_name,
-		 ch->qp->qp_num, ch->release_done);
+	pr_debug("%s: %s-%d\n", __func__, ch->sess_name, ch->qp->qp_num);
 
 	sdev = ch->sport->sdev;
 	BUG_ON(!sdev);
@@ -1892,8 +1902,6 @@ static void srpt_release_channel_work(struct work_struct *w)
 
 	mutex_lock(&sdev->mutex);
 	list_del_init(&ch->list);
-	if (ch->release_done)
-		complete(ch->release_done);
 	mutex_unlock(&sdev->mutex);
 
 	wake_up(&sdev->ch_releaseQ);
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index d2c08ca2bd74..3f4142edc53b 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -261,7 +261,6 @@ enum rdma_ch_state {
  * @sess_name:     Session name.
  * @ini_guid:      Initiator port GUID.
  * @release_work:  Allows scheduling of srpt_release_channel().
- * @release_done:  Enables waiting for srpt_release_channel() completion.
  */
 struct srpt_rdma_ch {
 	struct ib_cm_id		*cm_id;
@@ -290,7 +289,6 @@ struct srpt_rdma_ch {
 	u8			sess_name[36];
 	u8			ini_guid[24];
 	struct work_struct	release_work;
-	struct completion	*release_done;
 };
 
 /**
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
