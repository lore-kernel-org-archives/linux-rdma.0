From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 26/28] IB/srpt: Fix a race condition related to wait list processing
Date: Wed,  3 Jan 2018 13:39:36 -0800
Message-ID: <20180103213938.11664-27-bart.vanassche@wdc.com>
References: <20180103213938.11664-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180103213938.11664-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Wait list processing only occurs if the channel state >= CH_LIVE. Hence
set the channel state to CH_LIVE before triggering wait list processing
asynchronously.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index e222794ec1aa..a509e0d0df0b 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2300,18 +2300,20 @@ static void srpt_cm_rtu_recv(struct srpt_rdma_ch *ch)
 		return;
 	}
 
-	/* Trigger wait list processing. */
-	ret = srpt_zerolength_write(ch);
-	WARN_ONCE(ret < 0, "%d\n", ret);
-
 	/*
 	 * Note: calling srpt_close_ch() if the transition to the LIVE state
 	 * fails is not necessary since that means that that function has
 	 * already been invoked from another thread.
 	 */
-	if (!srpt_set_ch_state(ch, CH_LIVE))
+	if (!srpt_set_ch_state(ch, CH_LIVE)) {
 		pr_err("%s-%d: channel transition to LIVE state failed\n",
 		       ch->sess_name, ch->qp->qp_num);
+		return;
+	}
+
+	/* Trigger wait list processing. */
+	ret = srpt_zerolength_write(ch);
+	WARN_ONCE(ret < 0, "%d\n", ret);
 }
 
 /*
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
