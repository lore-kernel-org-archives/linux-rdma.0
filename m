From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 4/5] IB/srpt: Simplify srpt_queue_response()
Date: Thu, 21 Jul 2016 13:04:06 -0700
Message-ID: <8349ea63-5333-0d44-8591-0d77ab6f756f@sandisk.com>
References: <75fc8647-16a6-5a89-400f-f5f418a8d6eb@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <75fc8647-16a6-5a89-400f-f5f418a8d6eb-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Initialize first_wr to &send_wr. This allows to remove a ternary
operator and an else branch. This patch does not change the behavior
of srpt_queue_response().

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Tested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Tested-by: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 9a3b954..dfa23b0 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2262,7 +2262,7 @@ static void srpt_queue_response(struct se_cmd *cmd)
 		container_of(cmd, struct srpt_send_ioctx, cmd);
 	struct srpt_rdma_ch *ch = ioctx->ch;
 	struct srpt_device *sdev = ch->sport->sdev;
-	struct ib_send_wr send_wr, *first_wr = NULL, *bad_wr;
+	struct ib_send_wr send_wr, *first_wr = &send_wr, *bad_wr;
 	struct ib_sge sge;
 	enum srpt_command_state state;
 	unsigned long flags;
@@ -2303,11 +2303,8 @@ static void srpt_queue_response(struct se_cmd *cmd)
 			struct srpt_rw_ctx *ctx = &ioctx->rw_ctxs[i];
 
 			first_wr = rdma_rw_ctx_wrs(&ctx->rw, ch->qp,
-					ch->sport->port, NULL,
-					first_wr ? first_wr : &send_wr);
+					ch->sport->port, NULL, first_wr);
 		}
-	} else {
-		first_wr = &send_wr;
 	}
 
 	if (state != SRPT_STATE_MGMT)
-- 
2.9.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
