From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 3/5] IB/srpt: Introduce srpt_disconnect_ch_sync()
Date: Fri, 3 Nov 2017 16:20:54 -0700
Message-ID: <20171103232056.30614-4-bart.vanassche@wdc.com>
References: <20171103232056.30614-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171103232056.30614-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Except for changing a BUG_ON() call into a WARN_ON_ONCE() call, this
patch does not change any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 51 ++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index a5f232e9b1f3..1aeb8d6ae6d9 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1787,6 +1787,40 @@ static int srpt_disconnect_ch(struct srpt_rdma_ch *ch)
 	return ret;
 }
 
+/*
+ * Send DREQ and wait for DREP. Return true if and only if this function
+ * changed the state of @ch.
+ */
+static bool srpt_disconnect_ch_sync(struct srpt_rdma_ch *ch)
+	__must_hold(&sdev->mutex)
+{
+	DECLARE_COMPLETION_ONSTACK(release_done);
+	struct srpt_device *sdev = ch->sport->sdev;
+	bool wait;
+
+	lockdep_assert_held(&sdev->mutex);
+
+	pr_debug("ch %s-%d state %d\n", ch->sess_name, ch->qp->qp_num,
+		 ch->state);
+
+	WARN_ON(ch->release_done);
+	ch->release_done = &release_done;
+	wait = !list_empty(&ch->list);
+	srpt_disconnect_ch(ch);
+	mutex_unlock(&sdev->mutex);
+
+	if (!wait)
+		goto out;
+
+	while (wait_for_completion_timeout(&release_done, 180 * HZ) == 0)
+		pr_info("%s(%s-%d state %d): still waiting ...\n", __func__,
+			ch->sess_name, ch->qp->qp_num, ch->state);
+
+out:
+	mutex_lock(&sdev->mutex);
+	return wait;
+}
+
 static void __srpt_close_all_ch(struct srpt_device *sdev)
 {
 	struct srpt_rdma_ch *ch;
@@ -2791,27 +2825,12 @@ static void srpt_release_cmd(struct se_cmd *se_cmd)
  */
 static void srpt_close_session(struct se_session *se_sess)
 {
-	DECLARE_COMPLETION_ONSTACK(release_done);
 	struct srpt_rdma_ch *ch = se_sess->fabric_sess_ptr;
 	struct srpt_device *sdev = ch->sport->sdev;
-	bool wait;
-
-	pr_debug("ch %s-%d state %d\n", ch->sess_name, ch->qp->qp_num,
-		 ch->state);
 
 	mutex_lock(&sdev->mutex);
-	BUG_ON(ch->release_done);
-	ch->release_done = &release_done;
-	wait = !list_empty(&ch->list);
-	srpt_disconnect_ch(ch);
+	srpt_disconnect_ch_sync(ch);
 	mutex_unlock(&sdev->mutex);
-
-	if (!wait)
-		return;
-
-	while (wait_for_completion_timeout(&release_done, 180 * HZ) == 0)
-		pr_info("%s(%s-%d state %d): still waiting ...\n", __func__,
-			ch->sess_name, ch->qp->qp_num, ch->state);
 }
 
 /**
-- 
2.14.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
