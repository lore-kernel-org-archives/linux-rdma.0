From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 07/14] IB/srpt: Simplify srpt_close_session()
Date: Tue, 16 Jan 2018 16:14:11 -0800
Message-ID: <20180117001418.7852-8-bart.vanassche@wdc.com>
References: <20180117001418.7852-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180117001418.7852-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Move a mutex lock and unlock statement from srpt_close_session()
into srpt_disconnect_ch_sync(). Since the previous patch removed
the last user of the return value of that function, change the
return value of srpt_disconnect_ch_sync() into void.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index de3e77df146e..b248515a4fe4 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1868,22 +1868,16 @@ static bool srpt_ch_closed(struct srpt_port *sport, struct srpt_rdma_ch *ch)
 	return res;
 }
 
-/*
- * Send DREQ and wait for DREP. Return true if and only if this function
- * changed the state of @ch.
- */
-static bool srpt_disconnect_ch_sync(struct srpt_rdma_ch *ch)
-	__must_hold(&sdev->mutex)
+/* Send DREQ and wait for DREP. */
+static void srpt_disconnect_ch_sync(struct srpt_rdma_ch *ch)
 {
 	struct srpt_port *sport = ch->sport;
-	int ret;
-
-	lockdep_assert_held(&sport->mutex);
 
 	pr_debug("ch %s-%d state %d\n", ch->sess_name, ch->qp->qp_num,
 		 ch->state);
 
-	ret = srpt_disconnect_ch(ch);
+	mutex_lock(&sport->mutex);
+	srpt_disconnect_ch(ch);
 	mutex_unlock(&sport->mutex);
 
 	while (wait_event_timeout(sport->ch_releaseQ, srpt_ch_closed(sport, ch),
@@ -1891,8 +1885,6 @@ static bool srpt_disconnect_ch_sync(struct srpt_rdma_ch *ch)
 		pr_info("%s(%s-%d state %d): still waiting ...\n", __func__,
 			ch->sess_name, ch->qp->qp_num, ch->state);
 
-	mutex_lock(&sport->mutex);
-	return ret == 0;
 }
 
 static void __srpt_close_all_ch(struct srpt_port *sport)
@@ -2991,11 +2983,8 @@ static void srpt_release_cmd(struct se_cmd *se_cmd)
 static void srpt_close_session(struct se_session *se_sess)
 {
 	struct srpt_rdma_ch *ch = se_sess->fabric_sess_ptr;
-	struct srpt_port *sport = ch->sport;
 
-	mutex_lock(&sport->mutex);
 	srpt_disconnect_ch_sync(ch);
-	mutex_unlock(&sport->mutex);
 }
 
 /**
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
