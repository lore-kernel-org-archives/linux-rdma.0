From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 08/15] IB/srpt: Simplify srpt_shutdown_session()
Date: Tue, 5 Jan 2016 15:24:15 +0100
Message-ID: <568BD20F.7020101@sandisk.com>
References: <568BD0FC.70207@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <568BD0FC.70207-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The target core guarantees that shutdown_session() is only invoked
once per session. This means that the ib_srpt target driver doesn't
have to track whether or not shutdown_session() has been called.
Additionally, ensure that target_sess_cmd_list_set_waiting() is
called before target_wait_for_sess_cmds() by moving it into
srpt_release_channel_work().

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 14 +-------------
 drivers/infiniband/ulp/srpt/ib_srpt.h |  1 -
 2 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index a27414d..0ff4ed6 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1887,19 +1887,6 @@ static void srpt_close_ch(struct srpt_rdma_ch *ch)
  */
 static int srpt_shutdown_session(struct se_session *se_sess)
 {
-	struct srpt_rdma_ch *ch = se_sess->fabric_sess_ptr;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ch->spinlock, flags);
-	if (ch->in_shutdown) {
-		spin_unlock_irqrestore(&ch->spinlock, flags);
-		return true;
-	}
-
-	ch->in_shutdown = true;
-	target_sess_cmd_list_set_waiting(se_sess);
-	spin_unlock_irqrestore(&ch->spinlock, flags);
-
 	return true;
 }
 
@@ -2003,6 +1990,7 @@ static void srpt_release_channel_work(struct work_struct *w)
 	se_sess = ch->sess;
 	BUG_ON(!se_sess);
 
+	target_sess_cmd_list_set_waiting(se_sess);
 	target_wait_for_sess_cmds(se_sess);
 
 	transport_deregister_session_configfs(se_sess);
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index a98b86b..d0de468 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -288,7 +288,6 @@ struct srpt_rdma_ch {
 	u8			sess_name[36];
 	struct work_struct	release_work;
 	struct completion	*release_done;
-	bool			in_shutdown;
 };
 
 /**
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
