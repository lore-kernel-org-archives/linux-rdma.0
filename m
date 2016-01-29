From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 09/22] IB/srpt: Simplify srpt_shutdown_session()
Date: Fri, 29 Jan 2016 15:14:22 -0800
Message-ID: <56ABF24E.6070908@sandisk.com>
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

The target core guarantees that shutdown_session() is only invoked
once per session. This means that the ib_srpt target driver doesn't
have to track whether or not shutdown_session() has been called.
Additionally, ensure that target_sess_cmd_list_set_waiting() is
called before target_wait_for_sess_cmds() by moving it into
srpt_release_channel_work().

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 16 ++--------------
 drivers/infiniband/ulp/srpt/ib_srpt.h |  1 -
 2 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 72f58a7..b46e8d7 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1892,20 +1892,7 @@ static void srpt_close_ch(struct srpt_rdma_ch *ch)
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
-	return true;
+	return 1;
 }
 
 /**
@@ -2008,6 +1995,7 @@ static void srpt_release_channel_work(struct work_struct *w)
 	se_sess = ch->sess;
 	BUG_ON(!se_sess);
 
+	target_sess_cmd_list_set_waiting(se_sess);
 	target_wait_for_sess_cmds(se_sess);
 
 	transport_deregister_session_configfs(se_sess);
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index b0ede97..9c326c7 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -286,7 +286,6 @@ struct srpt_rdma_ch {
 	u8			sess_name[36];
 	struct work_struct	release_work;
 	struct completion	*release_done;
-	bool			in_shutdown;
 };
 
 /**
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
